package cn.iocoder.stmc.module.erp.controller.admin.statistics;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.stmc.framework.common.pojo.CommonResult;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.CustomerStatisticsRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.InvoiceSummaryGroupRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.InvoiceSummaryItemRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.InvoiceSummaryRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.OrderItemStatisticsRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.ProductSalesRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.ProjectProfitRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.ReceivablePayableRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.SalesmanStatisticsRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.SupplierStatisticsRespVO;
import cn.iocoder.stmc.framework.common.biz.system.permission.PermissionCommonApi;
import cn.iocoder.stmc.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderItemDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.voucher.VoucherDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.paymentplan.PaymentPlanDO;
import cn.iocoder.stmc.module.erp.dal.mysql.order.OrderItemMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.order.OrderMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.paymentplan.PaymentPlanMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.purchase.PurchaseOrderMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.voucher.VoucherMapper;
import cn.iocoder.stmc.module.erp.enums.PaymentPlanStatusEnum;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static cn.iocoder.stmc.framework.common.pojo.CommonResult.success;
import static cn.iocoder.stmc.framework.common.util.date.DateUtils.FORMAT_YEAR_MONTH_DAY;

/**
 * ERP 统计报表 Controller
 *
 * @author stmc
 */
@Tag(name = "管理后台 - ERP 统计报表")
@RestController
@RequestMapping("/erp/statistics")
@Validated
public class StatisticsController {

    private static final String[] ROLE_B = {"xihuidaxin"};

    @Resource
    private OrderItemMapper orderItemMapper;

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private PermissionCommonApi permissionApi;

    @Resource
    private PurchaseOrderMapper purchaseOrderMapper;

    @Resource
    private PaymentPlanMapper paymentPlanMapper;

    @Resource
    private VoucherMapper voucherMapper;

    @GetMapping("/supplier-purchase")
    @Operation(summary = "获取供应商采购统计")
    @PreAuthorize("@ss.hasPermission('erp:statistics:query')")
    public CommonResult<List<SupplierStatisticsRespVO>> getSupplierPurchaseStatistics(
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate endDate,
            @RequestParam(required = false) String supplierName) {
        // 转换日期为时间范围
        LocalDateTime startTime = startDate != null ? startDate.atStartOfDay() : null;
        LocalDateTime endTime = endDate != null ? endDate.plusDays(1).atStartOfDay() : null;
        Integer orderCategory = getOrderCategory();
        // 查询统计数据
        List<SupplierStatisticsRespVO> list = orderItemMapper.selectSupplierPurchaseStatistics(startTime, endTime, supplierName, orderCategory);
        return success(list);
    }

    @GetMapping("/supplier-purchase-detail")
    @Operation(summary = "获取供应商采购明细")
    @PreAuthorize("@ss.hasPermission('erp:statistics:query')")
    public CommonResult<PageResult<OrderItemStatisticsRespVO>> getSupplierPurchaseDetail(
            @RequestParam @Parameter(description = "供应商ID") Long supplierId,
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate endDate,
            @RequestParam(defaultValue = "1") Integer pageNo,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        // 转换日期为时间范围
        LocalDateTime startTime = startDate != null ? startDate.atStartOfDay() : null;
        LocalDateTime endTime = endDate != null ? endDate.plusDays(1).atStartOfDay() : null;

        // 构建查询条件
        Integer orderCategory = getOrderCategory();
        // 先按角色筛订单，再查这些订单下的采购明细
        LambdaQueryWrapper<OrderDO> orderQuery = new LambdaQueryWrapper<OrderDO>()
                .eq(OrderDO::getDeleted, false)
                .eq(OrderDO::getOrderCategory, orderCategory);
        if (orderCategory == 0) {
            orderQuery.isNull(OrderDO::getParentOrderId);
        } else {
            orderQuery.isNotNull(OrderDO::getParentOrderId);
        }
        List<OrderDO> scopedOrders = orderMapper.selectList(orderQuery);
        Set<Long> mainOrderIds = scopedOrders.stream().map(OrderDO::getId).collect(Collectors.toSet());
        if (CollUtil.isEmpty(mainOrderIds)) {
            return success(new PageResult<>(new ArrayList<>(), 0L));
        }

        LambdaQueryWrapper<OrderItemDO> queryWrapper = new LambdaQueryWrapper<OrderItemDO>()
                .in(OrderItemDO::getOrderId, mainOrderIds)
                .eq(OrderItemDO::getSupplierId, supplierId)
                .ge(startTime != null, OrderItemDO::getCreateTime, startTime)
                .lt(endTime != null, OrderItemDO::getCreateTime, endTime)
                .orderByDesc(OrderItemDO::getCreateTime);

        // 分页查询
        Page<OrderItemDO> page = new Page<>(pageNo, pageSize);
        Page<OrderItemDO> pageResult = orderItemMapper.selectPage(page, queryWrapper);

        // 转换为VO并填充订单号
        List<OrderItemStatisticsRespVO> voList = BeanUtils.toBean(pageResult.getRecords(), OrderItemStatisticsRespVO.class);
        fillOrderNo(voList, pageResult.getRecords());

        return success(new PageResult<>(voList, pageResult.getTotal()));
    }

