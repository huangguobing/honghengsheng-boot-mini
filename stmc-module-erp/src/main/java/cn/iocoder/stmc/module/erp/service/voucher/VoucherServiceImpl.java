package cn.iocoder.stmc.module.erp.service.voucher;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.voucher.vo.VoucherPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.voucher.vo.VoucherSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.voucher.VoucherDO;
import cn.iocoder.stmc.module.erp.dal.mysql.voucher.VoucherMapper;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import javax.annotation.Resource;
import java.util.List;

import static cn.iocoder.stmc.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.stmc.module.erp.enums.ErrorCodeConstants.VOUCHER_NOT_EXISTS;

/**
 * ERP 票据凭证 Service 实现类
 *
 * @author stmc
 */
@Service
@Validated
public class VoucherServiceImpl implements VoucherService {

    @Resource
    private VoucherMapper voucherMapper;

    @Override
    public Long createVoucher(VoucherSaveReqVO reqVO) {
        VoucherDO voucher = BeanUtils.toBean(reqVO, VoucherDO.class);
        voucher.setReconcileStatus(0); // 默认未核销
        voucherMapper.insert(voucher);
        return voucher.getId();
    }

    @Override
    public void updateVoucher(VoucherSaveReqVO reqVO) {
        validateVoucherExists(reqVO.getId());
        VoucherDO updateObj = BeanUtils.toBean(reqVO, VoucherDO.class);
        voucherMapper.updateById(updateObj);
    }

    @Override
    public void deleteVoucher(Long id) {
        validateVoucherExists(id);
        voucherMapper.deleteById(id);
    }

    @Override
    public VoucherDO getVoucher(Long id) {
        return voucherMapper.selectById(id);
    }

    @Override
    public PageResult<VoucherDO> getVoucherPage(VoucherPageReqVO pageReqVO) {
        return voucherMapper.selectPage(pageReqVO);
    }

    @Override
    public List<VoucherDO> getVoucherListByOrderId(Long orderId) {
        return voucherMapper.selectListByOrderId(orderId);
    }

    @Override
    public void reconcileVoucher(Long id, Integer reconcileStatus, String reconcileRemark) {
        VoucherDO voucher = validateVoucherExists(id);
        VoucherDO updateObj = new VoucherDO();
        updateObj.setId(id);
        updateObj.setReconcileStatus(reconcileStatus);
        updateObj.setReconcileRemark(reconcileRemark);
        voucherMapper.updateById(updateObj);
    }

    private VoucherDO validateVoucherExists(Long id) {
        VoucherDO voucher = voucherMapper.selectById(id);
        if (voucher == null) {
            throw exception(VOUCHER_NOT_EXISTS);
        }
        return voucher;
    }

}
