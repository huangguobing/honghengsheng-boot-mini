package cn.iocoder.stmc.module.erp.controller.admin.project.vo;

import cn.iocoder.stmc.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - ERP 项目/工地分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class ProjectPageReqVO extends PageParam {

    @Schema(description = "所属客户ID", example = "1")
    private Long customerId;

    @Schema(description = "项目名称", example = "XX工地")
    private String name;

    @Schema(description = "状态", example = "0")
    private Integer status;

    @Schema(description = "父项目ID")
    private Long parentId;

    @Schema(description = "是否一级项目（true=只查一级）")
    private Boolean topLevel;

}
