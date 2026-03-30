package cn.iocoder.stmc.module.erp.controller.admin.statistics.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Schema(description = "管理后台 - 开票统计分组 Response VO")
@Data
public class InvoiceSummaryGroupRespVO {

    @Schema(description = "发票编码")
    private String invoiceCode;

    @Schema(description = "展示编码")
    private String displayCode;

    @Schema(description = "分组数量")
    private Long count;

    @Schema(description = "分组金额")
    private BigDecimal amount;

    @Schema(description = "分组明细列表")
    private List<InvoiceSummaryItemRespVO> items;

}
