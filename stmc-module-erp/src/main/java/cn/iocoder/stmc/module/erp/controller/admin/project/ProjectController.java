package cn.iocoder.stmc.module.erp.controller.admin.project;

import cn.iocoder.stmc.framework.common.pojo.CommonResult;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.project.vo.ProjectPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.project.vo.ProjectRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.project.vo.ProjectSaveReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.project.vo.ProjectTreeRespVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.customer.CustomerDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.project.ProjectDO;
import cn.iocoder.stmc.module.erp.service.customer.CustomerService;
import cn.iocoder.stmc.module.erp.service.project.ProjectService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static cn.iocoder.stmc.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - ERP 项目/工地")
@RestController
@RequestMapping("/erp/project")
@Validated
public class ProjectController {

    @Resource
    private ProjectService projectService;

    @Resource
    private CustomerService customerService;

    @PostMapping("/create")
    @Operation(summary = "创建项目/工地")
    @PreAuthorize("@ss.hasPermission('erp:project:create')")
    public CommonResult<Long> createProject(@Valid @RequestBody ProjectSaveReqVO createReqVO) {
        return success(projectService.createProject(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新项目/工地")
    @PreAuthorize("@ss.hasPermission('erp:project:update')")
    public CommonResult<Boolean> updateProject(@Valid @RequestBody ProjectSaveReqVO updateReqVO) {
        projectService.updateProject(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除项目/工地")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:project:delete')")
    public CommonResult<Boolean> deleteProject(@RequestParam("id") Long id) {
        projectService.deleteProject(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得项目/工地")
    @Parameter(name = "id", description = "编号", required = true, example = "1024")
    @PreAuthorize("@ss.hasPermission('erp:project:query')")
    public CommonResult<ProjectRespVO> getProject(@RequestParam("id") Long id) {
        ProjectDO project = projectService.getProject(id);
        ProjectRespVO respVO = BeanUtils.toBean(project, ProjectRespVO.class);
        if (project != null) {
            CustomerDO customer = customerService.getCustomer(project.getCustomerId());
            if (customer != null) {
                respVO.setCustomerName(customer.getName());
            }
        }
        return success(respVO);
    }

    @GetMapping("/page")
    @Operation(summary = "获得项目/工地分页")
    @PreAuthorize("@ss.hasPermission('erp:project:query')")
    public CommonResult<PageResult<ProjectRespVO>> getProjectPage(@Valid ProjectPageReqVO pageVO) {
        PageResult<ProjectDO> pageResult = projectService.getProjectPage(pageVO);
        PageResult<ProjectRespVO> result = BeanUtils.toBean(pageResult, ProjectRespVO.class);
        // 填充客户名称
        List<Long> customerIds = pageResult.getList().stream()
                .map(ProjectDO::getCustomerId).distinct().collect(Collectors.toList());
        Map<Long, CustomerDO> customerMap = customerService.getCustomerMap(customerIds);
        result.getList().forEach(vo -> {
            CustomerDO customer = customerMap.get(vo.getCustomerId());
            if (customer != null) {
                vo.setCustomerName(customer.getName());
            }
        });
        return success(result);
    }

    @GetMapping("/list-by-customer")
    @Operation(summary = "按客户获取项目列表", description = "开单时联动下拉")
    @Parameter(name = "customerId", description = "客户ID", required = true, example = "1")
    public CommonResult<List<ProjectRespVO>> getProjectListByCustomer(@RequestParam("customerId") Long customerId) {
        List<ProjectDO> list = projectService.getProjectsByCustomerId(customerId);
        return success(BeanUtils.toBean(list, ProjectRespVO.class));
    }

    @GetMapping("/tree-list")
    @Operation(summary = "获取项目列表", description = "所有角色返回相同数据")
    @PreAuthorize("@ss.hasPermission('erp:project:query')")
    public CommonResult<List<ProjectTreeRespVO>> getProjectTreeList(
            @RequestParam(required = false) Long customerId,
            @RequestParam(required = false) Integer status) {
        List<ProjectTreeRespVO> treeList = projectService.getProjectTreeList(customerId, status);
        // 填充客户名称
        List<Long> customerIds = treeList.stream()
                .map(ProjectTreeRespVO::getCustomerId).distinct().collect(Collectors.toList());
        Map<Long, CustomerDO> customerMap = customerService.getCustomerMap(customerIds);
        treeList.forEach(node -> {
            CustomerDO customer = customerMap.get(node.getCustomerId());
            if (customer != null) {
                node.setCustomerName(customer.getName());
                if (node.getChildren() != null) {
                    node.getChildren().forEach(child -> child.setCustomerName(customer.getName()));
                }
            }
        });
        return success(treeList);
    }

}
