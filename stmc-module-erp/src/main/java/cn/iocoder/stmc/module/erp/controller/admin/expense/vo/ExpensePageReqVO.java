package cn.iocoder.stmc.module.erp.controller.admin.expense.vo;

import cn.iocoder.stmc.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.util.List;

import static cn.iocoder.stmc.framework.common.util.date.DateUtils.FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND;

@Schema(description = "管理后台 - ERP 费用支出分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class ExpensePageReqVO extends PageParam {

    @Schema(description = "关联订单编号", example = "1024")
    private Long orderId;

    @Schema(description = "费用日期范围")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND)
    private LocalDate[] expenseDate;

    @Schema(description = "当前角色可见的订单ID集合")
    private List<Long> visibleOrderIds;

}
