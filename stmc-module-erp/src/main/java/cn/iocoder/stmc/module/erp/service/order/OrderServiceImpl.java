package cn.iocoder.stmc.module.erp.service.order;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.IdUtil;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.stmc.module.erp.controller.admin.order.vo.OrderCostFillReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.order.vo.OrderItemSaveReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.order.vo.OrderPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.order.vo.OrderSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.customer.CustomerDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderItemDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.payment.PaymentDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.paymentplan.PaymentPlanDO;
import cn.iocoder.stmc.module.erp.dal.mysql.order.OrderItemMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.order.OrderMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.payment.PaymentMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.paymentplan.PaymentPlanMapper;
import cn.iocoder.stmc.module.erp.enums.OrderStatusEnum;
import cn.iocoder.stmc.module.erp.enums.PaymentPlanStatusEnum;
import cn.iocoder.stmc.module.erp.enums.PaymentStatusEnum;
import cn.iocoder.stmc.module.erp.service.customer.CustomerService;
import cn.iocoder.stmc.module.erp.service.payment.PaymentService;
import cn.iocoder.stmc.module.erp.service.paymentplan.PaymentPlanService;
import cn.iocoder.stmc.module.erp.service.supplier.SupplierService;
import cn.iocoder.stmc.module.erp.util.MoneyUtils;
import cn.iocoder.stmc.module.system.api.user.AdminUserApi;
import cn.iocoder.stmc.module.system.api.user.dto.AdminUserRespDTO;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

import static cn.iocoder.stmc.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.stmc.module.erp.enums.ErrorCodeConstants.*;

/**
 * ERP 订单 Service 实现类
 *
 * @author stmc
 */
@Service
@Validated
public class OrderServiceImpl implements OrderService {

    /**
     * 订单状态流转规则（新）
     * 0=待审核 → 10=待填充成本 → 20=已完成
     * 任意状态可取消 → 50=已取消
     */
    private static final Map<Integer, Set<Integer>> VALID_STATUS_TRANSITIONS = new HashMap<>();
    static {
        VALID_STATUS_TRANSITIONS.put(0, new HashSet<>(Arrays.asList(10, 50)));   // 待审核 -> 待填充成本、已取消
        VALID_STATUS_TRANSITIONS.put(10, new HashSet<>(Arrays.asList(20, 50)));  // 待填充成本 -> 已完成、已取消
        VALID_STATUS_TRANSITIONS.put(20, Collections.emptySet());                 // 已完成 -> 无
        VALID_STATUS_TRANSITIONS.put(50, Collections.emptySet());                 // 已取消 -> 无
    }

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private OrderItemMapper orderItemMapper;

    @Resource
    private PaymentPlanMapper paymentPlanMapper;

    @Resource
    private PaymentMapper paymentMapper;


    @Resource
    private CustomerService customerService;

    @Resource
    private SupplierService supplierService;

    @Resource
    private AdminUserApi adminUserApi;

    @Resource
    @Lazy // 避免循环依赖
    private PaymentService paymentService;



