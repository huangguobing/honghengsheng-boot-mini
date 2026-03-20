package cn.iocoder.stmc.module.erp.controller.admin.orderattachment.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - ERP 订单附件 Response VO")
@Data
public class OrderAttachmentRespVO {

    @Schema(description = "附件编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long id;

    @Schema(description = "关联订单编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1024")
    private Long orderId;

    @Schema(description = "附件分类", requiredMode = Schema.RequiredMode.REQUIRED, example = "invoice")
    private String category;

    @Schema(description = "原始文件名", requiredMode = Schema.RequiredMode.REQUIRED, example = "发票.jpg")
    private String fileName;

    @Schema(description = "文件访问URL", requiredMode = Schema.RequiredMode.REQUIRED, example = "http://xxx/file.jpg")
    private String fileUrl;

    @Schema(description = "文件大小(字节)", example = "102400")
    private Long fileSize;

    @Schema(description = "备注说明", example = "进项发票照片")
    private String remark;

    @Schema(description = "创建者", example = "admin")
    private String creator;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
