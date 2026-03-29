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

    @Schema(description = "关联订单ID", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "关联订单不能为空")
    private Long orderId;

    @Schema(description = "发票类型：1=增值税专用发票 2=普通发票 3=定额发票 4=其他发票；系统预制票可为空", example = "1")
    private Integer voucherType;

    @Schema(description = "方向：0=进项 1=销项", requiredMode = Schema.RequiredMode.REQUIRED, example = "0")
    @NotNull(message = "票据方向不能为空")
    private Integer direction;

    @Schema(description = "对方单位（进项=采购方，销项=客户）", example = "供应商A")
    private String counterparty;

    @Schema(description = "发票代码", example = "012345678901")
    private String invoiceCode;

    @Schema(description = "价税合计", example = "10000.00")
    private BigDecimal amount;

    @Schema(description = "开票日期", example = "2024-01-01")
    private LocalDate invoiceDate;

    @Schema(description = "文件URL", example = "https://xxx.com/file.pdf")
    private String fileUrl;

    @Schema(description = "文件名", example = "发票.pdf")
    private String fileName;

    @Schema(description = "备注", example = "3月份采购发票")
    private String remark;

    @Schema(description = "核销状态：0=未核销 1=已核销", example = "0")
    private Integer reconcileStatus;

}