    @Resource
    @Lazy // 避免循环依赖
    private PaymentPlanService paymentPlanService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createOrder(OrderSaveReqVO createReqVO) {
        // 校验客户/供应商是否存在
        validateCustomerOrSupplier(createReqVO.getOrderType(), createReqVO.getCustomerId(), createReqVO.getSupplierId());

        // 生成订单号
        String orderNo = generateOrderNo(createReqVO.getOrderType());

        // 构建订单主体
        OrderDO order = BeanUtils.toBean(createReqVO, OrderDO.class);
        order.setOrderNo(orderNo);
        order.setStatus(OrderStatusEnum.PENDING_REVIEW.getStatus()); // 待审核
        order.setPaidAmount(BigDecimal.ZERO);
        order.setCostFilled(false);

        // 设置业务员信息
        Long loginUserId = SecurityFrameworkUtils.getLoginUserId();
        order.setSalesmanId(loginUserId);
        if (loginUserId != null) {
            AdminUserRespDTO user = adminUserApi.getUser(loginUserId);
            if (user != null) {
                order.setSalesmanName(user.getNickname());
            }
        }

        // 从明细计算汇总金额
        List<OrderItemSaveReqVO> items = createReqVO.getItems();
        BigDecimal totalQuantity = BigDecimal.ZERO;
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (OrderItemSaveReqVO item : items) {
            totalQuantity = totalQuantity.add(item.getSaleQuantity() != null ? item.getSaleQuantity() : BigDecimal.ZERO);
            // 优先使用前端传的金额，否则用 数量×单价 计算
            BigDecimal saleAmount = item.getSaleAmount();
            if (saleAmount == null || saleAmount.compareTo(BigDecimal.ZERO) == 0) {
                saleAmount = (item.getSaleQuantity() != null ? item.getSaleQuantity() : BigDecimal.ZERO)
                        .multiply(item.getSalePrice() != null ? item.getSalePrice() : BigDecimal.ZERO);
            }
            item.setSaleAmount(saleAmount);
            totalAmount = totalAmount.add(saleAmount);
        }
        order.setTotalQuantity(totalQuantity);
        order.setTotalAmount(totalAmount);

        // 计算应付金额（含运费）
        BigDecimal shippingFee = order.getShippingFee() != null ? order.getShippingFee() : BigDecimal.ZERO;
        BigDecimal discountAmount = order.getDiscountAmount() != null ? order.getDiscountAmount() : BigDecimal.ZERO;
        order.setPayableAmount(totalAmount.add(shippingFee).subtract(discountAmount));

        // 插入订单
        orderMapper.insert(order);

        // 插入明细
        for (OrderItemSaveReqVO itemVO : items) {
            OrderItemDO item = BeanUtils.toBean(itemVO, OrderItemDO.class);
            item.setOrderId(order.getId());
            orderItemMapper.insert(item);
        }

        return order.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateOrder(OrderSaveReqVO updateReqVO) {
        // 校验存在
        OrderDO order = validateOrderExists(updateReqVO.getId());

        // 校验状态：待审核(0) 或 被驳回(50+有拒绝原因) 可修改
        boolean canEdit = OrderStatusEnum.PENDING_REVIEW.getStatus().equals(order.getStatus())
                || isRejectedOrder(order);

        if (!canEdit) {
            throw exception(ORDER_STATUS_NOT_ALLOW_UPDATE);
        }

        // 校验客户/供应商是否存在
        validateCustomerOrSupplier(updateReqVO.getOrderType(), updateReqVO.getCustomerId(), updateReqVO.getSupplierId());

        // 更新订单主体
        OrderDO updateObj = BeanUtils.toBean(updateReqVO, OrderDO.class);

        // 如果是被驳回的订单重新编辑，状态改回待审核，清空拒绝原因
        if (isRejectedOrder(order)) {
            updateObj.setStatus(OrderStatusEnum.PENDING_REVIEW.getStatus());
            updateObj.setRemark(null);
        }

        // 从明细计算汇总金额
        List<OrderItemSaveReqVO> items = updateReqVO.getItems();
        BigDecimal totalQuantity = BigDecimal.ZERO;
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (OrderItemSaveReqVO item : items) {
            totalQuantity = totalQuantity.add(item.getSaleQuantity() != null ? item.getSaleQuantity() : BigDecimal.ZERO);
            // 优先使用前端传的金额，否则用 数量×单价 计算
            BigDecimal saleAmount = item.getSaleAmount();
            if (saleAmount == null || saleAmount.compareTo(BigDecimal.ZERO) == 0) {
                saleAmount = (item.getSaleQuantity() != null ? item.getSaleQuantity() : BigDecimal.ZERO)
                        .multiply(item.getSalePrice() != null ? item.getSalePrice() : BigDecimal.ZERO);
            }
            item.setSaleAmount(saleAmount);
            totalAmount = totalAmount.add(saleAmount);
        }
        updateObj.setTotalQuantity(totalQuantity);
        updateObj.setTotalAmount(totalAmount);

        // 计算应付金额
        BigDecimal shippingFee = updateObj.getShippingFee() != null ? updateObj.getShippingFee() : BigDecimal.ZERO;
        BigDecimal discountAmount = updateObj.getDiscountAmount() != null ? updateObj.getDiscountAmount() : BigDecimal.ZERO;
        updateObj.setPayableAmount(totalAmount.add(shippingFee).subtract(discountAmount));

        orderMapper.updateById(updateObj);

        // 删除旧明细，插入新明细
        orderItemMapper.deleteByOrderId(order.getId());
        for (OrderItemSaveReqVO itemVO : items) {
            OrderItemDO item = BeanUtils.toBean(itemVO, OrderItemDO.class);
            item.setId(null); // 清空ID，插入新记录
            item.setOrderId(order.getId());
            orderItemMapper.insert(item);
        }
    }

    @Override
    public void updateOrderStatus(Long id, Integer status) {
        // 校验存在
        OrderDO order = validateOrderExists(id);
        // 校验状态流转是否合法
        validateStatusTransition(order.getStatus(), status);
        // 更新状态
        OrderDO updateObj = new OrderDO();
        updateObj.setId(id);
        updateObj.setStatus(status);
        orderMapper.updateById(updateObj);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteOrder(Long id) {
        // 校验存在
        OrderDO order = validateOrderExists(id);

        // 校验状态：只有待审核/已取消可以删除
        if (!OrderStatusEnum.PENDING_REVIEW.getStatus().equals(order.getStatus())
                && !OrderStatusEnum.CANCELLED.getStatus().equals(order.getStatus())) {
            throw exception(ORDER_DELETE_NOT_ALLOW);
        }

        // 删除关联通知（根据付款计划ID）
        List<Long> planIds = paymentPlanMapper.selectListByOrderId(id).stream()
                .map(PaymentPlanDO::getId)
                .collect(Collectors.toList());
        if (!planIds.isEmpty()) {
            paymentPlanService.deleteNotificationsByPlanIds(planIds);
        }

        // 删除付款计划
        paymentPlanMapper.deleteByOrderId(id);

        // 删除付款单
        paymentMapper.deleteByOrderId(id);

        // 删除订单明细
        orderItemMapper.deleteByOrderId(id);

        // 删除订单
        orderMapper.deleteById(id);
    }

    @Override
    public void deleteOrderList(List<Long> ids) {
        ids.forEach(this::deleteOrder);
    }

    private OrderDO validateOrderExists(Long id) {
        OrderDO order = orderMapper.selectById(id);
        if (order == null) {
            throw exception(ORDER_NOT_EXISTS);
        }
        return order;
    }

    @Override
    public OrderDO getOrder(Long id) {
        return orderMapper.selectById(id);
    }

    @Override
    public PageResult<OrderDO> getOrderPage(OrderPageReqVO pageReqVO) {
        return orderMapper.selectPage(pageReqVO);
    }

    @Override
    public List<OrderDO> getOrderSimpleList() {
        return orderMapper.selectList();
    }

    @Override
    public List<OrderDO> getOrderListBySupplierId(Long supplierId) {
        return orderMapper.selectList(OrderDO::getSupplierId, supplierId);
    }

    @Override
    public void updateOrderPaidAmount(Long id, BigDecimal paidAmountDelta) {
        OrderDO order = validateOrderExists(id);
        BigDecimal newPaidAmount = (order.getPaidAmount() != null ? order.getPaidAmount() : BigDecimal.ZERO)
                .add(paidAmountDelta);
        OrderDO updateObj = new OrderDO();
        updateObj.setId(id);
        updateObj.setPaidAmount(newPaidAmount);
        orderMapper.updateById(updateObj);
    }

    @Override
    public Map<Long, OrderDO> getOrderMap(Collection<Long> ids) {
        if (CollUtil.isEmpty(ids)) {
            return Collections.emptyMap();
        }
        List<OrderDO> list = orderMapper.selectBatchIds(ids);
        return list.stream().collect(Collectors.toMap(OrderDO::getId, o -> o));
    }

    // ========== 订单明细相关 ==========

    @Override
    public List<OrderItemDO> getOrderItemList(Long orderId) {
        return orderItemMapper.selectListByOrderId(orderId);
    }

    @Override
    public List<OrderItemDO> getOrderItemListByOrderIds(List<Long> orderIds) {
        if (CollUtil.isEmpty(orderIds)) {
            return Collections.emptyList();
        }
        return orderItemMapper.selectListByOrderIds(orderIds);
    }

    // ========== 成本填充相关 ==========

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void fillOrderCost(OrderCostFillReqVO fillReqVO) {
        // 1. 校验订单存在
        OrderDO order = validateOrderExists(fillReqVO.getOrderId());

        // 2. 校验订单状态（只有待填充成本状态可以填充）
        if (!OrderStatusEnum.PENDING_COST.getStatus().equals(order.getStatus())) {
            throw exception(ORDER_STATUS_NOT_ALLOW_FILL_COST);
        }

        // 3. 校验同供应商的付款日期和付款状态一致性
        validateSupplierPaymentConsistency(fillReqVO.getItems());

        // 4. 获取订单明细
        List<OrderItemDO> items = orderItemMapper.selectListByOrderId(order.getId());
        Map<Long, OrderItemDO> itemMap = items.stream().collect(Collectors.toMap(OrderItemDO::getId, i -> i));

        // 5. 更新明细成本信息
        BigDecimal totalPurchaseAmount = BigDecimal.ZERO;
        BigDecimal totalGrossProfit = BigDecimal.ZERO;
        BigDecimal totalTaxAmount = BigDecimal.ZERO;
        BigDecimal totalNetProfit = BigDecimal.ZERO;

        // 按供应商分组聚合采购金额（用于后续创建付款单）
        // Map<supplierId, {totalAmount, paymentDate, isPaid}>
        Map<Long, SupplierPaymentInfo> supplierPaymentMap = new HashMap<>();

        for (OrderCostFillReqVO.ItemCost itemCost : fillReqVO.getItems()) {
            OrderItemDO item = itemMap.get(itemCost.getItemId());
            if (item == null) {
                continue; // 跳过不存在的明细
            }

            // 更新采购信息
            item.setPurchaseUnit(itemCost.getPurchaseUnit());
            item.setPurchaseQuantity(itemCost.getPurchaseQuantity());
            item.setPurchasePrice(itemCost.getPurchasePrice());

            // 计算采购金额
            BigDecimal purchaseAmount = itemCost.getPurchaseAmount();
            if (purchaseAmount == null && itemCost.getPurchaseQuantity() != null && itemCost.getPurchasePrice() != null) {
                purchaseAmount = itemCost.getPurchaseQuantity().multiply(itemCost.getPurchasePrice());
            }
            item.setPurchaseAmount(purchaseAmount != null ? purchaseAmount : BigDecimal.ZERO);

            item.setPurchaseRemark(itemCost.getPurchaseRemark());
            item.setSupplierId(itemCost.getSupplierId());
            item.setTaxAmount(itemCost.getTaxAmount());

            // 新增：设置付款日期和付款状态
            item.setPaymentDate(itemCost.getPaymentDate());
            item.setIsPaid(itemCost.getIsPaid());

            // 计算毛利（销售金额 - 采购金额）
            BigDecimal grossProfit = (item.getSaleAmount() != null ? item.getSaleAmount() : BigDecimal.ZERO)
                    .subtract(item.getPurchaseAmount() != null ? item.getPurchaseAmount() : BigDecimal.ZERO);
            item.setGrossProfit(grossProfit);

            // 计算净利（毛利 - 税额）
            BigDecimal taxAmount = item.getTaxAmount() != null ? item.getTaxAmount() : BigDecimal.ZERO;
            item.setNetProfit(grossProfit.subtract(taxAmount));

            // 更新明细
            orderItemMapper.updateById(item);

            // 累计汇总
            totalPurchaseAmount = totalPurchaseAmount.add(item.getPurchaseAmount());
            totalGrossProfit = totalGrossProfit.add(grossProfit);
            totalTaxAmount = totalTaxAmount.add(taxAmount);
            totalNetProfit = totalNetProfit.add(item.getNetProfit());

            // 按供应商聚合采购金额（只有有供应商的明细才生成付款单）
            if (itemCost.getSupplierId() != null && item.getPurchaseAmount().compareTo(BigDecimal.ZERO) > 0) {
                SupplierPaymentInfo paymentInfo = supplierPaymentMap.computeIfAbsent(
                        itemCost.getSupplierId(),
                        k -> new SupplierPaymentInfo(itemCost.getPaymentDate(), itemCost.getIsPaid())
                );
                paymentInfo.addAmount(item.getPurchaseAmount());
                paymentInfo.addRemark(itemCost.getPurchaseRemark()); // 聚合备注
            }
        }

        // 6. 更新订单汇总信息
        // 注意：paidAmount 是客户付给我们的钱，不是我们付给供应商的钱
        // 填充成本时不修改 paidAmount，由"标注已付款"功能单独处理
        OrderDO updateOrder = new OrderDO();
        updateOrder.setId(order.getId());
        updateOrder.setTotalPurchaseAmount(totalPurchaseAmount);
        updateOrder.setTotalGrossProfit(totalGrossProfit);
        updateOrder.setTotalTaxAmount(totalTaxAmount);
        // 其他费用扣减净利
        BigDecimal extraCost = fillReqVO.getExtraCost() != null ? fillReqVO.getExtraCost() : BigDecimal.ZERO;
        updateOrder.setTotalNetProfit(totalNetProfit.subtract(extraCost));
        updateOrder.setExtraCost(fillReqVO.getExtraCost());
        updateOrder.setExtraCostRemark(fillReqVO.getExtraCostRemark());
        // 不更新 paidAmount，保持原值
        updateOrder.setCostFilled(true);
        updateOrder.setCostFilledBy(SecurityFrameworkUtils.getLoginUserId());
        updateOrder.setCostFilledTime(LocalDateTime.now());
        updateOrder.setStatus(OrderStatusEnum.COMPLETED.getStatus()); // 填充成本后直接完成

        orderMapper.updateById(updateOrder);

        // 7. 为每个供应商创建付款单
        for (Map.Entry<Long, SupplierPaymentInfo> entry : supplierPaymentMap.entrySet()) {
            Long supplierId = entry.getKey();
            SupplierPaymentInfo paymentInfo = entry.getValue();

            // 创建付款单（单期，不使用供应商账期配置）
            paymentService.createPaymentFromCostFill(
                    supplierId,
                    order.getId(),
                    paymentInfo.getTotalAmount(),
                    paymentInfo.getPaymentDate(),
                    paymentInfo.getIsPaid(),
                    paymentInfo.getRemark()  // 传入聚合后的备注
            );
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void editOrderCost(OrderCostFillReqVO editReqVO) {
        // 1. 校验订单存在
        OrderDO order = validateOrderExists(editReqVO.getOrderId());

        // 2. 校验订单状态：只有已完成状态可以编辑成本
        if (!OrderStatusEnum.COMPLETED.getStatus().equals(order.getStatus())) {
            throw exception(ORDER_STATUS_NOT_ALLOW_EDIT_COST);
        }

        // 3. 校验成本是否已填充
        if (!Boolean.TRUE.equals(order.getCostFilled())) {
            throw exception(ORDER_COST_NOT_FILLED);
        }

        // 4. 校验供应商付款一致性（复用现有方法）
        validateSupplierPaymentConsistency(editReqVO.getItems());

        // 5. 获取订单明细
        List<OrderItemDO> items = orderItemMapper.selectListByOrderId(order.getId());
        Map<Long, OrderItemDO> itemMap = items.stream().collect(Collectors.toMap(OrderItemDO::getId, i -> i));

        // 6. 更新明细成本信息（与fillOrderCost相同逻辑）
        BigDecimal totalPurchaseAmount = BigDecimal.ZERO;
        BigDecimal totalGrossProfit = BigDecimal.ZERO;
        BigDecimal totalTaxAmount = BigDecimal.ZERO;
        BigDecimal totalNetProfit = BigDecimal.ZERO;

        // 按供应商分组聚合采购金额（用于后续同步付款单）
        Map<Long, SupplierPaymentInfo> newSupplierPaymentMap = new HashMap<>();

        for (OrderCostFillReqVO.ItemCost itemCost : editReqVO.getItems()) {
            OrderItemDO item = itemMap.get(itemCost.getItemId());
            if (item == null) {
                continue; // 跳过不存在的明细
            }

            // 更新采购信息
            item.setPurchaseUnit(itemCost.getPurchaseUnit());
            item.setPurchaseQuantity(itemCost.getPurchaseQuantity());
            item.setPurchasePrice(itemCost.getPurchasePrice());

            // 计算采购金额
            BigDecimal purchaseAmount = itemCost.getPurchaseAmount();
            if (purchaseAmount == null && itemCost.getPurchaseQuantity() != null && itemCost.getPurchasePrice() != null) {
                purchaseAmount = itemCost.getPurchaseQuantity().multiply(itemCost.getPurchasePrice());
            }
            item.setPurchaseAmount(purchaseAmount != null ? purchaseAmount : BigDecimal.ZERO);

            item.setPurchaseRemark(itemCost.getPurchaseRemark());
            item.setSupplierId(itemCost.getSupplierId());
            item.setTaxAmount(itemCost.getTaxAmount());

            // 设置付款日期和付款状态
            item.setPaymentDate(itemCost.getPaymentDate());
            item.setIsPaid(itemCost.getIsPaid());

            // 计算毛利（销售金额 - 采购金额）
            BigDecimal grossProfit = (item.getSaleAmount() != null ? item.getSaleAmount() : BigDecimal.ZERO)
                    .subtract(item.getPurchaseAmount() != null ? item.getPurchaseAmount() : BigDecimal.ZERO);
            item.setGrossProfit(grossProfit);

            // 计算净利（毛利 - 税额）
            BigDecimal taxAmount = item.getTaxAmount() != null ? item.getTaxAmount() : BigDecimal.ZERO;
            item.setNetProfit(grossProfit.subtract(taxAmount));

            // 更新明细
            orderItemMapper.updateById(item);

            // 累计汇总
            totalPurchaseAmount = totalPurchaseAmount.add(item.getPurchaseAmount());
            totalGrossProfit = totalGrossProfit.add(grossProfit);
            totalTaxAmount = totalTaxAmount.add(taxAmount);
            totalNetProfit = totalNetProfit.add(item.getNetProfit());

            // 按供应商聚合采购金额（只有有供应商的明细才需要同步付款单）
            if (itemCost.getSupplierId() != null && item.getPurchaseAmount().compareTo(BigDecimal.ZERO) > 0) {
                SupplierPaymentInfo paymentInfo = newSupplierPaymentMap.computeIfAbsent(
                        itemCost.getSupplierId(),
                        k -> new SupplierPaymentInfo(itemCost.getPaymentDate(), itemCost.getIsPaid())
                );
                paymentInfo.addAmount(item.getPurchaseAmount());
                paymentInfo.addRemark(itemCost.getPurchaseRemark());
            }
        }

        // 7. 更新订单汇总成本（不更新costFilled、costFilledBy、costFilledTime，保留首次填充信息）
        // 注意：paidAmount 是客户付给我们的钱，不是我们付给供应商的钱
        // 编辑成本时不修改 paidAmount，保持原值
        OrderDO updateOrder = new OrderDO();
        updateOrder.setId(order.getId());
        updateOrder.setTotalPurchaseAmount(totalPurchaseAmount);
        updateOrder.setTotalGrossProfit(totalGrossProfit);
        updateOrder.setTotalTaxAmount(totalTaxAmount);
        // 其他费用扣减净利
        BigDecimal extraCost = editReqVO.getExtraCost() != null ? editReqVO.getExtraCost() : BigDecimal.ZERO;
        updateOrder.setTotalNetProfit(totalNetProfit.subtract(extraCost));
        updateOrder.setExtraCost(editReqVO.getExtraCost());
        updateOrder.setExtraCostRemark(editReqVO.getExtraCostRemark());
        // 不更新 paidAmount，保持原值
        orderMapper.updateById(updateOrder);

        // 8. 付款单处理（区分已付款和未付款，保留审计记录）
        Long orderId = order.getId();

        // 8.1 获取现有付款单
        List<PaymentDO> existingPayments = paymentMapper.selectListByOrderId(orderId);

        for (PaymentDO payment : existingPayments) {
            List<PaymentPlanDO> plans = paymentPlanMapper.selectListByPaymentId(payment.getId());

            // 检查是否有已付款的计划
            boolean hasPaidPlan = plans.stream()
                    .anyMatch(p -> PaymentPlanStatusEnum.PAID.getStatus().equals(p.getStatus()));

            if (hasPaidPlan) {
                // 已付款 - 逻辑取消，保留审计记录
                PaymentDO update = new PaymentDO();
                update.setId(payment.getId());
                update.setStatus(PaymentStatusEnum.CANCELLED.getStatus());
                update.setRemark((payment.getRemark() != null ? payment.getRemark() + "；" : "")
                        + "订单编辑成本时取消，原因：成本信息变更");
                paymentMapper.updateById(update);

                // 取消未付款的付款计划（不物理删除）
                for (PaymentPlanDO plan : plans) {
                    if (!PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus())) {
                        PaymentPlanDO planUpdate = new PaymentPlanDO();
                        planUpdate.setId(plan.getId());
                        planUpdate.setStatus(PaymentPlanStatusEnum.CANCELLED.getStatus());
                        paymentPlanMapper.updateById(planUpdate);
                    }
                }
            } else {
                // 未付款 - 物理删除
                List<Long> planIds = plans.stream().map(PaymentPlanDO::getId).collect(Collectors.toList());
                if (!planIds.isEmpty()) {
                    paymentPlanService.deleteNotificationsByPlanIds(planIds);
                }
                paymentPlanMapper.deleteByPaymentId(payment.getId());
                paymentMapper.deleteById(payment.getId());
            }
        }

        // 8.2 按新的供应商分组重新生成付款单（复用fillOrderCost的逻辑）
        for (Map.Entry<Long, SupplierPaymentInfo> entry : newSupplierPaymentMap.entrySet()) {
            Long supplierId = entry.getKey();
            SupplierPaymentInfo paymentInfo = entry.getValue();

            // 创建付款单（单期，不使用供应商账期配置）
            paymentService.createPaymentFromCostFill(
                    supplierId,
                    orderId,
                    paymentInfo.getTotalAmount(),
                    paymentInfo.getPaymentDate(),
                    paymentInfo.getIsPaid(),
                    paymentInfo.getRemark()
            );
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void editOrderItems(OrderSaveReqVO editReqVO) {
        // 1. 校验订单存在
        OrderDO order = validateOrderExists(editReqVO.getId());

        // 2. 校验订单状态：必须是已完成状态
        if (!OrderStatusEnum.COMPLETED.getStatus().equals(order.getStatus())) {
            throw exception(ORDER_STATUS_NOT_ALLOW_EDIT_ITEMS);
        }

        // 3. 校验成本是否已填充
        if (!Boolean.TRUE.equals(order.getCostFilled())) {
            throw exception(ORDER_COST_NOT_FILLED);
        }

        // 3.1 校验商品明细不能为空
        if (CollUtil.isEmpty(editReqVO.getItems())) {
            throw exception(ORDER_ITEMS_CANNOT_BE_EMPTY);
        }

        // 4. 校验供应商付款一致性
        validateSupplierPaymentConsistencyForItems(editReqVO.getItems());

        // 5. 建立旧明细映射（在删除前），用于保留未传递的字段值
        List<OrderItemDO> oldItems = orderItemMapper.selectListByOrderId(order.getId());
        Map<Long, OrderItemDO> oldItemMap = oldItems.stream()
                .collect(Collectors.toMap(OrderItemDO::getId, i -> i, (a, b) -> a));

        // 6. 删除旧明细，插入新明细
        orderItemMapper.deleteByOrderId(order.getId());

        BigDecimal totalQuantity = BigDecimal.ZERO;
        BigDecimal totalAmount = BigDecimal.ZERO;
        BigDecimal totalPurchaseAmount = BigDecimal.ZERO;
        BigDecimal totalGrossProfit = BigDecimal.ZERO;
        BigDecimal totalTaxAmount = BigDecimal.ZERO;
        BigDecimal totalNetProfit = BigDecimal.ZERO;

        // 按供应商分组聚合采购金额
        Map<Long, SupplierPaymentInfo> supplierPaymentMap = new HashMap<>();

        for (OrderItemSaveReqVO itemVO : editReqVO.getItems()) {
            OrderItemDO item = BeanUtils.toBean(itemVO, OrderItemDO.class);
            item.setId(null); // 清空ID，插入新记录
            item.setOrderId(order.getId());

            // 计算销售金额
            BigDecimal saleAmount = itemVO.getSaleAmount();
            if (saleAmount == null || saleAmount.compareTo(BigDecimal.ZERO) == 0) {
                saleAmount = (itemVO.getSaleQuantity() != null ? itemVO.getSaleQuantity() : BigDecimal.ZERO)
                        .multiply(itemVO.getSalePrice() != null ? itemVO.getSalePrice() : BigDecimal.ZERO);
            }
            item.setSaleAmount(saleAmount);

            // 计算采购金额（三层保护：前端传值 > 计算值 > 旧值 > 0）
            BigDecimal purchaseAmount = itemVO.getPurchaseAmount();
            if (purchaseAmount == null && itemVO.getPurchaseQuantity() != null && itemVO.getPurchasePrice() != null) {
                purchaseAmount = itemVO.getPurchaseQuantity().multiply(itemVO.getPurchasePrice());
            }
            if (purchaseAmount == null && itemVO.getId() != null) {
                OrderItemDO oldItem = oldItemMap.get(itemVO.getId());
                if (oldItem != null && oldItem.getPurchaseAmount() != null) {
                    purchaseAmount = oldItem.getPurchaseAmount();
                }
            }
            if (purchaseAmount == null) {
                purchaseAmount = BigDecimal.ZERO;
            }
            item.setPurchaseAmount(purchaseAmount);

            // 计算税额（三层保护：前端传值 > 旧值 > 0）
            BigDecimal taxAmount = itemVO.getTaxAmount();
            if (taxAmount == null && itemVO.getId() != null) {
                OrderItemDO oldItem = oldItemMap.get(itemVO.getId());
                if (oldItem != null && oldItem.getTaxAmount() != null) {
                    taxAmount = oldItem.getTaxAmount();
                }
            }
            if (taxAmount == null) {
                taxAmount = BigDecimal.ZERO;
            }

            // 计算毛利和净利
            BigDecimal grossProfit = saleAmount.subtract(item.getPurchaseAmount());
            item.setGrossProfit(grossProfit);
            item.setTaxAmount(taxAmount);
            item.setNetProfit(grossProfit.subtract(taxAmount));

            // 插入明细
            orderItemMapper.insert(item);

            // 累计汇总
            totalQuantity = totalQuantity.add(itemVO.getSaleQuantity() != null ? itemVO.getSaleQuantity() : BigDecimal.ZERO);
            totalAmount = totalAmount.add(saleAmount);
            totalPurchaseAmount = totalPurchaseAmount.add(item.getPurchaseAmount());
            totalGrossProfit = totalGrossProfit.add(grossProfit);
            totalTaxAmount = totalTaxAmount.add(taxAmount);
            totalNetProfit = totalNetProfit.add(item.getNetProfit());

            // 按供应商聚合采购金额
            if (itemVO.getSupplierId() != null && item.getPurchaseAmount().compareTo(BigDecimal.ZERO) > 0) {
                SupplierPaymentInfo paymentInfo = supplierPaymentMap.computeIfAbsent(
                        itemVO.getSupplierId(),
                        k -> new SupplierPaymentInfo(itemVO.getPaymentDate(), itemVO.getIsPaid())
                );
                paymentInfo.addAmount(item.getPurchaseAmount());
                paymentInfo.addRemark(itemVO.getPurchaseRemark());
            }
        }

        // 6. 更新订单汇总（销售汇总 + 成本汇总）
        // 三层null安全处理，防止NPE
        BigDecimal shippingFee = editReqVO.getShippingFee();
        if (shippingFee == null) {
            shippingFee = order.getShippingFee();
        }
        if (shippingFee == null) {
            shippingFee = BigDecimal.ZERO;
        }

        BigDecimal discountAmount = editReqVO.getDiscountAmount();
        if (discountAmount == null) {
            discountAmount = order.getDiscountAmount();
        }
        if (discountAmount == null) {
            discountAmount = BigDecimal.ZERO;
        }

        OrderDO updateOrder = new OrderDO();
        updateOrder.setId(order.getId());
        updateOrder.setTotalQuantity(totalQuantity);
        updateOrder.setTotalAmount(totalAmount);
        updateOrder.setShippingFee(shippingFee);
        updateOrder.setDiscountAmount(discountAmount);
        updateOrder.setPayableAmount(totalAmount.add(shippingFee).subtract(discountAmount));
        updateOrder.setTotalPurchaseAmount(totalPurchaseAmount);
        updateOrder.setTotalGrossProfit(totalGrossProfit);
        updateOrder.setTotalTaxAmount(totalTaxAmount);
        // 其他费用扣减净利
        BigDecimal extraCostVal = BigDecimal.ZERO;
        if (editReqVO.getExtraCost() != null) {
            extraCostVal = editReqVO.getExtraCost();
            updateOrder.setExtraCost(editReqVO.getExtraCost());
            updateOrder.setExtraCostRemark(editReqVO.getExtraCostRemark());
        } else if (order.getExtraCost() != null) {
            extraCostVal = order.getExtraCost();
        }
        updateOrder.setTotalNetProfit(totalNetProfit.subtract(extraCostVal));
        // 不更新costFilled、costFilledBy、costFilledTime（保留首次填充信息）

        orderMapper.updateById(updateOrder);

        // 7. 付款单处理（区分已付款和未付款，保留审计记录）
        Long orderId = order.getId();

        // 7.1 获取现有付款单
        List<PaymentDO> existingPayments = paymentMapper.selectListByOrderId(orderId);

        for (PaymentDO payment : existingPayments) {
            List<PaymentPlanDO> plans = paymentPlanMapper.selectListByPaymentId(payment.getId());

            // 检查是否有已付款的计划
            boolean hasPaidPlan = plans.stream()
                    .anyMatch(p -> PaymentPlanStatusEnum.PAID.getStatus().equals(p.getStatus()));

            if (hasPaidPlan) {
                // 已付款 - 逻辑取消，保留审计记录
                PaymentDO update = new PaymentDO();
                update.setId(payment.getId());
                update.setStatus(PaymentStatusEnum.CANCELLED.getStatus());
                update.setRemark((payment.getRemark() != null ? payment.getRemark() + "；" : "")
                        + "订单编辑时取消，原因：商品信息变更");
                paymentMapper.updateById(update);

                // 取消未付款的付款计划（不物理删除）
                for (PaymentPlanDO plan : plans) {
                    if (!PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus())) {
                        PaymentPlanDO planUpdate = new PaymentPlanDO();
                        planUpdate.setId(plan.getId());
                        planUpdate.setStatus(PaymentPlanStatusEnum.CANCELLED.getStatus());
                        paymentPlanMapper.updateById(planUpdate);
                    }
                }
            } else {
                // 未付款 - 物理删除
                List<Long> planIds = plans.stream().map(PaymentPlanDO::getId).collect(Collectors.toList());
                if (!planIds.isEmpty()) {
                    paymentPlanService.deleteNotificationsByPlanIds(planIds);
                }
                paymentPlanMapper.deleteByPaymentId(payment.getId());
                paymentMapper.deleteById(payment.getId());
            }
        }

        // 7.2 按新的供应商分组重新生成付款单
        for (Map.Entry<Long, SupplierPaymentInfo> entry : supplierPaymentMap.entrySet()) {
            Long supplierId = entry.getKey();
            SupplierPaymentInfo paymentInfo = entry.getValue();

            paymentService.createPaymentFromCostFill(
                    supplierId,
                    order.getId(),
                    paymentInfo.getTotalAmount(),
                    paymentInfo.getPaymentDate(),
                    paymentInfo.getIsPaid(),
                    paymentInfo.getRemark()
            );
        }
    }

    /**
     * 校验同供应商的付款日期和付款状态一致性（OrderItemSaveReqVO版本）
     * 同一供应商的所有商品必须有相同的付款日期和付款状态
     */
    private void validateSupplierPaymentConsistencyForItems(List<OrderItemSaveReqVO> items) {
        // 按供应商分组
        Map<Long, List<OrderItemSaveReqVO>> supplierItemsMap = items.stream()
                .filter(item -> item.getSupplierId() != null)
                .collect(Collectors.groupingBy(OrderItemSaveReqVO::getSupplierId));

        // 检查每个供应商组内的一致性
        for (Map.Entry<Long, List<OrderItemSaveReqVO>> entry : supplierItemsMap.entrySet()) {
            List<OrderItemSaveReqVO> supplierItems = entry.getValue();
            if (supplierItems.size() <= 1) {
                continue; // 只有一个商品，无需校验
            }

            // 取第一个商品的付款日期和状态作为基准
            LocalDate basePaymentDate = supplierItems.get(0).getPaymentDate();
            Boolean baseIsPaid = supplierItems.get(0).getIsPaid();

            // 检查其他商品是否一致
            for (int i = 1; i < supplierItems.size(); i++) {
                OrderItemSaveReqVO item = supplierItems.get(i);
                LocalDate itemPaymentDate = item.getPaymentDate();
                Boolean itemIsPaid = item.getIsPaid();

                // 比较付款日期
                boolean dateMatch = (basePaymentDate == null && itemPaymentDate == null)
                        || (basePaymentDate != null && basePaymentDate.equals(itemPaymentDate));

                // 比较付款状态
                boolean paidMatch = (baseIsPaid == null && itemIsPaid == null)
                        || (baseIsPaid != null && baseIsPaid.equals(itemIsPaid));

                if (!dateMatch || !paidMatch) {
                    throw exception(ORDER_SUPPLIER_PAYMENT_INCONSISTENT);
                }
            }
        }
    }

    /**
     * 校验同供应商的付款日期和付款状态一致性
     * 同一供应商的所有商品必须有相同的付款日期和付款状态
     */
    private void validateSupplierPaymentConsistency(List<OrderCostFillReqVO.ItemCost> items) {
        // 按供应商分组
        Map<Long, List<OrderCostFillReqVO.ItemCost>> supplierItemsMap = items.stream()
                .filter(item -> item.getSupplierId() != null)
                .collect(Collectors.groupingBy(OrderCostFillReqVO.ItemCost::getSupplierId));

        // 检查每个供应商组内的一致性
        for (Map.Entry<Long, List<OrderCostFillReqVO.ItemCost>> entry : supplierItemsMap.entrySet()) {
            List<OrderCostFillReqVO.ItemCost> supplierItems = entry.getValue();
            if (supplierItems.size() <= 1) {
                continue; // 只有一个商品，无需校验
            }

            // 取第一个商品的付款日期和状态作为基准
            LocalDate basePaymentDate = supplierItems.get(0).getPaymentDate();
            Boolean baseIsPaid = supplierItems.get(0).getIsPaid();

            // 检查其他商品是否一致
            for (int i = 1; i < supplierItems.size(); i++) {
                OrderCostFillReqVO.ItemCost item = supplierItems.get(i);
                LocalDate itemPaymentDate = item.getPaymentDate();
                Boolean itemIsPaid = item.getIsPaid();

                // 比较付款日期
                boolean dateMatch = (basePaymentDate == null && itemPaymentDate == null)
                        || (basePaymentDate != null && basePaymentDate.equals(itemPaymentDate));

                // 比较付款状态
                boolean paidMatch = (baseIsPaid == null && itemIsPaid == null)
                        || (baseIsPaid != null && baseIsPaid.equals(itemIsPaid));

                if (!dateMatch || !paidMatch) {
                    throw exception(ORDER_SUPPLIER_PAYMENT_INCONSISTENT);
                }
            }
        }
    }

    /**
     * 供应商付款信息（用于聚合同供应商的采购金额）
     */
    private static class SupplierPaymentInfo {
        private BigDecimal totalAmount = BigDecimal.ZERO;
        private LocalDate paymentDate;
        private Boolean isPaid;
        private StringBuilder remarkBuilder = new StringBuilder();

        public SupplierPaymentInfo(LocalDate paymentDate, Boolean isPaid) {
            this.paymentDate = paymentDate;
            this.isPaid = isPaid;
        }

        public void addAmount(BigDecimal amount) {
            this.totalAmount = this.totalAmount.add(amount);
        }

        public void addRemark(String remark) {
            if (remark != null && !remark.isEmpty()) {
                if (remarkBuilder.length() > 0) {
                    remarkBuilder.append("; ");
                }
                remarkBuilder.append(remark);
            }
        }

        public BigDecimal getTotalAmount() {
            return totalAmount;
        }

        public LocalDate getPaymentDate() {
            return paymentDate;
        }

        public Boolean getIsPaid() {
            return isPaid;
        }

        public String getRemark() {
            return remarkBuilder.length() > 0 ? remarkBuilder.toString() : null;
        }
    }

    @Override
    public void approveOrder(Long id) {
        // 校验订单存在
        OrderDO order = validateOrderExists(id);

        // 校验订单状态（只有待审核状态可以审核）
        if (!OrderStatusEnum.PENDING_REVIEW.getStatus().equals(order.getStatus())) {
            throw exception(ORDER_STATUS_INVALID_TRANSITION);
        }

        // 更新状态为待填充成本
        OrderDO updateObj = new OrderDO();
        updateObj.setId(id);
        updateObj.setStatus(OrderStatusEnum.PENDING_COST.getStatus());
        orderMapper.updateById(updateObj);
    }

    @Override
    public void rejectOrder(Long id, String reason) {
        // 校验订单存在
        OrderDO order = validateOrderExists(id);

        // 校验订单状态（只有待审核状态可以拒绝）
        if (!OrderStatusEnum.PENDING_REVIEW.getStatus().equals(order.getStatus())) {
            throw exception(ORDER_STATUS_INVALID_TRANSITION);
        }

        // 更新状态为已取消，备注填入拒绝原因
        OrderDO updateObj = new OrderDO();
        updateObj.setId(id);
        updateObj.setStatus(OrderStatusEnum.CANCELLED.getStatus());
        if (reason != null && !reason.isEmpty()) {
            updateObj.setRemark((order.getRemark() != null ? order.getRemark() + "；" : "") + "拒绝原因：" + reason);
        }
        orderMapper.updateById(updateObj);
    }

    // ========== 私有方法 ==========

    /**
     * 生成订单号
     */
    private String generateOrderNo(Integer orderType) {
        String prefix = orderType == 1 ? "SO" : "PO"; // 销售订单/采购订单
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String randomStr = String.format("%04d", IdUtil.getSnowflakeNextId() % 10000);
        return prefix + dateStr + randomStr;
    }

    /**
     * 校验客户/供应商是否存在
     */
    private void validateCustomerOrSupplier(Integer orderType, Long customerId, Long supplierId) {
        if (orderType == 1) {
            // 销售订单必须关联客户
            if (customerId == null) {
                throw exception(ORDER_CUSTOMER_NOT_FOUND);
            }
            if (customerService.getCustomer(customerId) == null) {
                throw exception(ORDER_CUSTOMER_NOT_FOUND);
            }
        } else if (orderType == 2) {
            // 采购订单必须关联供应商
            if (supplierId == null) {
                throw exception(ORDER_SUPPLIER_NOT_FOUND);
            }
            if (supplierService.getSupplier(supplierId) == null) {
                throw exception(ORDER_SUPPLIER_NOT_FOUND);
            }
        }
    }

    /**
     * 校验状态流转是否合法
     */
    private void validateStatusTransition(Integer currentStatus, Integer targetStatus) {
        Set<Integer> allowedStatuses = VALID_STATUS_TRANSITIONS.get(currentStatus);
        if (allowedStatuses == null || !allowedStatuses.contains(targetStatus)) {
            throw exception(ORDER_STATUS_INVALID_TRANSITION);
        }
    }

    /**
     * 判断订单是否为被驳回状态（已取消 + 有拒绝原因）
     */
    private boolean isRejectedOrder(OrderDO order) {
        return OrderStatusEnum.CANCELLED.getStatus().equals(order.getStatus())
                && order.getRemark() != null
                && order.getRemark().contains("拒绝原因");
    }

    // ========== 打印导出相关 ==========

    @Override
    public void generatePrintExcel(OrderDO order, CustomerDO customer,
                                   List<OrderItemDO> items, String salesmanName,
                                   HttpServletResponse response) throws IOException {

        // 1. 准备数据
        String customerName = customer != null ? customer.getName() : "";
        String contact = customer != null ? customer.getContact() : "";
        String mobile = customer != null ? customer.getMobile() : "";

        // 2. 判断付款状态
        String paymentStatus = getPaymentStatusText(order);

        // 3. 创建工作簿
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("销售清单");

        // 4. 设置列宽（精确还原模板，单位：1/256字符宽度）
        sheet.setColumnWidth(0, (int)(12.30 * 256));  // A列：名称 - 12.30字符
        sheet.setColumnWidth(1, (int)(18.80 * 256));  // B列：规格 - 18.80字符
        sheet.setColumnWidth(2, (int)(9.40 * 256));   // C列：单位 - 9.40字符
        sheet.setColumnWidth(3, (int)(12.30 * 256));  // D列：数量 - 12.30字符
        sheet.setColumnWidth(4, (int)(11.80 * 256));  // E列：价格 - 11.80字符
        sheet.setColumnWidth(5, (int)(12.10 * 256));  // F列：总价 - 12.10字符
        sheet.setColumnWidth(6, (int)(18.00 * 256));  // G列：备注 - 18.00字符（单号更长）

        // 5. 创建样式
        CellStyle companyStyleCenter = createCenterTextStyle(workbook, 20);  // 公司名样式（20磅，居中，不加粗）
        CellStyle titleStyle14 = createTextStyle(workbook, 14);              // 销售清单、客户信息样式（14磅，不加粗）
        CellStyle headerStyle = createHeaderStyle(workbook);                  // 表头样式（12磅，居中不加粗带边框）
        CellStyle dataCenterStyle = createDataCenterBorderStyle(workbook);    // 数据居中+边框
        CellStyle normalStyle = createTextStyle(workbook, 12);                // 普通文本样式（12磅，不加粗）
        CellStyle wrapStyle = createWrapTextStyle(workbook, 14);              // 换行文本样式（14磅，不加粗）
        CellStyle totalBorderStyle = createDataCenterBorderStyle(workbook);   // 合计行样式（12磅，不加粗，居中，完整边框）

        int rowIndex = 0;

        // 6. 第1-2行：公司名称、销售清单、单号（垂直合并，行高20.40磅）
        Row titleRow1 = sheet.createRow(rowIndex++);
        Row titleRow2 = sheet.createRow(rowIndex++);
        titleRow1.setHeightInPoints(20.4f);
        titleRow2.setHeightInPoints(20.4f);

        // A-F列（第1-2行垂直合并）：公司名称（20磅）+ 销售清单（14磅），居中
        Cell companyCell = titleRow1.createCell(0);

        // 创建富文本，支持不同字号
        XSSFRichTextString richText = new XSSFRichTextString("成都尚泰铭成贸易有限公司  销售清单");

        // 第一段：公司名称（20磅）
        Font font20 = workbook.createFont();
        font20.setFontName("宋体");
        font20.setFontHeightInPoints((short) 20);
        font20.setBold(false);
        richText.applyFont(0, 12, font20); // "成都尚泰铭成贸易有限公司"12个字

        // 第二段：销售清单（14磅）
        Font font14 = workbook.createFont();
        font14.setFontName("宋体");
        font14.setFontHeightInPoints((short) 14);
        font14.setBold(false);
        richText.applyFont(14, 18, font14); // "销售清单"4个字（从索引14开始，因为有两个空格）

        companyCell.setCellValue(richText);
        companyCell.setCellStyle(companyStyleCenter);
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 5)); // 第1-2行，A-F列

        // G列（第1-2行垂直合并）：单号（14磅，换行，居中）
        Cell orderNoCell = titleRow1.createCell(6);
        orderNoCell.setCellValue("单号\n" + order.getOrderNo());
        orderNoCell.setCellStyle(wrapStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 6, 6)); // 第1-2行，G列

        // 7. 第3-4行：收货单位、收货人（垂直合并，行高20.40磅）
        Row infoRow1 = sheet.createRow(rowIndex++);
        Row infoRow2 = sheet.createRow(rowIndex++);
        infoRow1.setHeightInPoints(20.4f);
        infoRow2.setHeightInPoints(20.4f);

        // A-D列（第3-4行垂直合并）：收货单位（14磅）
        Cell unitCell = infoRow1.createCell(0);
        unitCell.setCellValue("收货单位：" + customerName);
        unitCell.setCellStyle(titleStyle14);
        sheet.addMergedRegion(new CellRangeAddress(2, 3, 0, 3)); // 第3-4行，A-D列

        // E-G列（第3-4行垂直合并）：收货人+联系电话（换行，14磅）
        Cell contactCell = infoRow1.createCell(4);
        contactCell.setCellValue("收货人：" + contact + " 联系电话：\n" + mobile);
        contactCell.setCellStyle(wrapStyle);
        sheet.addMergedRegion(new CellRangeAddress(2, 3, 4, 6)); // 第3-4行，E-G列

        // 8. 第5行：表头（行高20.40磅）
        Row headerRow = sheet.createRow(rowIndex++);
        headerRow.setHeightInPoints(20.4f);
        String[] headers = {"名称", "规格", "单位", "数量", "价格", "总价", "备注"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // 11. 第6-N行：产品明细（每行高度20.40磅，田字格边框）
        BigDecimal totalSaleAmount = BigDecimal.ZERO;
        for (OrderItemDO item : items) {
            Row dataRow = sheet.createRow(rowIndex++);
            dataRow.setHeightInPoints(20.4f);  // 设置行高

            // A列：名称
            Cell nameCell = dataRow.createCell(0);
            nameCell.setCellValue(item.getProductName() != null ? item.getProductName() : "");
            nameCell.setCellStyle(dataCenterStyle);

            // B列：规格
            Cell specCell = dataRow.createCell(1);
            specCell.setCellValue(item.getSpec() != null ? item.getSpec() : "");
            specCell.setCellStyle(dataCenterStyle);

            // C列：单位
            Cell unitCellItem = dataRow.createCell(2);
            unitCellItem.setCellValue(item.getSaleUnit() != null ? item.getSaleUnit() : "");
            unitCellItem.setCellStyle(dataCenterStyle);

            // D列：数量
            Cell qtyCell = dataRow.createCell(3);
            if (item.getSaleQuantity() != null) {
                qtyCell.setCellValue(item.getSaleQuantity().doubleValue());
            }
            qtyCell.setCellStyle(dataCenterStyle);

            // E列：价格
            Cell priceCell = dataRow.createCell(4);
            if (item.getSalePrice() != null) {
                priceCell.setCellValue(item.getSalePrice().doubleValue());
            }
            priceCell.setCellStyle(dataCenterStyle);

            // F列：总价
            Cell amountCell = dataRow.createCell(5);
            if (item.getSaleAmount() != null) {
                amountCell.setCellValue(item.getSaleAmount().doubleValue());
                totalSaleAmount = totalSaleAmount.add(item.getSaleAmount());
            }
            amountCell.setCellStyle(dataCenterStyle);

            // G列：备注
            Cell remarkItemCell = dataRow.createCell(6);
            remarkItemCell.setCellValue(item.getSaleRemark() != null ? item.getSaleRemark() : "");
            remarkItemCell.setCellStyle(dataCenterStyle);
        }

        // 12. 合计行：A-D列合并（金额大写），E-F-G列独立（合计、金额、付款状态）
        String amountChinese = MoneyUtils.toChineseAmount(totalSaleAmount);
        Row totalRow = sheet.createRow(rowIndex++);
        totalRow.setHeightInPoints(20.4f);  // 设置行高

        // A-D列：金额（大写）：XXX（合并，12磅不加粗，居中，完整边框）
        Cell amountChineseCell = totalRow.createCell(0);
        amountChineseCell.setCellValue("金额（大写）：" + amountChinese);
        amountChineseCell.setCellStyle(totalBorderStyle);

        // 为B C D列创建空单元格并设置边框样式（确保合并后边框完整）
        Cell bCell = totalRow.createCell(1);
        bCell.setCellStyle(totalBorderStyle);
        Cell cCell = totalRow.createCell(2);
        cCell.setCellStyle(totalBorderStyle);
        Cell dCell = totalRow.createCell(3);
        dCell.setCellStyle(totalBorderStyle);

        sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 0, 3));  // A-D合并

        // E列：合计（12磅不加粗，居中，完整边框）
        Cell totalLabelCell = totalRow.createCell(4);
        totalLabelCell.setCellValue("合计");
        totalLabelCell.setCellStyle(totalBorderStyle);

        // F列：总金额（12磅不加粗，居中，完整边框）
        Cell totalAmountCell = totalRow.createCell(5);
        totalAmountCell.setCellValue(totalSaleAmount.doubleValue());
        totalAmountCell.setCellStyle(totalBorderStyle);

        // G列：付款状态（12磅不加粗，居中，完整边框）
        Cell paymentStatusCell = totalRow.createCell(6);
        paymentStatusCell.setCellValue(paymentStatus);
        paymentStatusCell.setCellStyle(totalBorderStyle);

        // 13. 空行（默认行高）
        sheet.createRow(rowIndex++);

        // 14. 日期行（合并D-G列）
        Row dateRow = sheet.createRow(rowIndex++);
        dateRow.setHeightInPoints(20.4f);
        String dateText = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy年M月d号"));
        Cell dateCell = dateRow.createCell(3);  // D列开始
        dateCell.setCellValue("日期：" + dateText);
        dateCell.setCellStyle(normalStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 3, 6));  // D-G合并

