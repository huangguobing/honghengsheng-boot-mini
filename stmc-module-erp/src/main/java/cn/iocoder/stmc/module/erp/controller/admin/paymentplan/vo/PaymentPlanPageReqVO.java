package cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo;

import cn.iocoder.stmc.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.util.List;

import static cn.iocoder.stmc.framework.common.util.date.DateUtils.FORMAT_YEAR_MONTH_DAY;

@Schema(description = "管理后台 - ERP 付款计划分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
public class PaymentPlanPageReqVO extends PageParam {

    @Schema(description = "付款单号", example = "PAY202401010001")
    private String paymentNo;

    @Schema(description = "供应商编号", example = "1")
    private Long supplierId;

    @Schema(description = "状态(0待付款 5部分付款 10已付款 20已逾期-历史兼容 30已取消-历史兼容)", example = "0")
    private Integer status;

    @Schema(description = "状态列表（多状态筛选）", example = "[0, 5]")
    private List<Integer> statusList;

    @Schema(description = "实际付款/收款日期开始", example = "2024-01-01")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY)
    private LocalDate actualDateStart;

    @Schema(description = "实际付款/收款日期结束", example = "2024-01-31")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY)
    private LocalDate actualDateEnd;

    @Schema(description = "类型：0=应付 1=应收", example = "0")
    private Integer type;

    @Schema(description = "客户编号", example = "1")
    private Long customerId;

    @Schema(description = "项目编号", example = "1")
    private Long projectId;

    @Schema(description = "收付方式", example = "1")
    private Integer paymentMethod;

    @Schema(description = "订单编号", example = "1")
    private Long orderId;

    @Schema(description = "当前角色可见的订单ID集合")
    private List<Long> visibleOrderIds;

}
