package cn.iocoder.stmc.module.erp.service.paymentplan;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.IdUtil;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanPreviewVO;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanSaveReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.ReconcileSummaryVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.paymentplan.PaymentPlanDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.paymentterm.PaymentTermConfigDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.supplier.SupplierDO;
import cn.iocoder.stmc.module.erp.dal.mysql.paymentplan.PaymentPlanMapper;
import cn.iocoder.stmc.module.erp.enums.PaymentPlanNotifyStatusEnum;
import cn.iocoder.stmc.module.erp.enums.PaymentPlanStatusEnum;
import cn.iocoder.stmc.module.erp.service.payment.PaymentService;
import cn.iocoder.stmc.module.erp.service.paymentterm.PaymentTermConfigService;
import cn.iocoder.stmc.module.erp.service.supplier.SupplierService;
import cn.iocoder.stmc.module.system.api.notify.NotifyMessageSendApi;
import cn.iocoder.stmc.module.system.api.notify.dto.NotifySendSingleToUserReqDTO;
import cn.iocoder.stmc.module.system.dal.dataobject.user.AdminUserDO;
import cn.iocoder.stmc.module.system.service.notify.NotifyMessageService;
import cn.iocoder.stmc.module.system.service.permission.PermissionService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

import static cn.iocoder.stmc.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.stmc.module.erp.enums.ErrorCodeConstants.*;

/**
 * ERP 付款计划 Service 实现类
 *
 * @author stmc
 */
@Slf4j
@Service
@Validated
public class PaymentPlanServiceImpl implements PaymentPlanService {

    /** 即将到期提醒天数 */
    private static final int UPCOMING_DAYS = 3;

    /** 通知模板编码 */
    private static final String NOTIFY_TEMPLATE_UPCOMING = "payment_plan_upcoming";
    private static final String NOTIFY_TEMPLATE_DUE_TODAY = "payment_plan_due_today";
    private static final String NOTIFY_TEMPLATE_OVERDUE = "payment_plan_overdue";

    /** 需要通知的角色ID：超管(1)和老板(2) */
    private static final List<Long> NOTIFY_ROLE_IDS = Arrays.asList(1L, 2L);

    @Resource
    private PaymentPlanMapper paymentPlanMapper;
    @Resource
    private PaymentTermConfigService paymentTermConfigService;
    @Resource
    private SupplierService supplierService;
    @Resource
    private NotifyMessageSendApi notifyMessageSendApi;
    @Resource
    private NotifyMessageService notifyMessageService;
    @Resource
    private PermissionService permissionService;
    @Resource
    @Lazy // 避免循环依赖
    private PaymentService paymentService;
    @Resource
    @Lazy
    private cn.iocoder.stmc.module.erp.service.order.OrderService orderService;
    @Resource
    private cn.iocoder.stmc.module.system.service.user.AdminUserService adminUserService;
    @Resource
    private cn.iocoder.stmc.module.erp.service.customer.CustomerService customerService;

