package cn.iocoder.stmc.module.erp.service.log;

import cn.iocoder.stmc.module.erp.dal.dataobject.log.OperationLogDO;

import java.util.List;

/**
 * ERP 操作日志 Service 接口
 *
 * @author stmc
 */
public interface OperationLogService {

    /**
     * 记录操作日志（自动获取当前用户ID/姓名/IP）
     *
     * @param module 模块名
     * @param businessId 业务ID
     * @param businessNo 业务单号
     * @param action 操作类型
     * @param beforeJson 修改前数据JSON
     * @param afterJson 修改后数据JSON
     * @param description 操作描述
     */
    void log(String module, Long businessId, String businessNo,
             String action, String beforeJson, String afterJson, String description);

    /**
     * 按业务查日志列表
     *
     * @param module 模块名
     * @param businessId 业务ID
     * @return 日志列表
     */
    List<OperationLogDO> getLogsByBusiness(String module, Long businessId);

}
