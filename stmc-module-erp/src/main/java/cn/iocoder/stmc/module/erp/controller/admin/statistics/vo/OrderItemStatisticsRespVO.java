package cn.iocoder.stmc.module.erp.controller.admin.statistics.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Schema(description = "管理后台 - 采购明细统计 Response VO")
@Data
public class OrderItemStatisticsRespVO {

    @Schema(description = "明细ID", example = "1")
    private Long id;

    @Schema(description = "关联订单号", example = "ORD20231225001")
    private String orderNo;

    @Schema(description = "商品名称", example = "钢管")
    private String productName;

    @Schema(description = "规格", example = "DN150")
    private String spec;

    @Schema(description = "采购数量", example = "100")
    private BigDecimal purchaseQuantity;

    @Schema(description = "采购单位", example = "吨")
    private String purchaseUnit;

    @Schema(description = "重量（吨）", example = "5.000")
    private BigDecimal weight;

    @Schema(description = "采购单价", example = "5000.00")
    private BigDecimal purchasePrice;

    @Schema(description = "采购金额", example = "500000.00")
    private BigDecimal purchaseAmount;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
