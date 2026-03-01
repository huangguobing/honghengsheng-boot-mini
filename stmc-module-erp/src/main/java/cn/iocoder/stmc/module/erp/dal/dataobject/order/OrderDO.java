package cn.iocoder.stmc.module.erp.dal.dataobject.order;

import cn.iocoder.stmc.framework.mybatis.core.dataobject.BaseDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.customer.CustomerDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.supplier.SupplierDO;
import cn.iocoder.stmc.module.erp.enums.OrderStatusEnum;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * ERP 订单 DO
 *
 * @author stmc
 */
@TableName("erp_order")
@KeySequence("erp_order_seq")
@Data
@EqualsAndHashCode(callSuper = true)
public class OrderDO extends BaseDO {

    /**
     * 订单编号
     */
    @TableId
    private Long id;

    /**
     * 订单号
     */
    private String orderNo;

    /**
     * 客户编号（销售订单使用）
     *
     * 关联 {@link CustomerDO#getId()}
     */
    private Long customerId;

    /**
     * 供应商编号（采购订单使用）
     *
     * 关联 {@link SupplierDO#getId()}
     */
    private Long supplierId;

    /**
     * 订单类型（1销售订单 2采购订单）
     */
    private Integer orderType;

    /**
     * 订单状态
     *
     * 枚举 {@link OrderStatusEnum}
     */
    private Integer status;

    /**
     * 订单日期
     */
    private LocalDateTime orderDate;

    /**
     * 交货日期
     */
    private LocalDateTime deliveryDate;

    /**
     * 商品总数量
     */
    private BigDecimal totalQuantity;

    /**
     * 商品总金额
     */
    private BigDecimal totalAmount;

    /**
     * 折扣金额
     */
    private BigDecimal discountAmount;

    /**
     * 应付金额（总金额 - 折扣金额）
     */
    private BigDecimal payableAmount;

    /**
     * 已付金额
     */
    private BigDecimal paidAmount;

    /**
     * 发货费/运费
     */
    private BigDecimal shippingFee;

    // ========== 采购成本汇总字段（管理员填充后计算）==========

    /**
     * 采购总成本
     */
    private BigDecimal totalPurchaseAmount;

    /**
     * 总毛利
     */
    private BigDecimal totalGrossProfit;

    /**
     * 总税额
     */
    private BigDecimal totalTaxAmount;

    /**
     * 总净利
     */
    private BigDecimal totalNetProfit;

    /**
     * 其他费用金额
     */
    private BigDecimal extraCost;

    /**
     * 其他费用备注
     */
    private String extraCostRemark;

    /**
     * 成本是否已填充
     */
    private Boolean costFilled;

    /**
     * 成本填充人ID
     */
    private Long costFilledBy;

    /**
     * 成本填充时间
     */
    private LocalDateTime costFilledTime;

    // ========== 业务员信息 ==========

    /**
     * 业务员ID
     */
    private Long salesmanId;

    /**
     * 业务员姓名
     */
    private String salesmanName;

    /**
     * 联系人
     */
    private String contact;

    /**
     * 联系电话
     */
    private String mobile;

    /**
     * 收货地址
     */
    private String address;

    /**
     * 备注
     */
    private String remark;

}
