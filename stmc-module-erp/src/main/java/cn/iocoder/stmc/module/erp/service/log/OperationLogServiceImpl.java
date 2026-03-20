package cn.iocoder.stmc.module.erp.service.log;

import cn.iocoder.stmc.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.stmc.module.erp.dal.dataobject.log.OperationLogDO;
import cn.iocoder.stmc.module.erp.dal.mysql.log.OperationLogMapper;
import cn.iocoder.stmc.module.system.api.user.AdminUserApi;
import cn.iocoder.stmc.module.system.api.user.dto.AdminUserRespDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.List;

/**
 * ERP 操作日志 Service 实现类
 *
 * @author stmc
 */
@Slf4j
@Service
@Validated
public class OperationLogServiceImpl implements OperationLogService {

    @Resource
    private OperationLogMapper operationLogMapper;

    @Resource
    private AdminUserApi adminUserApi;

    @Override
    public void log(String module, Long businessId, String businessNo,
                    String action, String beforeJson, String afterJson, String description) {
        try {
            OperationLogDO logDO = new OperationLogDO();
            logDO.setModule(module);
            logDO.setBusinessId(businessId);
            logDO.setBusinessNo(businessNo);
            logDO.setAction(action);
            logDO.setBeforeData(beforeJson);
            logDO.setAfterData(afterJson);
            logDO.setDescription(description);
            logDO.setOperateTime(LocalDateTime.now());

            // 获取当前用户信息
            Long userId = SecurityFrameworkUtils.getLoginUserId();
            logDO.setOperatorId(userId);
            if (userId != null) {
                AdminUserRespDTO user = adminUserApi.getUser(userId);
                if (user != null) {
                    logDO.setOperatorName(user.getNickname());
                }
            }

            // 获取IP
            logDO.setIp(getClientIp());

            operationLogMapper.insert(logDO);
        } catch (Exception e) {
            log.error("[log] 记录操作日志失败, module={}, businessId={}", module, businessId, e);
        }
    }

    @Override
    public List<OperationLogDO> getLogsByBusiness(String module, Long businessId) {
        return operationLogMapper.selectListByBusiness(module, businessId);
    }

    private String getClientIp() {
        try {
            ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs != null) {
                HttpServletRequest request = attrs.getRequest();
                String ip = request.getHeader("X-Forwarded-For");
                if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
                    ip = request.getHeader("X-Real-IP");
                }
                if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
                    ip = request.getRemoteAddr();
                }
                return ip != null && ip.contains(",") ? ip.split(",")[0].trim() : ip;
            }
        } catch (Exception e) {
            // ignore
        }
        return null;
    }

}
