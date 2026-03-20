package cn.iocoder.stmc.module.erp.service.payment;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.IdUtil;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.payment.vo.PaymentPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.payment.vo.PaymentSaveReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.payment.vo.PaymentSupplierSummaryRespVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.payment.PaymentDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.paymentplan.PaymentPlanDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.supplier.SupplierDO;
import cn.iocoder.stmc.module.erp.dal.mysql.payment.PaymentMapper;
import cn.iocoder.stmc.module.erp.enums.PaymentPlanStatusEnum;
import cn.iocoder.stmc.module.erp.enums.PaymentStatusEnum;
import cn.iocoder.stmc.module.erp.service.order.OrderService;
import cn.iocoder.stmc.module.erp.service.paymentplan.PaymentPlanService;
import cn.iocoder.stmc.module.erp.service.supplier.SupplierService;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static cn.iocoder.stmc.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.stmc.module.erp.enums.ErrorCodeConstants.*;

/**
 * ERP 付款 Service 实现类
 *
 * @author stmc
 */
@Service
@Validated
public class PaymentServiceImpl implements PaymentService {

    @Resource
    private PaymentMapper paymentMapper;

    @Resource
    private SupplierService supplierService;

    @Resource
    private OrderService orderService;

    @Resource
    @Lazy // 避免循环依赖
    private PaymentPlanService paymentPlanService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createPayment(PaymentSaveReqVO createReqVO) {
        // 校验供应商是否存在
        validateSupplierExists(createReqVO.getSupplierId());
        // 校验订单是否存在（如有）
        validateOrderExists(createReqVO.getOrderId());
        // 生成付款单号
        String paymentNo = generatePaymentNo();
        // 插入
        PaymentDO payment = BeanUtils.toBean(createReqVO, PaymentDO.class);
        payment.setPaymentNo(paymentNo);
        payment.setStatus(PaymentStatusEnum.PENDING.getStatus());
        // 默认付款类型为采购付款
        if (payment.getPaymentType() == null) {
            payment.setPaymentType(1);
        }
        paymentMapper.insert(payment);

        // 根据供应商账期配置自动生成付款计划
        paymentPlanService.generatePaymentPlansForPayment(
                payment.getId(),
                payment.getSupplierId(),
                payment.getAmount(),
                payment.getPaymentDate() != null ? payment.getPaymentDate() : java.time.LocalDate.now(),
                paymentNo,
                createReqVO.getPaidStages()
        );

        // 更新付款单状态（如果有当期已付款）
        updatePaymentStatus(payment.getId());

        return payment.getId();
    }

    @Override
    public void updatePayment(PaymentSaveReqVO updateReqVO) {
        // 校验存在
        PaymentDO payment = validatePaymentExists(updateReqVO.getId());
        // 校验状态（只有待付款的付款单可以修改）
        if (!PaymentStatusEnum.PENDING.getStatus().equals(payment.getStatus())) {
            throw exception(PAYMENT_STATUS_NOT_ALLOW_UPDATE);
        }
        // 更新
        PaymentDO updateObj = BeanUtils.toBean(updateReqVO, PaymentDO.class);
        paymentMapper.updateById(updateObj);
    }

