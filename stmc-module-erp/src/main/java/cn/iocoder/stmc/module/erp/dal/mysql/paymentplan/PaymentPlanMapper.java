package cn.iocoder.stmc.module.erp.dal.mysql.paymentplan;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanPageReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.paymentplan.PaymentPlanDO;
import cn.iocoder.stmc.module.erp.enums.PaymentPlanStatusEnum;
import org.apache.ibatis.annotations.Mapper;

import java.time.LocalDate;
import java.util.List;

/**
 * ERP 付款计划 Mapper
 *
 * @author stmc
 */
@Mapper
public interface PaymentPlanMapper extends BaseMapperX<PaymentPlanDO> {

    default PageResult<PaymentPlanDO> selectPage(PaymentPlanPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<PaymentPlanDO>()
                .likeIfPresent(PaymentPlanDO::getPaymentNo, reqVO.getPaymentNo())
                .eqIfPresent(PaymentPlanDO::getSupplierId, reqVO.getSupplierId())
                .eqIfPresent(PaymentPlanDO::getStatus, reqVO.getStatus())
                .inIfPresent(PaymentPlanDO::getStatus, reqVO.getStatusList())
                .eqIfPresent(PaymentPlanDO::getType, reqVO.getType())
                .eqIfPresent(PaymentPlanDO::getCustomerId, reqVO.getCustomerId())
                .eqIfPresent(PaymentPlanDO::getProjectId, reqVO.getProjectId())
                .eqIfPresent(PaymentPlanDO::getPaymentMethod, reqVO.getPaymentMethod())
                .eqIfPresent(PaymentPlanDO::getOrderId, reqVO.getOrderId())
                .geIfPresent(PaymentPlanDO::getActualDate,
                        reqVO.getActualDateStart() != null ? reqVO.getActualDateStart().atStartOfDay() : null)
                .leIfPresent(PaymentPlanDO::getActualDate,
                        reqVO.getActualDateEnd() != null ? reqVO.getActualDateEnd().atTime(23, 59, 59) : null)
                .last("ORDER BY CASE WHEN status IN (0, 5, 20) THEN 0 ELSE 1 END ASC, id DESC"));
    }

    default List<PaymentPlanDO> selectListByPaymentId(Long paymentId) {
        return selectList(new LambdaQueryWrapperX<PaymentPlanDO>()
                .eq(PaymentPlanDO::getPaymentId, paymentId)
                .orderByAsc(PaymentPlanDO::getStage));
    }
//
//    /**
//     * 查询即将到期的付款计划（指定日期且未通知即将到期）
//     */
//    default List<PaymentPlanDO> selectUpcomingPlans(LocalDate targetDate) {
//        return selectList(new LambdaQueryWrapperX<PaymentPlanDO>()
//                .eq(PaymentPlanDO::getStatus, PaymentPlanStatusEnum.PENDING.getStatus())
//                .eq(PaymentPlanDO::getPlanDate, targetDate)
//                .lt(PaymentPlanDO::getNotifyStatus, 1)); // 未通知即将到期
//    }
//
//    /**
//     * 查询今日到期的付款计划（当日且未通知当日到期）
//     */
//    default List<PaymentPlanDO> selectDueTodayPlans(LocalDate today) {
//        return selectList(new LambdaQueryWrapperX<PaymentPlanDO>()
//                .eq(PaymentPlanDO::getStatus, PaymentPlanStatusEnum.PENDING.getStatus())
//                .eq(PaymentPlanDO::getPlanDate, today)
//                .lt(PaymentPlanDO::getNotifyStatus, 2)); // 未通知当日到期
//    }
//
//    /**
//     * 查询已逾期的付款计划
//     */
//    default List<PaymentPlanDO> selectOverduePlans(LocalDate today) {
//        return selectList(new LambdaQueryWrapperX<PaymentPlanDO>()
//                .eq(PaymentPlanDO::getStatus, PaymentPlanStatusEnum.PENDING.getStatus())
//                .lt(PaymentPlanDO::getPlanDate, today)
//                .lt(PaymentPlanDO::getNotifyStatus, 3)); // 未通知逾期
//    }

    default void deleteByPaymentId(Long paymentId) {
        delete(PaymentPlanDO::getPaymentId, paymentId);
    }

    /**
     * 根据状态统计付款计划数量
     */
    default Long selectCountByStatus(Integer status) {
        return selectCount(new LambdaQueryWrapperX<PaymentPlanDO>()
                .eq(PaymentPlanDO::getStatus, status));
    }

    /**
     * 根据多个状态统计付款计划数量（待付款 + 已逾期）
     */
    default Long selectCountByStatuses(Integer... statuses) {
        return selectCount(new LambdaQueryWrapperX<PaymentPlanDO>()
                .in(PaymentPlanDO::getStatus, (Object[]) statuses));
    }

    /**
     * 根据订单ID物理删除付款计划
     *
     * @param orderId 订单ID
     * @return 删除的记录数
     */
    default int deleteByOrderId(Long orderId) {
        return delete(new LambdaQueryWrapperX<PaymentPlanDO>()
                .eq(PaymentPlanDO::getOrderId, orderId));
    }

    /**
     * 根据订单ID查询付款计划列表
     *
     * @param orderId 订单ID
     * @return 付款计划列表
     */
    default List<PaymentPlanDO> selectListByOrderId(Long orderId) {
        return selectList(new LambdaQueryWrapperX<PaymentPlanDO>()
                .eq(PaymentPlanDO::getOrderId, orderId));
    }

    /**
     * 根据采购单ID查询付款计划列表
     */
    default List<PaymentPlanDO> selectListByPurchaseOrderId(Long purchaseOrderId) {
        return selectList(new LambdaQueryWrapperX<PaymentPlanDO>()
                .eq(PaymentPlanDO::getPurchaseOrderId, purchaseOrderId));
    }

    /**
     * 按客户查询付款计划（应收）
     */
    default List<PaymentPlanDO> selectListByCustomerId(Long customerId) {
        return selectList(new LambdaQueryWrapperX<PaymentPlanDO>()
                .eq(PaymentPlanDO::getCustomerId, customerId)
                .orderByDesc(PaymentPlanDO::getId));
    }

    /**
     * 按项目查询付款计划（应收）
     */
    default List<PaymentPlanDO> selectListByProjectId(Long projectId) {
        return selectList(new LambdaQueryWrapperX<PaymentPlanDO>()
                .eq(PaymentPlanDO::getProjectId, projectId)
                .orderByDesc(PaymentPlanDO::getId));
    }

    /**
     * 按类型查询未结清的付款计划（用于对账汇总，只统计待付款/部分付款，兼容历史逾期）
     */
    default List<PaymentPlanDO> selectListByType(Integer type) {
        return selectList(new LambdaQueryWrapperX<PaymentPlanDO>()
                .eq(PaymentPlanDO::getType, type)
                .in(PaymentPlanDO::getStatus,
                        PaymentPlanStatusEnum.PENDING.getStatus(),
                        PaymentPlanStatusEnum.PARTIAL.getStatus(),
                        PaymentPlanStatusEnum.OVERDUE.getStatus()));
    }

}
