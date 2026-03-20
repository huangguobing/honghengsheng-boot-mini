package cn.iocoder.stmc.module.erp.controller.admin.purchase.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - ERP 采购单 Response VO")
@Data
public class PurchaseOrderRespVO {

    @Schema(description = "采购单编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long id;

    @Schema(description = "采购单号", requiredMode = Schema.RequiredMode.REQUIRED, example = "PO-20260305-001")
    private String purchaseNo;

    @Schema(description = "关联销售订单编号", example = "100")
    private Long orderId;

    @Schema(description = "供应商编号", example = "200")
    private Long supplierId;

    @Schema(description = "采购总金额", example = "50000.00")
    private BigDecimal totalAmount;

    @Schema(description = "送货单号", example = "DN-20260305-001")
    private String deliveryNoteNo;

    @Schema(description = "状态", example = "0")
    private Integer status;

    @Schema(description = "备注", example = "加急采购")
    private String remark;

    @Schema(description = "供应商名称", example = "XX钢铁有限公司")
    private String supplierName;

    @Schema(description = "销售订单号", example = "SO-20260305-001")
    private String orderNo;

    @Schema(description = "采购单明细列表")
    private List<PurchaseOrderItemRespVO> items;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
