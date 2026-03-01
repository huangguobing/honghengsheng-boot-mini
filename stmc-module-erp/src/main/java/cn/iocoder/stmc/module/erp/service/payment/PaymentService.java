package cn.iocoder.stmc.module.erp.service.payment;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.module.erp.controller.admin.payment.vo.PaymentPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.payment.vo.PaymentSaveReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.payment.vo.PaymentSupplierSummaryRespVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.payment.PaymentDO;

import javax.validation.Valid;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * ERP 付款 Service 接口
 *
 * @author stmc
 */
public interface PaymentService {

    /**
     * 创建付款
     *
     * @param createReqVO 创建信息
     * @return 编号
     */
    Long createPayment(@Valid PaymentSaveReqVO createReqVO);

    /**
     * 更新付款
     *
     * @param updateReqVO 更新信息
     */
    void updatePayment(@Valid PaymentSaveReqVO updateReqVO);

    /**
     * 更新付款单状态（根据付款计划的完成情况）
     *
     * @param paymentId 付款单编号
     */
    void updatePaymentStatus(Long paymentId);

    /**
     * 删除付款
     *
     * @param id 编号
     */
    void deletePayment(Long id);

    /**
     * 批量删除付款
     *
     * @param ids 编号列表
     */
    void deletePaymentList(List<Long> ids);

    /**
     * 获得付款
     *
     * @param id 编号
     * @return 付款
     */
    PaymentDO getPayment(Long id);

    /**
     * 获得付款分页
     *
     * @param pageReqVO 分页查询
     * @return 付款分页
     */
    PageResult<PaymentDO> getPaymentPage(PaymentPageReqVO pageReqVO);

    /**
     * 创建成本填充场景的付款单（单期，不使用供应商账期配置）
     *
     * @param supplierId 供应商编号
     * @param orderId 订单编号
     * @param amount 付款金额
     * @param paymentDate 付款日期
     * @param isPaid 是否已付款
     * @param remark 备注
     * @return 付款单编号
     */
    Long createPaymentFromCostFill(Long supplierId, Long orderId, BigDecimal amount,
                                    LocalDate paymentDate, Boolean isPaid, String remark);

    /**
     * 取消指定订单和供应商的付款单（成本编辑时供应商被移除）
     *
     * @param orderId 订单编号
     * @param supplierId 供应商编号
     */
    void cancelPaymentByOrderAndSupplier(Long orderId, Long supplierId);

    /**
     * 更新付款单（成本编辑时）
     *
     * @param orderId 订单编号
     * @param supplierId 供应商编号
     * @param newAmount 新金额
     * @param newPaymentDate 新付款日期
     * @param newIsPaid 新付款状态
     * @param newRemark 新备注
     */
    void updatePaymentFromCostEdit(Long orderId, Long supplierId, BigDecimal newAmount,
                                    LocalDate newPaymentDate, Boolean newIsPaid, String newRemark);

    /**
     * 获取供应商未付款汇总
     *
     * @return 供应商未付款汇总列表
     */
    List<PaymentSupplierSummaryRespVO> getUnpaidSupplierSummary();

}