        // 15. 签收人行（合并E-F列）
        Row signRow = sheet.createRow(rowIndex);
        signRow.setHeightInPoints(20.4f);
        Cell signCell = signRow.createCell(4);  // E列开始
        signCell.setCellValue("签收人：");
        signCell.setCellStyle(normalStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowIndex, rowIndex, 4, 5));  // E-F合并

        // 17. 设置响应头并输出
        // 文件名格式：尚泰铭成销售清单-{客户名称}-{年月日}.xlsx
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String filename = "尚泰铭成销售清单-" + customerName + "-" + dateStr + ".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition",
            "attachment;filename=" + URLEncoder.encode(filename, "UTF-8"));

        workbook.write(response.getOutputStream());
        workbook.close();
    }

    /**
     * 创建普通文本样式（宋体、指定字号、不加粗、居中）
     */
    private CellStyle createTextStyle(Workbook workbook, int fontSize) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) fontSize);
        font.setBold(false);  // 不加粗
        style.setFont(font);
        style.setAlignment(HorizontalAlignment.CENTER);  // 水平居中
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        return style;
    }

    /**
     * 创建居中文本样式（宋体、指定字号、不加粗、居中对齐）
     */
    private CellStyle createCenterTextStyle(Workbook workbook, int fontSize) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) fontSize);
        font.setBold(false);  // 不加粗
        style.setFont(font);
        style.setAlignment(HorizontalAlignment.CENTER);  // 水平居中
        style.setVerticalAlignment(VerticalAlignment.CENTER);  // 垂直居中
        return style;
    }

    /**
     * 创建换行文本样式（宋体、指定字号、不加粗、居中、自动换行）
     */
    private CellStyle createWrapTextStyle(Workbook workbook, int fontSize) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) fontSize);
        font.setBold(false);  // 不加粗
        style.setFont(font);
        style.setAlignment(HorizontalAlignment.CENTER);  // 水平居中
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setWrapText(true);  // 自动换行
        return style;
    }

    /**
     * 创建表头样式（宋体12磅、不加粗、居中、边框）
     */
    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        // 边框
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);

        Font font = workbook.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) 12);
        font.setBold(false);  // 不加粗
        style.setFont(font);

        return style;
    }

    /**
     * 创建数据样式（宋体12磅、不加粗、居中、带边框）
     */
    private CellStyle createDataCenterBorderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        // 边框
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);

        Font font = workbook.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) 12);
        font.setBold(false);  // 不加粗
        style.setFont(font);

        return style;
    }

    /**
     * 获取订单付款状态文本
     */
    private String getPaymentStatusText(OrderDO order) {
        BigDecimal paidAmount = order.getPaidAmount() != null ? order.getPaidAmount() : BigDecimal.ZERO;
        BigDecimal payableAmount = order.getPayableAmount() != null ? order.getPayableAmount() : BigDecimal.ZERO;

        if (paidAmount.compareTo(payableAmount) >= 0) {
            return "已付款";
        } else {
            return "未付款";
        }
    }

    // ========== 付款相关 ==========

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void markOrderAsPaid(Long id) {
        // 1. 校验订单存在
        OrderDO order = validateOrderExists(id);

        // 2. 更新已付金额为应付金额（表示已付清）
        OrderDO updateObj = new OrderDO();
        updateObj.setId(id);
        updateObj.setPaidAmount(order.getPayableAmount());
        orderMapper.updateById(updateObj);
    }

}
