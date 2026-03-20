package cn.iocoder.stmc.module.erp.dal.mysql.project;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.module.erp.controller.admin.project.vo.ProjectPageReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.project.ProjectDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * ERP 项目/工地 Mapper
 *
 * @author stmc
 */
@Mapper
public interface ProjectMapper extends BaseMapperX<ProjectDO> {

    default PageResult<ProjectDO> selectPage(ProjectPageReqVO reqVO) {
        LambdaQueryWrapperX<ProjectDO> wrapper = new LambdaQueryWrapperX<ProjectDO>()
                .eqIfPresent(ProjectDO::getCustomerId, reqVO.getCustomerId())
                .likeIfPresent(ProjectDO::getName, reqVO.getName())
                .eqIfPresent(ProjectDO::getStatus, reqVO.getStatus())
                .eqIfPresent(ProjectDO::getParentId, reqVO.getParentId())
                .orderByDesc(ProjectDO::getCreateTime);
        if (Boolean.TRUE.equals(reqVO.getTopLevel())) {
            wrapper.isNull(ProjectDO::getParentId);
        }
        return selectPage(reqVO, wrapper);
    }

    default List<ProjectDO> selectListByCustomerId(Long customerId) {
        return selectList(new LambdaQueryWrapperX<ProjectDO>()
                .eq(ProjectDO::getCustomerId, customerId)
                .eq(ProjectDO::getStatus, 0)
                .orderByDesc(ProjectDO::getCreateTime));
    }

    default ProjectDO selectByCustomerIdAndName(Long customerId, String name) {
        return selectOne(new LambdaQueryWrapperX<ProjectDO>()
                .eq(ProjectDO::getCustomerId, customerId)
                .eq(ProjectDO::getName, name));
    }

    default List<ProjectDO> selectListByParentId(Long parentId) {
        return selectList(new LambdaQueryWrapperX<ProjectDO>()
                .eq(ProjectDO::getParentId, parentId));
    }

    default List<ProjectDO> selectTopLevelList() {
        return selectList(new LambdaQueryWrapperX<ProjectDO>()
                .isNull(ProjectDO::getParentId)
                .orderByDesc(ProjectDO::getCreateTime));
    }

}
