package cn.iocoder.stmc.module.erp.controller.admin.voucher;

import cn.iocoder.stmc.framework.common.pojo.CommonResult;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.voucher.vo.VoucherPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.voucher.vo.VoucherRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.voucher.vo.VoucherSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.voucher.VoucherDO;
import cn.iocoder.stmc.module.erp.service.order.OrderService;
import cn.iocoder.stmc.module.erp.service.voucher.VoucherService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.List;

import static cn.iocoder.stmc.framework.common.pojo.CommonResult.success;

/**
 * 管理后台 - ERP 票据凭证
 *
 * @author stmc
 */
@Tag(name = "管理后台 - ERP 票据凭证")
@RestController
@RequestMapping("/erp/voucher")
@Validated
public class VoucherController {

    @Resource
    private VoucherService voucherService;

    @Resource
    private OrderService orderService;

    @PostMapping("/create")
    @Operation(summary = "创建票据")
    @PreAuthorize("@ss.hasPermission('erp:voucher:create')")
    public CommonResult<Long> createVoucher(@Valid @RequestBody VoucherSaveReqVO reqVO) {
        return success(voucherService.createVoucher(reqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新票据")
    @PreAuthorize("@ss.hasPermission('erp:voucher:update')")
    public CommonResult<Boolean> updateVoucher(@Valid @RequestBody VoucherSaveReqVO reqVO) {
        voucherService.updateVoucher(reqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除票据")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:voucher:delete')")
    public CommonResult<Boolean> deleteVoucher(@RequestParam("id") Long id) {
        voucherService.deleteVoucher(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得票据")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:voucher:query')")
    public CommonResult<VoucherRespVO> getVoucher(@RequestParam("id") Long id) {
        VoucherDO voucher = voucherService.getVoucher(id);
        if (voucher == null) {
            return success(null);
        }
        VoucherRespVO respVO = BeanUtils.toBean(voucher, VoucherRespVO.class);
        fillVoucherInfo(respVO);
        return success(respVO);
    }

    @GetMapping("/page")
    @Operation(summary = "获得票据分页")
    @PreAuthorize("@ss.hasPermission('erp:voucher:query')")
    public CommonResult<PageResult<VoucherRespVO>> getVoucherPage(@Valid VoucherPageReqVO pageVO) {
        PageResult<VoucherDO> pageResult = voucherService.getVoucherPage(pageVO);
        PageResult<VoucherRespVO> voPageResult = BeanUtils.toBean(pageResult, VoucherRespVO.class);
        if (voPageResult.getList() != null) {
            for (VoucherRespVO vo : voPageResult.getList()) {
                fillVoucherInfo(vo);
            }
        }
        return success(voPageResult);
    }

    @GetMapping("/list-by-order")
    @Operation(summary = "按订单查票据列表")
    @Parameter(name = "orderId", description = "订单ID", required = true)
    @PreAuthorize("@ss.hasPermission('erp:voucher:query')")
    public CommonResult<List<VoucherRespVO>> getVoucherListByOrderId(@RequestParam("orderId") Long orderId) {
        List<VoucherDO> list = voucherService.getVoucherListByOrderId(orderId);
        List<VoucherRespVO> voList = BeanUtils.toBean(list, VoucherRespVO.class);
        for (VoucherRespVO vo : voList) {
            fillVoucherInfo(vo);
        }
        return success(voList);
    }

    @PutMapping("/reconcile")
    @Operation(summary = "核销票据")
    @PreAuthorize("@ss.hasPermission('erp:voucher:reconcile')")
    public CommonResult<Boolean> reconcileVoucher(@RequestParam("id") Long id,
                                                   @RequestParam("reconcileStatus") Integer reconcileStatus,
                                                   @RequestParam(value = "reconcileRemark", required = false) String reconcileRemark) {
        voucherService.reconcileVoucher(id, reconcileStatus, reconcileRemark);
        return success(true);
    }

    /**
     * 填充票据关联信息
     */
    private void fillVoucherInfo(VoucherRespVO vo) {
        if (vo.getOrderId() != null) {
            OrderDO order = orderService.getOrder(vo.getOrderId());
            if (order != null) {
                vo.setOrderNo(order.getOrderNo());
            }
        }
    }

}
