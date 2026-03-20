package cn.iocoder.stmc.module.erp.service.voucher;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.module.erp.controller.admin.voucher.vo.VoucherPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.voucher.vo.VoucherSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.voucher.VoucherDO;

import javax.validation.Valid;
import java.util.List;

/**
 * ERP 票据凭证 Service 接口
 *
 * @author stmc
 */
public interface VoucherService {

    Long createVoucher(@Valid VoucherSaveReqVO reqVO);

    void updateVoucher(@Valid VoucherSaveReqVO reqVO);

    void deleteVoucher(Long id);

    VoucherDO getVoucher(Long id);

    PageResult<VoucherDO> getVoucherPage(VoucherPageReqVO pageReqVO);

    List<VoucherDO> getVoucherListByOrderId(Long orderId);

    void reconcileVoucher(Long id, Integer reconcileStatus, String reconcileRemark);

}
