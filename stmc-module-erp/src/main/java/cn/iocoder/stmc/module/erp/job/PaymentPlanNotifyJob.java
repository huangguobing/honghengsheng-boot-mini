package cn.iocoder.stmc.module.erp.job;

import cn.iocoder.stmc.framework.tenant.core.aop.TenantIgnore;
import cn.iocoder.stmc.framework.tenant.core.util.TenantUtils;
import cn.iocoder.stmc.module.erp.service.paymentplan.PaymentPlanService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

/**
 * 付款计划通知定时任务
 *
 * 每天早上5:00自动执行，检查付款计划并发送站内信通知：
 * 1. 提前3天到期的付款计划 - 发送即将到期通知
 * 2. 当天到期的付款计划 - 发送今日到期通知
 * 3. 已逾期的付款计划 - 更新状态并发送逾期通知
 *
 * 通知对象：老板(role_id=2)和超管(role_id=1)角色的用户
 *
 * @author stmc
 */
@Slf4j
@Component
public class PaymentPlanNotifyJob {

    /** 默认租户ID */
    private static final Long DEFAULT_TENANT_ID = 1L;

    @Resource
    private PaymentPlanService paymentPlanService;

    /**
     * 定时任务：每天早上5:00执行
     * 使用 @Scheduled 注解，应用启动后自动运行，无需手动配置
     */
    @Scheduled(cron = "0 0 5 * * ?")
    @TenantIgnore // 忽略租户过滤，手动设置租户上下文
    public void execute() {
        log.info("[PaymentPlanNotifyJob] 付款计划通知任务已停用，跳过执行");
    }

}

