package cn.iocoder.stmc.module.erp.service.project;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.project.vo.ProjectPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.project.vo.ProjectSaveReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.project.vo.ProjectTreeRespVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.project.ProjectDO;
import cn.iocoder.stmc.module.erp.dal.mysql.project.ProjectMapper;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import cn.hutool.core.collection.CollUtil;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static cn.iocoder.stmc.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.stmc.module.erp.enums.ErrorCodeConstants.PROJECT_NOT_EXISTS;
import static cn.iocoder.stmc.module.erp.enums.ErrorCodeConstants.PROJECT_NAME_EXISTS;

/**
 * ERP 项目/工地 Service 实现类
 *
 * @author stmc
 */
@Service
@Validated
public class ProjectServiceImpl implements ProjectService {

    @Resource
    private ProjectMapper projectMapper;

    @Override
    public Long createProject(ProjectSaveReqVO createReqVO) {
        validateProjectNameUnique(null, createReqVO.getCustomerId(), createReqVO.getName());
        ProjectDO project = BeanUtils.toBean(createReqVO, ProjectDO.class);
        projectMapper.insert(project);
        return project.getId();
    }

    @Override
    public void updateProject(ProjectSaveReqVO updateReqVO) {
        validateProjectExists(updateReqVO.getId());
        validateProjectNameUnique(updateReqVO.getId(), updateReqVO.getCustomerId(), updateReqVO.getName());
        ProjectDO updateObj = BeanUtils.toBean(updateReqVO, ProjectDO.class);
        projectMapper.updateById(updateObj);
    }

    @Override
    public void deleteProject(Long id) {
        validateProjectExists(id);
        projectMapper.deleteById(id);
    }

    @Override
    public ProjectDO getProject(Long id) {
        return projectMapper.selectById(id);
    }

    @Override
    public PageResult<ProjectDO> getProjectPage(ProjectPageReqVO pageReqVO) {
        return projectMapper.selectPage(pageReqVO);
    }

    @Override
    public List<ProjectDO> getProjectsByCustomerId(Long customerId) {
        return projectMapper.selectListByCustomerId(customerId);
    }

    @Override
    public Map<Long, ProjectDO> getProjectMap(Collection<Long> ids) {
        if (CollUtil.isEmpty(ids)) {
            return Collections.emptyMap();
        }
        List<ProjectDO> list = projectMapper.selectBatchIds(ids);
        return list.stream().collect(Collectors.toMap(ProjectDO::getId, p -> p));
    }

    @Override
    public List<ProjectTreeRespVO> getProjectTreeList(Long customerId, Integer status) {
        // 查询所有一级项目
        List<ProjectDO> topProjects = projectMapper.selectTopLevelList();
        if (customerId != null) {
            topProjects = topProjects.stream()
                    .filter(p -> customerId.equals(p.getCustomerId()))
                    .collect(Collectors.toList());
        }
        if (status != null) {
            topProjects = topProjects.stream()
                    .filter(p -> status.equals(p.getStatus()))
                    .collect(Collectors.toList());
        }
        // 为每个一级项目查询子项目
        List<ProjectTreeRespVO> result = new ArrayList<>();
        for (ProjectDO top : topProjects) {
            ProjectTreeRespVO treeNode = BeanUtils.toBean(top, ProjectTreeRespVO.class);
            List<ProjectDO> children = projectMapper.selectListByParentId(top.getId());
            treeNode.setChildren(BeanUtils.toBean(children, ProjectTreeRespVO.class));
            result.add(treeNode);
        }
        return result;
    }

    private void validateProjectExists(Long id) {
        if (projectMapper.selectById(id) == null) {
            throw exception(PROJECT_NOT_EXISTS);
        }
    }

    private void validateProjectNameUnique(Long id, Long customerId, String name) {
        ProjectDO project = projectMapper.selectByCustomerIdAndName(customerId, name);
        if (project == null) {
            return;
        }
        if (id == null) {
            throw exception(PROJECT_NAME_EXISTS);
        }
        if (!project.getId().equals(id)) {
            throw exception(PROJECT_NAME_EXISTS);
        }
    }

}
