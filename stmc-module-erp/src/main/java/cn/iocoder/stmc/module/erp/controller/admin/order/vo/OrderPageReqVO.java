package cn.iocoder.stmc.module.erp.controller.admin.order.vo;

import cn.iocoder.stmc.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

import static cn.iocoder.stmc.framework.common.util.date.DateUtils.FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND;

@Schema(description = "管理后台 - ERP 订单分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class OrderPageReqVO extends PageParam {

    @Schema(description = "订单号", example = "SO202312250001")
    private String orderNo;

    @Schema(description = "客户编号", example = "1")
    private Long customerId;

    @Schema(description = "订单类型", example = "1")
    private Integer orderType;

    @Schema(description = "订单状态", example = "0")
    private Integer status;

    @Schema(description = "订单日期")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND)
    private LocalDateTime[] orderDate;

    @Schema(description = "创建时间")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND)
    private LocalDateTime[] createTime;

    @Schema(description = "开票公司", example = "1")
    private Integer invoiceCompany;

    @Schema(description = "项目ID", example = "1")
    private Long projectId;

    @Schema(description = "是否退货单", example = "0")
    private Integer isReturn;

    @Schema(description = "业务员ID（数据权限过滤，内部使用）", hidden = true)
    private Long salesmanId;

    @Schema(description = "订单类别：0=主订单 1=副订单（内部使用）", hidden = true)
    private Integer orderCategory;

}
