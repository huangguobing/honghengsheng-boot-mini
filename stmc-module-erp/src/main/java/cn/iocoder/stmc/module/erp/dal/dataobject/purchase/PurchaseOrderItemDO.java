package cn.iocoder.stmc.module.erp.dal.dataobject.purchase;

import cn.iocoder.stmc.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * ERP 采购单明细 DO
 *
 * @author stmc
 */
@TableName("erp_purchase_order_item")
@KeySequence("erp_purchase_order_item_seq")
@Data
@EqualsAndHashCode(callSuper = true)
public class PurchaseOrderItemDO extends BaseDO {

    /**
     * 明细编号
     */
    @TableId
    private Long id;

    /**
     * 采购单编号
     */
    private Long purchaseOrderId;

    /**
     * 关联销售订单明细编号
     */
    private Long orderItemId;

    /**
     * 产品编号
     */
    private Long productId;

    /**
     * 规格编号
     */
    private Long specId;

    /**
     * 产品名称
     */
    private String productName;

    /**
     * 规格名称
     */
    private String specName;

    /**
     * 单位
     */
    private String unit;

    /**
     * 数量
     */
    private BigDecimal quantity;

    /**
     * 重量（吨）
     */
    private BigDecimal weight;

    /**
     * 采购单价
     */
    private BigDecimal purchasePrice;

    /**
     * 采购金额
     */
    private BigDecimal purchaseAmount;

}
