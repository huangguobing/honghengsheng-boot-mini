package cn.iocoder.stmc.module.erp.controller.admin.voucher.vo;

import cn.iocoder.stmc.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Schema(description = "管理后台 - ERP 票据凭证分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
public class VoucherPageReqVO extends PageParam {

    @Schema(description = "发票类型：1=增值税专用发票 2=普通发票 3=定额发票 4=其他发票", example = "1")
    private Integer voucherType;

    @Schema(description = "方向：0=进项 1=销项", example = "0")
    private Integer direction;

    @Schema(description = "核销状态：0=未核销 1=已核销 2=不匹配", example = "0")
    private Integer reconcileStatus;

    @Schema(description = "关联订单ID", example = "1")
    private Long orderId;

    @Schema(description = "发票代码", example = "012345678901")
    private String invoiceCode;

}
