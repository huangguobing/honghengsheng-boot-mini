package cn.iocoder.stmc.module.erp.service.order;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.IdUtil;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.stmc.module.erp.controller.admin.order.vo.OrderCostFillReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.order.vo.OrderItemSaveReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.order.vo.OrderPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.order.vo.OrderSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.customer.CustomerDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderItemDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.expense.ExpenseDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.payment.PaymentDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.paymentplan.PaymentPlanDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.project.ProjectDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderItemDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.supplier.SupplierDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.voucher.VoucherDO;
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
import cn.iocoder.stmc.module.erp.service.project.ProjectService;
import cn.iocoder.stmc.module.erp.service.supplier.SupplierService;
import cn.iocoder.stmc.module.erp.util.MoneyUtils;
import cn.iocoder.stmc.module.system.api.user.AdminUserApi;
import cn.iocoder.stmc.module.system.api.user.dto.AdminUserRespDTO;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.RegionUtil;
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
     * 订单状态流转规则
     * 1=进行中 → 3=已完成
     * 进行中 可取消 → 50=已取消
     */
    private static final Map<Integer, Set<Integer>> VALID_STATUS_TRANSITIONS = new HashMap<>();
    static {
        VALID_STATUS_TRANSITIONS.put(1, new HashSet<>(Arrays.asList(3, 50)));    // 进行中 -> 已完成、已取消
        VALID_STATUS_TRANSITIONS.put(3, Collections.emptySet());                  // 已完成 -> 无
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

    @Resource
    private cn.iocoder.stmc.module.erp.service.log.OperationLogService operationLogService;

    @Resource
    @Lazy
    private ProjectService projectService;

    @Resource
    private cn.iocoder.stmc.module.erp.dal.mysql.purchase.PurchaseOrderMapper purchaseOrderMapper;

    @Resource
    private cn.iocoder.stmc.module.erp.dal.mysql.purchase.PurchaseOrderItemMapper purchaseOrderItemMapper;

    @Resource
    private cn.iocoder.stmc.module.erp.dal.mysql.expense.ExpenseMapper expenseMapper;

    @Resource
    private cn.iocoder.stmc.module.erp.dal.mysql.voucher.VoucherMapper voucherMapper;

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
        order.setStatus(OrderStatusEnum.CONFIRMED.getStatus()); // 进行中
        order.setPaidAmount(BigDecimal.ZERO);
        order.setCostFilled(false);
        order.setInvoiceCompany(2); // 主订单固定鸿恒盛开票
        order.setOrderCategory(0); // 主订单

        // 根据客户"是否下级开单"标记决定是否推送给B角色
        if (createReqVO.getCustomerId() != null) {
            CustomerDO customer = customerService.getCustomer(createReqVO.getCustomerId());
            if (customer != null && Integer.valueOf(1).equals(customer.getNeedIntermediary())) {
                order.setSubOrderStatus(0); // 待B角色录入
            }
        }

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
            // 优先使用前端传的金额，否则用 重量×单价 计算
            BigDecimal saleAmount = item.getSaleAmount();
            if (saleAmount == null || saleAmount.compareTo(BigDecimal.ZERO) == 0) {
                saleAmount = (item.getWeight() != null ? item.getWeight() : BigDecimal.ZERO)
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

        // 记录操作日志
        operationLogService.log("order", order.getId(), order.getOrderNo(),
                "create", null, null, "创建订单");

        return order.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateOrder(OrderSaveReqVO updateReqVO) {
        // 校验存在
        OrderDO order = validateOrderExists(updateReqVO.getId());

        // 校验状态：进行中(1) 可修改
        if (!OrderStatusEnum.CONFIRMED.getStatus().equals(order.getStatus())) {
            throw exception(ORDER_STATUS_NOT_ALLOW_UPDATE);
        }

        // 校验客户/供应商是否存在
        validateCustomerOrSupplier(updateReqVO.getOrderType(), updateReqVO.getCustomerId(), updateReqVO.getSupplierId());

        // 更新订单主体
        OrderDO updateObj = BeanUtils.toBean(updateReqVO, OrderDO.class);

        // 从明细计算汇总金额
        List<OrderItemSaveReqVO> items = updateReqVO.getItems();
        BigDecimal totalQuantity = BigDecimal.ZERO;
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (OrderItemSaveReqVO item : items) {
            totalQuantity = totalQuantity.add(item.getSaleQuantity() != null ? item.getSaleQuantity() : BigDecimal.ZERO);
            // 优先使用前端传的金额，否则用 重量×单价 计算
            BigDecimal saleAmount = item.getSaleAmount();
            if (saleAmount == null || saleAmount.compareTo(BigDecimal.ZERO) == 0) {
                saleAmount = (item.getWeight() != null ? item.getWeight() : BigDecimal.ZERO)
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

        // 记录操作日志
        operationLogService.log("order", order.getId(), order.getOrderNo(),
                "update", null, null, "修改订单");
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

        // 记录操作日志
        operationLogService.log("order", id, order.getOrderNo(),
                "status_change", null, null, "状态变更为 " + status);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteOrder(Long id) {
        // 校验存在
        OrderDO order = validateOrderExists(id);

        // 1. 删除应收/应付付款计划（通知机制已停用，无需再删通知）

        // 2. 删除应收/应付付款计划
        paymentPlanMapper.deleteByOrderId(id);

        // 3. 删除付款单
        paymentMapper.deleteByOrderId(id);

        // 4. 删除关联采购单明细 & 采购单
        List<Long> purchaseOrderIds = purchaseOrderMapper.selectListByOrderId(id).stream()
                .map(cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderDO::getId)
                .collect(Collectors.toList());
        if (!purchaseOrderIds.isEmpty()) {
            purchaseOrderItemMapper.deleteByPurchaseOrderIds(purchaseOrderIds);
        }
        purchaseOrderMapper.deleteByOrderId(id);

        // 5. 删除费用明细
        expenseMapper.deleteByOrderId(id);

        // 6. 删除订单明细
        orderItemMapper.deleteByOrderId(id);

        // 7. 删除订单
        orderMapper.deleteById(id);

        operationLogService.log("order", id, order.getOrderNo(),
                "delete", null, null, "删除订单（含关联采购计划、付款计划、费用明细）");
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

        // 2. 校验订单状态（已取消不允许录入数据，其余状态均可）
        if (OrderStatusEnum.CANCELLED.getStatus().equals(order.getStatus())) {
            throw exception(ORDER_STATUS_NOT_ALLOW_FILL_COST);
        }

        // 3. 获取订单明细
        List<OrderItemDO> items = orderItemMapper.selectListByOrderId(order.getId());
        Map<Long, OrderItemDO> itemMap = items.stream().collect(Collectors.toMap(OrderItemDO::getId, i -> i));

        // 4. 更新明细成本信息
        BigDecimal totalPurchaseAmount = BigDecimal.ZERO;
        BigDecimal totalGrossProfit = BigDecimal.ZERO;
        BigDecimal totalTaxAmount = BigDecimal.ZERO;
        BigDecimal totalNetProfit = BigDecimal.ZERO;

        for (OrderCostFillReqVO.ItemCost itemCost : fillReqVO.getItems()) {
            OrderItemDO item = itemMap.get(itemCost.getItemId());
            if (item == null) {
                continue;
            }

            // 更新采购信息
            item.setPurchaseUnit(itemCost.getPurchaseUnit());
            item.setPurchaseQuantity(itemCost.getPurchaseQuantity());
            item.setPurchasePrice(itemCost.getPurchasePrice());

            // 计算采购金额（重量×采购单价）
            BigDecimal purchaseAmount = itemCost.getPurchaseAmount();
            if (purchaseAmount == null && itemCost.getPurchaseQuantity() != null && itemCost.getPurchasePrice() != null) {
                // 优先用重量计算，回退到数量（兼容旧数据）
                BigDecimal weight = item.getWeight();
                if (weight != null && weight.compareTo(BigDecimal.ZERO) > 0) {
                    purchaseAmount = weight.multiply(itemCost.getPurchasePrice());
                } else {
                    purchaseAmount = itemCost.getPurchaseQuantity().multiply(itemCost.getPurchasePrice());
                }
            }
            item.setPurchaseAmount(purchaseAmount != null ? purchaseAmount : BigDecimal.ZERO);

            item.setPurchaseRemark(itemCost.getPurchaseRemark());
            item.setSupplierId(itemCost.getSupplierId());
            item.setTaxAmount(itemCost.getTaxAmount());

            // 计算毛利（销售金额 - 采购金额）
            BigDecimal grossProfit = (item.getSaleAmount() != null ? item.getSaleAmount() : BigDecimal.ZERO)
                    .subtract(item.getPurchaseAmount() != null ? item.getPurchaseAmount() : BigDecimal.ZERO);
            item.setGrossProfit(grossProfit);

            // 计算净利（毛利 - 税额）
            BigDecimal taxAmount = item.getTaxAmount() != null ? item.getTaxAmount() : BigDecimal.ZERO;
            item.setNetProfit(grossProfit.subtract(taxAmount));

            orderItemMapper.updateById(item);

            // 累计汇总
            totalPurchaseAmount = totalPurchaseAmount.add(item.getPurchaseAmount());
            totalGrossProfit = totalGrossProfit.add(grossProfit);
            totalTaxAmount = totalTaxAmount.add(taxAmount);
            totalNetProfit = totalNetProfit.add(item.getNetProfit());
        }

        // 5. 更新订单汇总信息（不推状态、不创建付款单）
        OrderDO updateOrder = new OrderDO();
        updateOrder.setId(order.getId());
        updateOrder.setTotalPurchaseAmount(totalPurchaseAmount);
        updateOrder.setTotalGrossProfit(totalGrossProfit);
        updateOrder.setTotalTaxAmount(totalTaxAmount);
        BigDecimal extraCost = fillReqVO.getExtraCost() != null ? fillReqVO.getExtraCost() : BigDecimal.ZERO;
        updateOrder.setTotalNetProfit(totalNetProfit.subtract(extraCost));
        updateOrder.setExtraCost(fillReqVO.getExtraCost());
        updateOrder.setExtraCostRemark(fillReqVO.getExtraCostRemark());
        updateOrder.setCostFilled(true);
        updateOrder.setCostFilledBy(SecurityFrameworkUtils.getLoginUserId());
        updateOrder.setCostFilledTime(LocalDateTime.now());
        orderMapper.updateById(updateOrder);

        // 构建详细日志
        StringBuilder logDesc = new StringBuilder();
        logDesc.append("填充成本。");
        // 按供应商分组记录
        Set<Long> supplierIds = items.stream()
                .map(OrderItemDO::getSupplierId).filter(id -> id != null)
                .collect(Collectors.toSet());
        Map<Long, SupplierDO> supplierMap = supplierService.getSupplierMap(new ArrayList<>(supplierIds));
        Map<Long, List<OrderItemDO>> supplierGrouped = items.stream()
                .filter(i -> i.getSupplierId() != null && i.getPurchaseAmount() != null
                        && i.getPurchaseAmount().compareTo(BigDecimal.ZERO) > 0)
                .collect(Collectors.groupingBy(OrderItemDO::getSupplierId));
        for (Map.Entry<Long, List<OrderItemDO>> entry : supplierGrouped.entrySet()) {
            SupplierDO supplier = supplierMap.get(entry.getKey());
            String supplierName = supplier != null ? supplier.getName() : "未知供应商";
            logDesc.append("\n【").append(supplierName).append("】");
            BigDecimal supplierTotal = BigDecimal.ZERO;
            for (OrderItemDO i : entry.getValue()) {
                logDesc.append(i.getProductName());
                if (i.getSpec() != null && !i.getSpec().isEmpty()) {
                    logDesc.append("(").append(i.getSpec()).append(")");
                }
                logDesc.append(" ×").append(i.getPurchaseQuantity())
                        .append(" @").append(i.getPurchasePrice())
                        .append("=").append(i.getPurchaseAmount()).append("；");
                supplierTotal = supplierTotal.add(i.getPurchaseAmount());
            }
            logDesc.append("小计：").append(supplierTotal);
        }
        logDesc.append("\n采购总额：").append(totalPurchaseAmount)
                .append("，净利润：").append(updateOrder.getTotalNetProfit());
        operationLogService.log("order", order.getId(), order.getOrderNo(),
                "fill_cost", null, null, logDesc.toString());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void editOrderCost(OrderCostFillReqVO editReqVO) {
        // 1. 校验订单存在
        OrderDO order = validateOrderExists(editReqVO.getOrderId());

        // 2. 校验成本是否已填充
        if (!Boolean.TRUE.equals(order.getCostFilled())) {
            throw exception(ORDER_COST_NOT_FILLED);
        }

        // 3. 校验订单状态：进行中、结算中、已完成均可编辑成本
        Integer status = order.getStatus();
        if (!OrderStatusEnum.CONFIRMED.getStatus().equals(status)
                && !OrderStatusEnum.SETTLING.getStatus().equals(status)
                && !OrderStatusEnum.COMPLETED.getStatus().equals(status)) {
            throw exception(ORDER_STATUS_NOT_ALLOW_EDIT_COST);
        }

        // 4. 获取订单明细
        List<OrderItemDO> items = orderItemMapper.selectListByOrderId(order.getId());
        Map<Long, OrderItemDO> itemMap = items.stream().collect(Collectors.toMap(OrderItemDO::getId, i -> i));

        // 5. 更新明细成本信息
        BigDecimal totalPurchaseAmount = BigDecimal.ZERO;
        BigDecimal totalGrossProfit = BigDecimal.ZERO;
        BigDecimal totalTaxAmount = BigDecimal.ZERO;
        BigDecimal totalNetProfit = BigDecimal.ZERO;

        for (OrderCostFillReqVO.ItemCost itemCost : editReqVO.getItems()) {
            OrderItemDO item = itemMap.get(itemCost.getItemId());
            if (item == null) {
                continue;
            }

            item.setPurchaseUnit(itemCost.getPurchaseUnit());
            item.setPurchaseQuantity(itemCost.getPurchaseQuantity());
            item.setPurchasePrice(itemCost.getPurchasePrice());

            BigDecimal purchaseAmount = itemCost.getPurchaseAmount();
            if (purchaseAmount == null && itemCost.getPurchaseQuantity() != null && itemCost.getPurchasePrice() != null) {
                // 优先用重量计算，回退到数量（兼容旧数据）
                BigDecimal weight = item.getWeight();
                if (weight != null && weight.compareTo(BigDecimal.ZERO) > 0) {
                    purchaseAmount = weight.multiply(itemCost.getPurchasePrice());
                } else {
                    purchaseAmount = itemCost.getPurchaseQuantity().multiply(itemCost.getPurchasePrice());
                }
            }
            item.setPurchaseAmount(purchaseAmount != null ? purchaseAmount : BigDecimal.ZERO);

            item.setPurchaseRemark(itemCost.getPurchaseRemark());
            item.setSupplierId(itemCost.getSupplierId());
            item.setTaxAmount(itemCost.getTaxAmount());

            BigDecimal grossProfit = (item.getSaleAmount() != null ? item.getSaleAmount() : BigDecimal.ZERO)
                    .subtract(item.getPurchaseAmount() != null ? item.getPurchaseAmount() : BigDecimal.ZERO);
            item.setGrossProfit(grossProfit);

            BigDecimal taxAmount = item.getTaxAmount() != null ? item.getTaxAmount() : BigDecimal.ZERO;
            item.setNetProfit(grossProfit.subtract(taxAmount));

            orderItemMapper.updateById(item);

            totalPurchaseAmount = totalPurchaseAmount.add(item.getPurchaseAmount());
            totalGrossProfit = totalGrossProfit.add(grossProfit);
            totalTaxAmount = totalTaxAmount.add(taxAmount);
            totalNetProfit = totalNetProfit.add(item.getNetProfit());
        }

        // 6. 更新订单汇总成本
        OrderDO updateOrder = new OrderDO();
        updateOrder.setId(order.getId());
        updateOrder.setTotalPurchaseAmount(totalPurchaseAmount);
        updateOrder.setTotalGrossProfit(totalGrossProfit);
        updateOrder.setTotalTaxAmount(totalTaxAmount);
        BigDecimal extraCost = editReqVO.getExtraCost() != null ? editReqVO.getExtraCost() : BigDecimal.ZERO;
        updateOrder.setTotalNetProfit(totalNetProfit.subtract(extraCost));
        updateOrder.setExtraCost(editReqVO.getExtraCost());
        updateOrder.setExtraCostRemark(editReqVO.getExtraCostRemark());
        orderMapper.updateById(updateOrder);

        // 构建详细日志
        StringBuilder logDesc = new StringBuilder();
        logDesc.append("编辑成本。");
        Set<Long> supplierIds = items.stream()
                .map(OrderItemDO::getSupplierId).filter(id -> id != null)
                .collect(Collectors.toSet());
        Map<Long, SupplierDO> supplierMap = supplierService.getSupplierMap(new ArrayList<>(supplierIds));
        Map<Long, List<OrderItemDO>> supplierGrouped = items.stream()
                .filter(i -> i.getSupplierId() != null && i.getPurchaseAmount() != null
                        && i.getPurchaseAmount().compareTo(BigDecimal.ZERO) > 0)
                .collect(Collectors.groupingBy(OrderItemDO::getSupplierId));
        for (Map.Entry<Long, List<OrderItemDO>> entry : supplierGrouped.entrySet()) {
            SupplierDO supplier = supplierMap.get(entry.getKey());
            String supplierName = supplier != null ? supplier.getName() : "未知供应商";
            logDesc.append("\n【").append(supplierName).append("】");
            BigDecimal supplierTotal = BigDecimal.ZERO;
            for (OrderItemDO i : entry.getValue()) {
                logDesc.append(i.getProductName());
                if (i.getSpec() != null && !i.getSpec().isEmpty()) {
                    logDesc.append("(").append(i.getSpec()).append(")");
                }
                logDesc.append(" ×").append(i.getPurchaseQuantity())
                        .append(" @").append(i.getPurchasePrice())
                        .append("=").append(i.getPurchaseAmount()).append("；");
                supplierTotal = supplierTotal.add(i.getPurchaseAmount());
            }
            logDesc.append("小计：").append(supplierTotal);
        }
        logDesc.append("\n采购总额：").append(totalPurchaseAmount)
                .append("，净利润：").append(updateOrder.getTotalNetProfit());
        operationLogService.log("order", order.getId(), order.getOrderNo(),
                "edit_cost", null, null, logDesc.toString());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void editOrderItems(OrderSaveReqVO editReqVO) {
        // 1. 校验订单存在
        OrderDO order = validateOrderExists(editReqVO.getId());

        // 2. 校验订单状态：必须是已完成或结算中状态
        if (!OrderStatusEnum.COMPLETED.getStatus().equals(order.getStatus())
                && !OrderStatusEnum.SETTLING.getStatus().equals(order.getStatus())) {
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

            // 计算销售金额（重量×销售单价）
            BigDecimal saleAmount = itemVO.getSaleAmount();
            if (saleAmount == null || saleAmount.compareTo(BigDecimal.ZERO) == 0) {
                saleAmount = (itemVO.getWeight() != null ? itemVO.getWeight() : BigDecimal.ZERO)
                        .multiply(itemVO.getSalePrice() != null ? itemVO.getSalePrice() : BigDecimal.ZERO);
            }
            item.setSaleAmount(saleAmount);

            // 计算采购金额（三层保护：前端传值 > 计算值 > 旧值 > 0）
            BigDecimal purchaseAmount = itemVO.getPurchaseAmount();
            if (purchaseAmount == null && itemVO.getPurchaseQuantity() != null && itemVO.getPurchasePrice() != null) {
                BigDecimal weight = itemVO.getWeight();
                if (weight != null && weight.compareTo(BigDecimal.ZERO) > 0) {
                    purchaseAmount = weight.multiply(itemVO.getPurchasePrice());
                } else {
                    purchaseAmount = itemVO.getPurchaseQuantity().multiply(itemVO.getPurchasePrice());
                }
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

            // 检查是否存在已付款或部分付款的计划
            boolean hasPaidPlan = plans.stream()
                    .anyMatch(p -> PaymentPlanStatusEnum.PAID.getStatus().equals(p.getStatus())
                            || PaymentPlanStatusEnum.PARTIAL.getStatus().equals(p.getStatus()));

            if (hasPaidPlan) {
                throw exception(ORDER_STATUS_NOT_ALLOW_UPDATE);
            }

            // 未付款 - 直接删除并按新供应商重新生成
            paymentPlanMapper.deleteByPaymentId(payment.getId());
            paymentMapper.deleteById(payment.getId());
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

        operationLogService.log("order", order.getId(), order.getOrderNo(),
                "edit_items", null, null,
                "编辑商品明细，商品数：" + editReqVO.getItems().size()
                        + "，销售总额：" + totalAmount + "，采购总额：" + totalPurchaseAmount);
    }

    @Override
    public void editOrderItemsSimple(OrderSaveReqVO editReqVO) {
        // 1. 校验订单存在
        OrderDO order = validateOrderExists(editReqVO.getId());

        // 2. 校验订单状态：进行中/结算中/已完成可编辑
        Integer status = order.getStatus();
        if (!OrderStatusEnum.CONFIRMED.getStatus().equals(status)
                && !OrderStatusEnum.SETTLING.getStatus().equals(status)
                && !OrderStatusEnum.COMPLETED.getStatus().equals(status)) {
            throw exception(ORDER_STATUS_NOT_ALLOW_EDIT_ITEMS);
        }

        // 3. 校验商品明细不能为空
        if (CollUtil.isEmpty(editReqVO.getItems())) {
            throw exception(ORDER_ITEMS_CANNOT_BE_EMPTY);
        }

        // 4. 建立旧明细映射，用于保留采购字段
        List<OrderItemDO> oldItems = orderItemMapper.selectListByOrderId(order.getId());
        Map<Long, OrderItemDO> oldItemMap = oldItems.stream()
                .collect(Collectors.toMap(OrderItemDO::getId, i -> i, (a, b) -> a));

        // 5. 删除旧明细，插入新明细
        orderItemMapper.deleteByOrderId(order.getId());

        BigDecimal totalQuantity = BigDecimal.ZERO;
        BigDecimal totalAmount = BigDecimal.ZERO;
        BigDecimal totalPurchaseAmount = BigDecimal.ZERO;
        BigDecimal totalGrossProfit = BigDecimal.ZERO;
        BigDecimal totalTaxAmount = BigDecimal.ZERO;
        BigDecimal totalNetProfit = BigDecimal.ZERO;

        for (OrderItemSaveReqVO itemVO : editReqVO.getItems()) {
            OrderItemDO item = BeanUtils.toBean(itemVO, OrderItemDO.class);
            item.setId(null);
            item.setOrderId(order.getId());

            // 计算销售金额（重量×销售单价）
            BigDecimal saleAmount = itemVO.getSaleAmount();
            if (saleAmount == null || saleAmount.compareTo(BigDecimal.ZERO) == 0) {
                saleAmount = (itemVO.getWeight() != null ? itemVO.getWeight() : BigDecimal.ZERO)
                        .multiply(itemVO.getSalePrice() != null ? itemVO.getSalePrice() : BigDecimal.ZERO);
            }
            item.setSaleAmount(saleAmount);

            // 保留采购字段：通过旧明细ID匹配
            if (itemVO.getId() != null) {
                OrderItemDO oldItem = oldItemMap.get(itemVO.getId());
                if (oldItem != null) {
                    if (item.getPurchasePrice() == null) item.setPurchasePrice(oldItem.getPurchasePrice());
                    if (item.getPurchaseQuantity() == null) item.setPurchaseQuantity(oldItem.getPurchaseQuantity());
                    if (item.getPurchaseAmount() == null) item.setPurchaseAmount(oldItem.getPurchaseAmount());
                    if (item.getPurchaseUnit() == null) item.setPurchaseUnit(oldItem.getPurchaseUnit());
                    if (item.getSupplierId() == null) item.setSupplierId(oldItem.getSupplierId());
                    if (item.getTaxAmount() == null) item.setTaxAmount(oldItem.getTaxAmount());
                    if (item.getPurchaseRemark() == null) item.setPurchaseRemark(oldItem.getPurchaseRemark());
                }
            }

            // 采购金额兜底
            BigDecimal purchaseAmount = item.getPurchaseAmount() != null ? item.getPurchaseAmount() : BigDecimal.ZERO;
            item.setPurchaseAmount(purchaseAmount);
            BigDecimal taxAmount = item.getTaxAmount() != null ? item.getTaxAmount() : BigDecimal.ZERO;
            item.setTaxAmount(taxAmount);

            // 计算毛利和净利
            BigDecimal grossProfit = saleAmount.subtract(purchaseAmount);
            item.setGrossProfit(grossProfit);
            item.setNetProfit(grossProfit.subtract(taxAmount));

            orderItemMapper.insert(item);

            // 累计汇总
            totalQuantity = totalQuantity.add(itemVO.getSaleQuantity() != null ? itemVO.getSaleQuantity() : BigDecimal.ZERO);
            totalAmount = totalAmount.add(saleAmount);
            totalPurchaseAmount = totalPurchaseAmount.add(purchaseAmount);
            totalGrossProfit = totalGrossProfit.add(grossProfit);
            totalTaxAmount = totalTaxAmount.add(taxAmount);
            totalNetProfit = totalNetProfit.add(item.getNetProfit());
        }

        // 6. 更新订单汇总
        BigDecimal shippingFee = editReqVO.getShippingFee() != null ? editReqVO.getShippingFee()
                : (order.getShippingFee() != null ? order.getShippingFee() : BigDecimal.ZERO);
        BigDecimal discountAmount = editReqVO.getDiscountAmount() != null ? editReqVO.getDiscountAmount()
                : (order.getDiscountAmount() != null ? order.getDiscountAmount() : BigDecimal.ZERO);
        BigDecimal extraCostVal = order.getExtraCost() != null ? order.getExtraCost() : BigDecimal.ZERO;

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
        updateOrder.setTotalNetProfit(totalNetProfit.subtract(extraCostVal));
        orderMapper.updateById(updateOrder);

        // 7. 记录操作日志
        operationLogService.log("order", order.getId(), order.getOrderNo(),
                "edit_items_simple", null, null,
                "编辑商品明细（简单模式），商品数：" + editReqVO.getItems().size()
                        + "，销售总额：" + totalAmount);
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
        // 提交订单（草稿 → 已确认），无需审批
        OrderDO order = validateOrderExists(id);

        if (!OrderStatusEnum.DRAFT.getStatus().equals(order.getStatus())) {
            throw exception(ORDER_STATUS_INVALID_TRANSITION);
        }

        OrderDO updateObj = new OrderDO();
        updateObj.setId(id);
        updateObj.setStatus(OrderStatusEnum.CONFIRMED.getStatus());
        orderMapper.updateById(updateObj);

        operationLogService.log("order", id, order.getOrderNo(),
                "submit", null, null, "提交订单");
    }

    @Override
    public void rejectOrder(Long id, String reason) {
        // 取消订单（进行中 → 已取消）
        OrderDO order = validateOrderExists(id);

        if (!OrderStatusEnum.CONFIRMED.getStatus().equals(order.getStatus())) {
            throw exception(ORDER_STATUS_INVALID_TRANSITION);
        }

        OrderDO updateObj = new OrderDO();
        updateObj.setId(id);
        updateObj.setStatus(OrderStatusEnum.CANCELLED.getStatus());
        if (reason != null && !reason.isEmpty()) {
            updateObj.setRemark((order.getRemark() != null ? order.getRemark() + "；" : "") + "取消原因：" + reason);
        }
        orderMapper.updateById(updateObj);

        operationLogService.log("order", id, order.getOrderNo(),
                "cancel", null, null, "取消订单" + (reason != null ? "：" + reason : ""));
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
     * 判断订单是否为被取消状态（已取消 + 有取消原因）
     */
    private boolean isRejectedOrder(OrderDO order) {
        return OrderStatusEnum.CANCELLED.getStatus().equals(order.getStatus())
                && order.getRemark() != null
                && (order.getRemark().contains("取消原因") || order.getRemark().contains("拒绝原因"));
    }

    // ========== 打印导出相关 ==========

    @Override
    public void generatePrintExcel(OrderDO order, CustomerDO customer,
                                   List<OrderItemDO> items, String salesmanName,
                                   HttpServletResponse response) throws IOException {
        // 如果是副订单，调用B角色送货单方法
        if (order.getOrderCategory() != null && order.getOrderCategory() == 1) {
            generateSubOrderPrintExcel(order, items, response);
            return;
        }

        // ===== A角色 发货单（销售单及欠款协议） =====
        // 1. 准备数据
        String customerName = customer != null ? customer.getName() : "";
        String vehicleNo = order.getVehicleNo() != null ? order.getVehicleNo() : "";

        // 2. 创建工作簿
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("发货单");
        sheet.setDisplayGridlines(false); // 隐藏网格线，数据表格用显式边框，底部条款无边框

        // 3. 设置列宽（11列：序号|产品名称|材质|规格|计价单位|数量|重量|销售单价|销售金额|品牌|备注）
        sheet.setColumnWidth(0, (int)(4.5 * 256));    // A：序号
        sheet.setColumnWidth(1, (int)(16.0 * 256));   // B：产品名称
        sheet.setColumnWidth(2, (int)(7.0 * 256));    // C：材质
        sheet.setColumnWidth(3, (int)(18.0 * 256));   // D：规格（如HN400*200*8*13）
        sheet.setColumnWidth(4, (int)(7.0 * 256));    // E：计价单位
        sheet.setColumnWidth(5, (int)(6.0 * 256));    // F：数量
        sheet.setColumnWidth(6, (int)(9.0 * 256));    // G：重量
        sheet.setColumnWidth(7, (int)(11.0 * 256));   // H：销售单价
        sheet.setColumnWidth(8, (int)(12.0 * 256));   // I：销售金额
        sheet.setColumnWidth(9, (int)(6.0 * 256));    // J：品牌
        sheet.setColumnWidth(10, (int)(22.0 * 256));  // K：备注（如6-28#厂房氮气管道）

        // 4. 创建样式
        CellStyle titleStyle = createCenterTextStyle(workbook, 18);       // 中文标题
        CellStyle subtitleStyle = createCenterTextStyle(workbook, 12);    // 英文副标题
        CellStyle infoStyleLeft = createTextStyleLeft(workbook, 11);      // 信息行左对齐
        CellStyle infoStyleRight = createTextStyleRight(workbook, 11);    // 信息行右对齐
        CellStyle headerStyle = createHeaderStyle(workbook);              // 表头
        CellStyle dataCenterStyle = createDataCenterBorderStyle(workbook);// 数据居中+边框
        CellStyle totalBorderStyle = createDataCenterBorderStyle(workbook);
        CellStyle normalStyleLeft = createTextStyleLeft(workbook, 10);    // 条款文本
        CellStyle normalStyle = createTextStyle(workbook, 11);

        int rowIndex = 0;

        // 5. 第1-2行合并：中文标题 + 英文副标题（富文本，换行在同一单元格）
        Row titleRow1 = sheet.createRow(rowIndex++);
        Row titleRow2 = sheet.createRow(rowIndex++);
        titleRow1.setHeightInPoints(28f);
        titleRow2.setHeightInPoints(24f);

        String cnTitle = "四川鸿恒盛供应链管理有限公司销售单及欠款协议（代合同）";
        String enTitle = "Sichuan Honghengsheng Supply Chain Management Co. Ltd";
        XSSFRichTextString titleRichText = new XSSFRichTextString(cnTitle + "\n" + enTitle);

        // 中文部分：宋体18磅加粗
        Font cnFont = workbook.createFont();
        cnFont.setFontName("宋体");
        cnFont.setFontHeightInPoints((short) 18);
        cnFont.setBold(true);
        titleRichText.applyFont(0, cnTitle.length(), cnFont);

        // 英文部分：黑体14磅加粗
        Font enFont = workbook.createFont();
        enFont.setFontName("黑体");
        enFont.setFontHeightInPoints((short) 14);
        enFont.setBold(true);
        titleRichText.applyFont(cnTitle.length() + 1, cnTitle.length() + 1 + enTitle.length(), enFont);

        // 标题样式（居中、换行、白色填充遮住网格线，不设cell边框）
        CellStyle titleMergedStyle = workbook.createCellStyle();
        titleMergedStyle.setAlignment(HorizontalAlignment.CENTER);
        titleMergedStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        titleMergedStyle.setWrapText(true);
        titleMergedStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        titleMergedStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        // 为标题合并区域的所有cell设置样式
        for (int i = 0; i <= 10; i++) {
            titleRow1.createCell(i).setCellStyle(titleMergedStyle);
        }
        for (int i = 0; i <= 10; i++) {
            titleRow2.createCell(i).setCellStyle(titleMergedStyle);
        }
        titleRow1.getCell(0).setCellValue(titleRichText);
        CellRangeAddress titleRegion = new CellRangeAddress(0, 1, 0, 10);
        sheet.addMergedRegion(titleRegion);
        RegionUtil.setBorderTop(BorderStyle.THIN, titleRegion, sheet);
        RegionUtil.setBorderBottom(BorderStyle.THIN, titleRegion, sheet);
        RegionUtil.setBorderLeft(BorderStyle.THIN, titleRegion, sheet);
        RegionUtil.setBorderRight(BorderStyle.THIN, titleRegion, sheet);

        // 7. 第3行：客户名称（左） + 提货车号（右）
        // 白色填充样式（无cell边框）
        CellStyle infoLeftFill = workbook.createCellStyle();
        infoLeftFill.cloneStyleFrom(infoStyleLeft);
        infoLeftFill.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        infoLeftFill.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        CellStyle infoRightFill = workbook.createCellStyle();
        infoRightFill.cloneStyleFrom(infoStyleRight);
        infoRightFill.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        infoRightFill.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        Row infoRow = sheet.createRow(rowIndex++);
        infoRow.setHeightInPoints(20f);
        for (int i = 0; i <= 10; i++) {
            Cell c = infoRow.createCell(i);
            c.setCellStyle(i <= 5 ? infoLeftFill : infoRightFill);
        }
        infoRow.getCell(0).setCellValue("客户名称：" + customerName);
        infoRow.getCell(6).setCellValue("提货车号：" + vehicleNo);
        CellRangeAddress infoLeftRegion = new CellRangeAddress(2, 2, 0, 5);
        CellRangeAddress infoRightRegion = new CellRangeAddress(2, 2, 6, 10);
        sheet.addMergedRegion(infoLeftRegion);
        sheet.addMergedRegion(infoRightRegion);
        RegionUtil.setBorderTop(BorderStyle.THIN, infoLeftRegion, sheet);
        RegionUtil.setBorderBottom(BorderStyle.THIN, infoLeftRegion, sheet);
        RegionUtil.setBorderLeft(BorderStyle.THIN, infoLeftRegion, sheet);
        RegionUtil.setBorderRight(BorderStyle.THIN, infoLeftRegion, sheet);
        RegionUtil.setBorderTop(BorderStyle.THIN, infoRightRegion, sheet);
        RegionUtil.setBorderBottom(BorderStyle.THIN, infoRightRegion, sheet);
        RegionUtil.setBorderLeft(BorderStyle.THIN, infoRightRegion, sheet);
        RegionUtil.setBorderRight(BorderStyle.THIN, infoRightRegion, sheet);

        // 8. 表头行
        Row headerRow = sheet.createRow(rowIndex++);
        headerRow.setHeightInPoints(22f);
        String[] headers = {"序号", "产品名称", "材质", "规 格", "计价单位", "数量", "重量", "销售单价", "销售金额", "品牌", "备 注"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // 9. 产品明细行
        BigDecimal totalSaleAmount = BigDecimal.ZERO;
        BigDecimal totalWeight = BigDecimal.ZERO;
        int seq = 1;
        for (OrderItemDO item : items) {
            Row dataRow = sheet.createRow(rowIndex++);
            dataRow.setHeightInPoints(20f);

            // 序号
            Cell seqCell = dataRow.createCell(0);
            seqCell.setCellValue(seq++);
            seqCell.setCellStyle(dataCenterStyle);

            // 产品名称
            Cell nameCell = dataRow.createCell(1);
            nameCell.setCellValue(item.getProductName() != null ? item.getProductName() : "");
            nameCell.setCellStyle(dataCenterStyle);

            // 材质
            Cell materialCell = dataRow.createCell(2);
            materialCell.setCellValue(item.getMaterial() != null ? item.getMaterial() : "");
            materialCell.setCellStyle(dataCenterStyle);

            // 规格
            Cell specCell = dataRow.createCell(3);
            specCell.setCellValue(item.getSpec() != null ? item.getSpec() : "");
            specCell.setCellStyle(dataCenterStyle);

            // 计价单位
            Cell unitCell = dataRow.createCell(4);
            unitCell.setCellValue(item.getSaleUnit() != null ? item.getSaleUnit() : "");
            unitCell.setCellStyle(dataCenterStyle);

            // 数量
            Cell qtyCell = dataRow.createCell(5);
            if (item.getSaleQuantity() != null) {
                qtyCell.setCellValue(item.getSaleQuantity().doubleValue());
            }
            qtyCell.setCellStyle(dataCenterStyle);

            // 重量
            Cell weightCell = dataRow.createCell(6);
            if (item.getWeight() != null) {
                weightCell.setCellValue(item.getWeight().doubleValue());
                totalWeight = totalWeight.add(item.getWeight());
            }
            weightCell.setCellStyle(dataCenterStyle);

            // 销售单价
            Cell priceCell = dataRow.createCell(7);
            if (item.getSalePrice() != null) {
                priceCell.setCellValue(item.getSalePrice().doubleValue());
            }
            priceCell.setCellStyle(dataCenterStyle);

            // 销售金额
            Cell amountCell = dataRow.createCell(8);
            if (item.getSaleAmount() != null) {
                amountCell.setCellValue(item.getSaleAmount().doubleValue());
                totalSaleAmount = totalSaleAmount.add(item.getSaleAmount());
            }
            amountCell.setCellStyle(dataCenterStyle);

            // 品牌
            Cell brandCell = dataRow.createCell(9);
            brandCell.setCellValue(item.getBrand() != null ? item.getBrand() : "");
            brandCell.setCellStyle(dataCenterStyle);

            // 备注
            Cell remarkCell = dataRow.createCell(10);
            remarkCell.setCellValue(item.getSaleRemark() != null ? item.getSaleRemark() : "");
            remarkCell.setCellStyle(dataCenterStyle);
        }

        // 10. 合计行
        Row totalRow = sheet.createRow(rowIndex++);
        totalRow.setHeightInPoints(20f);

        // 合计：标签 (A-B合并)
        Cell totalLabelCell = totalRow.createCell(0);
        totalLabelCell.setCellValue("合计：");
        totalLabelCell.setCellStyle(totalBorderStyle);
        Cell totalB = totalRow.createCell(1);
        totalB.setCellStyle(totalBorderStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 0, 1));

        // 材质 "--"
        Cell totalC = totalRow.createCell(2);
        totalC.setCellValue("--");
        totalC.setCellStyle(totalBorderStyle);

        // 规格 "--"
        Cell totalD = totalRow.createCell(3);
        totalD.setCellValue("--");
        totalD.setCellStyle(totalBorderStyle);

        // 计价单位（空）
        Cell totalE = totalRow.createCell(4);
        totalE.setCellStyle(totalBorderStyle);

        // 数量（空）
        Cell totalF = totalRow.createCell(5);
        totalF.setCellStyle(totalBorderStyle);

        // 重量合计
        Cell totalWeightCell = totalRow.createCell(6);
        totalWeightCell.setCellValue(totalWeight.doubleValue());
        totalWeightCell.setCellStyle(totalBorderStyle);

        // 销售单价（空）
        Cell totalH = totalRow.createCell(7);
        totalH.setCellStyle(totalBorderStyle);

        // 销售金额合计
        Cell totalAmountCell = totalRow.createCell(8);
        totalAmountCell.setCellValue(totalSaleAmount.doubleValue());
        totalAmountCell.setCellStyle(totalBorderStyle);

        // 品牌（空）
        Cell totalJ = totalRow.createCell(9);
        totalJ.setCellStyle(totalBorderStyle);

        // 备注（空）
        Cell totalK = totalRow.createCell(10);
        totalK.setCellStyle(totalBorderStyle);

        // 11. 合计金额（大写）行
        String amountChinese = MoneyUtils.toChineseAmount(totalSaleAmount);
        Row amountRow = sheet.createRow(rowIndex++);
        amountRow.setHeightInPoints(22f);

        Cell amountLabelCell = amountRow.createCell(0);
        amountLabelCell.setCellValue("合计金额（大写）：");
        amountLabelCell.setCellStyle(totalBorderStyle);
        for (int i = 1; i <= 5; i++) {
            Cell c = amountRow.createCell(i);
            c.setCellStyle(totalBorderStyle);
        }
        sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 0, 5));

        Cell amountChineseCell = amountRow.createCell(6);
        amountChineseCell.setCellValue(amountChinese);
        amountChineseCell.setCellStyle(totalBorderStyle);
        for (int i = 7; i <= 10; i++) {
            Cell c = amountRow.createCell(i);
            c.setCellStyle(totalBorderStyle);
        }
        sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 6, 10));

        // 12. 条款区域
        CellStyle termStyle10 = createMergedRowBorderStyle(workbook, 10);  // 条款文字10磅
        CellStyle termStyle11 = createMergedRowBorderStyle(workbook, 11);  // 送货签收11磅
        int termsStartRow = rowIndex; // 记录条款区域起始行

        // 一、
        createFullMergedRow(sheet, rowIndex++, 16f,
            "一、凡在我公司购货的欠款用户，无论自提，委托供方代运，所欠货款按以下协议执行：",
            termStyle10, 10);

        // 二、（较长，需要2行高度显示换行）
        createFullMergedRow(sheet, rowIndex++, 28f,
            "二、需方所欠供方货款，必须按供方指定的时间即   年  月  日前付清。如果到期未付清欠款，则供方按每日欠款的0.1%加收需方滞纳金。如不能协商解决的，由供方所在地金牛区法院解决；",
            termStyle10, 10);

        // 三、
        createFullMergedRow(sheet, rowIndex++, 16f,
            "三、需方购货收到货品3日内对质量提出异议，未提出，视为合格。如异议参照钢厂处理意见协商解决。",
            termStyle10, 10);

        // 四、
        createFullMergedRow(sheet, rowIndex++, 16f,
            "四、本协议一式叁份，需方留底一份。收货单位签收人签字后生效，具有法律效力。",
            termStyle10, 10);

        // 地址+电话
        createFullMergedRow(sheet, rowIndex++, 16f,
            "地址：成都市金牛区量力钢材城B座1909   电话：19302852518",
            termStyle10, 10);

        // 空行（也填充白色样式，保持区域内部干净）
        createFullMergedRow(sheet, rowIndex++, 10f, "", termStyle10, 10);

        // 13. 送货单位及经手人 + 签收单位及经手人
        createFullMergedRow(sheet, rowIndex++, 20f,
            "送货单位及经手人（盖章）：四川鸿恒盛供应链管理有限公司                    签收单位及经手人（盖章）：",
            termStyle11, 10);

        // 14. 送货时间 + 签收时间
        String dateText = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-M-d"));
        createFullMergedRow(sheet, rowIndex++, 20f,
            "送货时间：" + dateText + "                                        签收时间：",
            termStyle11, 10);

        // 15. 给整个条款区域加一个外框边框（无内部分割线）
        CellRangeAddress termsRegion = new CellRangeAddress(termsStartRow, rowIndex - 1, 0, 10);
        RegionUtil.setBorderTop(BorderStyle.THIN, termsRegion, sheet);
        RegionUtil.setBorderBottom(BorderStyle.THIN, termsRegion, sheet);
        RegionUtil.setBorderLeft(BorderStyle.THIN, termsRegion, sheet);
        RegionUtil.setBorderRight(BorderStyle.THIN, termsRegion, sheet);

        // 17. 设置响应头并输出
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String filename = "鸿恒盛发货单-" + customerName + "-" + dateStr + ".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition",
            "attachment;filename=" + URLEncoder.encode(filename, "UTF-8"));

        workbook.write(response.getOutputStream());
        workbook.close();
    }

    /**
     * B角色 送货清单导出（熙汇达鑫模板）
     * 11列：序号|产品名称|规格|材质|数量/根/张|长度/米|重量/吨|品牌|卸货位置|总米数|车号
     */
    private void generateSubOrderPrintExcel(OrderDO order, List<OrderItemDO> items,
                                             HttpServletResponse response) throws IOException {
        // 1. 准备数据
        String receivingUnit = order.getReceivingUnit() != null ? order.getReceivingUnit() : "";
        String projectName = "";
        if (order.getProjectId() != null) {
            ProjectDO project = projectService.getProject(order.getProjectId());
            if (project != null) {
                projectName = project.getName() != null ? project.getName() : "";
            }
        }
        String deliveryDate = "";
        if (order.getOrderDate() != null) {
            deliveryDate = order.getOrderDate().format(DateTimeFormatter.ofPattern("yyyy年M月d日"));
        } else {
            deliveryDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy年M月d日"));
        }
        String address = order.getAddress() != null ? order.getAddress() : "";

        // 2. 创建工作簿
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("送货清单");
        sheet.setDisplayGridlines(false); // 隐藏网格线

        // 3. 设置列宽（11列，参照模板比例）
        sheet.setColumnWidth(0, (int)(5.0 * 256));    // A：序号
        sheet.setColumnWidth(1, (int)(18.0 * 256));   // B：产品名称
        sheet.setColumnWidth(2, (int)(18.0 * 256));   // C：规格
        sheet.setColumnWidth(3, (int)(9.0 * 256));    // D：材质
        sheet.setColumnWidth(4, (int)(13.0 * 256));   // E：数量/根/张
        sheet.setColumnWidth(5, (int)(9.0 * 256));    // F：长度/米
        sheet.setColumnWidth(6, (int)(10.0 * 256));   // G：重量/吨
        sheet.setColumnWidth(7, (int)(18.0 * 256));   // H：品牌
        sheet.setColumnWidth(8, (int)(18.0 * 256));   // I：卸货位置
        sheet.setColumnWidth(9, (int)(11.0 * 256));   // J：总米数
        sheet.setColumnWidth(10, (int)(11.0 * 256));  // K：车号

        // 4. 创建样式
        CellStyle titleBoldStyle = createCenterTextStyle(workbook, 18);
        Font bFont = workbook.createFont();
        bFont.setFontName("宋体");
        bFont.setFontHeightInPoints((short) 18);
        bFont.setBold(true);
        titleBoldStyle.setFont(bFont);
        titleBoldStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        titleBoldStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        CellStyle infoStyleLeft = createTextStyleLeft(workbook, 11);
        infoStyleLeft.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        infoStyleLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        CellStyle headerStyle = createHeaderStyle(workbook);
        CellStyle dataCenterStyle = createDataCenterBorderStyle(workbook);
        CellStyle totalBorderStyle = createDataCenterBorderStyle(workbook);
        CellStyle termStyle = createMergedRowBorderStyle(workbook, 10);

        int rowIndex = 0;

        // 第1行：空行（白色填充）
        Row emptyRow0 = sheet.createRow(rowIndex++);
        emptyRow0.setHeightInPoints(6f);
        for (int i = 0; i <= 10; i++) {
            Cell c = emptyRow0.createCell(i);
            CellStyle ws = workbook.createCellStyle();
            ws.setFillForegroundColor(IndexedColors.WHITE.getIndex());
            ws.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            c.setCellStyle(ws);
        }

        // 第2行：标题（合并A-K，带外框）
        Row titleRow = sheet.createRow(rowIndex++);
        titleRow.setHeightInPoints(36f);
        for (int i = 0; i <= 10; i++) {
            titleRow.createCell(i).setCellStyle(titleBoldStyle);
        }
        titleRow.getCell(0).setCellValue("四川熙汇达鑫商贸有限公司  送货清单");
        CellRangeAddress titleRegion = new CellRangeAddress(1, 1, 0, 10);
        sheet.addMergedRegion(titleRegion);
        RegionUtil.setBorderTop(BorderStyle.THIN, titleRegion, sheet);
        RegionUtil.setBorderBottom(BorderStyle.THIN, titleRegion, sheet);
        RegionUtil.setBorderLeft(BorderStyle.THIN, titleRegion, sheet);
        RegionUtil.setBorderRight(BorderStyle.THIN, titleRegion, sheet);

        // 第3行：收货单位 | 项目名称 | 送货日期
        Row infoRow1 = sheet.createRow(rowIndex++);
        infoRow1.setHeightInPoints(20f);
        for (int i = 0; i <= 10; i++) {
            infoRow1.createCell(i).setCellStyle(infoStyleLeft);
        }

        infoRow1.getCell(0).setCellValue("收货单位：" + receivingUnit);
        CellRangeAddress infoR1 = new CellRangeAddress(2, 2, 0, 3);
        sheet.addMergedRegion(infoR1);
        RegionUtil.setBorderTop(BorderStyle.THIN, infoR1, sheet);
        RegionUtil.setBorderBottom(BorderStyle.THIN, infoR1, sheet);
        RegionUtil.setBorderLeft(BorderStyle.THIN, infoR1, sheet);
        RegionUtil.setBorderRight(BorderStyle.THIN, infoR1, sheet);

        infoRow1.getCell(4).setCellValue("项目名称：" + projectName);
        CellRangeAddress infoR2 = new CellRangeAddress(2, 2, 4, 7);
        sheet.addMergedRegion(infoR2);
        RegionUtil.setBorderTop(BorderStyle.THIN, infoR2, sheet);
        RegionUtil.setBorderBottom(BorderStyle.THIN, infoR2, sheet);
        RegionUtil.setBorderLeft(BorderStyle.THIN, infoR2, sheet);
        RegionUtil.setBorderRight(BorderStyle.THIN, infoR2, sheet);

        infoRow1.getCell(8).setCellValue("送货日期：" + deliveryDate);
        CellRangeAddress infoR3 = new CellRangeAddress(2, 2, 8, 10);
        sheet.addMergedRegion(infoR3);
        RegionUtil.setBorderTop(BorderStyle.THIN, infoR3, sheet);
        RegionUtil.setBorderBottom(BorderStyle.THIN, infoR3, sheet);
        RegionUtil.setBorderLeft(BorderStyle.THIN, infoR3, sheet);
        RegionUtil.setBorderRight(BorderStyle.THIN, infoR3, sheet);

        // 第4行：送货地址（带外框）
        Row infoRow2 = sheet.createRow(rowIndex++);
        infoRow2.setHeightInPoints(20f);
        for (int i = 0; i <= 10; i++) {
            infoRow2.createCell(i).setCellStyle(infoStyleLeft);
        }
        infoRow2.getCell(0).setCellValue("送货地址：" + address);
        CellRangeAddress addrRegion = new CellRangeAddress(3, 3, 0, 10);
        sheet.addMergedRegion(addrRegion);
        RegionUtil.setBorderTop(BorderStyle.THIN, addrRegion, sheet);
        RegionUtil.setBorderBottom(BorderStyle.THIN, addrRegion, sheet);
        RegionUtil.setBorderLeft(BorderStyle.THIN, addrRegion, sheet);
        RegionUtil.setBorderRight(BorderStyle.THIN, addrRegion, sheet);

        // 8. 表头行
        Row headerRow = sheet.createRow(rowIndex++);
        headerRow.setHeightInPoints(22f);
        String[] headers = {"序号", "产品名称", "规格", "材质", "数量/根/张", "长度/米", "重量/吨", "品牌", "卸货位置", "总米数", "车号"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // 9. 产品明细行
        BigDecimal sumWeight = BigDecimal.ZERO;
        BigDecimal sumTotalMeters = BigDecimal.ZERO;
        int seq = 1;
        int dataStartRow = rowIndex; // 记录数据起始行，用于车号列合并
        String orderVehicleNo = order.getVehicleNo() != null ? order.getVehicleNo() : "";
        for (OrderItemDO item : items) {
            // 跳过费用行
            if (item.getItemType() != null && item.getItemType() == 1) continue;

            Row dataRow = sheet.createRow(rowIndex++);
            dataRow.setHeightInPoints(20f);

            // 序号
            Cell seqCell = dataRow.createCell(0);
            seqCell.setCellValue(seq++);
            seqCell.setCellStyle(dataCenterStyle);

            // 产品名称
            Cell nameCell = dataRow.createCell(1);
            nameCell.setCellValue(item.getProductName() != null ? item.getProductName() : "");
            nameCell.setCellStyle(dataCenterStyle);

            // 规格
            Cell specCell = dataRow.createCell(2);
            specCell.setCellValue(item.getSpec() != null ? item.getSpec() : "");
            specCell.setCellStyle(dataCenterStyle);

            // 材质
            Cell materialCell = dataRow.createCell(3);
            materialCell.setCellValue(item.getMaterial() != null ? item.getMaterial() : "");
            materialCell.setCellStyle(dataCenterStyle);

            // 数量/根/张
            Cell qtyCell = dataRow.createCell(4);
            if (item.getSaleQuantity() != null) {
                qtyCell.setCellValue(item.getSaleQuantity().doubleValue());
            }
            qtyCell.setCellStyle(dataCenterStyle);

            // 长度/米
            Cell lengthCell = dataRow.createCell(5);
            if (item.getLength() != null) {
                lengthCell.setCellValue(item.getLength().doubleValue());
            }
            lengthCell.setCellStyle(dataCenterStyle);

            // 重量/吨
            Cell weightCell = dataRow.createCell(6);
            if (item.getWeight() != null) {
                weightCell.setCellValue(item.getWeight().doubleValue());
                sumWeight = sumWeight.add(item.getWeight());
            }
            weightCell.setCellStyle(dataCenterStyle);

            // 品牌（兼容历史数据：品牌为空时回退厂家）
            Cell mfCell = dataRow.createCell(7);
            mfCell.setCellValue(resolveBrandForPrint(item));
            mfCell.setCellStyle(dataCenterStyle);

            // 卸货位置（使用备注字段）
            Cell posCell = dataRow.createCell(8);
            posCell.setCellValue(item.getSaleRemark() != null ? item.getSaleRemark() : "");
            posCell.setCellStyle(dataCenterStyle);

            // 总米数
            Cell tmCell = dataRow.createCell(9);
            if (item.getTotalMeters() != null) {
                tmCell.setCellValue(item.getTotalMeters().doubleValue());
                sumTotalMeters = sumTotalMeters.add(item.getTotalMeters());
            }
            tmCell.setCellStyle(dataCenterStyle);

            // 车号（合并列，先创建空单元格）
            Cell vnCell = dataRow.createCell(10);
            vnCell.setCellStyle(dataCenterStyle);
        }

        // 10. 合计行
        Row totalRow = sheet.createRow(rowIndex++);
        totalRow.setHeightInPoints(20f);

        Cell totalLabelCell = totalRow.createCell(0);
        totalLabelCell.setCellValue("合计");
        totalLabelCell.setCellStyle(totalBorderStyle);

        // 空单元格加边框
        for (int i = 1; i <= 5; i++) {
            Cell c = totalRow.createCell(i);
            c.setCellStyle(totalBorderStyle);
        }

        // 重量合计
        Cell sumWeightCell = totalRow.createCell(6);
        sumWeightCell.setCellValue(sumWeight.doubleValue());
        sumWeightCell.setCellStyle(totalBorderStyle);

        // 空单元格
        for (int i = 7; i <= 8; i++) {
            Cell c = totalRow.createCell(i);
            c.setCellStyle(totalBorderStyle);
        }

        // 总米数合计
        Cell sumMetersCell = totalRow.createCell(9);
        sumMetersCell.setCellValue(sumTotalMeters.doubleValue());
        sumMetersCell.setCellStyle(totalBorderStyle);

        // 车号（空，参与合并）
        Cell totalVnCell = totalRow.createCell(10);
        totalVnCell.setCellStyle(totalBorderStyle);

        // 车号列：将数据行+合计行的K列合并为一个单元格，写入订单的车号
        int dataEndRow = rowIndex - 1; // 合计行
        if (dataEndRow > dataStartRow) {
            sheet.addMergedRegion(new CellRangeAddress(dataStartRow, dataEndRow, 10, 10));
        }
        // 在合并区域的第一个单元格写入车号
        sheet.getRow(dataStartRow).getCell(10).setCellValue(orderVehicleNo);

        // 11. 底部签收区域（带外框，与模板一致）
        int bottomStartRow = rowIndex;

        // 签收意见（含完整说明文字）
        createFullMergedRow(sheet, rowIndex++, 20f,
            "签收意见：（若无特殊说明，则认为规格、材质、数量、重量无误。如有异议，请于签收时注明）",
            termStyle, 10);

        // 空行（签收区域留白）
        createFullMergedRow(sheet, rowIndex++, 24f, "", termStyle, 10);

        // 签收签字（左半空白 + 右半显示）
        Row signRow = sheet.createRow(rowIndex++);
        signRow.setHeightInPoints(22f);
        for (int i = 0; i <= 10; i++) {
            signRow.createCell(i).setCellStyle(termStyle);
        }
        signRow.getCell(7).setCellValue("签收签字：");
        sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 0, 6));
        sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 7, 10));

        // 签收日期（左半空白 + 右半显示）
        Row dateRow = sheet.createRow(rowIndex++);
        dateRow.setHeightInPoints(22f);
        for (int i = 0; i <= 10; i++) {
            dateRow.createCell(i).setCellStyle(termStyle);
        }
        dateRow.getCell(7).setCellValue("签收日期：");
        sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 0, 6));
        sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 7, 10));

        // 温馨提示
        createFullMergedRow(sheet, rowIndex++, 18f,
            "温馨提示：此单经收货方签收确认后生效。",
            termStyle, 10);

        // 给整个底部区域加外框
        CellRangeAddress bottomRegion = new CellRangeAddress(bottomStartRow, rowIndex - 1, 0, 10);
        RegionUtil.setBorderTop(BorderStyle.THIN, bottomRegion, sheet);
        RegionUtil.setBorderBottom(BorderStyle.THIN, bottomRegion, sheet);
        RegionUtil.setBorderLeft(BorderStyle.THIN, bottomRegion, sheet);
        RegionUtil.setBorderRight(BorderStyle.THIN, bottomRegion, sheet);

        // 15. 设置响应头并输出
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String filename = "熙汇达鑫送货单-" + receivingUnit + "-" + dateStr + ".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition",
            "attachment;filename=" + URLEncoder.encode(filename, "UTF-8"));

        workbook.write(response.getOutputStream());
        workbook.close();
    }

    private String resolveBrandForPrint(OrderItemDO item) {
        if (item == null) {
            return "";
        }
        if (item.getBrand() != null && !item.getBrand().trim().isEmpty()) {
            return item.getBrand();
        }
        if (item.getManufacturer() != null && !item.getManufacturer().trim().isEmpty()) {
            return item.getManufacturer();
        }
        return "";
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
     * 创建左对齐文本样式
     */
    private CellStyle createTextStyleLeft(Workbook workbook, int fontSize) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) fontSize);
        font.setBold(false);
        style.setFont(font);
        style.setAlignment(HorizontalAlignment.LEFT);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setWrapText(true);
        return style;
    }

    /**
     * 创建合并行样式（左对齐、自动换行、白色填充、无边框）
     */
    private CellStyle createMergedRowBorderStyle(Workbook workbook, int fontSize) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) fontSize);
        font.setBold(false);
        style.setFont(font);
        style.setAlignment(HorizontalAlignment.LEFT);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setWrapText(true);
        // 白色背景填充，遮住网格线
        style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        return style;
    }

    /**
     * 创建整行合并单元格（无边框，仅白色填充隐藏网格线）
     */
    private void createFullMergedRow(Sheet sheet, int rowIdx, float heightInPoints,
                                      String text, CellStyle style, int lastCol) {
        Row row = sheet.createRow(rowIdx);
        row.setHeightInPoints(heightInPoints);
        for (int i = 0; i <= lastCol; i++) {
            Cell cell = row.createCell(i);
            cell.setCellStyle(style);
        }
        row.getCell(0).setCellValue(text);
        CellRangeAddress region = new CellRangeAddress(rowIdx, rowIdx, 0, lastCol);
        sheet.addMergedRegion(region);
    }

    /**
     * 创建右对齐文本样式
     */
    private CellStyle createTextStyleRight(Workbook workbook, int fontSize) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) fontSize);
        font.setBold(false);
        style.setFont(font);
        style.setAlignment(HorizontalAlignment.RIGHT);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
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

    // ========== 进销项导出相关 ==========

    @Override
    public void generateDetailExcel(Long orderId, HttpServletResponse response) throws IOException {
        // 1. 查询所有关联数据
        OrderDO order = validateOrderExists(orderId);
        CustomerDO customer = order.getCustomerId() != null ? customerService.getCustomer(order.getCustomerId()) : null;
        List<OrderItemDO> items = orderItemMapper.selectListByOrderId(orderId);
        List<OrderItemDO> productItems = items.stream()
                .filter(i -> i.getItemType() == null || i.getItemType() == 0)
                .collect(Collectors.toList());

        List<PurchaseOrderDO> purchaseOrders = purchaseOrderMapper.selectListByOrderId(orderId);
        List<PurchaseOrderItemDO> purchaseItems = new ArrayList<>();
        if (CollUtil.isNotEmpty(purchaseOrders)) {
            List<Long> poIds = purchaseOrders.stream().map(PurchaseOrderDO::getId).collect(Collectors.toList());
            purchaseItems = purchaseOrderItemMapper.selectListByPurchaseOrderIds(poIds);
        }

        List<PaymentDO> payments = paymentMapper.selectListByOrderId(orderId);
        List<PaymentPlanDO> paymentPlans = paymentPlanMapper.selectListByOrderId(orderId);
        List<ExpenseDO> expenses = expenseMapper.selectListByOrderId(orderId);
        List<VoucherDO> vouchers = voucherMapper.selectListByOrderId(orderId);

        // 收集供应商ID
        Set<Long> supplierIds = new LinkedHashSet<>();
        items.forEach(i -> { if (i.getSupplierId() != null) supplierIds.add(i.getSupplierId()); });
        purchaseOrders.forEach(po -> { if (po.getSupplierId() != null) supplierIds.add(po.getSupplierId()); });
        payments.forEach(p -> { if (p.getSupplierId() != null) supplierIds.add(p.getSupplierId()); });
        Map<Long, SupplierDO> supplierMap = supplierIds.isEmpty() ? Collections.emptyMap()
                : supplierService.getSupplierMap(new ArrayList<>(supplierIds));

        String companyName = getCompanyNameByInvoice(order.getInvoiceCompany());
        String filePrefix = getFilePrefixByInvoice(order.getInvoiceCompany());
        String customerName = customer != null ? customer.getName() : "";

        // 2. 创建工作簿
        Workbook wb = new XSSFWorkbook();

        // 公用样式
        CellStyle headerStyle = createExportHeaderStyle(wb, false);
        CellStyle headerBoldStyle = createExportHeaderStyle(wb, true);
        CellStyle dataStyle = createExportDataStyle(wb);
        CellStyle moneyStyle = createExportMoneyStyle(wb);
        CellStyle titleStyle = createExportTitleStyle(wb);
        CellStyle subtitleStyle = createExportSubtitleStyle(wb);
        CellStyle redHeaderStyle = createExportRedHeaderStyle(wb);

        // --- Sheet 1: 客户信息 ---
        buildCustomerSheet(wb, headerStyle, dataStyle, customer);

        // --- Sheet 2: 产品信息 ---
        buildProductSheet(wb, headerStyle, dataStyle, moneyStyle, productItems);

        // --- Sheet 3: 供应商信息 ---
        buildSupplierSheet(wb, headerStyle, dataStyle, supplierMap);

        // --- Sheet 4: 采购明细 ---
        buildPurchaseDetailSheet(wb, headerStyle, dataStyle, moneyStyle,
                order, purchaseOrders, purchaseItems, productItems, supplierMap, vouchers);

        // --- Sheet 5: 销售明细 ---
        buildSalesDetailSheet(wb, headerBoldStyle, dataStyle, moneyStyle,
                order, productItems, customer, vouchers);

        // --- Sheet 6: 付款明细 ---
        buildPaymentDetailSheet(wb, headerStyle, dataStyle, moneyStyle,
                payments, paymentPlans, supplierMap, companyName);

        // --- Sheet 7: 应付账款 ---
        buildPayableSheet(wb, headerStyle, dataStyle, moneyStyle, redHeaderStyle,
                productItems, payments, supplierMap);

        // --- Sheet 8: 收款明细 ---
        buildReceiptDetailSheet(wb, headerStyle, dataStyle, moneyStyle,
                paymentPlans, customer, companyName);

        // --- Sheet 9: 应收账款 ---
        buildReceivableSheet(wb, headerStyle, dataStyle, moneyStyle, redHeaderStyle,
                order, customer, paymentPlans);

        // --- Sheet 10: 利润 ---
        buildProfitSheet(wb, headerStyle, dataStyle, moneyStyle, titleStyle, subtitleStyle, order);

        // --- Sheet 11: 运费支出 ---
        buildExpenseSheet(wb, headerStyle, dataStyle, moneyStyle, titleStyle, subtitleStyle, expenses);

        // 3. 输出
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String projectName = "";
        if (order.getProjectId() != null) {
            ProjectDO project = projectService.getProject(order.getProjectId());
            if (project != null) projectName = project.getName();
        }
        String filename = (projectName.isEmpty() ? filePrefix : projectName) + "进销项-" + customerName + "-" + dateStr + ".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition",
                "attachment;filename=" + URLEncoder.encode(filename, "UTF-8"));
        wb.write(response.getOutputStream());
        wb.close();
    }

    // ---------- 各 Sheet 构建方法 ----------

    private void buildCustomerSheet(Workbook wb, CellStyle hs, CellStyle ds, CustomerDO c) {
        Sheet s = wb.createSheet("客户信息");
        s.setColumnWidth(0, (int)(48 * 256));
        s.setColumnWidth(1, (int)(16 * 256));
        s.setColumnWidth(2, (int)(20 * 256));
        Row h = s.createRow(0);
        setCellVal(h, 0, "客户名称", hs); setCellVal(h, 1, "地址", hs); setCellVal(h, 2, "联系电话", hs);
        if (c != null) {
            Row r = s.createRow(1);
            setCellVal(r, 0, c.getName(), ds);
            setCellVal(r, 1, c.getAddress(), ds);
            setCellVal(r, 2, c.getMobile(), ds);
        }
    }

    private void buildProductSheet(Workbook wb, CellStyle hs, CellStyle ds, CellStyle ms, List<OrderItemDO> items) {
        Sheet s = wb.createSheet("产品信息");
        s.setColumnWidth(0, (int)(37 * 256));
        s.setColumnWidth(1, (int)(16 * 256));
        s.setColumnWidth(2, (int)(37 * 256));
        s.setColumnWidth(3, (int)(41 * 256));
        Row h = s.createRow(0);
        setCellVal(h, 0, "产品名称", hs); setCellVal(h, 1, "规格", hs);
        setCellVal(h, 2, "销售单价", hs); setCellVal(h, 3, "采购单价", hs);
        int rowIdx = 1;
        for (OrderItemDO item : items) {
            Row r = s.createRow(rowIdx++);
            setCellVal(r, 0, item.getProductName(), ds);
            setCellVal(r, 1, item.getSpec(), ds);
            setCellNum(r, 2, item.getSalePrice(), ms);
            setCellNum(r, 3, item.getPurchasePrice(), ms);
        }
    }

    private void buildSupplierSheet(Workbook wb, CellStyle hs, CellStyle ds, Map<Long, SupplierDO> map) {
        Sheet s = wb.createSheet("供应商信息");
        s.setColumnWidth(0, (int)(36 * 256));
        s.setColumnWidth(1, (int)(16 * 256));
        s.setColumnWidth(2, (int)(20 * 256));
        s.setColumnWidth(3, (int)(41 * 256));
        Row h = s.createRow(0);
        setCellVal(h, 0, "供应商", hs); setCellVal(h, 1, "地址", hs);
        setCellVal(h, 2, "联系电话", hs); setCellVal(h, 3, "备注", hs);
        int rowIdx = 1;
        for (SupplierDO sup : map.values()) {
            Row r = s.createRow(rowIdx++);
            setCellVal(r, 0, sup.getName(), ds);
            setCellVal(r, 1, sup.getAddress(), ds);
            setCellVal(r, 2, sup.getMobile(), ds);
            setCellVal(r, 3, sup.getRemark(), ds);
        }
    }

    private void buildPurchaseDetailSheet(Workbook wb, CellStyle hs, CellStyle ds, CellStyle ms,
                                          OrderDO order, List<PurchaseOrderDO> poList,
                                          List<PurchaseOrderItemDO> poItems,
                                          List<OrderItemDO> orderItems,
                                          Map<Long, SupplierDO> supplierMap,
                                          List<VoucherDO> vouchers) {
        Sheet s = wb.createSheet("采购明细");
        int[] widths = {16, 15, 14, 13, 13, 16, 14, 30, 20, 16, 15, 25};
        for (int i = 0; i < widths.length; i++) s.setColumnWidth(i, (int)(widths[i] * 256));
        Row h = s.createRow(0);
        String[] headers = {"日期", "产品名称", "规格", "单价", "数量", "金额", "采购员", "供应商名称", "地址", "联系电话", "开票情况", "备注"};
        for (int i = 0; i < headers.length; i++) setCellVal(h, i, headers[i], hs);

        // 按采购单ID汇总进项发票信息（direction=0为进项）
        Map<Long, List<VoucherDO>> poVoucherMap = vouchers.stream()
                .filter(v -> v.getDirection() != null && v.getDirection() == 0 && v.getOrderId() != null)
                .collect(Collectors.groupingBy(VoucherDO::getOrderId));

        int rowIdx = 1;
        if (CollUtil.isNotEmpty(poItems)) {
            Map<Long, PurchaseOrderDO> poMap = poList.stream().collect(Collectors.toMap(PurchaseOrderDO::getId, po -> po));
            for (PurchaseOrderItemDO pi : poItems) {
                Row r = s.createRow(rowIdx++);
                PurchaseOrderDO po = poMap.get(pi.getPurchaseOrderId());
                String dateStr = po != null && po.getCreateTime() != null
                        ? po.getCreateTime().format(DateTimeFormatter.ofPattern("yyyy.M.d")) : "";
                setCellVal(r, 0, dateStr, ds);
                setCellVal(r, 1, pi.getProductName(), ds);
                setCellVal(r, 2, pi.getSpecName(), ds);
                setCellNum(r, 3, pi.getPurchasePrice(), ms);
                setCellNum(r, 4, pi.getQuantity(), ms);
                setCellNum(r, 5, pi.getPurchaseAmount(), ms);
                setCellVal(r, 6, "", ds);
                SupplierDO sup = po != null ? supplierMap.get(po.getSupplierId()) : null;
                setCellVal(r, 7, sup != null ? sup.getName() : "", ds);
                setCellVal(r, 8, sup != null ? sup.getAddress() : "", ds);
                setCellVal(r, 9, sup != null ? sup.getMobile() : "", ds);
                // 开票情况：根据订单是否有进项发票
                String invoiceInfo = getInvoiceInfo(poVoucherMap, order.getId());
                setCellVal(r, 10, invoiceInfo, ds);
                setCellVal(r, 11, po != null ? po.getRemark() : "", ds);
            }
        } else {
            String dateStr = order.getOrderDate() != null
                    ? order.getOrderDate().format(DateTimeFormatter.ofPattern("yyyy.M.d")) : "";
            for (OrderItemDO item : orderItems) {
                if (item.getPurchasePrice() == null && item.getPurchaseAmount() == null) continue;
                Row r = s.createRow(rowIdx++);
                setCellVal(r, 0, dateStr, ds);
                setCellVal(r, 1, item.getProductName(), ds);
                setCellVal(r, 2, item.getSpec(), ds);
                setCellNum(r, 3, item.getPurchasePrice(), ms);
                setCellNum(r, 4, item.getPurchaseQuantity(), ms);
                setCellNum(r, 5, item.getPurchaseAmount(), ms);
                setCellVal(r, 6, "", ds);
                SupplierDO sup = item.getSupplierId() != null ? supplierMap.get(item.getSupplierId()) : null;
                setCellVal(r, 7, sup != null ? sup.getName() : "", ds);
                setCellVal(r, 8, sup != null ? sup.getAddress() : "", ds);
                setCellVal(r, 9, sup != null ? sup.getMobile() : "", ds);
                setCellVal(r, 10, "", ds);
                setCellVal(r, 11, "", ds);
            }
        }
    }

    private String getInvoiceInfo(Map<Long, List<VoucherDO>> poVoucherMap, Long orderId) {
        if (orderId == null) return "";
        List<VoucherDO> vList = poVoucherMap.get(orderId);
        if (CollUtil.isEmpty(vList)) return "";
        StringBuilder sb = new StringBuilder("已开票");
        for (VoucherDO v : vList) {
            if (v.getInvoiceCode() != null && !v.getInvoiceCode().isEmpty()) {
                sb.append(" ").append(v.getInvoiceCode());
            }
        }
        return sb.toString();
    }

    private void buildSalesDetailSheet(Workbook wb, CellStyle hs, CellStyle ds, CellStyle ms,
                                       OrderDO order, List<OrderItemDO> items,
                                       CustomerDO customer, List<VoucherDO> vouchers) {
        Sheet s = wb.createSheet("销售明细");
        int[] widths = {13, 24, 22, 12, 11, 13, 35, 16, 14};
        for (int i = 0; i < widths.length; i++) s.setColumnWidth(i, (int)(widths[i] * 256));
        Row h = s.createRow(0);
        String[] headers = {"日期", "产品名称", "规格", "单价", "数量", "金额", "客户名称", "地址", "开票情况"};
        for (int i = 0; i < headers.length; i++) setCellVal(h, i, headers[i], hs);

        List<VoucherDO> outgoingVouchers = vouchers.stream()
                .filter(v -> v.getDirection() != null && v.getDirection() == 1)
                .collect(Collectors.toList());
        String invoiceStatus = "";
        if (CollUtil.isNotEmpty(outgoingVouchers)) {
            StringBuilder sb = new StringBuilder("已开票");
            for (VoucherDO v : outgoingVouchers) {
                if (v.getInvoiceCode() != null && !v.getInvoiceCode().isEmpty()) {
                    sb.append(" ").append(v.getInvoiceCode());
                }
            }
            invoiceStatus = sb.toString();
        }
        String dateStr = order.getOrderDate() != null
                ? order.getOrderDate().format(DateTimeFormatter.ofPattern("yyyy.M.d")) : "";
        int rowIdx = 1;
        for (OrderItemDO item : items) {
            Row r = s.createRow(rowIdx++);
            setCellVal(r, 0, dateStr, ds);
            setCellVal(r, 1, item.getProductName(), ds);
            setCellVal(r, 2, item.getSpec(), ds);
            setCellNum(r, 3, item.getSalePrice(), ms);
            setCellNum(r, 4, item.getSaleQuantity(), ms);
            setCellNum(r, 5, item.getSaleAmount(), ms);
            setCellVal(r, 6, customer != null ? customer.getName() : "", ds);
            setCellVal(r, 7, customer != null ? customer.getAddress() : "", ds);
            setCellVal(r, 8, invoiceStatus, ds);
        }
    }

    private void buildPaymentDetailSheet(Workbook wb, CellStyle hs, CellStyle ds, CellStyle ms,
                                         List<PaymentDO> payments, List<PaymentPlanDO> paymentPlans,
                                         Map<Long, SupplierDO> supplierMap, String companyName) {
        Sheet s = wb.createSheet("付款明细");
        s.setColumnWidth(0, (int)(21 * 256));
        s.setColumnWidth(1, (int)(31 * 256));
        s.setColumnWidth(2, (int)(21 * 256));
        s.setColumnWidth(3, (int)(16 * 256));
        s.setColumnWidth(4, (int)(21 * 256));
        s.setColumnWidth(5, (int)(30 * 256));
        s.setColumnWidth(6, (int)(11 * 256));
        Row h = s.createRow(0);
        String[] headers = {"日期", "供应商名称", "地址", "联系电话", "金额", "交款人", "发票"};
        for (int i = 0; i < headers.length; i++) setCellVal(h, i, headers[i], hs);

        int rowIdx = 1;
        if (CollUtil.isNotEmpty(payments)) {
            for (PaymentDO p : payments) {
                Row r = s.createRow(rowIdx++);
                String dateStr = p.getPaymentDate() != null
                        ? p.getPaymentDate().format(DateTimeFormatter.ofPattern("yyyy.M.d")) : "";
                setCellVal(r, 0, dateStr, ds);
                SupplierDO sup = p.getSupplierId() != null ? supplierMap.get(p.getSupplierId()) : null;
                setCellVal(r, 1, sup != null ? sup.getName() : "", ds);
                setCellVal(r, 2, sup != null ? sup.getAddress() : "", ds);
                setCellVal(r, 3, sup != null ? sup.getMobile() : "", ds);
                setCellNum(r, 4, p.getAmount(), ms);
                setCellVal(r, 5, companyName, ds);
                setCellVal(r, 6, "", ds);
            }
            return;
        }

        for (PaymentPlanDO p : paymentPlans) {
            if (!Integer.valueOf(0).equals(p.getType())) {
                continue;
            }
            Row r = s.createRow(rowIdx++);
            String dateStr = p.getPlanDate() != null
                    ? p.getPlanDate().format(DateTimeFormatter.ofPattern("yyyy.M.d")) : "";
            setCellVal(r, 0, dateStr, ds);
            SupplierDO sup = p.getSupplierId() != null ? supplierMap.get(p.getSupplierId()) : null;
            setCellVal(r, 1, sup != null ? sup.getName() : "", ds);
            setCellVal(r, 2, sup != null ? sup.getAddress() : "", ds);
            setCellVal(r, 3, sup != null ? sup.getMobile() : "", ds);
            setCellNum(r, 4, p.getPlanAmount(), ms);
            setCellVal(r, 5, companyName, ds);
            setCellVal(r, 6, "", ds);
        }
    }

    private void buildPayableSheet(Workbook wb, CellStyle hs, CellStyle ds, CellStyle ms, CellStyle rhs,
                                   List<OrderItemDO> items, List<PaymentDO> payments,
                                   Map<Long, SupplierDO> supplierMap) {
        Sheet s = wb.createSheet("应付账款");
        int[] widths = {33, 17, 16, 20, 18, 18, 16, 11};
        for (int i = 0; i < widths.length; i++) s.setColumnWidth(i, (int)(widths[i] * 256));
        Row h = s.createRow(0);
        String[] headers = {"供应商名称", "地址", "联系电话", "采购金额", "已付金额", "应付金额", "应付占百分比", "排名"};
        for (int i = 0; i < 7; i++) setCellVal(h, i, headers[i], hs);
        setCellVal(h, 7, headers[7], rhs);

        // 按供应商聚合采购金额
        Map<Long, BigDecimal> purchaseBySupplier = new LinkedHashMap<>();
        for (OrderItemDO item : items) {
            if (item.getSupplierId() != null && item.getPurchaseAmount() != null) {
                purchaseBySupplier.merge(item.getSupplierId(), item.getPurchaseAmount(), BigDecimal::add);
            }
        }
        // 按供应商聚合已付金额
        Map<Long, BigDecimal> paidBySupplier = new LinkedHashMap<>();
        for (PaymentDO p : payments) {
            if (p.getSupplierId() != null && p.getAmount() != null) {
                paidBySupplier.merge(p.getSupplierId(), p.getAmount(), BigDecimal::add);
            }
        }

        BigDecimal totalPayable = BigDecimal.ZERO;
        Set<Long> allSupplierIds = new LinkedHashSet<>();
        allSupplierIds.addAll(purchaseBySupplier.keySet());
        allSupplierIds.addAll(paidBySupplier.keySet());
        // 计算每个供应商应付金额并排序
        List<Map.Entry<Long, BigDecimal>> payableEntries = new ArrayList<>();
        for (Long sid : allSupplierIds) {
            BigDecimal purchase = purchaseBySupplier.getOrDefault(sid, BigDecimal.ZERO);
            BigDecimal paid = paidBySupplier.getOrDefault(sid, BigDecimal.ZERO);
            BigDecimal payable = purchase.subtract(paid);
            payableEntries.add(new AbstractMap.SimpleEntry<>(sid, payable));
            totalPayable = totalPayable.add(payable);
        }
        payableEntries.sort((a, b) -> b.getValue().compareTo(a.getValue()));

        int rowIdx = 1;
        int rank = 1;
        for (Map.Entry<Long, BigDecimal> entry : payableEntries) {
            Long sid = entry.getKey();
            SupplierDO sup = supplierMap.get(sid);
            BigDecimal purchase = purchaseBySupplier.getOrDefault(sid, BigDecimal.ZERO);
            BigDecimal paid = paidBySupplier.getOrDefault(sid, BigDecimal.ZERO);
            BigDecimal payable = entry.getValue();
            double pct = totalPayable.compareTo(BigDecimal.ZERO) != 0
                    ? payable.doubleValue() / totalPayable.doubleValue() : 0;

            Row r = s.createRow(rowIdx++);
            setCellVal(r, 0, sup != null ? sup.getName() : "", ds);
            setCellVal(r, 1, sup != null ? sup.getAddress() : "", ds);
            setCellVal(r, 2, sup != null ? sup.getMobile() : "", ds);
            setCellNum(r, 3, purchase, ms);
            setCellNum(r, 4, paid, ms);
            setCellNum(r, 5, payable, ms);
            Cell pctCell = r.createCell(6); pctCell.setCellValue(pct); pctCell.setCellStyle(ds);
            Cell rankCell = r.createCell(7); rankCell.setCellValue(rank++); rankCell.setCellStyle(ds);
        }
    }

    private void buildReceiptDetailSheet(Workbook wb, CellStyle hs, CellStyle ds, CellStyle ms,
                                         List<PaymentPlanDO> plans, CustomerDO customer, String companyName) {
        Sheet s = wb.createSheet("收款明细");
        s.setColumnWidth(0, (int)(17 * 256));
        s.setColumnWidth(1, (int)(31 * 256));
        s.setColumnWidth(2, (int)(15 * 256));
        s.setColumnWidth(3, (int)(17 * 256));
        s.setColumnWidth(4, (int)(17 * 256));
        s.setColumnWidth(5, (int)(43 * 256));
        s.setColumnWidth(6, (int)(16 * 256));
        Row h = s.createRow(0);
        String[] headers = {"日期", "客户名称", "地址", "联系电话", "金额", "交款人", "收款人"};
        for (int i = 0; i < headers.length; i++) setCellVal(h, i, headers[i], hs);

        int rowIdx = 1;
        List<PaymentPlanDO> receipts = plans.stream()
                .filter(p -> p.getType() != null && p.getType() == 1
                        && p.getPaidAmount() != null && p.getPaidAmount().compareTo(BigDecimal.ZERO) > 0)
                .collect(Collectors.toList());
        for (PaymentPlanDO plan : receipts) {
            Row r = s.createRow(rowIdx++);
            String dateStr = plan.getActualDate() != null
                    ? plan.getActualDate().format(DateTimeFormatter.ofPattern("yyyy.M.d"))
                    : (plan.getPlanDate() != null ? plan.getPlanDate().format(DateTimeFormatter.ofPattern("yyyy.M.d")) : "");
            setCellVal(r, 0, dateStr, ds);
            setCellVal(r, 1, customer != null ? customer.getName() : "", ds);
            setCellVal(r, 2, customer != null ? customer.getAddress() : "", ds);
            setCellVal(r, 3, customer != null ? customer.getMobile() : "", ds);
            setCellNum(r, 4, plan.getPaidAmount(), ms);
            setCellVal(r, 5, customer != null ? customer.getName() : "", ds);
            setCellVal(r, 6, companyName, ds);
        }
    }

    private void buildReceivableSheet(Workbook wb, CellStyle hs, CellStyle ds, CellStyle ms, CellStyle rhs,
                                      OrderDO order, CustomerDO customer, List<PaymentPlanDO> plans) {
        Sheet s = wb.createSheet("应收账款");
        int[] widths = {34, 16, 19, 13, 16, 14, 13, 18, 12};
        for (int i = 0; i < widths.length; i++) s.setColumnWidth(i, (int)(widths[i] * 256));
        Row h = s.createRow(0);
        String[] headers = {"客户名称", "地址", "联系电话", "上期结转应收", "销售金额", "已收金额", "应收金额", "应收占百分比", "排名"};
        for (int i = 0; i < 8; i++) setCellVal(h, i, headers[i], hs);
        setCellVal(h, 8, headers[8], rhs);

        BigDecimal salesAmount = order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO;
        BigDecimal discount = order.getDiscountAmount() != null ? order.getDiscountAmount() : BigDecimal.ZERO;
        BigDecimal netSales = salesAmount.subtract(discount);
        BigDecimal received = plans.stream()
                .filter(p -> p.getType() != null && p.getType() == 1 && p.getPaidAmount() != null)
                .map(PaymentPlanDO::getPaidAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        if (received.compareTo(BigDecimal.ZERO) == 0 && order.getPaidAmount() != null) {
            received = order.getPaidAmount();
        }
        BigDecimal receivable = netSales.subtract(received);

        Row r = s.createRow(1);
        setCellVal(r, 0, customer != null ? customer.getName() : "", ds);
        setCellVal(r, 1, customer != null ? customer.getAddress() : "", ds);
        setCellVal(r, 2, customer != null ? customer.getMobile() : "", ds);
        setCellNum(r, 3, BigDecimal.ZERO, ms);
        setCellNum(r, 4, netSales, ms);
        setCellNum(r, 5, received, ms);
        setCellNum(r, 6, receivable, ms);
        Cell pctCell = r.createCell(7);
        pctCell.setCellValue(netSales.compareTo(BigDecimal.ZERO) != 0
                ? receivable.doubleValue() / netSales.doubleValue() : 0);
        pctCell.setCellStyle(ds);
        Cell rankCell = r.createCell(8); rankCell.setCellValue(1); rankCell.setCellStyle(ds);
    }

    private void buildProfitSheet(Workbook wb, CellStyle hs, CellStyle ds, CellStyle ms,
                                  CellStyle titleStyle, CellStyle subtitleStyle, OrderDO order) {
        Sheet s = wb.createSheet("利润");
        int[] widths = {5, 12, 12, 15, 12, 11, 15, 27};
        for (int i = 0; i < widths.length; i++) s.setColumnWidth(i, (int)(widths[i] * 256));

        // Row 0: 标题
        Row r0 = s.createRow(0);
        setCellVal(r0, 0, "利润明细表", titleStyle);
        for (int i = 1; i < 8; i++) r0.createCell(i).setCellStyle(titleStyle);
        s.addMergedRegion(new CellRangeAddress(0, 0, 0, 7));

        // Row 1: 子标题
        Row r1 = s.createRow(1);
        setCellVal(r1, 0, "利润", subtitleStyle);
        for (int i = 1; i < 8; i++) r1.createCell(i).setCellStyle(subtitleStyle);
        s.addMergedRegion(new CellRangeAddress(1, 1, 0, 7));

        // Row 2: 表头
        Row hRow = s.createRow(2);
        String[] headers = {"序号", "日期", "销售金额", "采购金额", "吨位", "加价", "总金额", "备注"};
        for (int i = 0; i < headers.length; i++) setCellVal(hRow, i, headers[i], hs);

        // Row 3: 数据
        Row dRow = s.createRow(3);
        Cell seqCell = dRow.createCell(0); seqCell.setCellValue(1); seqCell.setCellStyle(ds);
        String dateStr = order.getOrderDate() != null
                ? order.getOrderDate().format(DateTimeFormatter.ofPattern("yyyy.M.d")) : "";
        setCellVal(dRow, 1, dateStr, ds);
        setCellNum(dRow, 2, order.getTotalAmount(), ms);
        setCellNum(dRow, 3, order.getTotalPurchaseAmount(), ms);
        setCellVal(dRow, 4, "", ds); // 吨位 - 留空
        setCellVal(dRow, 5, "", ds); // 加价 - 留空
        setCellNum(dRow, 6, order.getTotalNetProfit(), ms);
        setCellVal(dRow, 7, order.getRemark(), ds);

        // Row 4: 合计
        Row tRow = s.createRow(4);
        setCellVal(tRow, 0, "合计", hs);
        tRow.createCell(1).setCellStyle(hs);
        s.addMergedRegion(new CellRangeAddress(4, 4, 0, 1));
        setCellNum(tRow, 2, order.getTotalAmount(), ms);
        setCellNum(tRow, 3, order.getTotalPurchaseAmount(), ms);
        setCellVal(tRow, 4, "", hs);
        setCellVal(tRow, 5, "", hs);
        setCellNum(tRow, 6, order.getTotalNetProfit(), ms);
        setCellVal(tRow, 7, "", hs);
    }

    private void buildExpenseSheet(Workbook wb, CellStyle hs, CellStyle ds, CellStyle ms,
                                   CellStyle titleStyle, CellStyle subtitleStyle, List<ExpenseDO> expenses) {
        Sheet s = wb.createSheet("运费支出");
        int[] widths = {5, 12, 12, 15, 10, 11, 10, 10, 32};
        for (int i = 0; i < widths.length; i++) s.setColumnWidth(i, (int)(widths[i] * 256));

        // Row 0: 标题
        Row r0 = s.createRow(0);
        setCellVal(r0, 0, "运费明细表", titleStyle);
        for (int i = 1; i < 9; i++) r0.createCell(i).setCellStyle(titleStyle);
        s.addMergedRegion(new CellRangeAddress(0, 0, 0, 8));

        // Row 1: 子标题
        Row r1 = s.createRow(1);
        setCellVal(r1, 0, "运费吊装费支出", subtitleStyle);
        for (int i = 1; i < 9; i++) r1.createCell(i).setCellStyle(subtitleStyle);
        s.addMergedRegion(new CellRangeAddress(1, 1, 0, 8));

        // Row 2: 表头
        Row hRow = s.createRow(2);
        String[] headers = {"序号", "日期", "车号", "运费", "吊装费", "复印费", "支出", "付款人", "备注"};
        for (int i = 0; i < headers.length; i++) setCellVal(hRow, i, headers[i], hs);

        BigDecimal totalExpense = BigDecimal.ZERO;
        int rowIdx = 3;
        int seq = 1;
        for (ExpenseDO exp : expenses) {
            Row r = s.createRow(rowIdx++);
            Cell seqCell = r.createCell(0); seqCell.setCellValue(seq++); seqCell.setCellStyle(ds);
            String dateStr = exp.getExpenseDate() != null
                    ? exp.getExpenseDate().format(DateTimeFormatter.ofPattern("yyyy.M.d")) : "";
            setCellVal(r, 1, dateStr, ds);
            setCellVal(r, 2, exp.getVehicleNo(), ds);
            setCellNum(r, 3, exp.getFreight(), ms);
            setCellNum(r, 4, exp.getCraneFee(), ms);
            setCellNum(r, 5, exp.getCopyFee(), ms);
            setCellNum(r, 6, exp.getTotalExpense(), ms);
            setCellVal(r, 7, exp.getPayer(), ds);
            setCellVal(r, 8, exp.getRemark(), ds);
            if (exp.getTotalExpense() != null) totalExpense = totalExpense.add(exp.getTotalExpense());
        }

        // 合计行
        Row tRow = s.createRow(rowIdx);
        setCellVal(tRow, 0, "", hs);
        for (int i = 1; i < 6; i++) tRow.createCell(i).setCellStyle(hs);
        setCellNum(tRow, 6, totalExpense, ms);
        tRow.createCell(7).setCellStyle(hs);
        tRow.createCell(8).setCellStyle(hs);
    }

    // ---------- 导出样式辅助方法 ----------

    private CellStyle createExportHeaderStyle(Workbook wb, boolean bold) {
        CellStyle style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        Font font = wb.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) 11);
        font.setBold(bold);
        style.setFont(font);
        return style;
    }

    private CellStyle createExportDataStyle(Workbook wb) {
        CellStyle style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        Font font = wb.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) 11);
        style.setFont(font);
        return style;
    }

    private CellStyle createExportMoneyStyle(Workbook wb) {
        CellStyle style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.RIGHT);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setDataFormat(wb.createDataFormat().getFormat("0.00_ "));
        Font font = wb.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) 11);
        style.setFont(font);
        return style;
    }

    private CellStyle createExportTitleStyle(Workbook wb) {
        CellStyle style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        Font font = wb.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) 18);
        font.setBold(true);
        style.setFont(font);
        return style;
    }

    private CellStyle createExportSubtitleStyle(Workbook wb) {
        CellStyle style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        Font font = wb.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) 12);
        style.setFont(font);
        return style;
    }

    private CellStyle createExportRedHeaderStyle(Workbook wb) {
        CellStyle style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setFillForegroundColor(IndexedColors.RED.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        Font font = wb.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) 11);
        font.setColor(IndexedColors.WHITE.getIndex());
        style.setFont(font);
        return style;
    }

    // ---------- 单元格写入辅助方法 ----------

    private void setCellVal(Row row, int col, String value, CellStyle style) {
        Cell cell = row.createCell(col);
        cell.setCellValue(value != null ? value : "");
        cell.setCellStyle(style);
    }

    private void setCellNum(Row row, int col, BigDecimal value, CellStyle style) {
        Cell cell = row.createCell(col);
        if (value != null) {
            cell.setCellValue(value.doubleValue());
        }
        cell.setCellStyle(style);
    }

    // ========== 结算相关 ==========

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void enterSettlement(Long id) {
        // 1. 校验订单存在
        OrderDO order = validateOrderExists(id);

        // 2. 校验订单状态：必须是进行中
        if (!OrderStatusEnum.CONFIRMED.getStatus().equals(order.getStatus())) {
            throw exception(ORDER_STATUS_NOT_ALLOW_SETTLEMENT);
        }

        // 3. 校验成本已填充
        if (!Boolean.TRUE.equals(order.getCostFilled())) {
            throw exception(ORDER_COST_NOT_FILLED_FOR_SETTLEMENT);
        }

        // 4. 校验应收计划已建立
        List<PaymentPlanDO> receivables = paymentPlanMapper.selectList(
                new LambdaQueryWrapperX<PaymentPlanDO>()
                        .eq(PaymentPlanDO::getOrderId, id)
                        .eq(PaymentPlanDO::getType, 1)
                        .ne(PaymentPlanDO::getStatus, PaymentPlanStatusEnum.CANCELLED.getStatus())
        );
        if (CollUtil.isEmpty(receivables)) {
            throw exception(ORDER_NO_RECEIVABLE_PLAN);
        }

        // 5. 校验应付计划已建立
        List<PaymentPlanDO> payables = paymentPlanMapper.selectList(
                new LambdaQueryWrapperX<PaymentPlanDO>()
                        .eq(PaymentPlanDO::getOrderId, id)
                        .eq(PaymentPlanDO::getType, 0)
                        .ne(PaymentPlanDO::getStatus, PaymentPlanStatusEnum.CANCELLED.getStatus())
        );
        if (CollUtil.isEmpty(payables)) {
            throw exception(ORDER_NO_PAYABLE_PLAN);
        }

        // 6. 校验应收计划总额 = 订单应收金额
        BigDecimal receivableTotal = receivables.stream()
                .map(PaymentPlanDO::getPlanAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        if (order.getPayableAmount() != null && receivableTotal.compareTo(order.getPayableAmount()) != 0) {
            throw exception(ORDER_RECEIVABLE_AMOUNT_MISMATCH);
        }

        // 7. 校验应付计划按供应商汇总 = 各供应商采购总额
        List<OrderItemDO> items = orderItemMapper.selectListByOrderId(id);
        Map<Long, BigDecimal> supplierPurchaseMap = items.stream()
                .filter(item -> item.getSupplierId() != null && item.getPurchaseAmount() != null)
                .collect(Collectors.groupingBy(OrderItemDO::getSupplierId,
                        Collectors.reducing(BigDecimal.ZERO, OrderItemDO::getPurchaseAmount, BigDecimal::add)));

        Map<Long, BigDecimal> supplierPlanMap = payables.stream()
                .filter(p -> p.getSupplierId() != null)
                .collect(Collectors.groupingBy(PaymentPlanDO::getSupplierId,
                        Collectors.reducing(BigDecimal.ZERO, PaymentPlanDO::getPlanAmount, BigDecimal::add)));

        for (Map.Entry<Long, BigDecimal> entry : supplierPurchaseMap.entrySet()) {
            BigDecimal planTotal = supplierPlanMap.getOrDefault(entry.getKey(), BigDecimal.ZERO);
            if (planTotal.compareTo(entry.getValue()) != 0) {
                throw exception(ORDER_PAYABLE_AMOUNT_MISMATCH);
            }
        }

        // 8. 更新订单状态为结算中
        OrderDO updateObj = new OrderDO();
        updateObj.setId(id);
        updateObj.setStatus(OrderStatusEnum.SETTLING.getStatus());
        orderMapper.updateById(updateObj);

        operationLogService.log("order", id, order.getOrderNo(),
                "enter_settlement", null, null, "进入结算");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void completeOrder(Long id) {
        OrderDO order = validateOrderExists(id);
        if (!OrderStatusEnum.CONFIRMED.getStatus().equals(order.getStatus())) {
            throw exception(ORDER_STATUS_INVALID_TRANSITION);
        }
        OrderDO updateObj = new OrderDO();
        updateObj.setId(id);
        updateObj.setStatus(OrderStatusEnum.COMPLETED.getStatus());
        orderMapper.updateById(updateObj);
        operationLogService.log("order", id, order.getOrderNo(),
                "complete", null, null, "手动标记订单完成");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void checkAndAutoComplete(Long orderId) {
        OrderDO order = orderMapper.selectById(orderId);
        if (order == null) {
            return;
        }
        // 已完成、已取消状态不参与自动流转
        Integer status = order.getStatus();
        if (OrderStatusEnum.COMPLETED.getStatus().equals(status)
                || OrderStatusEnum.CANCELLED.getStatus().equals(status)) {
            return;
        }
        List<PaymentPlanDO> allPlans = paymentPlanMapper.selectList(
                new LambdaQueryWrapperX<PaymentPlanDO>()
                        .eq(PaymentPlanDO::getOrderId, orderId)
                        .ne(PaymentPlanDO::getStatus, PaymentPlanStatusEnum.CANCELLED.getStatus())
        );
        if (CollUtil.isEmpty(allPlans)) {
            return;
        }
        // 必须同时存在应收计划（type=1）和应付计划（type=0），且各自全部已结清，才触发自动完成
        List<PaymentPlanDO> receivablePlans = allPlans.stream()
                .filter(p -> Integer.valueOf(1).equals(p.getType()))
                .collect(Collectors.toList());
        List<PaymentPlanDO> payablePlans = allPlans.stream()
                .filter(p -> Integer.valueOf(0).equals(p.getType()))
                .collect(Collectors.toList());
        if (CollUtil.isEmpty(receivablePlans) || CollUtil.isEmpty(payablePlans)) {
            return;
        }
        boolean allPaid = allPlans.stream()
                .allMatch(p -> PaymentPlanStatusEnum.PAID.getStatus().equals(p.getStatus()));
        if (allPaid) {
            OrderDO updateObj = new OrderDO();
            updateObj.setId(orderId);
            updateObj.setStatus(OrderStatusEnum.COMPLETED.getStatus());
            orderMapper.updateById(updateObj);
            operationLogService.log("order", orderId, order.getOrderNo(),
                    "auto_complete", null, null, "应收应付全部结清，订单自动完成");
        }
    }

    @Override
    public boolean hasAssociatedData(Long id) {
        // 有采购单 OR 付款计划 OR 费用 即视为有关联数据
        boolean hasPurchase = !purchaseOrderMapper.selectListByOrderId(id).isEmpty();
        if (hasPurchase) return true;
        boolean hasPlan = !paymentPlanMapper.selectListByOrderId(id).isEmpty();
        if (hasPlan) return true;
        return !expenseMapper.selectListByOrderId(id).isEmpty();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void clearAssociatedData(Long id) {
        OrderDO order = validateOrderExists(id);

        // 若已有实际付款记录，拒绝清空（钱已经动了，不能随意清除）
        List<cn.iocoder.stmc.module.erp.dal.dataobject.payment.PaymentDO> payments =
                paymentMapper.selectListByOrderId(id);
        if (!CollUtil.isEmpty(payments)) {
            throw exception(ORDER_STATUS_NOT_ALLOW_UPDATE); // 复用异常：已有付款记录不可清空
        }

        // 1. 删除付款计划（通知机制已停用，无需再删通知）
        paymentPlanMapper.deleteByOrderId(id);

        // 3. 删除采购单明细 & 采购单
        List<Long> purchaseOrderIds = purchaseOrderMapper.selectListByOrderId(id).stream()
                .map(cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderDO::getId)
                .collect(Collectors.toList());
        if (!purchaseOrderIds.isEmpty()) {
            purchaseOrderItemMapper.deleteByPurchaseOrderIds(purchaseOrderIds);
        }
        purchaseOrderMapper.deleteByOrderId(id);

        // 4. 删除费用明细
        expenseMapper.deleteByOrderId(id);

        // 5. 重置订单明细的成本字段
        List<OrderItemDO> items = orderItemMapper.selectListByOrderId(id);
        for (OrderItemDO item : items) {
            OrderItemDO reset = new OrderItemDO();
            reset.setId(item.getId());
            reset.setPurchaseUnit(null);
            reset.setPurchaseQuantity(null);
            reset.setPurchasePrice(null);
            reset.setPurchaseAmount(null);
            reset.setPurchaseRemark(null);
            reset.setSupplierId(null);
            reset.setGrossProfit(null);
            reset.setTaxAmount(null);
            reset.setNetProfit(null);
            orderItemMapper.updateById(reset);
        }

        // 6. 重置订单成本汇总字段
        OrderDO resetOrder = new OrderDO();
        resetOrder.setId(id);
        resetOrder.setCostFilled(false);
        resetOrder.setTotalPurchaseAmount(null);
        resetOrder.setTotalGrossProfit(null);
        resetOrder.setTotalTaxAmount(null);
        resetOrder.setTotalNetProfit(null);
        orderMapper.updateById(resetOrder);

        operationLogService.log("order", id, order.getOrderNo(),
                "clear_associated", null, null, "清空关联数据（采购单、付款计划、费用），准备重新编辑");
    }

    // ========== 副订单相关 ==========

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createSubOrder(cn.iocoder.stmc.module.erp.controller.admin.order.vo.SubOrderSaveReqVO reqVO) {
        // 1. 校验主订单存在且未录入副订单
        OrderDO mainOrder = orderMapper.selectById(reqVO.getParentOrderId());
        if (mainOrder == null) {
            throw exception(ORDER_NOT_EXISTS);
        }
        if (mainOrder.getSubOrderStatus() != null && mainOrder.getSubOrderStatus() == 1) {
            throw exception(new cn.iocoder.stmc.framework.common.exception.ErrorCode(1_030_010_100, "该订单已录入副订单"));
        }
        // 退货单不能创建副订单
        if (mainOrder.getIsReturn() != null && mainOrder.getIsReturn() == 1) {
            throw exception(new cn.iocoder.stmc.framework.common.exception.ErrorCode(1_030_010_101, "退货单不支持创建副订单"));
        }

        // 2. 生成副订单号
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String randomStr = String.format("%04d", IdUtil.getSnowflakeNextId() % 10000);
        String orderNo = "SUB" + dateStr + randomStr;

        // 3. 创建副订单
        OrderDO subOrder = new OrderDO();
        subOrder.setOrderNo(orderNo);
        subOrder.setOrderType(mainOrder.getOrderType());
        subOrder.setParentOrderId(reqVO.getParentOrderId());
        subOrder.setCustomerId(mainOrder.getCustomerId());
        subOrder.setProjectId(mainOrder.getProjectId());
        subOrder.setInvoiceCompany(1); // 固定熙汇达鑫
        subOrder.setOrderDate(mainOrder.getOrderDate());
        subOrder.setDeliveryDate(mainOrder.getDeliveryDate());
        subOrder.setContact(reqVO.getContact() != null ? reqVO.getContact() : mainOrder.getContact());
        subOrder.setMobile(reqVO.getMobile() != null ? reqVO.getMobile() : mainOrder.getMobile());
        subOrder.setAddress(reqVO.getAddress() != null ? reqVO.getAddress() : mainOrder.getAddress());
        subOrder.setReceivingUnit(reqVO.getReceivingUnit());
        subOrder.setVehicleNo(reqVO.getVehicleNo());
        subOrder.setRemark(reqVO.getRemark());
        subOrder.setStatus(mainOrder.getStatus());
        subOrder.setIsReturn(0);
        subOrder.setOrderCategory(1); // 标记为副订单
        subOrder.setSubOrderStatus(0);

        // 设置录入人为当前用户
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        subOrder.setSalesmanId(userId);

        // 计算汇总
        BigDecimal totalQuantity = BigDecimal.ZERO;
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (cn.iocoder.stmc.module.erp.controller.admin.order.vo.SubOrderSaveReqVO.SubOrderItemVO item : reqVO.getItems()) {
            totalQuantity = totalQuantity.add(item.getSaleQuantity() != null ? item.getSaleQuantity() : BigDecimal.ZERO);
            totalAmount = totalAmount.add(item.getSaleAmount() != null ? item.getSaleAmount() : BigDecimal.ZERO);
        }
        subOrder.setTotalQuantity(totalQuantity);
        subOrder.setTotalAmount(totalAmount);
        subOrder.setPayableAmount(totalAmount);

        orderMapper.insert(subOrder);

        // 4. 创建副订单商品行
        List<OrderItemDO> subItems = new ArrayList<>();
        for (cn.iocoder.stmc.module.erp.controller.admin.order.vo.SubOrderSaveReqVO.SubOrderItemVO itemVO : reqVO.getItems()) {
            OrderItemDO item = new OrderItemDO();
            item.setOrderId(subOrder.getId());
            item.setParentItemId(itemVO.getParentItemId());
            item.setItemType(itemVO.getItemType() != null ? itemVO.getItemType() : 0);
            item.setProductName(itemVO.getProductName());
            item.setSpec(itemVO.getSpec());
            item.setSaleUnit(itemVO.getSaleUnit());
            item.setSaleQuantity(itemVO.getSaleQuantity());
            item.setSalePrice(itemVO.getSalePrice());
            item.setSaleAmount(itemVO.getSaleAmount());
            item.setSaleRemark(itemVO.getSaleRemark());
            // 产品属性字段
            item.setMaterial(itemVO.getMaterial());
            item.setBrand(itemVO.getBrand());
            item.setManufacturer(itemVO.getManufacturer());
            // 发货/送货信息字段
            item.setWeight(itemVO.getWeight());
            item.setLength(itemVO.getLength());
            item.setTotalMeters(itemVO.getTotalMeters());
            item.setVehicleNo(itemVO.getVehicleNo());
            subItems.add(item);
        }
        orderItemMapper.insertBatch(subItems);

        // 5. 更新主订单 sub_order_status = 1
        OrderDO updateMain = new OrderDO();
        updateMain.setId(reqVO.getParentOrderId());
        updateMain.setSubOrderStatus(1);
        orderMapper.updateById(updateMain);

        return subOrder.getId();
    }

    @Override
    public Long createReturnOrder(Long orderId, List<cn.iocoder.stmc.module.erp.controller.admin.order.vo.ReturnOrderReqVO.ReturnItemVO> items) {
        // 1. 校验原订单存在
        OrderDO originalOrder = validateOrderExists(orderId);

        // 2. 获取原订单明细
        List<OrderItemDO> originalItems = orderItemMapper.selectList(OrderItemDO::getOrderId, orderId);
        Map<Long, OrderItemDO> originalItemMap = originalItems.stream()
                .collect(java.util.stream.Collectors.toMap(OrderItemDO::getId, item -> item));

        // 3. 创建退货单（负数订单）
        OrderDO returnOrder = new OrderDO();
        returnOrder.setOrderNo("RT-" + IdUtil.getSnowflakeNextIdStr());
        returnOrder.setCustomerId(originalOrder.getCustomerId());
        returnOrder.setProjectId(originalOrder.getProjectId());
        returnOrder.setInvoiceCompany(originalOrder.getInvoiceCompany());
        returnOrder.setOrderType(originalOrder.getOrderType());
        returnOrder.setOrderDate(java.time.LocalDateTime.now());
        returnOrder.setStatus(OrderStatusEnum.COMPLETED.getStatus());
        returnOrder.setParentOrderId(orderId);
        returnOrder.setIsReturn(1);
        returnOrder.setContact(originalOrder.getContact());
        returnOrder.setMobile(originalOrder.getMobile());
        returnOrder.setAddress(originalOrder.getAddress());

        // 4. 计算退货明细和总金额
        java.math.BigDecimal totalQuantity = java.math.BigDecimal.ZERO;
        java.math.BigDecimal totalAmount = java.math.BigDecimal.ZERO;
        java.util.List<OrderItemDO> returnItems = new java.util.ArrayList<>();

        for (cn.iocoder.stmc.module.erp.controller.admin.order.vo.ReturnOrderReqVO.ReturnItemVO reqItem : items) {
            OrderItemDO originalItem = originalItemMap.get(reqItem.getOrderItemId());
            if (originalItem == null) {
                continue;
            }
            OrderItemDO returnItem = new OrderItemDO();
            returnItem.setProductName(originalItem.getProductName());
            returnItem.setSpec(originalItem.getSpec());
            returnItem.setSaleUnit(originalItem.getSaleUnit());
            returnItem.setItemType(originalItem.getItemType());
            // 退货数量和金额取负值
            returnItem.setSaleQuantity(reqItem.getReturnQuantity().negate());
            if (originalItem.getSalePrice() != null) {
                returnItem.setSalePrice(originalItem.getSalePrice());
                returnItem.setSaleAmount(originalItem.getSalePrice().multiply(reqItem.getReturnQuantity()).negate());
            } else {
                returnItem.setSaleAmount(java.math.BigDecimal.ZERO);
            }
            totalQuantity = totalQuantity.subtract(reqItem.getReturnQuantity());
            totalAmount = totalAmount.add(returnItem.getSaleAmount());
            returnItems.add(returnItem);
        }

        returnOrder.setTotalQuantity(totalQuantity);
        returnOrder.setTotalAmount(totalAmount);
        returnOrder.setPayableAmount(totalAmount);

        // 5. 保存退货单
        orderMapper.insert(returnOrder);

        // 6. 保存退货明细
        for (OrderItemDO returnItem : returnItems) {
            returnItem.setOrderId(returnOrder.getId());
            orderItemMapper.insert(returnItem);
        }

        // 记录操作日志
        operationLogService.log("order", returnOrder.getId(), returnOrder.getOrderNo(),
                "create_return", null, null, "创建退货单，关联原订单：" + originalOrder.getOrderNo());

        return returnOrder.getId();
    }

    // ========== 打印模板选择（基于订单开票公司） ==========

    /**
     * 根据订单的开票公司获取公司全称
     * invoiceCompany: 1=四川熙汇达鑫商贸有限公司  2=四川鸿恒盛供应链管理有限公司
     */
    private String getCompanyNameByInvoice(Integer invoiceCompany) {
        if (invoiceCompany != null) {
            switch (invoiceCompany) {
                case 1:
                    return "四川熙汇达鑫商贸有限公司";
                case 2:
                    return "四川鸿恒盛供应链管理有限公司";
            }
        }
        return "四川鸿恒盛供应链管理有限公司";
    }

    /**
     * 根据订单的开票公司获取文件名前缀
     */
    private String getFilePrefixByInvoice(Integer invoiceCompany) {
        if (invoiceCompany != null) {
            switch (invoiceCompany) {
                case 1:
                    return "熙汇达鑫";
                case 2:
                    return "鸿恒盛";
            }
        }
        return "鸿恒盛";
    }

}
