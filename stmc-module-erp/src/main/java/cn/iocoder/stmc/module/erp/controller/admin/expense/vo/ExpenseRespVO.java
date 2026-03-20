package cn.iocoder.stmc.module.erp.controller.admin.expense.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Schema(description = "管理后台 - ERP 费用支出 Response VO")
@Data
public class ExpenseRespVO {

    @Schema(description = "费用编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long id;

    @Schema(description = "关联订单编号", example = "1024")
    private Long orderId;

    @Schema(description = "关联采购订单编号", example = "2048")
    private Long purchaseOrderId;

    @Schema(description = "费用日期", requiredMode = Schema.RequiredMode.REQUIRED)
    private LocalDate expenseDate;

    @Schema(description = "运费", example = "100.00")
    private BigDecimal freight;

    @Schema(description = "吊车费", example = "200.00")
    private BigDecimal craneFee;

    @Schema(description = "复印费", example = "10.00")
    private BigDecimal copyFee;

    @Schema(description = "其他费用", example = "50.00")
    private BigDecimal otherFee;

    @Schema(description = "总支出", example = "360.00")
    private BigDecimal totalExpense;

    @Schema(description = "车牌号", example = "粤B12345")
    private String vehicleNo;

    @Schema(description = "付款人", example = "张三")
    private String payer;

    @Schema(description = "备注", example = "运费支出")
    private String remark;

    @Schema(description = "关联订单号", example = "SO20240101001")
    private String orderNo;

    @Schema(description = "创建时间", requiredMode = Schema.RequiredMode.REQUIRED)
    private LocalDateTime createTime;

}
