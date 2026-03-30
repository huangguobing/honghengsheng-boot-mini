package cn.iocoder.stmc.module.erp.dal.mysql.purchase;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.module.erp.controller.admin.purchase.vo.PurchaseOrderPageReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * ERP 采购单 Mapper
 *
 * @author stmc
 */
@Mapper
public interface PurchaseOrderMapper extends BaseMapperX<PurchaseOrderDO> {

    default PageResult<PurchaseOrderDO> selectPage(PurchaseOrderPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<PurchaseOrderDO>()
                .inIfPresent(PurchaseOrderDO::getOrderId, reqVO.getVisibleOrderIds())
                .eqIfPresent(PurchaseOrderDO::getOrderId, reqVO.getOrderId())
                .eqIfPresent(PurchaseOrderDO::getSupplierId, reqVO.getSupplierId())
                .eqIfPresent(PurchaseOrderDO::getStatus, reqVO.getStatus())
                .likeIfPresent(PurchaseOrderDO::getPurchaseNo, reqVO.getPurchaseNo())
                .orderByDesc(PurchaseOrderDO::getCreateTime));
    }

    default List<PurchaseOrderDO> selectListByOrderId(Long orderId) {
        return selectList(PurchaseOrderDO::getOrderId, orderId);
    }

    default int deleteByOrderId(Long orderId) {
        return delete(new LambdaQueryWrapperX<PurchaseOrderDO>()
                .eq(PurchaseOrderDO::getOrderId, orderId));
    }

    default PurchaseOrderDO selectByPurchaseNo(String purchaseNo) {
        return selectOne(PurchaseOrderDO::getPurchaseNo, purchaseNo);
    }

}
