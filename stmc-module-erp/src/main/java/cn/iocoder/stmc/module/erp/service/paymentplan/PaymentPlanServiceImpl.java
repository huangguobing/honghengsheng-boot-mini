package cn.iocoder.stmc.module.erp.service.paymentplan;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.IdUtil;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanAvailableOrderRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanSaveReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.ReconcileSummaryVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.paymentplan.PaymentPlanDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.paymentterm.PaymentTermConfigDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderDO;
import cn.iocoder.stmc.module.erp.dal.mysql.paymentplan.PaymentPlanMapper;
import cn.iocoder.stmc.module.erp.enums.PaymentPlanStatusEnum;
import cn.iocoder.stmc.module.erp.service.payment.PaymentService;
import cn.iocoder.stmc.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.stmc.module.erp.service.paymentterm.PaymentTermConfigService;
import cn.iocoder.stmc.module.erp.service.purchase.PurchaseOrderService;
import cn.iocoder.stmc.module.erp.service.supplier.SupplierService;
import cn.iocoder.stmc.module.erp.service.voucher.VoucherService;
import cn.iocoder.stmc.module.system.enums.permission.RoleCodeEnum;
import cn.iocoder.stmc.module.system.service.permission.PermissionService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static cn.iocoder.stmc.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.stmc.module.erp.enums.ErrorCodeConstants.*;

/**
 * ERP 付款计划 Service 实现类
 *
 * @author stmc
 */
@Slf4j
@Service
@Validated
public class PaymentPlanServiceImpl implements PaymentPlanService {

    @Resource
    private PaymentPlanMapper paymentPlanMapper;
    @Resource
    private PaymentTermConfigService paymentTermConfigService;
    @Resource
    private SupplierService supplierService;
    @Resource
    private PurchaseOrderService purchaseOrderService;
    @Resource
    @Lazy // 避免循环依赖
    private PaymentService paymentService;
    @Resource
    @Lazy
    private cn.iocoder.stmc.module.erp.service.order.OrderService orderService;
    @Resource
    private cn.iocoder.stmc.module.erp.service.customer.CustomerService customerService;
    @Resource
    @Lazy
    private VoucherService voucherService;
    @Resource
    private PermissionService permissionService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void generatePaymentPlansForPayment(Long paymentId, Long supplierId, BigDecimal totalAmount,
                                                LocalDate paymentDate, String paymentNo, List<Integer> paidStages) {
        // 1. 参数校验
        if (paymentId == null || supplierId == null || totalAmount == null || paymentDate == null) {
            log.warn("[generatePaymentPlansForPayment] 参数不完整，跳过生成付款计划");
            return;
        }

        // 2. 获取供应商的分期配置
        List<PaymentTermConfigDO> configs = paymentTermConfigService.getEnabledConfigsBySupplierId(supplierId);
        if (CollUtil.isEmpty(configs)) {
            log.info("[generatePaymentPlansForPayment] 供应商[{}]未配置分期付款，跳过生成付款计划", supplierId);
            return;
        }

        // 3. 校验金额
        if (totalAmount.compareTo(BigDecimal.ZERO) <= 0) {
            log.info("[generatePaymentPlansForPayment] 付款单[{}]金额为0或负数，跳过生成付款计划", paymentNo);
            return;
        }

        // 4. 删除旧的付款计划（如果有）
        paymentPlanMapper.deleteByPaymentId(paymentId);

        // 5. 处理 paidStages 为 Set 便于查找
        Set<Integer> paidStageSet = CollUtil.isEmpty(paidStages) ? Collections.emptySet() : new HashSet<>(paidStages);

        // 6. 生成付款计划
        for (PaymentTermConfigDO config : configs) {
            PaymentPlanDO plan = new PaymentPlanDO();
            plan.setPlanNo(generatePlanNo());
            plan.setPaymentId(paymentId);
            plan.setPaymentNo(paymentNo);
            plan.setSupplierId(supplierId);
            plan.setConfigId(config.getId());
            plan.setStage(config.getStage());

            // 计算付款金额
            BigDecimal planAmount = totalAmount
                    .multiply(config.getPercentage())
                    .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
            plan.setPlanAmount(planAmount);

            // 计算付款日期
            LocalDate planDate = paymentDate.plusDays(config.getDaysAfterOrder());
            plan.setPlanDate(planDate);

            // 检查该期是否在 paidStages 中，直接标记为已付款
            if (paidStageSet.contains(config.getStage())) {
                plan.setActualAmount(planAmount);
                plan.setActualDate(LocalDateTime.now());
                plan.setStatus(PaymentPlanStatusEnum.PAID.getStatus());
            } else {
                plan.setActualAmount(BigDecimal.ZERO);
                plan.setStatus(PaymentPlanStatusEnum.PENDING.getStatus());
            }

            paymentPlanMapper.insert(plan);
        }

        log.info("[generatePaymentPlansForPayment] 付款单[{}]生成了{}条付款计划，其中{}条已标记为已付款",
                paymentNo, configs.size(), paidStageSet.size());
    }

