package cn.iocoder.stmc.module.erp.dal.dataobject.project;

import cn.iocoder.stmc.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * ERP 项目/工地 DO
 *
 * @author stmc
 */
@TableName("erp_project")
@KeySequence("erp_project_seq")
@Data
@EqualsAndHashCode(callSuper = true)
public class ProjectDO extends BaseDO {

    /**
     * 项目编号
     */
    @TableId
    private Long id;

    /**
     * 父项目ID，NULL=一级项目（工地）
     */
    private Long parentId;

    /**
     * 所属客户ID
     */
    private Long customerId;

    /**
     * 项目/工地名称
     */
    private String name;

    /**
     * 工地地址
     */
    private String address;

    /**
     * 现场联系人
     */
    private String contact;

    /**
     * 现场联系电话
     */
    private String phone;

    /**
     * 收货单位
     */
    private String receivingUnit;

    /**
     * 投资模式: 0=单独投资 1=合作投资
     */
    private Integer investmentType;

    /**
     * 合作方信息
     */
    private String partnerInfo;

    /**
     * 合同编号
     */
    private String contractNo;

    /**
     * 合同金额
     */
    private BigDecimal contractAmount;

    /**
     * 打印模板: 1/2/3
     */
    private Integer printTemplateId;

    /**
     * 状态: 0=进行中 1=已完工
     */
    private Integer status;

}
