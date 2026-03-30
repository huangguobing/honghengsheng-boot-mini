package cn.iocoder.stmc.module.erp.controller.admin.statistics.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Schema(description = "管理后台 - 开票统计明细 Response VO")
@Data
public class InvoiceSummaryItemRespVO {

    @Schema(description = "发票编号")
    private Long id;

    @Schema(description = "订单ID")
    private Long orderId;

    @Schema(description = "订单编号")
    private String orderNo;

    @Schema(description = "往来单位")
    private String counterparty;

    @Schema(description = "凭证类型")
    private Integer voucherType;

    @Schema(description = "金额")
    private BigDecimal amount;

    @Schema(description = "开票日期")
    private LocalDate invoiceDate;

    @Schema(description = "核销状态")
    private Integer reconcileStatus;

    @Schema(description = "备注")
    private String remark;

}