    @Override
    public void updatePaymentStatus(Long paymentId) {
        // 获取付款单的所有付款计划
        List<PaymentPlanDO> plans = paymentPlanService.getPaymentPlansByPaymentId(paymentId);
        if (CollUtil.isEmpty(plans)) {
            return; // 没有付款计划，保持原状态
        }

        // 统计各状态数量
        long totalCount = plans.size();
        long paidCount = plans.stream()
                .filter(p -> PaymentPlanStatusEnum.PAID.getStatus().equals(p.getStatus()))
                .count();
        long cancelledCount = plans.stream()
                .filter(p -> PaymentPlanStatusEnum.CANCELLED.getStatus().equals(p.getStatus()))
                .count();

        // 计算有效计划数（排除已取消的）
        long validCount = totalCount - cancelledCount;

        // 判断状态
        Integer newStatus;
        if (validCount == 0) {
            // 所有计划都被取消了
            newStatus = PaymentStatusEnum.CANCELLED.getStatus();
        } else if (paidCount == 0) {
            // 没有付款
            newStatus = PaymentStatusEnum.PENDING.getStatus();
        } else if (paidCount >= validCount) {
            // 全部付款完成
            newStatus = PaymentStatusEnum.COMPLETED.getStatus();
        } else {
            // 部分付款
            newStatus = PaymentStatusEnum.PARTIAL.getStatus();
        }

        // 更新状态
        PaymentDO updateObj = new PaymentDO();
        updateObj.setId(paymentId);
        updateObj.setStatus(newStatus);
        paymentMapper.updateById(updateObj);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deletePayment(Long id) {
        // 校验存在
        PaymentDO payment = validatePaymentExists(id);
        // 校验状态（只有待付款的付款单可以删除）
        if (!PaymentStatusEnum.PENDING.getStatus().equals(payment.getStatus())) {
            throw exception(PAYMENT_STATUS_NOT_ALLOW_DELETE);
        }
        // 校验是否存在已付款的计划
        if (paymentPlanService.hasPaidPlansByPaymentId(id)) {
            throw exception(PAYMENT_HAS_PAID_PLAN);
        }
        // 取消关联的付款计划
        paymentPlanService.cancelByPaymentId(id);
        // 删除
        paymentMapper.deleteById(id);
    }

    @Override
    public void deletePaymentList(List<Long> ids) {
        ids.forEach(this::deletePayment);
    }

    private PaymentDO validatePaymentExists(Long id) {
        PaymentDO payment = paymentMapper.selectById(id);
        if (payment == null) {
            throw exception(PAYMENT_NOT_EXISTS);
        }
        return payment;
    }

    @Override
    public PaymentDO getPayment(Long id) {
        return paymentMapper.selectById(id);
    }

    @Override
    public PageResult<PaymentDO> getPaymentPage(PaymentPageReqVO pageReqVO) {
        return paymentMapper.selectPage(pageReqVO);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createPaymentFromCostFill(Long supplierId, Long orderId, BigDecimal amount,
                                           LocalDate paymentDate, Boolean isPaid, String remark) {
        // 1. 校验供应商是否存在
        validateSupplierExists(supplierId);
        // 2. 校验订单是否存在
        validateOrderExists(orderId);

        // 3. 获取供应商信息（用于获取银行账号）
        SupplierDO supplier = supplierService.getSupplier(supplierId);

        // 4. 生成付款单号
        String paymentNo = generatePaymentNo();

        // 5. 创建付款单
        // 如果付款日期为空，使用当前日期（数据库 payment_date 字段不允许为 NULL）
        LocalDate actualPaymentDate = paymentDate != null ? paymentDate : LocalDate.now();

        PaymentDO payment = new PaymentDO();
        payment.setPaymentNo(paymentNo);
        payment.setSupplierId(supplierId);
        payment.setOrderId(orderId);
        payment.setPaymentType(1); // 采购付款
        payment.setAmount(amount);
        payment.setPaymentDate(actualPaymentDate);
        payment.setPaymentMethod(1); // 默认银行卡转账
        payment.setPaymentAccount(supplier != null ? supplier.getBankAccount() : null); // 默认供应商银行账号

        // 6. 根据是否已付款设置状态
        if (Boolean.TRUE.equals(isPaid)) {
            payment.setStatus(PaymentStatusEnum.COMPLETED.getStatus());
        } else {
            payment.setStatus(PaymentStatusEnum.PENDING.getStatus());
        }

        paymentMapper.insert(payment);

        // 8. 直接创建付款明细（不依赖供应商账期配置）
        paymentPlanService.createSinglePaymentPlan(
                payment.getId(),
                supplierId,
                orderId,           // 直接关联订单ID
                amount,
                actualPaymentDate, // 使用处理后的付款日期
                paymentNo,
                isPaid,
                remark             // 传入备注
        );

        return payment.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelPaymentByOrderAndSupplier(Long orderId, Long supplierId) {
        // 1. 查询该订单+供应商的付款单
        PaymentDO payment = paymentMapper.selectByOrderIdAndSupplierId(orderId, supplierId);
        if (payment == null) {
            // 未找到付款单，可能已经被删除，直接返回
            return;
        }

        // 2. 检查是否可以取消（已付款的不能取消）
        if (PaymentStatusEnum.COMPLETED.getStatus().equals(payment.getStatus())) {
            throw exception(PAYMENT_ALREADY_PAID_CANNOT_CANCEL);
        }

        // 3. 更新付款单状态为已取消
        PaymentDO updatePayment = new PaymentDO();
        updatePayment.setId(payment.getId());
        updatePayment.setStatus(PaymentStatusEnum.CANCELLED.getStatus());
        paymentMapper.updateById(updatePayment);

        // 4. 取消关联的付款计划
        paymentPlanService.cancelPaymentPlansByPaymentId(payment.getId());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePaymentFromCostEdit(Long orderId, Long supplierId, BigDecimal newAmount,
                                          LocalDate newPaymentDate, Boolean newIsPaid, String newRemark) {
        // 1. 查询付款单
        PaymentDO payment = paymentMapper.selectByOrderIdAndSupplierId(orderId, supplierId);
        if (payment == null) {
            throw exception(PAYMENT_NOT_EXISTS);
        }

        // 2. 检查是否可以修改（已付款的不能修改金额）
        if (PaymentStatusEnum.COMPLETED.getStatus().equals(payment.getStatus())) {
            throw exception(PAYMENT_ALREADY_PAID_CANNOT_EDIT);
        }

        // 3. 更新付款单
        PaymentDO updatePayment = new PaymentDO();
        updatePayment.setId(payment.getId());
        updatePayment.setAmount(newAmount);
        updatePayment.setPaymentDate(newPaymentDate);

        // 更新状态
        if (Boolean.TRUE.equals(newIsPaid)) {
            updatePayment.setStatus(PaymentStatusEnum.COMPLETED.getStatus());
        } else {
            updatePayment.setStatus(PaymentStatusEnum.PENDING.getStatus());
        }

        paymentMapper.updateById(updatePayment);

        // 4. 同步更新付款计划
        paymentPlanService.updatePaymentPlanFromCostEdit(
                payment.getId(),
                newAmount,
                newPaymentDate,
                newIsPaid
        );
    }

    /**
     * 生成付款单号
     *
     * @return 付款单号
     */
    private String generatePaymentNo() {
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String randomStr = String.format("%04d", IdUtil.getSnowflakeNextId() % 10000);
        return "PAY" + dateStr + randomStr;
    }

    /**
     * 校验供应商是否存在
     *
     * @param supplierId 供应商编号
     */
    private void validateSupplierExists(Long supplierId) {
        if (supplierId == null) {
            throw exception(PAYMENT_SUPPLIER_NOT_FOUND);
        }
        if (supplierService.getSupplier(supplierId) == null) {
            throw exception(PAYMENT_SUPPLIER_NOT_FOUND);
        }
    }

    /**
     * 校验订单是否存在
     *
     * @param orderId 订单编号
     */
    private void validateOrderExists(Long orderId) {
        if (orderId == null) {
            return; // 订单不是必填项
        }
        if (orderService.getOrder(orderId) == null) {
            throw exception(PAYMENT_ORDER_NOT_FOUND);
        }
    }

    @Override
    public List<PaymentDO> getPaymentListByOrderId(Long orderId) {
        return paymentMapper.selectListByOrderId(orderId);
    }

    @Override
    public List<PaymentSupplierSummaryRespVO> getUnpaidSupplierSummary() {
        List<Map<String, Object>> rawList = paymentMapper.selectUnpaidSupplierSummary();
        if (CollUtil.isEmpty(rawList)) {
            return Collections.emptyList();
        }
        // 收集供应商ID
        Set<Long> supplierIds = rawList.stream()
                .map(m -> ((Number) m.get("supplierId")).longValue())
                .collect(Collectors.toSet());
        Map<Long, SupplierDO> supplierMap = supplierService.getSupplierMap(supplierIds);
        // 组装结果
        List<PaymentSupplierSummaryRespVO> result = new ArrayList<>();
        for (Map<String, Object> row : rawList) {
            PaymentSupplierSummaryRespVO vo = new PaymentSupplierSummaryRespVO();
            Long supplierId = ((Number) row.get("supplierId")).longValue();
            vo.setSupplierId(supplierId);
            SupplierDO supplier = supplierMap.get(supplierId);
            vo.setSupplierName(supplier != null ? supplier.getName() : "未知供应商");
            vo.setUnpaidCount(((Number) row.get("unpaidCount")).intValue());
            vo.setUnpaidAmount(new BigDecimal(row.get("unpaidAmount").toString()));
            result.add(vo);
        }
        return result;
    }

}
