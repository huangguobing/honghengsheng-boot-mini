package cn.iocoder.stmc.module.erp.controller.admin.voucher.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Schema(description = "管理后台 - ERP 票据凭证 Response VO")
@Data
public class VoucherRespVO {

    @Schema(description = "编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long id;

    @Schema(description = "关联订单ID", example = "1")
    private Long orderId;

    @Schema(description = "订单号", example = "SO20240101001")
    private String orderNo;

    @Schema(description = "关联采购单ID", example = "1")
    private Long purchaseOrderId;

    @Schema(description = "采购单号", example = "PO20240101001")
    private String purchaseOrderNo;

    @Schema(description = "票据类型：1=专用发票 2=普通发票 3=送货单 4=采购单 5=其他", example = "1")
    private Integer voucherType;

    @Schema(description = "方向：0=进项 1=销项", example = "0")
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

    @Schema(description = "核销状态：0=未核销 1=已核销 2=不匹配", example = "0")
    private Integer reconcileStatus;

    @Schema(description = "核销备注", example = "金额不匹配")
    private String reconcileRemark;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
