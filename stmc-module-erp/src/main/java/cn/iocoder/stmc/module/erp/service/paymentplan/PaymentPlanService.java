package cn.iocoder.stmc.module.erp.service.paymentplan;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanPageReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.paymentplan.PaymentPlanDO;

import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanAvailableOrderRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanSaveReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.ReconcileSummaryVO;

import javax.validation.Valid;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * ERP 付款计划 Service 接口
 *
 * @author stmc
 */
public interface PaymentPlanService {

    /**
     * 根据付款单生成付款计划
     *
     * @param paymentId 付款单编号
     * @param supplierId 供应商编号
     * @param totalAmount 付款总金额
     * @param paymentDate 付款日期（作为计算账期的起始日期）
     * @param paymentNo 付款单号
     * @param paidStages 创建时标记为已付款的期数列表（可选）
     */
    void generatePaymentPlansForPayment(Long paymentId, Long supplierId, BigDecimal totalAmount,
                                         LocalDate paymentDate, String paymentNo, List<Integer> paidStages);

    /**
     * 获得付款计划
     *
     * @param id 编号
     * @return 付款计划
     */
    PaymentPlanDO getPaymentPlan(Long id);

    /**
     * 获取付款单的付款计划列表
     *
     * @param paymentId 付款单编号
     * @return 付款计划列表
     */
    List<PaymentPlanDO> getPaymentPlansByPaymentId(Long paymentId);

    /**
     * 根据订单ID获取收付款计划列表
     *
     * @param orderId 订单ID
     * @return 收付款计划列表
     */
    List<PaymentPlanDO> getPaymentPlansByOrderId(Long orderId);

    /**
     * 分页查询付款计划
     *
     * @param pageReqVO 分页查询条件
     * @return 付款计划分页
     */
    PageResult<PaymentPlanDO> getPaymentPlanPage(PaymentPlanPageReqVO pageReqVO);

    /**
     * 标记付款计划为已付款
     *
     * @param id 付款计划编号
     */
    void markAsPaid(Long id);

    /**
     * 取消付款单的付款计划
     *
     * @param paymentId 付款单编号
     */
    void cancelByPaymentId(Long paymentId);

    /**
     * 检查付款单是否存在已付款的计划
     *
     * @param paymentId 付款单编号
     * @return 是否存在已付款的计划
     */
    boolean hasPaidPlansByPaymentId(Long paymentId);

    /**
     * 处理付款计划通知
     * 包括：即将到期（提前3天）、当日到期、已逾期
     */
    void processPaymentPlanNotifications();

    /**
     * 创建单期付款计划（用于成本填充场景，不使用供应商账期配置）
     *
     * @param paymentId 付款单编号
     * @param supplierId 供应商编号
     * @param orderId 订单编号
     * @param amount 付款金额
     * @param planDate 计划付款日期
     * @param paymentNo 付款单号
     * @param isPaid 是否已付款
     * @param remark 备注
     */
    void createSinglePaymentPlan(Long paymentId, Long supplierId, Long orderId, BigDecimal amount,
                                  LocalDate planDate, String paymentNo, Boolean isPaid, String remark);

    /**
     * 取消付款单的所有付款计划（成本编辑时供应商被移除）
     *
     * @param paymentId 付款单编号
     */
    void cancelPaymentPlansByPaymentId(Long paymentId);

    /**
     * 更新付款计划（成本编辑时）
     *
     * @param paymentId 付款单编号
     * @param newAmount 新金额
     * @param newPlanDate 新计划日期
     * @param newIsPaid 新付款状态
     */
    void updatePaymentPlanFromCostEdit(Long paymentId, BigDecimal newAmount,
                                        LocalDate newPlanDate, Boolean newIsPaid);


    // ========== 鸿恒盛扩展：灵活收付款计划 ==========

    /**
     * 创建收付款计划
     */
    Long createPaymentPlan(@Valid PaymentPlanSaveReqVO reqVO);

    /**
     * 更新收付款计划
     */
    void updatePaymentPlan(@Valid PaymentPlanSaveReqVO reqVO);

    /**
     * 删除收付款计划（只能删未付款的）
     */
    void deletePaymentPlan(Long id);

    /**
     * 部分付款
     *
     * @param id 计划编号
     * @param amount 本次付款金额
     * @param paymentMethod 收付方式
     */
    void partialPay(Long id, BigDecimal amount, Integer paymentMethod);

    /**
     * 对账汇总
     *
     * @param type 类型：0=应付（按供应商汇总） 1=应收（按客户汇总）
     * @return 汇总列表
     */
    List<ReconcileSummaryVO> getReconcileSummary(Integer type);

    /**
     * 获取收付款计划可分配订单列表
     */
    List<PaymentPlanAvailableOrderRespVO> getAvailableOrderList(Integer type);
}
