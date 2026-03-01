package cn.iocoder.stmc.module.erp.controller.admin.product.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import java.util.List;

@Schema(description = "管理后台 - ERP 产品新增/修改 Request VO")
@Data
public class ProductSaveReqVO {

    @Schema(description = "产品编号", example = "1")
    private Long id;

    @Schema(description = "产品名称", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "产品名称不能为空")
    private String name;

    @Schema(description = "状态", example = "0")
    private Integer status;

    @Schema(description = "排序", example = "0")
    private Integer sort;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "规格列表", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotEmpty(message = "至少添加一个规格")
    private List<ProductSpecItem> specs;

    @Data
    public static class ProductSpecItem {

        @Schema(description = "规格编号（修改时传）")
        private Long id;

        @Schema(description = "规格", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotBlank(message = "规格不能为空")
        private String spec;

        @Schema(description = "单位", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotBlank(message = "单位不能为空")
        private String unit;

        @Schema(description = "状态", example = "0")
        private Integer status;

        @Schema(description = "排序", example = "0")
        private Integer sort;
    }
}
