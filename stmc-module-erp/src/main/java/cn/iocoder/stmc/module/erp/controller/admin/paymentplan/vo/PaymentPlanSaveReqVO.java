package cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;

@Schema(description = "管理后台 - ERP 付款计划创建/更新 Request VO")
@Data
public class PaymentPlanSaveReqVO {

    @Schema(description = "计划编号（有则更新，无则新增）", example = "1")
    private Long id;

    @Schema(description = "类型：0=应付 1=应收", requiredMode = Schema.RequiredMode.REQUIRED, example = "0")
    @NotNull(message = "类型不能为空")
    private Integer type;

    @Schema(description = "关联订单ID", example = "1")
    private Long orderId;

    @Schema(description = "关联采购单ID", example = "1")
    private Long purchaseOrderId;

    @Schema(description = "供应商ID（应付时）", example = "1")
    private Long supplierId;

    @Schema(description = "客户ID（应收时）", example = "1")
    private Long customerId;

    @Schema(description = "项目ID（应收时）", example = "1")
    private Long projectId;

    @Schema(description = "计划金额", requiredMode = Schema.RequiredMode.REQUIRED, example = "5000.00")
    @NotNull(message = "计划金额不能为空")
    private BigDecimal planAmount;

    @Schema(description = "已付/已收金额", example = "0.00")
    private BigDecimal paidAmount;

    @Schema(description = "收付方式：1=对公 2=对私 3=现金 4=微信 5=支付宝 6=承兑", example = "1")
    private Integer paymentMethod;

    @Schema(description = "历史计划日期（兼容保留）", example = "2024-01-08")
    private LocalDate planDate;

    @Schema(description = "状态：0=待付款 5=部分付款 10=已付款 30=已取消(历史兼容)", example = "0")
    private Integer status;

    @Schema(description = "备注", example = "第一期付款")
    private String remark;

}
