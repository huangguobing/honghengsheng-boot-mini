package cn.iocoder.stmc.module.erp.dal.dataobject.voucher;

import cn.iocoder.stmc.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * ERP 票据凭证 DO
 *
 * @author stmc
 */
@TableName("erp_voucher")
@KeySequence("erp_voucher_seq")
@Data
@EqualsAndHashCode(callSuper = true)
public class VoucherDO extends BaseDO {

    @TableId
    private Long id;

    /**
     * 关联订单ID
     */
    private Long orderId;

    /**
     * 关联采购单ID
     */
    private Long purchaseOrderId;

    /**
     * 票据类型：1=专用发票 2=普通发票 3=送货单 4=采购单 5=其他
     */
    private Integer voucherType;

    /**
     * 方向：0=进项（采购） 1=销项（销售）
     */
    private Integer direction;

    /**
     * 发票号
     */
    private String invoiceNo;

    /**
     * 金额
     */
    private BigDecimal amount;

    /**
     * 税额
     */
    private BigDecimal taxAmount;

    /**
     * 开票日期
     */
    private LocalDate invoiceDate;

    /**
     * 采购方
     */
    private String buyer;

    /**
     * 销售方
     */
    private String seller;

    /**
     * 文件URL
     */
    private String fileUrl;

    /**
     * 文件名
     */
    private String fileName;

    /**
     * 核销状态：0=未核销 1=已核销 2=不匹配
     */
    private Integer reconcileStatus;

    /**
     * 核销备注
     */
    private String reconcileRemark;

}