    @Override
    public PaymentPlanDO getPaymentPlan(Long id) {
        return paymentPlanMapper.selectById(id);
    }

    @Override
    public List<PaymentPlanDO> getPaymentPlansByPaymentId(Long paymentId) {
        return paymentPlanMapper.selectListByPaymentId(paymentId);
    }

    @Override
    public List<PaymentPlanDO> getPaymentPlansByOrderId(Long orderId) {
        return paymentPlanMapper.selectListByOrderId(orderId);
    }

    @Override
    public PageResult<PaymentPlanDO> getPaymentPlanPage(PaymentPlanPageReqVO pageReqVO) {
        return paymentPlanMapper.selectPage(pageReqVO);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void markAsPaid(Long id) {
        PaymentPlanDO plan = paymentPlanMapper.selectById(id);
        if (plan == null) {
            throw exception(PAYMENT_PLAN_NOT_EXISTS);
        }
        if (PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus())) {
            throw exception(PAYMENT_PLAN_ALREADY_PAID);
        }

        plan.setStatus(PaymentPlanStatusEnum.PAID.getStatus());
        plan.setPaidAmount(plan.getPlanAmount());
        plan.setActualAmount(plan.getPlanAmount());
        plan.setActualDate(LocalDateTime.now());
        paymentPlanMapper.updateById(plan);

        // 更新订单已收/已付金额
        if (plan.getOrderId() != null) {
            orderService.updateOrderPaidAmount(plan.getOrderId(), plan.getPlanAmount());
        }

        // 更新付款单状态
        paymentService.updatePaymentStatus(plan.getPaymentId());

        // 检查订单是否可以自动完成
        if (plan.getOrderId() != null) {
            orderService.checkAndAutoComplete(plan.getOrderId());
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelByPaymentId(Long paymentId) {
        List<PaymentPlanDO> plans = paymentPlanMapper.selectListByPaymentId(paymentId);
        for (PaymentPlanDO plan : plans) {
            if (PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus())
                    || PaymentPlanStatusEnum.PARTIAL.getStatus().equals(plan.getStatus())) {
                throw exception(PAYMENT_PLAN_STATUS_NOT_ALLOW_CANCEL);
            }
        }
        paymentPlanMapper.deleteByPaymentId(paymentId);
    }

    @Override
    public boolean hasPaidPlansByPaymentId(Long paymentId) {
        List<PaymentPlanDO> plans = paymentPlanMapper.selectListByPaymentId(paymentId);
        if (CollUtil.isEmpty(plans)) {
            return false;
        }
        // 检查是否有已付款状态的计划
        return plans.stream()
                .anyMatch(plan -> PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus()));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void processPaymentPlanNotifications() {
        log.info("[processPaymentPlanNotifications] 付款计划通知机制已停用，跳过处理");
    }


    /**
     * 生成付款计划单号
     */
    private String generatePlanNo() {
        return "PP" + IdUtil.getSnowflakeNextIdStr();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void createSinglePaymentPlan(Long paymentId, Long supplierId, Long orderId, BigDecimal amount,
                                         LocalDate planDate, String paymentNo, Boolean isPaid, String remark) {
        // 1. 参数校验
        if (paymentId == null || supplierId == null || amount == null || planDate == null) {
            log.warn("[createSinglePaymentPlan] 参数不完整，跳过创建付款计划");
            return;
        }

        // 2. 校验金额
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            log.info("[createSinglePaymentPlan] 付款金额为0或负数，跳过创建付款计划");
            return;
        }

        // 3. 创建单期付款计划
        PaymentPlanDO plan = new PaymentPlanDO();
        plan.setPlanNo(generatePlanNo());
        plan.setPaymentId(paymentId);
        plan.setPaymentNo(paymentNo);
        plan.setSupplierId(supplierId);
        plan.setOrderId(orderId); // 直接关联订单ID
        plan.setConfigId(null); // 不关联账期配置
        plan.setStage(1); // 单期
        plan.setPlanAmount(amount);
        plan.setPlanDate(planDate);
        plan.setRemark(remark); // 设置备注

        // 4. 根据是否已付款设置状态
        if (Boolean.TRUE.equals(isPaid)) {
            plan.setActualAmount(amount);
            plan.setActualDate(LocalDateTime.now());
            plan.setStatus(PaymentPlanStatusEnum.PAID.getStatus());
        } else {
            plan.setActualAmount(BigDecimal.ZERO);
            plan.setStatus(PaymentPlanStatusEnum.PENDING.getStatus());
        }

        paymentPlanMapper.insert(plan);

        log.info("[createSinglePaymentPlan] 创建单期付款计划成功，paymentNo:{}, amount:{}, isPaid:{}, remark:{}",
                paymentNo, amount, isPaid, remark);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelPaymentPlansByPaymentId(Long paymentId) {
        List<PaymentPlanDO> plans = paymentPlanMapper.selectListByPaymentId(paymentId);
        for (PaymentPlanDO plan : plans) {
            if (PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus())
                    || PaymentPlanStatusEnum.PARTIAL.getStatus().equals(plan.getStatus())) {
                throw exception(PAYMENT_PLAN_STATUS_NOT_ALLOW_CANCEL);
            }
        }
        paymentPlanMapper.deleteByPaymentId(paymentId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePaymentPlanFromCostEdit(Long paymentId, BigDecimal newAmount,
                                               LocalDate newPlanDate, Boolean newIsPaid) {
        // 成本填充创建的是单期付款计划（stage=1）
        List<PaymentPlanDO> plans = paymentPlanMapper.selectListByPaymentId(paymentId);
        if (plans.isEmpty()) {
            log.warn("[updatePaymentPlanFromCostEdit] 未找到付款计划，paymentId={}", paymentId);
            return;
        }

        // 只更新第一个计划（单期）
        PaymentPlanDO plan = plans.get(0);

        // 如果已付款，不允许修改
        if (PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus())) {
            throw exception(PAYMENT_PLAN_ALREADY_PAID_CANNOT_EDIT);
        }

        PaymentPlanDO update = new PaymentPlanDO();
        update.setId(plan.getId());
        update.setPlanAmount(newAmount);
        update.setPlanDate(newPlanDate);

        if (Boolean.TRUE.equals(newIsPaid)) {
            update.setActualAmount(newAmount);
            update.setActualDate(LocalDateTime.now());
            update.setStatus(PaymentPlanStatusEnum.PAID.getStatus());
        } else {
            update.setActualAmount(BigDecimal.ZERO);
            update.setActualDate(null);
            update.setStatus(PaymentPlanStatusEnum.PENDING.getStatus());
        }

        paymentPlanMapper.updateById(update);
    }

    // ========== 鸿恒盛扩展：灵活收付款计划 ==========

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createPaymentPlan(PaymentPlanSaveReqVO reqVO) {
        validatePaymentPlanTarget(reqVO);
        validatePaymentPlanAmount(reqVO.getPlanAmount());

        OrderDO order = lockOrder(reqVO.getOrderId());
        BigDecimal paidAmount = reqVO.getPaidAmount() != null ? reqVO.getPaidAmount() : BigDecimal.ZERO;
        if (paidAmount.compareTo(BigDecimal.ZERO) < 0) {
            throw exception(PAYMENT_PLAN_PARTIAL_PAY_INVALID);
        }
        if (paidAmount.compareTo(reqVO.getPlanAmount()) > 0) {
            throw exception(PAYMENT_PLAN_PAID_AMOUNT_EXCEEDS_PLAN);
        }

        validatePlanCap(reqVO, null, reqVO.getPlanAmount());

        PaymentPlanDO plan = new PaymentPlanDO();
        plan.setPlanNo(generatePlanNo());
        plan.setType(reqVO.getType());
        plan.setOrderId(reqVO.getOrderId());
        plan.setPurchaseOrderId(reqVO.getPurchaseOrderId());
        plan.setSupplierId(resolvePersistedSupplierId(reqVO));
        plan.setCustomerId(reqVO.getCustomerId());
        plan.setProjectId(reqVO.getProjectId());
        plan.setPlanAmount(reqVO.getPlanAmount());
        plan.setPaidAmount(paidAmount);
        plan.setPaymentMethod(reqVO.getPaymentMethod());
        plan.setPlanDate(reqVO.getPlanDate() != null ? reqVO.getPlanDate() : LocalDate.now());
        plan.setRemark(reqVO.getRemark());
        plan.setStage(1);

        LocalDateTime now = LocalDateTime.now();
        if (paidAmount.compareTo(reqVO.getPlanAmount()) >= 0 || PaymentPlanStatusEnum.PAID.getStatus().equals(reqVO.getStatus())) {
            plan.setStatus(PaymentPlanStatusEnum.PAID.getStatus());
            plan.setActualAmount(paidAmount.compareTo(BigDecimal.ZERO) > 0 ? paidAmount : reqVO.getPlanAmount());
            plan.setPaidAmount(plan.getActualAmount());
            plan.setActualDate(now);
        } else if (paidAmount.compareTo(BigDecimal.ZERO) > 0 || PaymentPlanStatusEnum.PARTIAL.getStatus().equals(reqVO.getStatus())) {
            plan.setStatus(PaymentPlanStatusEnum.PARTIAL.getStatus());
            plan.setActualAmount(paidAmount);
            plan.setActualDate(now);
        } else {
            plan.setStatus(PaymentPlanStatusEnum.PENDING.getStatus());
            plan.setActualAmount(BigDecimal.ZERO);
            plan.setActualDate(null);
        }

        paymentPlanMapper.insert(plan);
        tryAutoCreateVoucher(plan);
        return plan.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePaymentPlan(PaymentPlanSaveReqVO reqVO) {
        PaymentPlanDO plan = paymentPlanMapper.selectById(reqVO.getId());
        if (plan == null) {
            throw exception(PAYMENT_PLAN_NOT_EXISTS);
        }
        if (PaymentPlanStatusEnum.CANCELLED.getStatus().equals(plan.getStatus())) {
            throw exception(PAYMENT_PLAN_HISTORICAL_CANCELLED_READ_ONLY);
        }

        OrderDO order = lockOrder(reqVO.getOrderId() != null ? reqVO.getOrderId() : plan.getOrderId());
        validatePaymentPlanTarget(reqVO);

        boolean immutablePlan = PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus())
                || PaymentPlanStatusEnum.PARTIAL.getStatus().equals(plan.getStatus());

        if (immutablePlan) {
            boolean targetChanged = !Objects.equals(plan.getType(), reqVO.getType())
                    || !Objects.equals(plan.getOrderId(), reqVO.getOrderId())
                    || !Objects.equals(plan.getPurchaseOrderId(), reqVO.getPurchaseOrderId())
                    || !Objects.equals(plan.getSupplierId(), reqVO.getSupplierId())
                    || !Objects.equals(plan.getCustomerId(), reqVO.getCustomerId())
                    || !Objects.equals(plan.getProjectId(), reqVO.getProjectId());
            if (targetChanged || (reqVO.getPlanAmount() != null && plan.getPlanAmount() != null
                    && reqVO.getPlanAmount().compareTo(plan.getPlanAmount()) != 0)) {
                throw exception(PAYMENT_PLAN_STATUS_NOT_ALLOW_EDIT);
            }
        } else {
            validatePaymentPlanAmount(reqVO.getPlanAmount());
            validatePlanCap(reqVO, plan, reqVO.getPlanAmount());
        }

        if (reqVO.getPlanAmount() != null && plan.getPaidAmount() != null
                && reqVO.getPlanAmount().compareTo(plan.getPaidAmount()) < 0) {
            throw exception(PAYMENT_PLAN_AMOUNT_BELOW_PAID);
        }

        PaymentPlanDO update = new PaymentPlanDO();
        update.setId(reqVO.getId());
        update.setPaymentMethod(reqVO.getPaymentMethod());
        update.setRemark(reqVO.getRemark());
        update.setPlanDate(reqVO.getPlanDate());

        if (!immutablePlan) {
            update.setType(reqVO.getType());
            update.setOrderId(reqVO.getOrderId());
            update.setPurchaseOrderId(reqVO.getPurchaseOrderId());
            update.setSupplierId(resolvePersistedSupplierId(reqVO));
            update.setCustomerId(reqVO.getCustomerId());
            update.setProjectId(reqVO.getProjectId());
            update.setPlanAmount(reqVO.getPlanAmount());
        }

        paymentPlanMapper.updateById(update);

        PaymentPlanDO planAfterUpdate = paymentPlanMapper.selectById(reqVO.getId());
        tryAutoSyncVouchers(planAfterUpdate);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deletePaymentPlan(Long id) {
        PaymentPlanDO plan = paymentPlanMapper.selectById(id);
        if (plan == null) {
            throw exception(PAYMENT_PLAN_NOT_EXISTS);
        }
        boolean superAdmin = isCurrentUserSuperAdmin();
        if (!superAdmin && !PaymentPlanStatusEnum.PENDING.getStatus().equals(plan.getStatus())) {
            throw exception(PAYMENT_PLAN_STATUS_NOT_ALLOW_DELETE);
        }
        paymentPlanMapper.deleteById(id);
        tryAutoDeleteVouchers(plan);
    }

    private boolean isCurrentUserSuperAdmin() {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        return userId != null && permissionService.hasAnyRoles(userId, RoleCodeEnum.SUPER_ADMIN.getCode());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void partialPay(Long id, BigDecimal amount, Integer paymentMethod) {
        PaymentPlanDO plan = paymentPlanMapper.selectById(id);
        if (plan == null) {
            throw exception(PAYMENT_PLAN_NOT_EXISTS);
        }
        if (PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus())) {
            throw exception(PAYMENT_PLAN_ALREADY_PAID);
        }
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw exception(PAYMENT_PLAN_PARTIAL_PAY_INVALID);
        }

        BigDecimal currentPaid = plan.getPaidAmount() != null ? plan.getPaidAmount() : BigDecimal.ZERO;
        BigDecimal planAmount = plan.getPlanAmount() != null ? plan.getPlanAmount() : BigDecimal.ZERO;
        BigDecimal remaining = planAmount.subtract(currentPaid);
        if (amount.compareTo(remaining) > 0) {
            throw exception(PAYMENT_PLAN_PARTIAL_PAY_EXCEEDS,
                    planAmount, currentPaid, remaining, amount);
        }

        BigDecimal newPaid = currentPaid.add(amount);

        PaymentPlanDO update = new PaymentPlanDO();
        update.setId(id);
        update.setPaidAmount(newPaid);
        update.setActualAmount(newPaid);
        update.setPaymentMethod(paymentMethod != null ? paymentMethod : plan.getPaymentMethod());
        update.setActualDate(LocalDateTime.now());
        update.setStatus(newPaid.compareTo(planAmount) >= 0
                ? PaymentPlanStatusEnum.PAID.getStatus()
                : PaymentPlanStatusEnum.PARTIAL.getStatus());
        paymentPlanMapper.updateById(update);

        if (plan.getOrderId() != null) {
            orderService.checkAndAutoComplete(plan.getOrderId());
        }
    }

    @Override
    public List<ReconcileSummaryVO> getReconcileSummary(Integer type) {
        List<PaymentPlanDO> plans = paymentPlanMapper.selectListByType(type);
        if (CollUtil.isEmpty(plans)) {
            return Collections.emptyList();
        }

        // 按目标ID分组：type=0 按供应商，type=1 按客户
        Map<Long, List<PaymentPlanDO>> grouped;
        if (Integer.valueOf(0).equals(type)) {
            grouped = plans.stream()
                    .filter(p -> p.getSupplierId() != null)
                    .collect(Collectors.groupingBy(PaymentPlanDO::getSupplierId));
        } else {
            grouped = plans.stream()
                    .filter(p -> p.getCustomerId() != null)
                    .collect(Collectors.groupingBy(PaymentPlanDO::getCustomerId));
        }

        // 获取名称映射
        Map<Long, String> nameMap = new HashMap<>();
        if (Integer.valueOf(0).equals(type)) {
            Map<Long, cn.iocoder.stmc.module.erp.dal.dataobject.supplier.SupplierDO> supplierMap =
                    supplierService.getSupplierMap(grouped.keySet());
            supplierMap.forEach((k, v) -> nameMap.put(k, v.getName()));
        } else {
            Map<Long, cn.iocoder.stmc.module.erp.dal.dataobject.customer.CustomerDO> customerMap =
                    customerService.getCustomerMap(grouped.keySet());
            customerMap.forEach((k, v) -> nameMap.put(k, v.getName()));
        }

        List<ReconcileSummaryVO> result = new ArrayList<>();
        for (Map.Entry<Long, List<PaymentPlanDO>> entry : grouped.entrySet()) {
            ReconcileSummaryVO vo = new ReconcileSummaryVO();
            vo.setTargetId(entry.getKey());
            vo.setTargetName(nameMap.getOrDefault(entry.getKey(), "未知"));
            vo.setPlanCount(entry.getValue().size());

            BigDecimal totalAmount = BigDecimal.ZERO;
            BigDecimal paidAmount = BigDecimal.ZERO;
            for (PaymentPlanDO p : entry.getValue()) {
                if (p.getPlanAmount() != null) {
                    totalAmount = totalAmount.add(p.getPlanAmount());
                }
                if (p.getPaidAmount() != null) {
                    paidAmount = paidAmount.add(p.getPaidAmount());
                }
            }
            vo.setTotalAmount(totalAmount);
            vo.setPaidAmount(paidAmount);
            vo.setUnpaidAmount(totalAmount.subtract(paidAmount));
            result.add(vo);
        }
        return result;
    }

    @Override
    public List<PaymentPlanAvailableOrderRespVO> getAvailableOrderList(Integer type) {
        List<OrderDO> orders = orderService.getOrderSimpleList();
        if (CollUtil.isEmpty(orders)) {
            return Collections.emptyList();
        }

        return orders.stream()
                .filter(order -> order.getOrderType() != null && order.getOrderType() == 1)
                .map(order -> buildAvailableOrder(order, type))
                .filter(Objects::nonNull)
                .sorted(Comparator.comparing(PaymentPlanAvailableOrderRespVO::getId).reversed())
                .collect(Collectors.toList());
    }

    private PaymentPlanAvailableOrderRespVO buildAvailableOrder(OrderDO order, Integer type) {
        List<PaymentPlanDO> plans = paymentPlanMapper.selectListByOrderId(order.getId()).stream()
                .filter(plan -> Objects.equals(plan.getType(), type))
                .filter(plan -> !Objects.equals(plan.getStatus(), PaymentPlanStatusEnum.CANCELLED.getStatus()))
                .collect(Collectors.toList());

        BigDecimal assignedAmount = plans.stream()
                .map(plan -> plan.getPlanAmount() != null ? plan.getPlanAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal cap;
        if (Integer.valueOf(0).equals(type)) {
            cap = order.getTotalPurchaseAmount() != null ? order.getTotalPurchaseAmount() : BigDecimal.ZERO;
        } else {
            cap = order.getPayableAmount() != null ? order.getPayableAmount() : BigDecimal.ZERO;
        }

        BigDecimal remainingAmount = cap.subtract(assignedAmount);
        if (remainingAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return null;
        }

        PaymentPlanAvailableOrderRespVO vo = new PaymentPlanAvailableOrderRespVO();
        vo.setId(order.getId());
        vo.setOrderNo(order.getOrderNo());
        vo.setRemainingAmount(remainingAmount);
        return vo;
    }

    private void validatePaymentPlanTarget(PaymentPlanSaveReqVO reqVO) {
        if (reqVO.getOrderId() == null || reqVO.getType() == null) {
            throw exception(PAYMENT_PLAN_REQUIRED_TARGET_MISSING);
        }
        if (Integer.valueOf(0).equals(reqVO.getType()) && reqVO.getSupplierId() == null) {
            throw exception(PAYMENT_PLAN_REQUIRED_TARGET_MISSING);
        }
        if (Integer.valueOf(1).equals(reqVO.getType()) && reqVO.getCustomerId() == null) {
            throw exception(PAYMENT_PLAN_REQUIRED_TARGET_MISSING);
        }
    }

    private void validatePaymentPlanAmount(BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw exception(PAYMENT_PLAN_AMOUNT_INVALID);
        }
    }

    private Long resolvePersistedSupplierId(PaymentPlanSaveReqVO reqVO) {
        if (Integer.valueOf(1).equals(reqVO.getType()) && reqVO.getSupplierId() == null) {
            return 0L;
        }
        return reqVO.getSupplierId();
    }

    private OrderDO lockOrder(Long orderId) {
        OrderDO order = orderService.getOrder(orderId);
        if (order == null) {
            throw exception(ORDER_NOT_EXISTS);
        }
        return order;
    }

    private void tryAutoCreateVoucher(PaymentPlanDO plan) {
        try {
            voucherService.createAutoVoucherFromPlan(plan);
        } catch (Exception e) {
            log.warn("[tryAutoCreateVoucher] 发票预制失败，跳过，不影响付款计划主流程，planId={}",
                    plan != null ? plan.getId() : null, e);
        }
    }

    private void tryAutoSyncVouchers(PaymentPlanDO plan) {
        try {
            voucherService.syncAutoVouchersFromPlan(plan);
        } catch (Exception e) {
            log.warn("[tryAutoSyncVouchers] 发票弱同步失败，跳过，不影响付款计划主流程，planId={}",
                    plan != null ? plan.getId() : null, e);
        }
    }

    private void tryAutoDeleteVouchers(PaymentPlanDO plan) {
        try {
            voucherService.deleteAutoVouchersByPlan(plan);
        } catch (Exception e) {
            log.warn("[tryAutoDeleteVouchers] 发票联删失败，跳过，不影响付款计划主流程，planId={}",
                    plan != null ? plan.getId() : null, e);
        }
    }

    private void validatePlanCap(PaymentPlanSaveReqVO reqVO, PaymentPlanDO existingPlan, BigDecimal targetAmount) {
        OrderDO order = orderService.getOrder(reqVO.getOrderId());
        if (order == null) {
            throw exception(ORDER_NOT_EXISTS);
        }

        BigDecimal cap;
        List<PaymentPlanDO> existingPlans;
        if (Integer.valueOf(0).equals(reqVO.getType()) && reqVO.getPurchaseOrderId() != null) {
            PurchaseOrderDO purchaseOrder = purchaseOrderService.getPurchaseOrder(reqVO.getPurchaseOrderId());
            if (purchaseOrder == null) {
                throw exception(PURCHASE_ORDER_NOT_EXISTS);
            }
            cap = purchaseOrder.getTotalAmount() != null ? purchaseOrder.getTotalAmount() : BigDecimal.ZERO;
            existingPlans = paymentPlanMapper.selectListByPurchaseOrderId(reqVO.getPurchaseOrderId()).stream()
                    .filter(plan -> Objects.equals(plan.getType(), reqVO.getType()))
                    .filter(plan -> !Objects.equals(plan.getStatus(), PaymentPlanStatusEnum.CANCELLED.getStatus()))
                    .filter(plan -> existingPlan == null || !Objects.equals(plan.getId(), existingPlan.getId()))
                    .collect(Collectors.toList());
        } else if (Integer.valueOf(0).equals(reqVO.getType())) {
            cap = orderService.getOrderItemList(reqVO.getOrderId()).stream()
                    .filter(item -> Objects.equals(item.getSupplierId(), reqVO.getSupplierId()))
                    .map(item -> item.getPurchaseAmount() != null ? item.getPurchaseAmount() : BigDecimal.ZERO)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            existingPlans = paymentPlanMapper.selectListByOrderId(reqVO.getOrderId()).stream()
                    .filter(plan -> Objects.equals(plan.getType(), reqVO.getType()))
                    .filter(plan -> !Objects.equals(plan.getStatus(), PaymentPlanStatusEnum.CANCELLED.getStatus()))
                    .filter(plan -> existingPlan == null || !Objects.equals(plan.getId(), existingPlan.getId()))
                    .filter(plan -> Objects.equals(plan.getSupplierId(), reqVO.getSupplierId()))
                    .collect(Collectors.toList());
        } else {
            cap = order.getPayableAmount() != null ? order.getPayableAmount() : BigDecimal.ZERO;
            existingPlans = paymentPlanMapper.selectListByOrderId(reqVO.getOrderId()).stream()
                    .filter(plan -> Objects.equals(plan.getType(), reqVO.getType()))
                    .filter(plan -> !Objects.equals(plan.getStatus(), PaymentPlanStatusEnum.CANCELLED.getStatus()))
                    .filter(plan -> existingPlan == null || !Objects.equals(plan.getId(), existingPlan.getId()))
                    .collect(Collectors.toList());
        }

        BigDecimal existingTotal = existingPlans.stream()
                .map(plan -> plan.getPlanAmount() != null ? plan.getPlanAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        if (existingTotal.add(targetAmount).compareTo(cap) > 0) {
            throw exception(PAYMENT_PLAN_CAP_EXCEEDED);
        }
    }

}
