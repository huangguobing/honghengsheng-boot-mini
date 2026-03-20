package cn.iocoder.stmc.module.erp.dal.mysql.log;

import cn.iocoder.stmc.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.module.erp.dal.dataobject.log.OperationLogDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * ERP 操作日志 Mapper
 *
 * @author stmc
 */
@Mapper
public interface OperationLogMapper extends BaseMapperX<OperationLogDO> {

    default List<OperationLogDO> selectListByBusiness(String module, Long businessId) {
        return selectList(new LambdaQueryWrapperX<OperationLogDO>()
                .eq(OperationLogDO::getModule, module)
                .eq(OperationLogDO::getBusinessId, businessId)
                .orderByDesc(OperationLogDO::getOperateTime));
    }

}
