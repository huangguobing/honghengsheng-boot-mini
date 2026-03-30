package cn.iocoder.stmc.module.erp.controller.admin.home;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.stmc.framework.common.biz.system.permission.PermissionCommonApi;
import cn.iocoder.stmc.framework.common.pojo.CommonResult;
import cn.iocoder.stmc.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.stmc.module.erp.controller.admin.home.vo.HomeStatisticsRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.home.vo.OrderStatisticsVO;
import cn.iocoder.stmc.module.erp.dal.mysql.customer.CustomerMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.order.OrderMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.paymentplan.PaymentPlanMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.purchase.PurchaseOrderMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.supplier.SupplierMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.voucher.VoucherMapper;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.voucher.VoucherDO;
import cn.iocoder.stmc.module.erp.enums.OrderStatusEnum;
import cn.iocoder.stmc.module.erp.enums.PaymentPlanStatusEnum;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.TemporalAdjusters;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static cn.iocoder.stmc.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - ERP 首页")
@RestController
@RequestMapping("/erp/home")
@Validated
public class HomeController {

    /** 可以查看成本信息的角色编码：超级管理员、鸿恒盛 */
    private static final String[] COST_VIEW_ROLES = {"super_admin", "honghengsheng"};
    /** B角色编码 */
    private static final String[] ROLE_B = {"xihuidaxin"};

    @Resource
    private CustomerMapper customerMapper;

    @Resource
    private SupplierMapper supplierMapper;

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private PaymentPlanMapper paymentPlanMapper;

    @Resource
    private PurchaseOrderMapper purchaseOrderMapper;

    @Resource
    private VoucherMapper voucherMapper;

    @Resource
    private PermissionCommonApi permissionApi;

