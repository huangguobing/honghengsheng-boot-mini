package cn.iocoder.stmc.module.erp.controller.admin.expense.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;

@Schema(description = "管理后台 - ERP 费用支出新增/修改 Request VO")
@Data
public class ExpenseSaveReqVO {

    @Schema(description = "费用编号", example = "1")
    private Long id;

    @Schema(description = "关联订单编号", example = "1024")
    private Long orderId;

    @Schema(description = "关联采购订单编号", example = "2048")
    private Long purchaseOrderId;

    @Schema(description = "费用日期", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "费用日期不能为空")
    private LocalDate expenseDate;

    @Schema(description = "运费", example = "100.00")
    private BigDecimal freight;

    @Schema(description = "吊车费", example = "200.00")
    private BigDecimal craneFee;

    @Schema(description = "复印费", example = "10.00")
    private BigDecimal copyFee;

    @Schema(description = "其他费用", example = "50.00")
    private BigDecimal otherFee;

    @Schema(description = "车牌号", example = "粤B12345")
    private String vehicleNo;

    @Schema(description = "付款人", example = "张三")
    private String payer;

    @Schema(description = "备注", example = "运费支出")
    private String remark;

}
