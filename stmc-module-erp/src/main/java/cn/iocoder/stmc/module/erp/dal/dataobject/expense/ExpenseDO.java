package cn.iocoder.stmc.module.erp.dal.dataobject.expense;

import cn.iocoder.stmc.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * ERP 费用/运费支出 DO
 *
 * @author stmc
 */
@TableName("erp_expense")
@KeySequence("erp_expense_seq")
@Data
@EqualsAndHashCode(callSuper = true)
public class ExpenseDO extends BaseDO {

    /**
     * 费用编号
     */
    @TableId
    private Long id;

    /**
     * 关联订单编号
     */
    private Long orderId;

    /**
     * 关联采购订单编号
     */
    private Long purchaseOrderId;

    /**
     * 费用日期
     */
    private LocalDate expenseDate;

    /**
     * 运费
     */
    private BigDecimal freight;

    /**
     * 吊车费
     */
    private BigDecimal craneFee;

    /**
     * 复印费
     */
    private BigDecimal copyFee;

    /**
     * 其他费用
     */
    private BigDecimal otherFee;

    /**
     * 总支出
     */
    private BigDecimal totalExpense;

    /**
     * 车牌号
     */
    private String vehicleNo;

    /**
     * 付款人
     */
    private String payer;

    /**
     * 备注
     */
    private String remark;

}
