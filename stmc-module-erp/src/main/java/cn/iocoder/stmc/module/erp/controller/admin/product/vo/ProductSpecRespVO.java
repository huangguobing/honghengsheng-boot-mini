package cn.iocoder.stmc.module.erp.controller.admin.product.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "管理后台 - ERP 产品规格 Response VO")
@Data
public class ProductSpecRespVO {

    @Schema(description = "规格编号")
    private Long id;

    @Schema(description = "产品编号")
    private Long productId;

    @Schema(description = "规格")
    private String spec;

    @Schema(description = "单位")
    private String unit;

    @Schema(description = "状态")
    private Integer status;

    @Schema(description = "排序")
    private Integer sort;
}
