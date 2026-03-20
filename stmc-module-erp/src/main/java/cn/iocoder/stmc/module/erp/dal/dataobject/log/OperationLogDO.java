package cn.iocoder.stmc.module.erp.dal.dataobject.log;

import cn.iocoder.stmc.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * ERP 操作日志 DO
 *
 * @author stmc
 */
@TableName("erp_operation_log")
@KeySequence("erp_operation_log_seq")
@Data
@EqualsAndHashCode(callSuper = true)
public class OperationLogDO extends BaseDO {

    @TableId
    private Long id;

    /**
     * 模块名（order/purchase/payment等）
     */
    private String module;

    /**
     * 业务ID
     */
    private Long businessId;

    /**
     * 业务单号
     */
    private String businessNo;

    /**
     * 操作类型（create/update/delete/status_change/return）
     */
    private String action;

    /**
     * 修改前数据（JSON）
     */
    private String beforeData;

    /**
     * 修改后数据（JSON）
     */
    private String afterData;

    /**
     * 操作描述
     */
    private String description;

    /**
     * 操作人ID
     */
    private Long operatorId;

    /**
     * 操作人姓名
     */
    private String operatorName;

    /**
     * 操作时间
     */
    private LocalDateTime operateTime;

    /**
     * 操作IP
     */
    private String ip;

}
