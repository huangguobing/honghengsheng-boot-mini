package cn.iocoder.stmc.module.erp.controller.admin.statistics.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Schema(description = "管理后台 - 应收应付汇总 Response VO")
@Data
public class ReceivablePayableRespVO {

    @Schema(description = "应收总额（销售订单应付金额合计）")
    private BigDecimal totalReceivable;

    @Schema(description = "已收总额")
    private BigDecimal totalReceived;

    @Schema(description = "待收总额")
    private BigDecimal pendingReceivable;

    @Schema(description = "应付总额（采购单金额合计）")
    private BigDecimal totalPayable;

    @Schema(description = "已付总额")
    private BigDecimal totalPaid;

    @Schema(description = "待付总额")
    private BigDecimal pendingPayable;

}
