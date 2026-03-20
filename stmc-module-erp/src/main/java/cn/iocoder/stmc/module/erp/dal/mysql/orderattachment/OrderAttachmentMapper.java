package cn.iocoder.stmc.module.erp.dal.mysql.orderattachment;

import cn.iocoder.stmc.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.module.erp.dal.dataobject.orderattachment.OrderAttachmentDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface OrderAttachmentMapper extends BaseMapperX<OrderAttachmentDO> {

    default List<OrderAttachmentDO> selectListByOrderId(Long orderId) {
        return selectList(new LambdaQueryWrapperX<OrderAttachmentDO>()
                .eq(OrderAttachmentDO::getOrderId, orderId)
                .orderByDesc(OrderAttachmentDO::getCreateTime));
    }

}
