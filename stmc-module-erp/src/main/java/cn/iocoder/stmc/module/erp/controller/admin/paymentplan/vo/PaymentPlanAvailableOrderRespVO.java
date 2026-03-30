package cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Schema(description = "管理后台 - 收付款计划可分配订单 Response VO")
public class PaymentPlanAvailableOrderRespVO {

    @Schema(description = "订单ID", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long id;

    @Schema(description = "订单号", requiredMode = Schema.RequiredMode.REQUIRED, example = "SO20260328001")
    private String orderNo;

    @Schema(description = "剩余可分配金额", requiredMode = Schema.RequiredMode.REQUIRED, example = "12000.00")
    private BigDecimal remainingAmount;
}
