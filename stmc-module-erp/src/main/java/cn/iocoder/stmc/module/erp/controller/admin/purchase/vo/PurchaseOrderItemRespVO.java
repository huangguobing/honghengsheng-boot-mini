package cn.iocoder.stmc.module.erp.controller.admin.purchase.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Schema(description = "管理后台 - ERP 采购单明细 Response VO")
@Data
public class PurchaseOrderItemRespVO {

    @Schema(description = "明细编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long id;

    @Schema(description = "采购单编号", example = "1")
    private Long purchaseOrderId;

    @Schema(description = "关联销售订单明细编号", example = "100")
    private Long orderItemId;

    @Schema(description = "产品编号", example = "10")
    private Long productId;

    @Schema(description = "规格编号", example = "20")
    private Long specId;

    @Schema(description = "产品名称", example = "钢管")
    private String productName;

    @Schema(description = "规格名称", example = "DN100")
    private String specName;

    @Schema(description = "单位", example = "吨")
    private String unit;

    @Schema(description = "数量", example = "100")
    private BigDecimal quantity;

    @Schema(description = "重量（吨）", example = "5.500")
    private BigDecimal weight;

    @Schema(description = "采购单价", example = "50.00")
    private BigDecimal purchasePrice;

    @Schema(description = "采购金额", example = "5000.00")
    private BigDecimal purchaseAmount;

}
