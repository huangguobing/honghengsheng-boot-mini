package cn.iocoder.stmc.module.erp.controller.admin.purchase.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.Valid;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;

@Schema(description = "管理后台 - ERP 采购单新增/修改 Request VO")
@Data
public class PurchaseOrderSaveReqVO {

    @Schema(description = "采购单编号", example = "1")
    private Long id;

    @Schema(description = "关联销售订单编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "100")
    @NotNull(message = "关联销售订单不能为空")
    private Long orderId;

    @Schema(description = "供应商编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "200")
    @NotNull(message = "供应商不能为空")
    private Long supplierId;

    @Schema(description = "送货单号", example = "DN-20260305-001")
    private String deliveryNoteNo;

    @Schema(description = "备注", example = "加急采购")
    private String remark;

    @Schema(description = "采购单明细列表")
    @NotEmpty(message = "采购单明细不能为空")
    @Valid
    private List<PurchaseOrderItemSaveReqVO> items;

}
