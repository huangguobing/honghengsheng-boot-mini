package cn.iocoder.stmc.module.erp.service.orderattachment;

import cn.iocoder.stmc.module.erp.controller.admin.orderattachment.vo.OrderAttachmentSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.orderattachment.OrderAttachmentDO;

import javax.validation.Valid;
import java.util.List;

/**
 * ERP 订单附件 Service 接口
 *
 * @author stmc
 */
public interface OrderAttachmentService {

    /**
     * 创建订单附件
     */
    Long createOrderAttachment(@Valid OrderAttachmentSaveReqVO createReqVO);

    /**
     * 删除订单附件
     */
    void deleteOrderAttachment(Long id);

    /**
     * 根据订单ID获取附件列表
     */
    List<OrderAttachmentDO> getOrderAttachmentListByOrderId(Long orderId);

}
