package cn.iocoder.stmc.module.erp.controller.admin.log;

import cn.iocoder.stmc.framework.common.pojo.CommonResult;
import cn.iocoder.stmc.module.erp.dal.dataobject.log.OperationLogDO;
import cn.iocoder.stmc.module.erp.service.log.OperationLogService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.Parameters;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

import static cn.iocoder.stmc.framework.common.pojo.CommonResult.success;

/**
 * 管理后台 - ERP 操作日志
 *
 * @author stmc
 */
@Tag(name = "管理后台 - ERP 操作日志")
@RestController
@RequestMapping("/erp/operation-log")
@Validated
public class OperationLogController {

    @Resource
    private OperationLogService operationLogService;

    @GetMapping("/list")
    @Operation(summary = "查询业务操作日志")
    @Parameters({
            @Parameter(name = "module", description = "模块名", required = true),
            @Parameter(name = "businessId", description = "业务ID", required = true)
    })
    @PreAuthorize("isAuthenticated()")
    public CommonResult<List<OperationLogDO>> getOperationLogs(
            @RequestParam("module") String module,
            @RequestParam("businessId") Long businessId) {
        return success(operationLogService.getLogsByBusiness(module, businessId));
    }

}
