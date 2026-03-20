package cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Schema(description = "管理后台 - ERP 对账汇总 Response VO")
@Data
public class ReconcileSummaryVO {

    @Schema(description = "目标ID（客户ID或供应商ID）", example = "1")
    private Long targetId;

    @Schema(description = "目标名称", example = "客户A")
    private String targetName;

    @Schema(description = "计划总额", example = "50000.00")
    private BigDecimal totalAmount;

    @Schema(description = "已付/已收总额", example = "30000.00")
    private BigDecimal paidAmount;

    @Schema(description = "未付/未收总额", example = "20000.00")
    private BigDecimal unpaidAmount;

    @Schema(description = "计划笔数", example = "5")
    private Integer planCount;

}
