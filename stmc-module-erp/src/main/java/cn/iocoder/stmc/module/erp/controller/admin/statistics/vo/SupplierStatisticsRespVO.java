package cn.iocoder.stmc.module.erp.controller.admin.statistics.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Schema(description = "管理后台 - 供应商采购统计 Response VO")
@Data
public class SupplierStatisticsRespVO {

    @Schema(description = "供应商ID", example = "1")
    private Long supplierId;

    @Schema(description = "供应商名称", example = "供应商A")
    private String supplierName;

    @Schema(description = "供应商编号", example = "SUP001")
    private String supplierCode;

    @Schema(description = "联系人", example = "张三")
    private String contact;

    @Schema(description = "联系电话", example = "13800138000")
    private String mobile;

    @Schema(description = "地址", example = "北京市朝阳区")
    private String address;

    @Schema(description = "采购总额", example = "100000.00")
    private BigDecimal totalPurchaseAmount;

    @Schema(description = "总重量（吨）", example = "50.000")
    private BigDecimal totalWeight;

    @Schema(description = "采购明细数", example = "50")
    private Long orderItemCount;

}
