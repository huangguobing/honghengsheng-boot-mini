package cn.iocoder.stmc.module.erp.dal.mysql.purchase;

import cn.iocoder.stmc.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderItemDO;
import org.apache.ibatis.annotations.Mapper;

import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import java.util.Collection;
import java.util.List;

/**
 * ERP 采购单明细 Mapper
 *
 * @author stmc
 */
@Mapper
public interface PurchaseOrderItemMapper extends BaseMapperX<PurchaseOrderItemDO> {

    default List<PurchaseOrderItemDO> selectListByPurchaseOrderId(Long purchaseOrderId) {
        return selectList(PurchaseOrderItemDO::getPurchaseOrderId, purchaseOrderId);
    }

    default List<PurchaseOrderItemDO> selectListByPurchaseOrderIds(Collection<Long> purchaseOrderIds) {
        return selectList(PurchaseOrderItemDO::getPurchaseOrderId, purchaseOrderIds);
    }

    default int deleteByPurchaseOrderIds(Collection<Long> purchaseOrderIds) {
        if (purchaseOrderIds == null || purchaseOrderIds.isEmpty()) {
            return 0;
        }
        return delete(new LambdaQueryWrapperX<PurchaseOrderItemDO>()
                .in(PurchaseOrderItemDO::getPurchaseOrderId, purchaseOrderIds));
    }

}
