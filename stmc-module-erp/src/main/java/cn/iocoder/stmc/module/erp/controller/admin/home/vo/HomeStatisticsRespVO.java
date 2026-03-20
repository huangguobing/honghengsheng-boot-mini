package cn.iocoder.stmc.module.erp.controller.admin.home.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Schema(description = "管理后台 - 首页统计 Response VO")
@Data
public class HomeStatisticsRespVO {

    // ========== 基础统计 ==========

    @Schema(description = "客户总数", requiredMode = Schema.RequiredMode.REQUIRED, example = "100")
    private Long customerCount;

    @Schema(description = "供应商总数", requiredMode = Schema.RequiredMode.REQUIRED, example = "50")
    private Long supplierCount;

    @Schema(description = "订单总数", requiredMode = Schema.RequiredMode.REQUIRED, example = "200")
    private Long orderCount;

    @Schema(description = "待付款计划数", requiredMode = Schema.RequiredMode.REQUIRED, example = "10")
    private Long pendingPaymentPlanCount;

    // ========== 今日统计 ==========

    @Schema(description = "今日订单数", example = "5")
    private Long todayOrderCount;

    @Schema(description = "今日销售额", example = "10000.00")
    private BigDecimal todaySalesAmount;

    @Schema(description = "今日成本", example = "8000.00")
    private BigDecimal todayCostAmount;

    @Schema(description = "今日毛利", example = "2000.00")
    private BigDecimal todayGrossProfit;

    @Schema(description = "今日净利", example = "1800.00")
    private BigDecimal todayNetProfit;

    // ========== 本周统计 ==========

    @Schema(description = "本周订单数", example = "20")
    private Long weekOrderCount;

    @Schema(description = "本周销售额", example = "50000.00")
    private BigDecimal weekSalesAmount;

    @Schema(description = "本周成本", example = "40000.00")
    private BigDecimal weekCostAmount;

    @Schema(description = "本周毛利", example = "10000.00")
    private BigDecimal weekGrossProfit;

    @Schema(description = "本周净利", example = "9000.00")
    private BigDecimal weekNetProfit;

    // ========== 本月统计 ==========

    @Schema(description = "本月订单数", example = "80")
    private Long monthOrderCount;

    @Schema(description = "本月销售额", example = "200000.00")
    private BigDecimal monthSalesAmount;

    @Schema(description = "本月成本", example = "160000.00")
    private BigDecimal monthCostAmount;

    @Schema(description = "本月毛利", example = "40000.00")
    private BigDecimal monthGrossProfit;

    @Schema(description = "本月净利", example = "36000.00")
    private BigDecimal monthNetProfit;

    // ========== 本季度统计 ==========

    @Schema(description = "本季度订单数", example = "200")
    private Long quarterOrderCount;

    @Schema(description = "本季度销售额", example = "500000.00")
    private BigDecimal quarterSalesAmount;

    @Schema(description = "本季度成本", example = "400000.00")
    private BigDecimal quarterCostAmount;

    @Schema(description = "本季度毛利", example = "100000.00")
    private BigDecimal quarterGrossProfit;

    @Schema(description = "本季度净利", example = "90000.00")
    private BigDecimal quarterNetProfit;

    // ========== 本年统计 ==========

    @Schema(description = "本年订单数", example = "500")
    private Long yearOrderCount;

    @Schema(description = "本年销售额", example = "2000000.00")
    private BigDecimal yearSalesAmount;

    @Schema(description = "本年成本", example = "1600000.00")
    private BigDecimal yearCostAmount;

    @Schema(description = "本年毛利", example = "400000.00")
    private BigDecimal yearGrossProfit;

    @Schema(description = "本年净利", example = "360000.00")
    private BigDecimal yearNetProfit;

    // ========== 待处理事项 ==========

    @Schema(description = "待审核订单数", example = "3")
    private Long pendingReviewOrderCount;

    @Schema(description = "待填充成本订单数", example = "5")
    private Long pendingCostOrderCount;

    // ========== 鸿恒盛适配指标 ==========

    @Schema(description = "待收款金额")
    private BigDecimal pendingReceivableAmount;

    @Schema(description = "待付款金额")
    private BigDecimal pendingPayableAmount;

    @Schema(description = "本月采购单数")
    private Long monthPurchaseOrderCount;

    @Schema(description = "未核销发票数")
    private Long unreconcileInvoiceCount;

    // ========== 权限标识 ==========

    @Schema(description = "是否为管理员（可查看完整数据）", example = "true")
    private Boolean isAdmin;

}
