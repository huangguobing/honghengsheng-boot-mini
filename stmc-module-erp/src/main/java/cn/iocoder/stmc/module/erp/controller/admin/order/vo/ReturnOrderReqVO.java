package cn.iocoder.stmc.module.erp.controller.admin.order.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.Valid;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.List;

@Schema(description = "管理后台 - ERP 退货单创建 Request VO")
@Data
public class ReturnOrderReqVO {

    @Schema(description = "原订单ID", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "原订单ID不能为空")
    private Long orderId;

    @Schema(description = "退货明细列表", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotEmpty(message = "退货明细不能为空")
    @Valid
    private List<ReturnItemVO> items;

    @Schema(description = "退货明细")
    @Data
    public static class ReturnItemVO {

        @Schema(description = "原订单明细ID", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
        @NotNull(message = "原订单明细ID不能为空")
        private Long orderItemId;

        @Schema(description = "退货数量", requiredMode = Schema.RequiredMode.REQUIRED, example = "5.00")
        @NotNull(message = "退货数量不能为空")
        private BigDecimal returnQuantity;

    }

}
