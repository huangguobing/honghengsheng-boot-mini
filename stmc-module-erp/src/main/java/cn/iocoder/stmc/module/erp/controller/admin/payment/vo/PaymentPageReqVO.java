package cn.iocoder.stmc.module.erp.controller.admin.payment.vo;

import cn.iocoder.stmc.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.List;

import static cn.iocoder.stmc.framework.common.util.date.DateUtils.FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND;

@Schema(description = "管理后台 - ERP 付款分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class PaymentPageReqVO extends PageParam {

    @Schema(description = "付款单号", example = "PAY202312250001")
    private String paymentNo;

    @Schema(description = "供应商编号", example = "1")
    private Long supplierId;

    @Schema(description = "订单编号", example = "1")
    private Long orderId;

    @Schema(description = "付款类型", example = "1")
    private Integer paymentType;

    @Schema(description = "状态", example = "0")
    private Integer status;

    @Schema(description = "付款日期")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND)
    private LocalDateTime[] paymentDate;

    @Schema(description = "创建时间")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND)
    private LocalDateTime[] createTime;

    @Schema(description = "当前角色可见的订单ID集合")
    private List<Long> visibleOrderIds;

}
