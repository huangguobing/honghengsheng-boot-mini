package cn.iocoder.stmc.module.erp.controller.admin.expense;

import cn.iocoder.stmc.framework.common.pojo.CommonResult;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.expense.vo.ExpensePageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.expense.vo.ExpenseRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.expense.vo.ExpenseSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.expense.ExpenseDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import cn.iocoder.stmc.module.erp.service.expense.ExpenseService;
import cn.iocoder.stmc.module.erp.service.order.OrderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static cn.iocoder.stmc.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - ERP 费用/运费支出")
@RestController
@RequestMapping("/erp/expense")
@Validated
public class ExpenseController {

    @Resource
    private ExpenseService expenseService;

    @Resource
    private OrderService orderService;

    @PostMapping("/create")
    @Operation(summary = "创建费用记录")
    @PreAuthorize("@ss.hasPermission('erp:expense:create')")
    public CommonResult<Long> createExpense(@Valid @RequestBody ExpenseSaveReqVO createReqVO) {
        return success(expenseService.createExpense(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新费用记录")
    @PreAuthorize("@ss.hasPermission('erp:expense:update')")
    public CommonResult<Boolean> updateExpense(@Valid @RequestBody ExpenseSaveReqVO updateReqVO) {
        expenseService.updateExpense(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除费用记录")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:expense:delete')")
    public CommonResult<Boolean> deleteExpense(@RequestParam("id") Long id) {
        expenseService.deleteExpense(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得费用记录")
    @Parameter(name = "id", description = "编号", required = true, example = "1024")
    @PreAuthorize("@ss.hasPermission('erp:expense:query')")
    public CommonResult<ExpenseRespVO> getExpense(@RequestParam("id") Long id) {
        ExpenseDO expense = expenseService.getExpense(id);
        ExpenseRespVO respVO = BeanUtils.toBean(expense, ExpenseRespVO.class);
        // 填充订单号
        if (respVO != null && respVO.getOrderId() != null) {
            OrderDO order = orderService.getOrder(respVO.getOrderId());
            if (order != null) {
                respVO.setOrderNo(order.getOrderNo());
            }
        }
        return success(respVO);
    }

    @GetMapping("/page")
    @Operation(summary = "获得费用记录分页")
    @PreAuthorize("@ss.hasPermission('erp:expense:query')")
    public CommonResult<PageResult<ExpenseRespVO>> getExpensePage(@Valid ExpensePageReqVO pageVO) {
        PageResult<ExpenseDO> pageResult = expenseService.getExpensePage(pageVO);
        PageResult<ExpenseRespVO> respPage = BeanUtils.toBean(pageResult, ExpenseRespVO.class);
        // 填充订单号
        if (respPage.getList() != null && !respPage.getList().isEmpty()) {
            Set<Long> orderIds = respPage.getList().stream()
                    .map(ExpenseRespVO::getOrderId)
                    .filter(java.util.Objects::nonNull)
                    .collect(Collectors.toSet());
            if (!orderIds.isEmpty()) {
                Map<Long, OrderDO> orderMap = orderService.getOrderMap(orderIds);
                respPage.getList().forEach(vo -> {
                    if (vo.getOrderId() != null) {
                        OrderDO order = orderMap.get(vo.getOrderId());
                        if (order != null) {
                            vo.setOrderNo(order.getOrderNo());
                        }
                    }
                });
            }
        }
        return success(respPage);
    }

    @GetMapping("/list-by-order")
    @Operation(summary = "根据订单获得费用列表")
    @Parameter(name = "orderId", description = "订单编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:expense:query')")
    public CommonResult<List<ExpenseRespVO>> getExpenseListByOrder(@RequestParam("orderId") Long orderId) {
        List<ExpenseDO> list = expenseService.getExpensesByOrderId(orderId);
        List<ExpenseRespVO> respList = BeanUtils.toBean(list, ExpenseRespVO.class);
        // 填充订单号
        if (!respList.isEmpty()) {
            OrderDO order = orderService.getOrder(orderId);
            if (order != null) {
                respList.forEach(vo -> vo.setOrderNo(order.getOrderNo()));
            }
        }
        return success(respList);
    }

    @GetMapping("/total-by-order")
    @Operation(summary = "根据订单获得总支出")
    @Parameter(name = "orderId", description = "订单编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:expense:query')")
    public CommonResult<BigDecimal> getTotalExpenseByOrder(@RequestParam("orderId") Long orderId) {
        return success(expenseService.getTotalExpenseByOrderId(orderId));
    }

}
