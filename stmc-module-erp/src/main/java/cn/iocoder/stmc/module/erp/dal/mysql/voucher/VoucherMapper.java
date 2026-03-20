package cn.iocoder.stmc.module.erp.dal.mysql.voucher;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.module.erp.controller.admin.voucher.vo.VoucherPageReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.voucher.VoucherDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * ERP 票据凭证 Mapper
 *
 * @author stmc
 */
@Mapper
public interface VoucherMapper extends BaseMapperX<VoucherDO> {

    default PageResult<VoucherDO> selectPage(VoucherPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<VoucherDO>()
                .eqIfPresent(VoucherDO::getVoucherType, reqVO.getVoucherType())
                .eqIfPresent(VoucherDO::getDirection, reqVO.getDirection())
                .eqIfPresent(VoucherDO::getReconcileStatus, reqVO.getReconcileStatus())
                .eqIfPresent(VoucherDO::getOrderId, reqVO.getOrderId())
                .eqIfPresent(VoucherDO::getPurchaseOrderId, reqVO.getPurchaseOrderId())
                .likeIfPresent(VoucherDO::getInvoiceNo, reqVO.getInvoiceNo())
                .orderByDesc(VoucherDO::getId));
    }

    default List<VoucherDO> selectListByOrderId(Long orderId) {
        return selectList(new LambdaQueryWrapperX<VoucherDO>()
                .eq(VoucherDO::getOrderId, orderId)
                .orderByDesc(VoucherDO::getId));
    }

    default List<VoucherDO> selectListByPurchaseOrderId(Long purchaseOrderId) {
        return selectList(new LambdaQueryWrapperX<VoucherDO>()
                .eq(VoucherDO::getPurchaseOrderId, purchaseOrderId)
                .orderByDesc(VoucherDO::getId));
    }

}
