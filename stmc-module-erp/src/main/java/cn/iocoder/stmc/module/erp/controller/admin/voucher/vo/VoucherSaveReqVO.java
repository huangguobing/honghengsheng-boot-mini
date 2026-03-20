package cn.iocoder.stmc.module.erp.controller.admin.voucher.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;

@Schema(description = "管理后台 - ERP 票据凭证创建/更新 Request VO")
@Data
public class VoucherSaveReqVO {

    @Schema(description = "编号（有则更新，无则新增）", example = "1")
    private Long id;

    @Schema(description = "关联订单ID", example = "1")
    private Long orderId;

    @Schema(description = "关联采购单ID", example = "1")
    private Long purchaseOrderId;

    @Schema(description = "票据类型：1=专用发票 2=普通发票 3=送货单 4=采购单 5=其他", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "票据类型不能为空")
    private Integer voucherType;

    @Schema(description = "方向：0=进项 1=销项", requiredMode = Schema.RequiredMode.REQUIRED, example = "0")
    @NotNull(message = "票据方向不能为空")
    private Integer direction;

    @Schema(description = "发票号", example = "FP20240101001")
    private String invoiceNo;

    @Schema(description = "金额", example = "10000.00")
    private BigDecimal amount;

    @Schema(description = "税额", example = "1300.00")
    private BigDecimal taxAmount;

    @Schema(description = "开票日期", example = "2024-01-01")
    private LocalDate invoiceDate;

    @Schema(description = "采购方", example = "四川鸿恒盛供应链管理有限公司")
    private String buyer;

    @Schema(description = "销售方", example = "供应商A")
    private String seller;

    @Schema(description = "文件URL", example = "https://xxx.com/file.pdf")
    private String fileUrl;

    @Schema(description = "文件名", example = "发票.pdf")
    private String fileName;

}