    @GetMapping("/salesman-sales")
    @Operation(summary = "获取员工销售统计")
    @PreAuthorize("@ss.hasPermission('erp:statistics:query')")
    public CommonResult<List<SalesmanStatisticsRespVO>> getSalesmanSalesStatistics(
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate endDate,
            @RequestParam(required = false) String salesmanName,
            @RequestParam(required = false) String mobile) {
        // 转换日期为时间范围
        LocalDateTime startTime = startDate != null ? startDate.atStartOfDay() : null;
        LocalDateTime endTime = endDate != null ? endDate.plusDays(1).atStartOfDay() : null;
        // 根据角色确定订单类别
        Integer orderCategory = getOrderCategory();
        List<SalesmanStatisticsRespVO> list = orderMapper.selectSalesmanStatistics(startTime, endTime, salesmanName, mobile, orderCategory);
        return success(list);
    }

    @GetMapping("/customer-sales")
    @Operation(summary = "获取客户销售统计")
    @PreAuthorize("@ss.hasPermission('erp:statistics:query')")
    public CommonResult<List<CustomerStatisticsRespVO>> getCustomerSalesStatistics(
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate endDate,
            @RequestParam(required = false) String customerName,
            @RequestParam(required = false) String mobile) {
        // 转换日期为时间范围
        LocalDateTime startTime = startDate != null ? startDate.atStartOfDay() : null;
        LocalDateTime endTime = endDate != null ? endDate.plusDays(1).atStartOfDay() : null;
        Integer orderCategory = getOrderCategory();
        List<CustomerStatisticsRespVO> list = orderMapper.selectCustomerStatistics(startTime, endTime, customerName, mobile, orderCategory);
        return success(list);
    }

    @GetMapping("/project-profit")
    @Operation(summary = "获取项目利润统计")
    @PreAuthorize("@ss.hasPermission('erp:statistics:query')")
    public CommonResult<List<ProjectProfitRespVO>> getProjectProfitStatistics(
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate endDate,
            @RequestParam(required = false) String projectName) {
        LocalDateTime startTime = startDate != null ? startDate.atStartOfDay() : null;
        LocalDateTime endTime = endDate != null ? endDate.plusDays(1).atStartOfDay() : null;
        Integer orderCategory = getOrderCategory();
        List<ProjectProfitRespVO> list = orderMapper.selectProjectProfitStatistics(startTime, endTime, projectName, orderCategory);
        return success(list);
    }

