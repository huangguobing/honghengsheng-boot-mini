package cn.iocoder.stmc.module.erp.controller.admin.purchase.vo;

import cn.iocoder.stmc.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.List;

@Schema(description = "管理后台 - ERP 采购单分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class PurchaseOrderPageReqVO extends PageParam {

    @Schema(description = "关联销售订单编号", example = "100")
    private Long orderId;

    @Schema(description = "供应商编号", example = "200")
    private Long supplierId;

    @Schema(description = "状态", example = "0")
    private Integer status;

    @Schema(description = "采购单号", example = "PO-20260305")
    private String purchaseNo;

    @Schema(description = "当前角色可见的订单ID集合")
    private List<Long> visibleOrderIds;

}
