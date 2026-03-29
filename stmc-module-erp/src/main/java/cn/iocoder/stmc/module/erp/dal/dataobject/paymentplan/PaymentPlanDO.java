package cn.iocoder.stmc.module.erp.dal.dataobject.paymentplan;

import cn.iocoder.stmc.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * ERP 付款计划 DO
 *
 * @author stmc
 */
@TableName("erp_payment_plan")
@KeySequence("erp_payment_plan_seq")
@Data
@EqualsAndHashCode(callSuper = true)
public class PaymentPlanDO extends BaseDO {

    /**
     * 计划编号
     */
    @TableId
    private Long id;

    /**
     * 计划单号
     */
    private String planNo;

    /**
     * 付款单编号
     */
    private Long paymentId;

    /**
     * 付款单号
     */
    private String paymentNo;

    /**
     * 供应商编号
     */
    private Long supplierId;

    /**
     * 订单ID（直接关联，用于查询开单业务员和订单号）
     */
    private Long orderId;

    /**
     * 配置编号
     */
    private Long configId;

    /**
     * 期数
     */
    private Integer stage;

    /**
     * 计划付款金额
     */
    private BigDecimal planAmount;

    /**
     * 计划付款日期
     */
    private LocalDate planDate;

    /**
     * 实际付款金额
     */
    private BigDecimal actualAmount;

    /**
     * 实际付款日期
     */
    private LocalDateTime actualDate;

    /**
     * 状态(0待付款 10已付款 20已逾期 30已取消)
     */
    private Integer status;

    /**
     * 备注
     */
    private String remark;

    // ========== 鸿恒盛扩展字段 ==========

    /**
     * 类型：0=应付（付供应商） 1=应收（收客户款）
     */
    private Integer type;

    /**
     * 关联采购单ID（应付时）
     */
    private Long purchaseOrderId;

    /**
     * 客户ID（应收时）
     */
    private Long customerId;

    /**
     * 项目ID（应收时）
     */
    private Long projectId;

    /**
     * 实际已付/已收金额（支持部分付款）
     */
    private BigDecimal paidAmount;

    /**
     * 收付方式：1=对公 2=对私 3=现金 4=微信 5=支付宝 6=承兑
     */
    private Integer paymentMethod;

}