    @GetMapping("/product-sales")
    @Operation(summary = "获取产品销售统计")
    @PreAuthorize("@ss.hasPermission('erp:statistics:query')")
    public CommonResult<List<ProductSalesRespVO>> getProductSalesStatistics(
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate endDate,
            @RequestParam(required = false) String productName) {
        LocalDateTime startTime = startDate != null ? startDate.atStartOfDay() : null;
        LocalDateTime endTime = endDate != null ? endDate.plusDays(1).atStartOfDay() : null;
        Integer orderCategory = getOrderCategory();
        List<ProductSalesRespVO> list = orderMapper.selectProductSalesStatistics(startTime, endTime, productName, orderCategory);
        return success(list);
    }

    @GetMapping("/receivable-payable")
    @Operation(summary = "获取应收应付汇总")
    @PreAuthorize("@ss.hasPermission('erp:statistics:query')")
    public CommonResult<ReceivablePayableRespVO> getReceivablePayableStatistics(
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate endDate) {
        LocalDateTime startTime = startDate != null ? startDate.atStartOfDay() : null;
        LocalDateTime endTime = endDate != null ? endDate.plusDays(1).atStartOfDay() : null;

        // 查询销售订单（应收总额）
        Integer orderCategory = getOrderCategory();
        LambdaQueryWrapper<OrderDO> salesQuery = new LambdaQueryWrapper<OrderDO>()
                .eq(OrderDO::getOrderType, 1)
                .eq(OrderDO::getOrderCategory, orderCategory)
                .ge(startTime != null, OrderDO::getCreateTime, startTime)
                .lt(endTime != null, OrderDO::getCreateTime, endTime);
        if (orderCategory == 0) {
            salesQuery.isNull(OrderDO::getParentOrderId);
        } else {
            salesQuery.isNotNull(OrderDO::getParentOrderId);
        }
        List<OrderDO> salesOrders = orderMapper.selectList(salesQuery);

        BigDecimal totalReceivable = BigDecimal.ZERO;
        for (OrderDO o : salesOrders) {
            totalReceivable = totalReceivable.add(o.getPayableAmount() != null ? o.getPayableAmount() : BigDecimal.ZERO);
        }

        Set<Long> mainOrderIds = salesOrders.stream().map(OrderDO::getId).collect(Collectors.toSet());

        // 已收金额：从主订单的收款计划（type=1）中统计累计已收金额
        LambdaQueryWrapper<PaymentPlanDO> receivedQuery = new LambdaQueryWrapper<PaymentPlanDO>()
                .in(CollUtil.isNotEmpty(mainOrderIds), PaymentPlanDO::getOrderId, mainOrderIds)
                .eq(PaymentPlanDO::getType, 1)
                .ne(PaymentPlanDO::getStatus, PaymentPlanStatusEnum.CANCELLED.getStatus())
                .ge(startTime != null, PaymentPlanDO::getCreateTime, startTime)
                .lt(endTime != null, PaymentPlanDO::getCreateTime, endTime);
        List<PaymentPlanDO> receivedPlans = paymentPlanMapper.selectList(receivedQuery);
        BigDecimal totalReceived = receivedPlans.stream()
                .map(p -> p.getPaidAmount() != null ? p.getPaidAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // 应付总额：从主订单的付款计划（type=0）中统计
        LambdaQueryWrapper<PaymentPlanDO> payableQuery = new LambdaQueryWrapper<PaymentPlanDO>()
                .in(CollUtil.isNotEmpty(mainOrderIds), PaymentPlanDO::getOrderId, mainOrderIds)
                .eq(PaymentPlanDO::getType, 0)
                .ne(PaymentPlanDO::getStatus, PaymentPlanStatusEnum.CANCELLED.getStatus())
                .ge(startTime != null, PaymentPlanDO::getCreateTime, startTime)
                .lt(endTime != null, PaymentPlanDO::getCreateTime, endTime);
        List<PaymentPlanDO> payablePlans = paymentPlanMapper.selectList(payableQuery);
        BigDecimal totalPayable = payablePlans.stream()
                .map(p -> p.getPlanAmount() != null ? p.getPlanAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // 已付金额：从付款计划（type=0）中统计已付清的金额
        BigDecimal totalPaid = payablePlans.stream()
                .map(p -> p.getPaidAmount() != null ? p.getPaidAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        ReceivablePayableRespVO result = new ReceivablePayableRespVO();
        result.setTotalReceivable(totalReceivable);
        result.setTotalReceived(totalReceived);
        result.setPendingReceivable(totalReceivable.subtract(totalReceived));
        result.setTotalPayable(totalPayable);
        result.setTotalPaid(totalPaid);
        result.setPendingPayable(totalPayable.subtract(totalPaid));
        return success(result);
    }

    @GetMapping("/invoice-summary")
    @Operation(summary = "获取开票统计")
    @PreAuthorize("@ss.hasPermission('erp:statistics:query')")
    public CommonResult<InvoiceSummaryRespVO> getInvoiceSummary(
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY) LocalDate endDate) {
        Integer orderCategory = getOrderCategory();
        LambdaQueryWrapper<OrderDO> orderQuery = new LambdaQueryWrapper<OrderDO>()
                .eq(OrderDO::getDeleted, false)
                .eq(OrderDO::getOrderCategory, orderCategory);
        if (orderCategory == 0) {
            orderQuery.isNull(OrderDO::getParentOrderId);
        } else {
            orderQuery.isNotNull(OrderDO::getParentOrderId);
        }
        List<OrderDO> scopedOrders = orderMapper.selectList(orderQuery);
        Set<Long> mainOrderIds = scopedOrders.stream().map(OrderDO::getId).collect(Collectors.toSet());
        if (CollUtil.isEmpty(mainOrderIds)) {
            return success(new InvoiceSummaryRespVO());
        }

        LambdaQueryWrapper<VoucherDO> queryWrapper = new LambdaQueryWrapper<VoucherDO>()
                .in(VoucherDO::getOrderId, mainOrderIds)
                .ge(startDate != null, VoucherDO::getInvoiceDate, startDate)
                .le(endDate != null, VoucherDO::getInvoiceDate, endDate)
                .orderByDesc(VoucherDO::getInvoiceDate)
                .orderByDesc(VoucherDO::getId);
        List<VoucherDO> vouchers = voucherMapper.selectList(queryWrapper);

        Map<Long, String> orderNoMap = buildOrderNoMap(vouchers);
        List<VoucherDO> incomingVouchers = vouchers.stream()
                .filter(voucher -> Integer.valueOf(0).equals(voucher.getDirection()))
                .collect(Collectors.toList());
        List<VoucherDO> outgoingVouchers = vouchers.stream()
                .filter(voucher -> Integer.valueOf(1).equals(voucher.getDirection()))
                .collect(Collectors.toList());

        InvoiceSummaryRespVO result = new InvoiceSummaryRespVO();
        result.setIncomingCount((long) incomingVouchers.size());
        result.setIncomingAmount(sumVoucherAmount(incomingVouchers));
        result.setOutgoingCount((long) outgoingVouchers.size());
        result.setOutgoingAmount(sumVoucherAmount(outgoingVouchers));
        result.setIncomingGroups(buildInvoiceSummaryGroups(incomingVouchers, orderNoMap));
        result.setOutgoingGroups(buildInvoiceSummaryGroups(outgoingVouchers, orderNoMap));
        return success(result);
    }

    private Map<Long, String> buildOrderNoMap(List<VoucherDO> vouchers) {
        Set<Long> orderIds = vouchers.stream()
                .map(VoucherDO::getOrderId)
                .filter(id -> id != null)
                .collect(Collectors.toSet());
        if (CollUtil.isEmpty(orderIds)) {
            return new LinkedHashMap<>();
        }
        return orderMapper.selectBatchIds(orderIds).stream()
                .collect(Collectors.toMap(OrderDO::getId, OrderDO::getOrderNo));
    }

    private BigDecimal sumVoucherAmount(List<VoucherDO> vouchers) {
        return vouchers.stream()
                .map(this::getVoucherAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private List<InvoiceSummaryGroupRespVO> buildInvoiceSummaryGroups(List<VoucherDO> vouchers,
                                                                      Map<Long, String> orderNoMap) {
        if (CollUtil.isEmpty(vouchers)) {
            return new ArrayList<>();
        }

        Map<String, List<VoucherDO>> groupMap = vouchers.stream()
                .collect(Collectors.groupingBy(voucher -> StrUtil.blankToDefault(voucher.getInvoiceCode(), ""),
                        LinkedHashMap::new, Collectors.toList()));

        return groupMap.entrySet().stream()
                .map(entry -> buildInvoiceSummaryGroup(entry.getKey(), entry.getValue(), orderNoMap))
                .sorted(Comparator.comparing(InvoiceSummaryGroupRespVO::getAmount, Comparator.nullsFirst(BigDecimal::compareTo)).reversed()
                        .thenComparing(group -> StrUtil.nullToDefault(group.getInvoiceCode(), "")))
                .collect(Collectors.toList());
    }

    private InvoiceSummaryGroupRespVO buildInvoiceSummaryGroup(String invoiceCode,
                                                               List<VoucherDO> vouchers,
                                                               Map<Long, String> orderNoMap) {
        InvoiceSummaryGroupRespVO group = new InvoiceSummaryGroupRespVO();
        group.setInvoiceCode(invoiceCode);
        group.setDisplayCode(StrUtil.isBlank(invoiceCode) ? "未填写发票代码" : invoiceCode);
        group.setCount((long) vouchers.size());
        group.setAmount(sumVoucherAmount(vouchers));
        group.setItems(vouchers.stream()
                .map(voucher -> buildInvoiceSummaryItem(voucher, orderNoMap))
                .collect(Collectors.toList()));
        return group;
    }

    private InvoiceSummaryItemRespVO buildInvoiceSummaryItem(VoucherDO voucher, Map<Long, String> orderNoMap) {
        InvoiceSummaryItemRespVO item = new InvoiceSummaryItemRespVO();
        item.setId(voucher.getId());
        item.setOrderId(voucher.getOrderId());
        item.setOrderNo(orderNoMap.get(voucher.getOrderId()));
        item.setCounterparty(voucher.getCounterparty());
        item.setVoucherType(voucher.getVoucherType());
        item.setAmount(getVoucherAmount(voucher));
        item.setInvoiceDate(voucher.getInvoiceDate());
        item.setReconcileStatus(voucher.getReconcileStatus());
        item.setRemark(voucher.getRemark());
        return item;
    }

    private BigDecimal getVoucherAmount(VoucherDO voucher) {

        return voucher.getAmount() != null ? voucher.getAmount() : BigDecimal.ZERO;
    }

    /**
     * 根据当前用户角色确定订单类别：B角色看副订单(1)，其他看主订单(0)
     */
    private Integer getOrderCategory() {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        if (userId != null && permissionApi.hasAnyRoles(userId, ROLE_B)) {
            return 1;
        }
        return 0;
    }

    /**
     * 填充订单号到明细VO
     */
    private void fillOrderNo(List<OrderItemStatisticsRespVO> voList, List<OrderItemDO> items) {
        if (CollUtil.isEmpty(items)) {
            return;
        }
        // 获取所有订单ID
        Set<Long> orderIds = items.stream()
                .map(OrderItemDO::getOrderId)
                .collect(Collectors.toSet());
        // 批量查询订单
        List<OrderDO> orders = orderMapper.selectBatchIds(orderIds);
        Map<Long, String> orderNoMap = orders.stream()
                .collect(Collectors.toMap(OrderDO::getId, OrderDO::getOrderNo));
        // 填充订单号
        for (int i = 0; i < voList.size(); i++) {
            OrderItemDO item = items.get(i);
            voList.get(i).setOrderNo(orderNoMap.get(item.getOrderId()));
        }
    }

}
