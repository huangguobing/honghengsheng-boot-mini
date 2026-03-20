package cn.iocoder.stmc.module.erp.dal.dataobject.orderattachment;

import cn.iocoder.stmc.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * ERP 订单附件 DO
 *
 * @author stmc
 */
@TableName("erp_order_attachment")
@KeySequence("erp_order_attachment_seq")
@Data
@EqualsAndHashCode(callSuper = true)
public class OrderAttachmentDO extends BaseDO {

    @TableId
    private Long id;

    /**
     * 关联订单ID
     */
    private Long orderId;

    /**
     * 附件分类: invoice-发票照片, receipt-回执照片, delivery-送货单, contract-合同, other-其他
     */
    private String category;

    /**
     * 原始文件名
     */
    private String fileName;

    /**
     * 文件访问URL
     */
    private String fileUrl;

    /**
     * 文件大小(字节)
     */
    private Long fileSize;

    /**
     * 备注说明
     */
    private String remark;

}
