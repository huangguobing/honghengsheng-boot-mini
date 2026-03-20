package cn.iocoder.stmc.module.erp.dal.dataobject.order;

import cn.iocoder.stmc.framework.mybatis.core.dataobject.BaseDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.supplier.SupplierDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * ERP 订单明细 DO
 *
 * @author stmc
 */
@TableName("erp_order_item")
@KeySequence("erp_order_item_seq")
@Data
@EqualsAndHashCode(callSuper = true)
public class OrderItemDO extends BaseDO {

    /**
     * 明细ID
     */
    @TableId
    private Long id;

    /**
     * 订单ID
     *
     * 关联 {@link OrderDO#getId()}
     */
    private Long orderId;

    /**
     * 关联主订单商品行ID（副订单商品行使用）
     */
    private Long parentItemId;

    /**
     * 明细类型（0商品 1费用）
     */
    private Integer itemType;

    // ========== 业务员填写字段（销售信息）==========

    /**
     * 商品名称
     */
    private String productName;

    /**
     * 规格（如DN150、DN100）
     */
    private String spec;

    /**
     * 销售单位（个、吨等）
     */
    private String saleUnit;

    /**
     * 销售数量
     */
    private BigDecimal saleQuantity;

    /**
     * 销售单价
     */
    private BigDecimal salePrice;

    /**
     * 销售金额（数量*单价）
     */
    private BigDecimal saleAmount;

    /**
     * 销售备注（如45度、90度）
     */
    private String saleRemark;

    // ========== 产品属性字段（从产品规格带入）==========

    /** 材质（如304、20#） */
    private String material;

    /** 品牌（如青山、友发） */
    private String brand;

    /** 厂家 */
    private String manufacturer;

    // ========== 发货/送货信息字段 ==========

    /** 重量（吨） */
    private BigDecimal weight;

    /** 长度（米） */
    private BigDecimal length;

    /** 总米数（数量×长度） */
    private BigDecimal totalMeters;

    /** 车号 */
    private String vehicleNo;

    // ========== 管理员填写字段（采购成本信息）==========

    /**
     * 进货单位
     */
    private String purchaseUnit;

    /**
     * 进货数量
     */
    private BigDecimal purchaseQuantity;

    /**
     * 采购单价
     */
    private BigDecimal purchasePrice;

    /**
     * 采购金额
     */
    private BigDecimal purchaseAmount;

    /**
     * 采购备注
     */
    private String purchaseRemark;

    /**
     * 供应商ID
     *
     * 关联 {@link SupplierDO#getId()}
     */
    private Long supplierId;

    // ========== 利润计算字段 ==========

    /**
     * 毛利（销售金额-采购金额）
     */
    private BigDecimal grossProfit;

    /**
     * 税额（手动输入）
     */
    private BigDecimal taxAmount;

    /**
     * 净利（毛利-税额）
     */
    private BigDecimal netProfit;

    // ========== 付款信息字段 ==========

    /**
     * 付款日期
     *
     * @deprecated 废弃：付款信息已由 PaymentPlan 独立管理
     */
    @Deprecated
    private LocalDate paymentDate;

    /**
     * 是否已付款（0未付款 1已付款）
     *
     * @deprecated 废弃：付款信息已由 PaymentPlan 独立管理
     */
    @Deprecated
    private Boolean isPaid;

}
