package cn.iocoder.stmc.module.erp.controller.admin.order.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.Valid;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.List;

@Schema(description = "管理后台 - ERP 订单成本填充 Request VO")
@Data
public class OrderCostFillReqVO {

    @Schema(description = "订单ID", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "订单ID不能为空")
    private Long orderId;

    @Schema(description = "其他费用金额", example = "50")
    private BigDecimal extraCost;

    @Schema(description = "其他费用备注", example = "快递费")
    private String extraCostRemark;

    @Schema(description = "明细成本信息列表", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotEmpty(message = "明细成本信息不能为空")
    @Valid
    private List<ItemCost> items;

    /**
     * 明细成本信息
     */
    @Data
    public static class ItemCost {

        @Schema(description = "明细ID", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
        @NotNull(message = "明细ID不能为空")
        private Long itemId;

        @Schema(description = "进货单位", example = "个")
        private String purchaseUnit;

        @Schema(description = "进货数量", example = "50")
        private BigDecimal purchaseQuantity;

        @Schema(description = "采购单价", example = "16")
        private BigDecimal purchasePrice;

        @Schema(description = "采购金额", example = "800")
        private BigDecimal purchaseAmount;

        @Schema(description = "采购备注", example = "")
        private String purchaseRemark;

        @Schema(description = "供应商ID", example = "1")
        private Long supplierId;

        @Schema(description = "税额（手动输入）", example = "2")
        private BigDecimal taxAmount;

    }

}
