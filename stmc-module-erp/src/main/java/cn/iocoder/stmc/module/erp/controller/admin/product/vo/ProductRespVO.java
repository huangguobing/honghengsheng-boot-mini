package cn.iocoder.stmc.module.erp.controller.admin.product.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - ERP 产品 Response VO")
@Data
public class ProductRespVO {

    @Schema(description = "产品编号")
    private Long id;

    @Schema(description = "产品名称")
    private String name;

    @Schema(description = "状态")
    private Integer status;

    @Schema(description = "排序")
    private Integer sort;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "规格数量")
    private Integer specCount;

    @Schema(description = "规格列表")
    private List<ProductSpecRespVO> specs;
}