    @GetMapping("/statistics")
    @Operation(summary = "获取首页统计数据")
    @PreAuthorize("isAuthenticated()") // 所有登录用户都可以访问首页统计
    public CommonResult<HomeStatisticsRespVO> getStatistics() {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        boolean isAdmin = canViewCostInfo(); // 复用已有方法判断是否管理员

        HomeStatisticsRespVO respVO = new HomeStatisticsRespVO();
        respVO.setIsAdmin(isAdmin);

        // ========== 基础统计 ==========
        // 客户数：管理员看全部，业务员只看自己创建的
        if (isAdmin) {
            respVO.setCustomerCount(customerMapper.selectCount());
        } else {
            respVO.setCustomerCount(customerMapper.selectCountByCreator(String.valueOf(userId)));
        }

        // 供应商数只有管理员可见；付款计划提醒入口本期隐藏
        if (isAdmin) {
            respVO.setSupplierCount(supplierMapper.selectCount());
            respVO.setPendingPaymentPlanCount(null);
        } else {
            respVO.setSupplierCount(null);
            respVO.setPendingPaymentPlanCount(null);
        }


        // 根据角色确定订单类别
        boolean isRoleB = permissionApi.hasAnyRoles(userId, ROLE_B);
        Integer orderCategory = isRoleB ? 1 : 0;

        // 订单数：管理员看全部，业务员只看自己的
        Long salesmanId = isAdmin ? null : userId;
        respVO.setOrderCount(orderMapper.selectCountBySalesman(salesmanId, orderCategory));

        // ========== 待处理事项统计（仅管理员可见） ==========
        if (isAdmin) {
            respVO.setPendingReviewOrderCount(orderMapper.selectCountByStatus(OrderStatusEnum.DRAFT.getStatus()));
            respVO.setPendingCostOrderCount(orderMapper.selectCountByStatus(OrderStatusEnum.CONFIRMED.getStatus()));
        } else {
            respVO.setPendingReviewOrderCount(0L);
            respVO.setPendingCostOrderCount(0L);
        }

        // ========== 今日统计 ==========
        LocalDate today = LocalDate.now();
        LocalDateTime todayStart = today.atStartOfDay();
        LocalDateTime todayEnd = today.plusDays(1).atStartOfDay();
        OrderStatisticsVO todayStats = orderMapper.selectStatisticsByDateRangeAndSalesman(todayStart, todayEnd, salesmanId, orderCategory);
        fillStatistics(respVO, todayStats, "today");

        // ========== 本周统计 ==========
        LocalDate weekStart = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDateTime weekStartTime = weekStart.atStartOfDay();
        LocalDateTime weekEndTime = weekStart.plusWeeks(1).atStartOfDay();
        OrderStatisticsVO weekStats = orderMapper.selectStatisticsByDateRangeAndSalesman(weekStartTime, weekEndTime, salesmanId, orderCategory);
        fillStatistics(respVO, weekStats, "week");

        // ========== 本月统计 ==========
        LocalDate monthStart = today.withDayOfMonth(1);
        LocalDateTime monthStartTime = monthStart.atStartOfDay();
        LocalDateTime monthEndTime = monthStart.plusMonths(1).atStartOfDay();
        OrderStatisticsVO monthStats = orderMapper.selectStatisticsByDateRangeAndSalesman(monthStartTime, monthEndTime, salesmanId, orderCategory);
        fillStatistics(respVO, monthStats, "month");

        // ========== 本季度统计 ==========
        int currentQuarter = (today.getMonthValue() - 1) / 3;
        LocalDate quarterStart = today.withMonth(currentQuarter * 3 + 1).withDayOfMonth(1);
        LocalDateTime quarterStartTime = quarterStart.atStartOfDay();
        LocalDateTime quarterEndTime = quarterStart.plusMonths(3).atStartOfDay();
        OrderStatisticsVO quarterStats = orderMapper.selectStatisticsByDateRangeAndSalesman(quarterStartTime, quarterEndTime, salesmanId, orderCategory);
        fillStatistics(respVO, quarterStats, "quarter");

        // ========== 本年统计 ==========
        LocalDate yearStart = today.withDayOfYear(1);
        LocalDateTime yearStartTime = yearStart.atStartOfDay();
        LocalDateTime yearEndTime = yearStart.plusYears(1).atStartOfDay();
        OrderStatisticsVO yearStats = orderMapper.selectStatisticsByDateRangeAndSalesman(yearStartTime, yearEndTime, salesmanId, orderCategory);
        fillStatistics(respVO, yearStats, "year");

        // ========== 鸿恒盛适配指标（仅管理员） ==========
        if (isAdmin) {
            // 本期隐藏付款计划提醒相关金额入口
            respVO.setPendingReceivableAmount(null);
            respVO.setPendingPayableAmount(null);


            // 本月采购单数
            List<OrderDO> monthMainOrders = orderMapper.selectList(new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<OrderDO>()
                    .isNull(OrderDO::getParentOrderId)
                    .ge(OrderDO::getCreateTime, monthStartTime)
                    .lt(OrderDO::getCreateTime, monthEndTime));
            Set<Long> monthMainOrderIds = monthMainOrders.stream().map(OrderDO::getId).collect(Collectors.toSet());
            if (CollUtil.isEmpty(monthMainOrderIds)) {
                respVO.setMonthPurchaseOrderCount(0L);
            } else {
                com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<PurchaseOrderDO> monthPurchaseQuery =
                        new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<PurchaseOrderDO>()
                                .in(PurchaseOrderDO::getOrderId, monthMainOrderIds)
                                .ge(PurchaseOrderDO::getCreateTime, monthStartTime)
                                .lt(PurchaseOrderDO::getCreateTime, monthEndTime);
                respVO.setMonthPurchaseOrderCount(purchaseOrderMapper.selectCount(monthPurchaseQuery));
            }

            // 未核销发票数
            com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<VoucherDO> unrecQuery =
                    new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<VoucherDO>()
                            .eq(VoucherDO::getReconcileStatus, 0);
            respVO.setUnreconcileInvoiceCount(voucherMapper.selectCount(unrecQuery));
        }

        // ========== 成本信息权限控制 ==========
        // 非管理员隐藏成本、毛利、净利润信息
        if (!isAdmin) {
            clearCostInfo(respVO);
        }

        return success(respVO);
    }

