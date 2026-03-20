package cn.iocoder.stmc.module.erp.controller.admin.statistics.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Schema(description = "管理后台 - 产品销售统计 Response VO")
@Data
public class ProductSalesRespVO {

    @Schema(description = "产品名称")
    private String productName;

    @Schema(description = "规格")
    private String spec;

    @Schema(description = "销售数量")
    private BigDecimal totalQuantity;

    @Schema(description = "总重量（吨）")
    private BigDecimal totalWeight;

    @Schema(description = "销售额")
    private BigDecimal salesAmount;

    @Schema(description = "订单数")
    private Long orderCount;

}
