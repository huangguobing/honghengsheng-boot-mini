package cn.iocoder.stmc.module.erp.controller.admin.customer.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Schema(description = "管理后台 - ERP 客户 Response VO")
@Data
public class CustomerRespVO {

    @Schema(description = "客户编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long id;

    @Schema(description = "客户名称", requiredMode = Schema.RequiredMode.REQUIRED, example = "张三")
    private String name;

    @Schema(description = "客户编码", example = "C001")
    private String code;

    @Schema(description = "联系人", example = "李四")
    private String contact;

    @Schema(description = "联系电话", example = "13800138000")
    private String mobile;

    @Schema(description = "电子邮箱", example = "test@example.com")
    private String email;

    @Schema(description = "传真", example = "010-12345678")
    private String fax;

    @Schema(description = "地址", example = "北京市朝阳区")
    private String address;

    @Schema(description = "开户银行", example = "中国工商银行")
    private String bankName;

    @Schema(description = "银行账号", example = "6222021234567890123")
    private String bankAccount;

    @Schema(description = "税号", example = "91110000MA00ABCDEF")
    private String taxNo;

    @Schema(description = "信用额度", example = "100000.00")
    private BigDecimal creditLimit;

    @Schema(description = "状态", requiredMode = Schema.RequiredMode.REQUIRED, example = "0")
    private Integer status;

    @Schema(description = "排序", example = "1")
    private Integer sort;

    @Schema(description = "备注", example = "VIP客户")
    private String remark;

    @Schema(description = "是否下级开单: 0=否 1=是", example = "1")
    private Integer needIntermediary;

    @Schema(description = "创建时间", requiredMode = Schema.RequiredMode.REQUIRED)
    private LocalDateTime createTime;

}
