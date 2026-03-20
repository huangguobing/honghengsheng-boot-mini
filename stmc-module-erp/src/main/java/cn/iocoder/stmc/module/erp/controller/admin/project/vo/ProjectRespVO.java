package cn.iocoder.stmc.module.erp.controller.admin.project.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Schema(description = "管理后台 - ERP 项目/工地 Response VO")
@Data
public class ProjectRespVO {

    @Schema(description = "项目编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long id;

    @Schema(description = "父项目ID")
    private Long parentId;

    @Schema(description = "所属客户ID", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long customerId;

    @Schema(description = "所属客户名称", example = "XX公司")
    private String customerName;

    @Schema(description = "项目/工地名称", requiredMode = Schema.RequiredMode.REQUIRED, example = "XX工地")
    private String name;

    @Schema(description = "工地地址", example = "成都市武侯区")
    private String address;

    @Schema(description = "现场联系人", example = "张三")
    private String contact;

    @Schema(description = "现场联系电话", example = "13800138000")
    private String phone;

    @Schema(description = "收货单位")
    private String receivingUnit;

    @Schema(description = "投资模式: 0=单独投资 1=合作投资", example = "0")
    private Integer investmentType;

    @Schema(description = "合作方信息", example = "XX公司")
    private String partnerInfo;

    @Schema(description = "合同编号", example = "HT-2026-001")
    private String contractNo;

    @Schema(description = "合同金额", example = "500000.00")
    private BigDecimal contractAmount;

    @Schema(description = "打印模板: 1/2/3", example = "1")
    private Integer printTemplateId;

    @Schema(description = "状态: 0=进行中 1=已完工", requiredMode = Schema.RequiredMode.REQUIRED, example = "0")
    private Integer status;

    @Schema(description = "创建时间", requiredMode = Schema.RequiredMode.REQUIRED)
    private LocalDateTime createTime;

}