    @Override
    public List<PaymentPlanPreviewVO> previewPaymentPlans(Long supplierId, BigDecimal totalAmount, LocalDate paymentDate) {
        // 1. 参数校验
        if (supplierId == null || totalAmount == null) {
            return Collections.emptyList();
        }
        if (paymentDate == null) {
            paymentDate = LocalDate.now();
        }

        // 2. 获取供应商的分期配置
        List<PaymentTermConfigDO> configs = paymentTermConfigService.getEnabledConfigsBySupplierId(supplierId);
        if (CollUtil.isEmpty(configs)) {
            return Collections.emptyList();
        }

        // 3. 生成预览数据
        LocalDate today = LocalDate.now();
        List<PaymentPlanPreviewVO> previewList = new ArrayList<>();
        for (PaymentTermConfigDO config : configs) {
            PaymentPlanPreviewVO preview = new PaymentPlanPreviewVO();
            preview.setStage(config.getStage());
            preview.setPercentage(config.getPercentage());

            // 计算付款金额
            BigDecimal planAmount = totalAmount
                    .multiply(config.getPercentage())
                    .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
            preview.setPlanAmount(planAmount);

            // 计算付款日期
            LocalDate planDate = paymentDate.plusDays(config.getDaysAfterOrder());
            preview.setPlanDate(planDate);

            // 判断是否当天到期
            preview.setIsToday(planDate.equals(today));

            previewList.add(preview);
        }

        return previewList;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void generatePaymentPlansForPayment(Long paymentId, Long supplierId, BigDecimal totalAmount,
                                                LocalDate paymentDate, String paymentNo, List<Integer> paidStages) {
        // 1. 参数校验
        if (paymentId == null || supplierId == null || totalAmount == null || paymentDate == null) {
            log.warn("[generatePaymentPlansForPayment] 参数不完整，跳过生成付款计划");
            return;
        }

        // 2. 获取供应商的分期配置
        List<PaymentTermConfigDO> configs = paymentTermConfigService.getEnabledConfigsBySupplierId(supplierId);
        if (CollUtil.isEmpty(configs)) {
            log.info("[generatePaymentPlansForPayment] 供应商[{}]未配置分期付款，跳过生成付款计划", supplierId);
            return;
        }

        // 3. 校验金额
        if (totalAmount.compareTo(BigDecimal.ZERO) <= 0) {
            log.info("[generatePaymentPlansForPayment] 付款单[{}]金额为0或负数，跳过生成付款计划", paymentNo);
            return;
        }

        // 4. 删除旧的付款计划（如果有）
        paymentPlanMapper.deleteByPaymentId(paymentId);

        // 5. 处理 paidStages 为 Set 便于查找
        Set<Integer> paidStageSet = CollUtil.isEmpty(paidStages) ? Collections.emptySet() : new HashSet<>(paidStages);

        // 6. 生成付款计划
        for (PaymentTermConfigDO config : configs) {
            PaymentPlanDO plan = new PaymentPlanDO();
            plan.setPlanNo(generatePlanNo());
            plan.setPaymentId(paymentId);
            plan.setPaymentNo(paymentNo);
            plan.setSupplierId(supplierId);
            plan.setConfigId(config.getId());
            plan.setStage(config.getStage());

            // 计算付款金额
            BigDecimal planAmount = totalAmount
                    .multiply(config.getPercentage())
                    .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
            plan.setPlanAmount(planAmount);

            // 计算付款日期
            LocalDate planDate = paymentDate.plusDays(config.getDaysAfterOrder());
            plan.setPlanDate(planDate);

            // 检查该期是否在 paidStages 中，直接标记为已付款
            if (paidStageSet.contains(config.getStage())) {
                plan.setActualAmount(planAmount);
                plan.setActualDate(LocalDateTime.now());
                plan.setStatus(PaymentPlanStatusEnum.PAID.getStatus());
                plan.setNotifyStatus(PaymentPlanNotifyStatusEnum.NOT_NOTIFIED.getStatus());
            } else {
                plan.setActualAmount(BigDecimal.ZERO);
                plan.setStatus(PaymentPlanStatusEnum.PENDING.getStatus());
                plan.setNotifyStatus(PaymentPlanNotifyStatusEnum.NOT_NOTIFIED.getStatus());
            }

            paymentPlanMapper.insert(plan);
        }

        log.info("[generatePaymentPlansForPayment] 付款单[{}]生成了{}条付款计划，其中{}条已标记为已付款",
                paymentNo, configs.size(), paidStageSet.size());

        // 7. 立即检查并发送当天到期或已过期的通知
        checkAndNotifyImmediately(paymentId);
    }

    @Override
    public PaymentPlanDO getPaymentPlan(Long id) {
        return paymentPlanMapper.selectById(id);
    }

    @Override
    public List<PaymentPlanDO> getPaymentPlansByPaymentId(Long paymentId) {
        return paymentPlanMapper.selectListByPaymentId(paymentId);
    }

    @Override
    public List<PaymentPlanDO> getPaymentPlansByOrderId(Long orderId) {
        return paymentPlanMapper.selectListByOrderId(orderId);
    }

    @Override
    public PageResult<PaymentPlanDO> getPaymentPlanPage(PaymentPlanPageReqVO pageReqVO) {
        return paymentPlanMapper.selectPage(pageReqVO);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void markAsPaid(Long id) {
        PaymentPlanDO plan = paymentPlanMapper.selectById(id);
        if (plan == null) {
            throw exception(PAYMENT_PLAN_NOT_EXISTS);
        }
        if (PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus())) {
            throw exception(PAYMENT_PLAN_ALREADY_PAID);
        }

        plan.setStatus(PaymentPlanStatusEnum.PAID.getStatus());
        plan.setPaidAmount(plan.getPlanAmount());
        plan.setActualAmount(plan.getPlanAmount());
        plan.setActualDate(LocalDateTime.now());
        paymentPlanMapper.updateById(plan);

        // 更新订单已收/已付金额
        if (plan.getOrderId() != null) {
            orderService.updateOrderPaidAmount(plan.getOrderId(), plan.getPlanAmount());
        }

        // 更新付款单状态
        paymentService.updatePaymentStatus(plan.getPaymentId());

        // 检查订单是否可以自动完成
        if (plan.getOrderId() != null) {
            orderService.checkAndAutoComplete(plan.getOrderId());
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelByPaymentId(Long paymentId) {
        List<PaymentPlanDO> plans = paymentPlanMapper.selectListByPaymentId(paymentId);
        for (PaymentPlanDO plan : plans) {
            // 只取消待付款状态的计划
            if (PaymentPlanStatusEnum.PENDING.getStatus().equals(plan.getStatus())) {
                plan.setStatus(PaymentPlanStatusEnum.CANCELLED.getStatus());
                paymentPlanMapper.updateById(plan);
            }
        }
    }

    @Override
    public boolean hasPaidPlansByPaymentId(Long paymentId) {
        List<PaymentPlanDO> plans = paymentPlanMapper.selectListByPaymentId(paymentId);
        if (CollUtil.isEmpty(plans)) {
            return false;
        }
        // 检查是否有已付款状态的计划
        return plans.stream()
                .anyMatch(plan -> PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus()));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void processPaymentPlanNotifications() {
        LocalDate today = LocalDate.now();
        LocalDate upcomingDate = today.plusDays(UPCOMING_DAYS);

        // 1. 获取需要通知的用户（老板和超管）
        Set<Long> notifyUserIds = getNotifyUserIds();
        if (CollUtil.isEmpty(notifyUserIds)) {
            log.warn("[processPaymentPlanNotifications] 未找到需要通知的用户（老板和超管角色）");
            return;
        }

        int upcomingCount = 0;
        int dueTodayCount = 0;
        int overdueCount = 0;

        // 2. 【已屏蔽】处理即将到期的付款计划（提前3天）
        // 根据需求优化，不再发送"即将到期"通知，只保留"当日到期"和"逾期"通知
        // List<PaymentPlanDO> upcomingPlans = paymentPlanMapper.selectUpcomingPlans(upcomingDate);
        // for (PaymentPlanDO plan : upcomingPlans) {
        //     sendUpcomingNotification(plan, notifyUserIds);
        //     plan.setNotifyStatus(PaymentPlanNotifyStatusEnum.NOTIFIED_UPCOMING.getStatus());
        //     paymentPlanMapper.updateById(plan);
        //     upcomingCount++;
        // }

        // 3. 处理今日到期的付款计划
        List<PaymentPlanDO> dueTodayPlans = paymentPlanMapper.selectDueTodayPlans(today);
        for (PaymentPlanDO plan : dueTodayPlans) {
            sendDueTodayNotification(plan, notifyUserIds);
            plan.setNotifyStatus(PaymentPlanNotifyStatusEnum.NOTIFIED_DUE_TODAY.getStatus());
            paymentPlanMapper.updateById(plan);
            dueTodayCount++;
        }

        // 4. 处理已逾期的付款计划
        List<PaymentPlanDO> overduePlans = paymentPlanMapper.selectOverduePlans(today);
        for (PaymentPlanDO plan : overduePlans) {
            // 更新状态为逾期
            plan.setStatus(PaymentPlanStatusEnum.OVERDUE.getStatus());
            sendOverdueNotification(plan, notifyUserIds);
            plan.setNotifyStatus(PaymentPlanNotifyStatusEnum.NOTIFIED_OVERDUE.getStatus());
            paymentPlanMapper.updateById(plan);
            overdueCount++;
        }

        log.info("[processPaymentPlanNotifications] 处理完成，即将到期:{}条，今日到期:{}条，已逾期:{}条",
                upcomingCount, dueTodayCount, overdueCount);
    }

    /**
     * 获取需要通知的用户ID集合（老板role_id=2和超管role_id=1）
     */
    private Set<Long> getNotifyUserIds() {
        return permissionService.getUserRoleIdListByRoleId(NOTIFY_ROLE_IDS);
    }

    /**
     * 发送即将到期通知（提前3天）
     */
    private void sendUpcomingNotification(PaymentPlanDO plan, Set<Long> userIds) {
        SupplierDO supplier = supplierService.getSupplier(plan.getSupplierId());
        String supplierName = supplier != null ? supplier.getName() : "未知供应商";

        Map<String, Object> params = new HashMap<>();
        params.put("orderNo", plan.getPaymentNo()); // 模板参数名为orderNo
        params.put("stage", plan.getStage());
        params.put("supplierName", supplierName);
        params.put("planAmount", plan.getPlanAmount().toString());
        params.put("planDate", plan.getPlanDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));

        sendNotification(userIds, NOTIFY_TEMPLATE_UPCOMING, params, plan.getId());
    }

    /**
     * 发送今日到期通知
     */
    private void sendDueTodayNotification(PaymentPlanDO plan, Set<Long> userIds) {
        SupplierDO supplier = supplierService.getSupplier(plan.getSupplierId());
        String supplierName = supplier != null ? supplier.getName() : "未知供应商";

        // 获取业务员名称
        String salesmanName = "未知业务员";
        if (plan.getOrderId() != null) {
            OrderDO order = orderService.getOrder(plan.getOrderId());
            if (order != null && order.getSalesmanId() != null) {
                AdminUserDO salesman = adminUserService.getUser(order.getSalesmanId());
                if (salesman != null) {
                    salesmanName = salesman.getNickname();
                }
            }
        }

        Map<String, Object> params = new HashMap<>();
        params.put("salesmanName", salesmanName);
        params.put("supplierName", supplierName);
        params.put("planAmount", plan.getPlanAmount().toString());

        sendNotification(userIds, NOTIFY_TEMPLATE_DUE_TODAY, params, plan.getId());
    }

    /**
     * 发送逾期通知
     */
    private void sendOverdueNotification(PaymentPlanDO plan, Set<Long> userIds) {
        // 发送逾期通知前，标记该付款计划之前的"当日到期"通知为已读
        // 防止同一付款计划重复提醒（一个付款计划只需要一次提醒）
        markPreviousDueTodayNotificationsAsRead(plan.getId());

        SupplierDO supplier = supplierService.getSupplier(plan.getSupplierId());
        String supplierName = supplier != null ? supplier.getName() : "未知供应商";

        long overdueDays = ChronoUnit.DAYS.between(plan.getPlanDate(), LocalDate.now());

        Map<String, Object> params = new HashMap<>();
        params.put("orderNo", plan.getPaymentNo()); // 模板参数名为orderNo
        params.put("stage", plan.getStage());
        params.put("supplierName", supplierName);
        params.put("planAmount", plan.getPlanAmount().toString());
        params.put("planDate", plan.getPlanDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        params.put("overdueDays", overdueDays);

        sendNotification(userIds, NOTIFY_TEMPLATE_OVERDUE, params, plan.getId());
    }

    /**
     * 发送通知给用户列表
     */
    private void sendNotification(Set<Long> userIds, String templateCode, Map<String, Object> params, Long planId) {
        for (Long userId : userIds) {
            try {
                NotifySendSingleToUserReqDTO reqDTO = new NotifySendSingleToUserReqDTO();
                reqDTO.setUserId(userId);
                reqDTO.setTemplateCode(templateCode);
                reqDTO.setTemplateParams(params);
                reqDTO.setBusinessId(planId); // 关联付款计划ID，用于后续防重和删除
                notifyMessageSendApi.sendSingleMessageToAdmin(reqDTO);
            } catch (Exception e) {
                log.error("[sendNotification] 发送通知失败，userId:{}, templateCode:{}, planId:{}",
                        userId, templateCode, planId, e);
            }
        }
    }

    /**
     * 立即检查并发送当天到期的通知
     * 场景：新增付款计划时，如果某期当天到期且未付款，立即发送通知
     */
    private void checkAndNotifyImmediately(Long paymentId) {
        LocalDate today = LocalDate.now();
        Set<Long> notifyUserIds = getNotifyUserIds();
        if (CollUtil.isEmpty(notifyUserIds)) {
            log.warn("[checkAndNotifyImmediately] 未找到需要通知的用户");
            return;
        }

        List<PaymentPlanDO> plans = paymentPlanMapper.selectListByPaymentId(paymentId);
        for (PaymentPlanDO plan : plans) {
            // 只处理待付款状态的计划
            if (!PaymentPlanStatusEnum.PENDING.getStatus().equals(plan.getStatus())) {
                continue;
            }

            LocalDate planDate = plan.getPlanDate();
            if (planDate == null) {
                continue;
            }

            // 当天到期且未付款，立即发送通知
            if (planDate.equals(today)) {
                sendDueTodayNotification(plan, notifyUserIds);
                plan.setNotifyStatus(PaymentPlanNotifyStatusEnum.NOTIFIED_DUE_TODAY.getStatus());
                paymentPlanMapper.updateById(plan);
                log.info("[checkAndNotifyImmediately] 付款计划[{}]当天到期且未付款，已发送即时通知", plan.getPlanNo());
            }
        }
    }

    /**
     * 生成付款计划单号
     */
    private String generatePlanNo() {
        return "PP" + IdUtil.getSnowflakeNextIdStr();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void createSinglePaymentPlan(Long paymentId, Long supplierId, Long orderId, BigDecimal amount,
                                         LocalDate planDate, String paymentNo, Boolean isPaid, String remark) {
        // 1. 参数校验
        if (paymentId == null || supplierId == null || amount == null || planDate == null) {
            log.warn("[createSinglePaymentPlan] 参数不完整，跳过创建付款计划");
            return;
        }

        // 2. 校验金额
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            log.info("[createSinglePaymentPlan] 付款金额为0或负数，跳过创建付款计划");
            return;
        }

        // 3. 创建单期付款计划
        PaymentPlanDO plan = new PaymentPlanDO();
        plan.setPlanNo(generatePlanNo());
        plan.setPaymentId(paymentId);
        plan.setPaymentNo(paymentNo);
        plan.setSupplierId(supplierId);
        plan.setOrderId(orderId); // 直接关联订单ID
        plan.setConfigId(null); // 不关联账期配置
        plan.setStage(1); // 单期
        plan.setPlanAmount(amount);
        plan.setPlanDate(planDate);
        plan.setRemark(remark); // 设置备注

        // 4. 根据是否已付款设置状态
        if (Boolean.TRUE.equals(isPaid)) {
            plan.setActualAmount(amount);
            plan.setActualDate(LocalDateTime.now());
            plan.setStatus(PaymentPlanStatusEnum.PAID.getStatus());
        } else {
            plan.setActualAmount(BigDecimal.ZERO);
            plan.setStatus(PaymentPlanStatusEnum.PENDING.getStatus());
        }
        plan.setNotifyStatus(PaymentPlanNotifyStatusEnum.NOT_NOTIFIED.getStatus());

        paymentPlanMapper.insert(plan);

        log.info("[createSinglePaymentPlan] 创建单期付款计划成功，paymentNo:{}, amount:{}, isPaid:{}, remark:{}",
                paymentNo, amount, isPaid, remark);

        // 5. 如果是待付款状态且当天到期，立即发送通知
        if (!Boolean.TRUE.equals(isPaid)) {
            checkAndNotifySinglePlan(plan);
        }
    }

    /**
     * 检查单个付款计划是否需要立即发送通知
     */
    private void checkAndNotifySinglePlan(PaymentPlanDO plan) {
        LocalDate today = LocalDate.now();
        LocalDate planDate = plan.getPlanDate();
        if (planDate == null) {
            return;
        }

        Set<Long> notifyUserIds = getNotifyUserIds();
        if (CollUtil.isEmpty(notifyUserIds)) {
            return;
        }

        // 当天到期且未付款，立即发送通知
        if (planDate.equals(today)) {
            sendDueTodayNotification(plan, notifyUserIds);
            plan.setNotifyStatus(PaymentPlanNotifyStatusEnum.NOTIFIED_DUE_TODAY.getStatus());
            paymentPlanMapper.updateById(plan);
            log.info("[checkAndNotifySinglePlan] 付款计划[{}]当天到期且未付款，已发送即时通知", plan.getPlanNo());
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelPaymentPlansByPaymentId(Long paymentId) {
        List<PaymentPlanDO> plans = paymentPlanMapper.selectListByPaymentId(paymentId);
        for (PaymentPlanDO plan : plans) {
            // 只取消未付款的计划
            if (!PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus())) {
                PaymentPlanDO update = new PaymentPlanDO();
                update.setId(plan.getId());
                update.setStatus(PaymentPlanStatusEnum.CANCELLED.getStatus());
                paymentPlanMapper.updateById(update);
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePaymentPlanFromCostEdit(Long paymentId, BigDecimal newAmount,
                                               LocalDate newPlanDate, Boolean newIsPaid) {
        // 成本填充创建的是单期付款计划（stage=1）
        List<PaymentPlanDO> plans = paymentPlanMapper.selectListByPaymentId(paymentId);
        if (plans.isEmpty()) {
            log.warn("[updatePaymentPlanFromCostEdit] 未找到付款计划，paymentId={}", paymentId);
            return;
        }

        // 只更新第一个计划（单期）
        PaymentPlanDO plan = plans.get(0);

        // 如果已付款，不允许修改
        if (PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus())) {
            throw exception(PAYMENT_PLAN_ALREADY_PAID_CANNOT_EDIT);
        }

        PaymentPlanDO update = new PaymentPlanDO();
        update.setId(plan.getId());
        update.setPlanAmount(newAmount);
        update.setPlanDate(newPlanDate);

        if (Boolean.TRUE.equals(newIsPaid)) {
            update.setActualAmount(newAmount);
            update.setActualDate(LocalDateTime.now());
            update.setStatus(PaymentPlanStatusEnum.PAID.getStatus());
        } else {
            update.setActualAmount(BigDecimal.ZERO);
            update.setActualDate(null);
            update.setStatus(PaymentPlanStatusEnum.PENDING.getStatus());
        }

        paymentPlanMapper.updateById(update);
    }

    /**
     * 标记指定付款计划的"当日到期"通知为已读
     * 用于逾期通知发送前，避免同一付款计划重复提醒
     */
    private void markPreviousDueTodayNotificationsAsRead(Long planId) {
        int updated = notifyMessageService.markReadByBusinessIdAndTemplate(planId, NOTIFY_TEMPLATE_DUE_TODAY);
        if (updated > 0) {
            log.info("[markPreviousDueTodayNotificationsAsRead] 标记{}条当日到期通知为已读，planId:{}", updated, planId);
        }
    }

    @Override
    public void deleteNotificationsByPlanIds(Collection<Long> planIds) {
        if (CollUtil.isEmpty(planIds)) {
            return;
        }
        int deleted = notifyMessageService.deleteByBusinessIds(planIds);
        log.info("[deleteNotificationsByPlanIds] 删除{}条通知，planIds:{}", deleted, planIds);
    }

    // ========== 鸿恒盛扩展：灵活收付款计划 ==========

    @Override
    public Long createPaymentPlan(PaymentPlanSaveReqVO reqVO) {
        PaymentPlanDO plan = new PaymentPlanDO();
        plan.setPlanNo(generatePlanNo());
        plan.setType(reqVO.getType());
        plan.setOrderId(reqVO.getOrderId());
        plan.setPurchaseOrderId(reqVO.getPurchaseOrderId());
        plan.setSupplierId(reqVO.getSupplierId());
        plan.setCustomerId(reqVO.getCustomerId());
        plan.setProjectId(reqVO.getProjectId());
        plan.setPlanAmount(reqVO.getPlanAmount());
        plan.setPaidAmount(reqVO.getPaidAmount() != null ? reqVO.getPaidAmount() : BigDecimal.ZERO);
        plan.setPaymentMethod(reqVO.getPaymentMethod());
        plan.setPlanDate(reqVO.getPlanDate());
        plan.setRemark(reqVO.getRemark());
        plan.setStage(1); // 灵活添加默认单期
        plan.setActualAmount(BigDecimal.ZERO);
        // 如果前端传入了 status（如直接标记为已付款），则使用该值，否则默认待付款
        plan.setStatus(reqVO.getStatus() != null ? reqVO.getStatus() : PaymentPlanStatusEnum.PENDING.getStatus());
        plan.setNotifyStatus(PaymentPlanNotifyStatusEnum.NOT_NOTIFIED.getStatus());
        paymentPlanMapper.insert(plan);
        return plan.getId();
    }

    @Override
    public void updatePaymentPlan(PaymentPlanSaveReqVO reqVO) {
        PaymentPlanDO plan = paymentPlanMapper.selectById(reqVO.getId());
        if (plan == null) {
            throw exception(PAYMENT_PLAN_NOT_EXISTS);
        }
        PaymentPlanDO update = new PaymentPlanDO();
        update.setId(reqVO.getId());
        update.setType(reqVO.getType());
        update.setOrderId(reqVO.getOrderId());
        update.setPurchaseOrderId(reqVO.getPurchaseOrderId());
        update.setSupplierId(reqVO.getSupplierId());
        update.setCustomerId(reqVO.getCustomerId());
        update.setProjectId(reqVO.getProjectId());
        update.setPlanAmount(reqVO.getPlanAmount());
        update.setPaymentMethod(reqVO.getPaymentMethod());
        update.setPlanDate(reqVO.getPlanDate());
        update.setRemark(reqVO.getRemark());
        // 如果修改了已付款的计划，重置为待付款状态
        if (PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus())) {
            update.setStatus(PaymentPlanStatusEnum.PENDING.getStatus());
            update.setPaidAmount(BigDecimal.ZERO);
            update.setActualAmount(BigDecimal.ZERO);
            update.setActualDate(null);
        }
        paymentPlanMapper.updateById(update);
    }

    @Override
    public void deletePaymentPlan(Long id) {
        PaymentPlanDO plan = paymentPlanMapper.selectById(id);
        if (plan == null) {
            throw exception(PAYMENT_PLAN_NOT_EXISTS);
        }
        // 允许删除任何状态的计划（包括已付款）
        paymentPlanMapper.deleteById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void partialPay(Long id, BigDecimal amount, Integer paymentMethod) {
        PaymentPlanDO plan = paymentPlanMapper.selectById(id);
        if (plan == null) {
            throw exception(PAYMENT_PLAN_NOT_EXISTS);
        }
        if (PaymentPlanStatusEnum.PAID.getStatus().equals(plan.getStatus())) {
            throw exception(PAYMENT_PLAN_ALREADY_PAID);
        }

        BigDecimal currentPaid = plan.getPaidAmount() != null ? plan.getPaidAmount() : BigDecimal.ZERO;
        BigDecimal planAmount = plan.getPlanAmount() != null ? plan.getPlanAmount() : BigDecimal.ZERO;
        BigDecimal remaining = planAmount.subtract(currentPaid);
        if (amount.compareTo(remaining) > 0) {
            throw exception(PAYMENT_PLAN_PARTIAL_PAY_EXCEEDS,
                    planAmount, currentPaid, remaining, amount);
        }

        BigDecimal newPaid = currentPaid.add(amount);

        PaymentPlanDO update = new PaymentPlanDO();
        update.setId(id);
        update.setPaidAmount(newPaid);
        update.setPaymentMethod(paymentMethod);
        update.setActualDate(LocalDateTime.now());

        if (newPaid.compareTo(planAmount) >= 0) {
            update.setStatus(PaymentPlanStatusEnum.PAID.getStatus());
            update.setActualAmount(newPaid);
        }
        paymentPlanMapper.updateById(update);

        // 如果已付清，检查订单是否可以自动完成
        if (newPaid.compareTo(planAmount) >= 0 && plan.getOrderId() != null) {
            orderService.checkAndAutoComplete(plan.getOrderId());
        }
    }

    @Override
    public List<ReconcileSummaryVO> getReconcileSummary(Integer type) {
        List<PaymentPlanDO> plans = paymentPlanMapper.selectListByType(type);
        if (CollUtil.isEmpty(plans)) {
            return Collections.emptyList();
        }

        // 按目标ID分组：type=0 按供应商，type=1 按客户
        Map<Long, List<PaymentPlanDO>> grouped;
        if (Integer.valueOf(0).equals(type)) {
            grouped = plans.stream()
                    .filter(p -> p.getSupplierId() != null)
                    .collect(Collectors.groupingBy(PaymentPlanDO::getSupplierId));
        } else {
            grouped = plans.stream()
                    .filter(p -> p.getCustomerId() != null)
                    .collect(Collectors.groupingBy(PaymentPlanDO::getCustomerId));
        }

        // 获取名称映射
        Map<Long, String> nameMap = new HashMap<>();
        if (Integer.valueOf(0).equals(type)) {
            Map<Long, cn.iocoder.stmc.module.erp.dal.dataobject.supplier.SupplierDO> supplierMap =
                    supplierService.getSupplierMap(grouped.keySet());
            supplierMap.forEach((k, v) -> nameMap.put(k, v.getName()));
        } else {
            Map<Long, cn.iocoder.stmc.module.erp.dal.dataobject.customer.CustomerDO> customerMap =
                    customerService.getCustomerMap(grouped.keySet());
            customerMap.forEach((k, v) -> nameMap.put(k, v.getName()));
        }

        List<ReconcileSummaryVO> result = new ArrayList<>();
        for (Map.Entry<Long, List<PaymentPlanDO>> entry : grouped.entrySet()) {
            ReconcileSummaryVO vo = new ReconcileSummaryVO();
            vo.setTargetId(entry.getKey());
            vo.setTargetName(nameMap.getOrDefault(entry.getKey(), "未知"));
            vo.setPlanCount(entry.getValue().size());

            BigDecimal totalAmount = BigDecimal.ZERO;
            BigDecimal paidAmount = BigDecimal.ZERO;
            for (PaymentPlanDO p : entry.getValue()) {
                if (p.getPlanAmount() != null) {
                    totalAmount = totalAmount.add(p.getPlanAmount());
                }
                if (p.getPaidAmount() != null) {
                    paidAmount = paidAmount.add(p.getPaidAmount());
                }
            }
            vo.setTotalAmount(totalAmount);
            vo.setPaidAmount(paidAmount);
            vo.setUnpaidAmount(totalAmount.subtract(paidAmount));
            result.add(vo);
        }
        return result;
    }

}
