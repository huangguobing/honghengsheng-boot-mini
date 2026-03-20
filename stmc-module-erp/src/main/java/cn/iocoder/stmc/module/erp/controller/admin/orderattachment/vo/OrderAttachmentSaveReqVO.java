package cn.iocoder.stmc.module.erp.controller.admin.orderattachment.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

@Schema(description = "管理后台 - ERP 订单附件新增 Request VO")
@Data
public class OrderAttachmentSaveReqVO {

    @Schema(description = "附件编号（更新时传）", example = "1")
    private Long id;

    @Schema(description = "关联订单编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1024")
    @NotNull(message = "关联订单编号不能为空")
    private Long orderId;

    @Schema(description = "附件分类", requiredMode = Schema.RequiredMode.REQUIRED, example = "invoice")
    @NotEmpty(message = "附件分类不能为空")
    private String category;

    @Schema(description = "原始文件名", requiredMode = Schema.RequiredMode.REQUIRED, example = "发票.jpg")
    @NotEmpty(message = "文件名不能为空")
    private String fileName;

    @Schema(description = "文件访问URL", requiredMode = Schema.RequiredMode.REQUIRED, example = "http://xxx/file.jpg")
    @NotEmpty(message = "文件URL不能为空")
    private String fileUrl;

    @Schema(description = "文件大小(字节)", example = "102400")
    private Long fileSize;

    @Schema(description = "备注说明", example = "进项发票照片")
    private String remark;

}
