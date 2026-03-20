package cn.iocoder.stmc.module.erp.controller.admin.orderattachment;

import cn.iocoder.stmc.framework.common.pojo.CommonResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.orderattachment.vo.OrderAttachmentRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.orderattachment.vo.OrderAttachmentSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.orderattachment.OrderAttachmentDO;
import cn.iocoder.stmc.module.erp.service.orderattachment.OrderAttachmentService;
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

@Tag(name = "管理后台 - ERP 订单附件")
@RestController
@RequestMapping("/erp/order-attachment")
@Validated
public class OrderAttachmentController {

    @Resource
    private OrderAttachmentService orderAttachmentService;

    @PostMapping("/create")
    @Operation(summary = "上传订单附件")
    @PreAuthorize("@ss.hasPermission('erp:order:update')")
    public CommonResult<Long> createOrderAttachment(@Valid @RequestBody OrderAttachmentSaveReqVO createReqVO) {
        return success(orderAttachmentService.createOrderAttachment(createReqVO));
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除订单附件")
    @Parameter(name = "id", description = "附件编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:order:update')")
    public CommonResult<Boolean> deleteOrderAttachment(@RequestParam("id") Long id) {
        orderAttachmentService.deleteOrderAttachment(id);
        return success(true);
    }

    @GetMapping("/list-by-order")
    @Operation(summary = "根据订单获取附件列表")
    @Parameter(name = "orderId", description = "订单编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:order:query')")
    public CommonResult<List<OrderAttachmentRespVO>> getOrderAttachmentListByOrderId(@RequestParam("orderId") Long orderId) {
        List<OrderAttachmentDO> list = orderAttachmentService.getOrderAttachmentListByOrderId(orderId);
        return success(BeanUtils.toBean(list, OrderAttachmentRespVO.class));
    }

}
