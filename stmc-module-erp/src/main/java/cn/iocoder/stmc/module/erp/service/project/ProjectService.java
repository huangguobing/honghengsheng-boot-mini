package cn.iocoder.stmc.module.erp.service.project;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.module.erp.controller.admin.project.vo.ProjectPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.project.vo.ProjectSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.project.ProjectDO;

import cn.iocoder.stmc.module.erp.controller.admin.project.vo.ProjectTreeRespVO;

import javax.validation.Valid;
import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * ERP 项目/工地 Service 接口
 *
 * @author stmc
 */
public interface ProjectService {

    Long createProject(@Valid ProjectSaveReqVO createReqVO);

    void updateProject(@Valid ProjectSaveReqVO updateReqVO);

    void deleteProject(Long id);

    ProjectDO getProject(Long id);

    PageResult<ProjectDO> getProjectPage(ProjectPageReqVO pageReqVO);

    List<ProjectDO> getProjectsByCustomerId(Long customerId);

    /**
     * 根据ID集合批量获取项目Map
     */
    Map<Long, ProjectDO> getProjectMap(Collection<Long> ids);

    /**
     * 获取项目树形列表（一级项目+子项目）
     */
    List<ProjectTreeRespVO> getProjectTreeList(Long customerId, Integer status);

}