    /**
     * 判断当前用户是否可以查看成本信息
     */
    private boolean canViewCostInfo() {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        if (userId == null) {
            return false;
        }
        return permissionApi.hasAnyRoles(userId, COST_VIEW_ROLES);
    }

    /**
     * 清空成本相关信息
     */
    private void clearCostInfo(HomeStatisticsRespVO respVO) {
        // 今日
        respVO.setTodayCostAmount(null);
        respVO.setTodayGrossProfit(null);
        respVO.setTodayNetProfit(null);
        // 本周
        respVO.setWeekCostAmount(null);
        respVO.setWeekGrossProfit(null);
        respVO.setWeekNetProfit(null);
        // 本月
        respVO.setMonthCostAmount(null);
        respVO.setMonthGrossProfit(null);
        respVO.setMonthNetProfit(null);
        // 本季度
        respVO.setQuarterCostAmount(null);
        respVO.setQuarterGrossProfit(null);
        respVO.setQuarterNetProfit(null);
        // 本年
        respVO.setYearCostAmount(null);
        respVO.setYearGrossProfit(null);
        respVO.setYearNetProfit(null);
    }

    /**
     * 填充统计数据到响应VO
     */
    private void fillStatistics(HomeStatisticsRespVO respVO, OrderStatisticsVO stats, String period) {
        // 安全获取值，处理 null 情况
        Long orderCount = (stats != null && stats.getOrderCount() != null) ? stats.getOrderCount() : 0L;
        BigDecimal salesAmount = (stats != null && stats.getSalesAmount() != null) ? stats.getSalesAmount() : BigDecimal.ZERO;
        BigDecimal costAmount = (stats != null && stats.getCostAmount() != null) ? stats.getCostAmount() : BigDecimal.ZERO;
        BigDecimal grossProfit = (stats != null && stats.getGrossProfit() != null) ? stats.getGrossProfit() : BigDecimal.ZERO;
        BigDecimal netProfit = (stats != null && stats.getNetProfit() != null) ? stats.getNetProfit() : BigDecimal.ZERO;

        switch (period) {
            case "today":
                respVO.setTodayOrderCount(orderCount);
                respVO.setTodaySalesAmount(salesAmount);
                respVO.setTodayCostAmount(costAmount);
                respVO.setTodayGrossProfit(grossProfit);
                respVO.setTodayNetProfit(netProfit);
                break;
            case "week":
                respVO.setWeekOrderCount(orderCount);
                respVO.setWeekSalesAmount(salesAmount);
                respVO.setWeekCostAmount(costAmount);
                respVO.setWeekGrossProfit(grossProfit);
                respVO.setWeekNetProfit(netProfit);
                break;
            case "month":
                respVO.setMonthOrderCount(orderCount);
                respVO.setMonthSalesAmount(salesAmount);
                respVO.setMonthCostAmount(costAmount);
                respVO.setMonthGrossProfit(grossProfit);
                respVO.setMonthNetProfit(netProfit);
                break;
            case "quarter":
                respVO.setQuarterOrderCount(orderCount);
                respVO.setQuarterSalesAmount(salesAmount);
                respVO.setQuarterCostAmount(costAmount);
                respVO.setQuarterGrossProfit(grossProfit);
                respVO.setQuarterNetProfit(netProfit);
                break;
            case "year":
                respVO.setYearOrderCount(orderCount);
                respVO.setYearSalesAmount(salesAmount);
                respVO.setYearCostAmount(costAmount);
                respVO.setYearGrossProfit(grossProfit);
                respVO.setYearNetProfit(netProfit);
                break;
        }
    }

}
