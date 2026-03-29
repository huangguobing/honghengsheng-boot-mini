package cn.iocoder.stmc.module.erp.controller.admin.statistics.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Schema(description = "管理后台 - 开票统计 Response VO")
@Data
public class InvoiceSummaryRespVO {

    @Schema(description = "进项发票数")
    private Long incomingCount;

    @Schema(description = "进项金额")
    private BigDecimal incomingAmount;

    @Schema(description = "销项发票数")
    private Long outgoingCount;

    @Schema(description = "销项金额")
    private BigDecimal outgoingAmount;

    @Schema(description = "进项分组列表")
    private List<InvoiceSummaryGroupRespVO> incomingGroups;

    @Schema(description = "销项分组列表")
    private List<InvoiceSummaryGroupRespVO> outgoingGroups;

}
