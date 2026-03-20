package cn.iocoder.stmc.module.erp.controller.admin.project.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - ERP 项目树形结构 Response VO")
@Data
public class ProjectTreeRespVO {

    @Schema(description = "项目编号")
    private Long id;

    @Schema(description = "父项目ID")
    private Long parentId;

    @Schema(description = "客户ID")
    private Long customerId;

    @Schema(description = "客户名称")
    private String customerName;

    @Schema(description = "项目名称")
    private String name;

    @Schema(description = "地址")
    private String address;

    @Schema(description = "联系人")
    private String contact;

    @Schema(description = "电话")
    private String phone;

    @Schema(description = "合同编号")
    private String contractNo;

    @Schema(description = "合同金额")
    private BigDecimal contractAmount;

    @Schema(description = "打印模板ID")
    private Integer printTemplateId;

    @Schema(description = "状态")
    private Integer status;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "子项目列表")
    private List<ProjectTreeRespVO> children;

}
