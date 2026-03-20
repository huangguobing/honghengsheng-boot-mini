package cn.iocoder.stmc.module.erp.dal.dataobject.purchase;

import cn.iocoder.stmc.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * ERP 采购单 DO
 *
 * @author stmc
 */
@TableName("erp_purchase_order")
@KeySequence("erp_purchase_order_seq")
@Data
@EqualsAndHashCode(callSuper = true)
public class PurchaseOrderDO extends BaseDO {

    /**
     * 采购单编号
     */
    @TableId
    private Long id;

    /**
     * 采购单号
     */
    private String purchaseNo;

    /**
     * 关联销售订单编号
     */
    private Long orderId;

    /**
     * 供应商编号
     */
    private Long supplierId;

    /**
     * 采购总金额
     */
    private BigDecimal totalAmount;

    /**
     * 送货单号
     */
    private String deliveryNoteNo;

    /**
     * 状态（0草稿 1已提交 2已完成）
     */
    private Integer status;

    /**
     * 备注
     */
    private String remark;

}
