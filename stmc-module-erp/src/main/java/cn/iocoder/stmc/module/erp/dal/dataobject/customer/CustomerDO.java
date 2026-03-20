package cn.iocoder.stmc.module.erp.dal.dataobject.customer;

import cn.iocoder.stmc.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * ERP 客户 DO
 *
 * @author stmc
 */
@TableName("erp_customer")
@KeySequence("erp_customer_seq")
@Data
@EqualsAndHashCode(callSuper = true)
public class CustomerDO extends BaseDO {

    /**
     * 客户编号
     */
    @TableId
    private Long id;

    /**
     * 客户名称
     */
    private String name;

    /**
     * 客户编码
     */
    private String code;

    /**
     * 联系人
     */
    private String contact;

    /**
     * 联系电话
     */
    private String mobile;

    /**
     * 电子邮箱
     */
    private String email;

    /**
     * 传真
     */
    private String fax;

    /**
     * 地址
     */
    private String address;

    /**
     * 开户银行
     */
    private String bankName;

    /**
     * 银行账号
     */
    private String bankAccount;

    /**
     * 税号
     */
    private String taxNo;

    /**
     * 信用额度
     */
    private BigDecimal creditLimit;

    /**
     * 状态（0正常 1停用）
     */
    private Integer status;

    /**
     * 排序
     */
    private Integer sort;

    /**
     * 备注
     */
    private String remark;

    /**
     * 是否下级开单: 0=否 1=是
     * 标记为1时，A角色创建的订单会自动推送给下级录入
     */
    private Integer needIntermediary;

}
