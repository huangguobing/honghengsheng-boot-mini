package cn.iocoder.stmc.module.erp.dal.mysql.payment;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.module.erp.controller.admin.payment.vo.PaymentPageReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.payment.PaymentDO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

/**
 * ERP 付款 Mapper
 *
 * @author stmc
 */
@Mapper
public interface PaymentMapper extends BaseMapperX<PaymentDO> {

    default PageResult<PaymentDO> selectPage(PaymentPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<PaymentDO>()
                .likeIfPresent(PaymentDO::getPaymentNo, reqVO.getPaymentNo())
                .eqIfPresent(PaymentDO::getSupplierId, reqVO.getSupplierId())
                .eqIfPresent(PaymentDO::getOrderId, reqVO.getOrderId())
                .eqIfPresent(PaymentDO::getPaymentType, reqVO.getPaymentType())
                .eqIfPresent(PaymentDO::getStatus, reqVO.getStatus())
                .betweenIfPresent(PaymentDO::getPaymentDate, reqVO.getPaymentDate())
                .betweenIfPresent(PaymentDO::getCreateTime, reqVO.getCreateTime())
                .orderByDesc(PaymentDO::getId));
    }

    default PaymentDO selectByPaymentNo(String paymentNo) {
        return selectOne(PaymentDO::getPaymentNo, paymentNo);
    }

    /**
     * 根据订单ID和供应商ID查询付款单
     *
     * @param orderId 订单ID
     * @param supplierId 供应商ID
     * @return 付款单
     */
    default PaymentDO selectByOrderIdAndSupplierId(Long orderId, Long supplierId) {
        return selectOne(new LambdaQueryWrapperX<PaymentDO>()
                .eq(PaymentDO::getOrderId, orderId)
                .eq(PaymentDO::getSupplierId, supplierId)
                .last("LIMIT 1"));
    }

    /**
     * 根据订单ID物理删除付款单
     *
     * @param orderId 订单ID
     * @return 删除的记录数
     */
    default int deleteByOrderId(Long orderId) {
        return delete(new LambdaQueryWrapperX<PaymentDO>()
                .eq(PaymentDO::getOrderId, orderId));
    }

    /**
     * 根据订单ID查询付款单列表
     *
     * @param orderId 订单ID
     * @return 付款单列表
     */
    default List<PaymentDO> selectListByOrderId(Long orderId) {
        return selectList(new LambdaQueryWrapperX<PaymentDO>()
                .eq(PaymentDO::getOrderId, orderId));
    }

    /**
     * 查询未付款供应商汇总（status IN (0, 10)）
     */
    @Select("SELECT supplier_id AS supplierId, COUNT(*) AS unpaidCount, COALESCE(SUM(amount), 0) AS unpaidAmount " +
            "FROM erp_payment WHERE deleted = 0 AND status IN (0, 10) " +
            "GROUP BY supplier_id ORDER BY unpaidAmount DESC")
    List<Map<String, Object>> selectUnpaidSupplierSummary();

}
