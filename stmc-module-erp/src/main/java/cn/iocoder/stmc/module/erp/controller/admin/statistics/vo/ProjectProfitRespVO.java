package cn.iocoder.stmc.module.erp.controller.admin.statistics.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Schema(description = "管理后台 - 项目利润统计 Response VO")
@Data
public class ProjectProfitRespVO {

    @Schema(description = "项目ID")
    private Long projectId;

    @Schema(description = "项目名称")
    private String projectName;

    @Schema(description = "客户名称")
    private String customerName;

    @Schema(description = "订单数")
    private Long orderCount;

    @Schema(description = "销售额")
    private BigDecimal salesAmount;

    @Schema(description = "采购额")
    private BigDecimal purchaseAmount;

    @Schema(description = "运费总额")
    private BigDecimal freightAmount;

    @Schema(description = "总数量")
    private BigDecimal totalQuantity;

    @Schema(description = "总重量（吨）")
    private BigDecimal totalWeight;

    @Schema(description = "净利润")
    private BigDecimal netProfit;

}
