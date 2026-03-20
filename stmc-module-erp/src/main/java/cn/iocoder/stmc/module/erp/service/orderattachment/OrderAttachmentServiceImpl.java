package cn.iocoder.stmc.module.erp.service.orderattachment;

import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.orderattachment.vo.OrderAttachmentSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.orderattachment.OrderAttachmentDO;
import cn.iocoder.stmc.module.erp.dal.mysql.orderattachment.OrderAttachmentMapper;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import javax.annotation.Resource;
import java.util.List;

import static cn.iocoder.stmc.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.stmc.module.erp.enums.ErrorCodeConstants.ORDER_ATTACHMENT_NOT_EXISTS;

/**
 * ERP 订单附件 Service 实现类
 *
 * @author stmc
 */
@Service
@Validated
public class OrderAttachmentServiceImpl implements OrderAttachmentService {

    @Resource
    private OrderAttachmentMapper orderAttachmentMapper;

    @Override
    public Long createOrderAttachment(OrderAttachmentSaveReqVO createReqVO) {
        OrderAttachmentDO attachment = BeanUtils.toBean(createReqVO, OrderAttachmentDO.class);
        orderAttachmentMapper.insert(attachment);
        return attachment.getId();
    }

    @Override
    public void deleteOrderAttachment(Long id) {
        if (orderAttachmentMapper.selectById(id) == null) {
            throw exception(ORDER_ATTACHMENT_NOT_EXISTS);
        }
        orderAttachmentMapper.deleteById(id);
    }

    @Override
    public List<OrderAttachmentDO> getOrderAttachmentListByOrderId(Long orderId) {
        return orderAttachmentMapper.selectListByOrderId(orderId);
    }

}
