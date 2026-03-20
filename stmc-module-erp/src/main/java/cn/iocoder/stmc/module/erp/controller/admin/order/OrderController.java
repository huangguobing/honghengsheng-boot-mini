package cn.iocoder.stmc.module.erp.controller.admin.order;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.stmc.framework.common.biz.system.permission.PermissionCommonApi;
import cn.iocoder.stmc.framework.common.pojo.CommonResult;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.stmc.module.erp.controller.admin.order.vo.*;
import cn.iocoder.stmc.module.erp.dal.dataobject.customer.CustomerDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderItemDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.supplier.SupplierDO;
import cn.iocoder.stmc.module.erp.dal.mysql.order.OrderMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.order.OrderItemMapper;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.module.erp.service.customer.CustomerService;
import cn.iocoder.stmc.module.erp.enums.OrderStatusEnum;
import cn.iocoder.stmc.module.erp.service.order.OrderService;
import cn.iocoder.stmc.module.erp.service.supplier.SupplierService;
import cn.iocoder.stmc.module.system.api.user.AdminUserApi;
import cn.iocoder.stmc.module.system.api.user.dto.AdminUserRespDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.Parameters;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static cn.iocoder.stmc.framework.common.pojo.CommonResult.success;
import static cn.iocoder.stmc.module.erp.enums.ErrorCodeConstants.ORDER_NOT_EXISTS;

@Tag(name = "管理后台 - ERP 订单")
@RestController
@RequestMapping("/erp/order")
@Validated
public class OrderController {

    /** 可以查看全部订单的角色编码：超级管理员、鸿恒盛 */
    private static final String[] ADMIN_ROLES = {"super_admin", "honghengsheng"};
    /** B角色编码 */
    private static final String[] ROLE_B = {"xihuidaxin"};

    @Resource
    private OrderService orderService;

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private OrderItemMapper orderItemMapper;

    @Resource
    private CustomerService customerService;

    @Resource
    private SupplierService supplierService;

    @Resource
    private AdminUserApi adminUserApi;

    @Resource
    private PermissionCommonApi permissionApi;

    @Resource
    private cn.iocoder.stmc.module.erp.service.project.ProjectService projectService;

    @PostMapping("/create")
    @Operation(summary = "创建订单")
    @PreAuthorize("@ss.hasPermission('erp:order:create')")
    public CommonResult<Long> createOrder(@Valid @RequestBody OrderSaveReqVO createReqVO) {
        return success(orderService.createOrder(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新订单")
    @PreAuthorize("@ss.hasPermission('erp:order:update')")
    public CommonResult<Boolean> updateOrder(@Valid @RequestBody OrderSaveReqVO updateReqVO) {
        orderService.updateOrder(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "更新订单状态")
    @Parameters({
            @Parameter(name = "id", description = "订单编号", required = true),
            @Parameter(name = "status", description = "状态", required = true)
    })
    @PreAuthorize("@ss.hasPermission('erp:order:update')")
    public CommonResult<Boolean> updateOrderStatus(@RequestParam("id") Long id,
                                                    @RequestParam("status") Integer status) {
        orderService.updateOrderStatus(id, status);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除订单")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:order:delete')")
    public CommonResult<Boolean> deleteOrder(@RequestParam("id") Long id) {
        orderService.deleteOrder(id);
        return success(true);
    }

    @DeleteMapping("/delete-list")
    @Operation(summary = "批量删除订单")
    @Parameter(name = "ids", description = "编号列表", required = true)
    @PreAuthorize("@ss.hasPermission('erp:order:delete')")
    public CommonResult<Boolean> deleteOrderList(@RequestParam("ids") List<Long> ids) {
        orderService.deleteOrderList(ids);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得订单（含明细）")
    @Parameter(name = "id", description = "编号", required = true, example = "1024")
    @PreAuthorize("@ss.hasPermission('erp:order:query')")
    public CommonResult<OrderRespVO> getOrder(@RequestParam("id") Long id) {
        OrderDO order = orderService.getOrder(id);
        if (order == null) {
            return success(null);
        }

        // 构建响应
        OrderRespVO respVO = BeanUtils.toBean(order, OrderRespVO.class);

        // 获取明细列表
        List<OrderItemDO> items = orderService.getOrderItemList(id);
        List<OrderItemRespVO> itemRespVOs = BeanUtils.toBean(items, OrderItemRespVO.class);

        // 填充供应商名称
        if (CollUtil.isNotEmpty(items)) {
            List<Long> supplierIds = items.stream()
                    .map(OrderItemDO::getSupplierId)
                    .filter(sid -> sid != null)
                    .distinct()
                    .collect(Collectors.toList());
            if (CollUtil.isNotEmpty(supplierIds)) {
                Map<Long, SupplierDO> supplierMap = supplierService.getSupplierMap(supplierIds);
                for (OrderItemRespVO itemVO : itemRespVOs) {
                    if (itemVO.getSupplierId() != null) {
                        SupplierDO supplier = supplierMap.get(itemVO.getSupplierId());
                        if (supplier != null) {
                            itemVO.setSupplierName(supplier.getName());
                        }
                    }
                }
            }
        }

        respVO.setItems(itemRespVOs);

        // 填充客户名称
        if (respVO.getCustomerId() != null) {
            CustomerDO customer = customerService.getCustomer(respVO.getCustomerId());
            if (customer != null) {
                respVO.setCustomerName(customer.getName());
            }
        }

        // 填充项目名称
        if (respVO.getProjectId() != null) {
            cn.iocoder.stmc.module.erp.dal.dataobject.project.ProjectDO project = projectService.getProject(respVO.getProjectId());
            if (project != null) {
                respVO.setProjectName(project.getName());
            }
        }
        // 填充原订单号
        if (respVO.getParentOrderId() != null) {
            OrderDO parentOrder = orderService.getOrder(respVO.getParentOrderId());
            if (parentOrder != null) {
                respVO.setParentOrderNo(parentOrder.getOrderNo());
            }
        }

        // 填充成本填充人姓名
        if (respVO.getCostFilledBy() != null) {
            AdminUserRespDTO user = adminUserApi.getUser(respVO.getCostFilledBy());
            if (user != null) {
                respVO.setCostFilledByName(user.getNickname());
            }
        }

        return success(respVO);
    }

    @GetMapping("/page")
    @Operation(summary = "获得订单分页")
    @PreAuthorize("@ss.hasPermission('erp:order:query')")
    public CommonResult<PageResult<OrderRespVO>> getOrderPage(@Valid OrderPageReqVO pageVO) {
        // 数据权限过滤：根据角色设置订单类别和数据范围
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        if (isRoleB(userId)) {
            // B角色只看副订单，且只看自己录入的
            pageVO.setOrderCategory(1);
            pageVO.setSalesmanId(userId);
        } else if (isAdmin(userId)) {
            // A角色/超管只看主订单
            if (pageVO.getOrderCategory() == null) {
                pageVO.setOrderCategory(0);
            }
        } else {
            // 普通业务员只看自己的主订单
            pageVO.setSalesmanId(userId);
            if (pageVO.getOrderCategory() == null) {
                pageVO.setOrderCategory(0);
            }
        }

        PageResult<OrderDO> pageResult = orderService.getOrderPage(pageVO);
        PageResult<OrderRespVO> voPageResult = BeanUtils.toBean(pageResult, OrderRespVO.class);

        // 填充客户名称
        if (CollUtil.isNotEmpty(voPageResult.getList())) {
            List<Long> customerIds = voPageResult.getList().stream()
                    .map(OrderRespVO::getCustomerId)
                    .filter(cid -> cid != null)
                    .distinct()
                    .collect(Collectors.toList());
            if (CollUtil.isNotEmpty(customerIds)) {
                Map<Long, CustomerDO> customerMap = customerService.getCustomerMap(customerIds);
                for (OrderRespVO vo : voPageResult.getList()) {
                    if (vo.getCustomerId() != null) {
                        CustomerDO customer = customerMap.get(vo.getCustomerId());
                        if (customer != null) {
                            vo.setCustomerName(customer.getName());
                        }
                    }
                }
            }

            // 填充工地名称
            Set<Long> projectIds = voPageResult.getList().stream()
                    .map(OrderRespVO::getProjectId)
                    .filter(pid -> pid != null)
                    .collect(Collectors.toSet());
            if (CollUtil.isNotEmpty(projectIds)) {
                Map<Long, cn.iocoder.stmc.module.erp.dal.dataobject.project.ProjectDO> projectMap =
                        projectService.getProjectMap(projectIds);
                for (OrderRespVO vo : voPageResult.getList()) {
                    if (vo.getProjectId() != null) {
                        cn.iocoder.stmc.module.erp.dal.dataobject.project.ProjectDO project = projectMap.get(vo.getProjectId());
                        if (project != null) {
                            vo.setProjectName(project.getName());
                        }
                    }
                }
            }
        }

        return success(voPageResult);
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得订单精简列表")
    @PreAuthorize("@ss.hasPermission('erp:order:query')")
    public CommonResult<List<OrderRespVO>> getOrderSimpleList() {
        List<OrderDO> list = orderService.getOrderSimpleList();
        return success(BeanUtils.toBean(list, OrderRespVO.class));
    }

    @GetMapping("/simple-list-by-supplier")
    @Operation(summary = "根据供应商获得采购订单精简列表")
    @Parameter(name = "supplierId", description = "供应商编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:order:query')")
    public CommonResult<List<OrderRespVO>> getOrderSimpleListBySupplierId(@RequestParam("supplierId") Long supplierId) {
        List<OrderDO> list = orderService.getOrderListBySupplierId(supplierId);
        return success(BeanUtils.toBean(list, OrderRespVO.class));
    }

    // ========== 提交/取消相关接口 ==========

    @PutMapping("/approve")
    @Operation(summary = "提交订单（草稿→已确认）")
    @Parameter(name = "id", description = "订单编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:order:update')")
    public CommonResult<Boolean> approveOrder(@RequestParam("id") Long id) {
        orderService.approveOrder(id);
        return success(true);
    }

    @PutMapping("/reject")
    @Operation(summary = "取消订单")
    @Parameters({
            @Parameter(name = "id", description = "订单编号", required = true),
            @Parameter(name = "reason", description = "取消原因")
    })
    @PreAuthorize("@ss.hasPermission('erp:order:update')")
    public CommonResult<Boolean> rejectOrder(@RequestParam("id") Long id,
                                              @RequestParam(value = "reason", required = false) String reason) {
        orderService.rejectOrder(id, reason);
        return success(true);
    }

    // ========== 成本填充相关接口 ==========

    @PutMapping("/fill-cost")
    @Operation(summary = "填充订单成本")
    @PreAuthorize("@ss.hasPermission('erp:order:fill-cost')")
    public CommonResult<Boolean> fillOrderCost(@Valid @RequestBody OrderCostFillReqVO fillReqVO) {
        orderService.fillOrderCost(fillReqVO);
        return success(true);
    }

    @PutMapping("/edit-cost")
    @Operation(summary = "编辑订单成本（管理员）")
    @PreAuthorize("@ss.hasPermission('erp:order:edit-cost')")
    public CommonResult<Boolean> editOrderCost(@Valid @RequestBody OrderCostFillReqVO editReqVO) {
        orderService.editOrderCost(editReqVO);
        return success(true);
    }

    @PutMapping("/edit-items")
    @Operation(summary = "编辑订单商品（退换货）")
    @PreAuthorize("@ss.hasPermission('erp:order:edit-cost')")
    public CommonResult<Boolean> editOrderItems(@Valid @RequestBody OrderSaveReqVO editReqVO) {
        orderService.editOrderItems(editReqVO);
        return success(true);
    }

    @PutMapping("/edit-items-simple")
    @Operation(summary = "简单编辑订单商品（仅修改销售信息，不动关联数据）")
    @PreAuthorize("@ss.hasPermission('erp:order:update')")
    public CommonResult<Boolean> editOrderItemsSimple(@Valid @RequestBody OrderSaveReqVO editReqVO) {
        orderService.editOrderItemsSimple(editReqVO);
        return success(true);
    }

    // ========== 结算相关接口 ==========

    @PutMapping("/enter-settlement")
    @Operation(summary = "进入结算（已发货→结算中）")
    @Parameter(name = "id", description = "订单编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:order:update')")
    public CommonResult<Boolean> enterSettlement(@RequestParam("id") Long id) {
        orderService.enterSettlement(id);
        return success(true);
    }

    @PutMapping("/complete")
    @Operation(summary = "手动标记订单完成（结算中→已完成）")
    @Parameter(name = "id", description = "订单编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:order:update')")
    public CommonResult<Boolean> completeOrder(@RequestParam("id") Long id) {
        orderService.completeOrder(id);
        return success(true);
    }

    @GetMapping("/has-associated-data")
    @Operation(summary = "检查订单是否存在关联数据（采购单/付款计划/费用）")
    @Parameter(name = "id", description = "订单编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:order:update')")
    public CommonResult<Boolean> hasAssociatedData(@RequestParam("id") Long id) {
        return success(orderService.hasAssociatedData(id));
    }

    @DeleteMapping("/clear-associated-data")
    @Operation(summary = "清空订单关联数据，保留订单本身（需无实付记录）")
    @Parameter(name = "id", description = "订单编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:order:update')")
    public CommonResult<Boolean> clearAssociatedData(@RequestParam("id") Long id) {
        orderService.clearAssociatedData(id);
        return success(true);
    }

    // ========== 打印导出相关接口 ==========

    @GetMapping("/print-export")
    @Operation(summary = "导出订单打印数据（客户联开单）")
    @Parameter(name = "id", description = "订单编号", required = true)
    public void printOrderExport(@RequestParam("id") Long id,
                                 HttpServletResponse response) throws Exception {
        // 1. 获取订单信息
        OrderDO order = orderService.getOrder(id);
        if (order == null) {
            throw new Exception(String.valueOf(ORDER_NOT_EXISTS));
        }

        // 2. 获取客户信息
        CustomerDO customer = null;
        if (order.getCustomerId() != null) {
            customer = customerService.getCustomer(order.getCustomerId());
        }

        // 3. 获取订单明细
        List<OrderItemDO> items = orderService.getOrderItemList(id);

        // 4. 获取销售员姓名
        String salesmanName = "";
        if (order.getSalesmanId() != null) {
            AdminUserRespDTO user = adminUserApi.getUser(order.getSalesmanId());
            if (user != null) {
                salesmanName = user.getNickname();
            }
        }

        // 5. 生成Excel并写入响应流
        orderService.generatePrintExcel(order, customer, items, salesmanName, response);
    }

    @GetMapping("/export-detail")
    @Operation(summary = "导出订单进销项明细Excel（多Sheet）")
    @Parameter(name = "id", description = "订单编号", required = true)
    public void exportOrderDetail(@RequestParam("id") Long id,
                                  HttpServletResponse response) throws Exception {
        orderService.generateDetailExcel(id, response);
    }

    // ========== 副订单相关接口 ==========

    @GetMapping("/pending-sub-orders")
    @Operation(summary = "查询待录入副订单的主订单列表")
    @PreAuthorize("@ss.hasPermission('erp:order:query')")
    public CommonResult<List<OrderRespVO>> getPendingSubOrders() {
        List<OrderDO> orders = orderMapper.selectList(new LambdaQueryWrapperX<OrderDO>()
                .eq(OrderDO::getOrderCategory, 0)
                .eq(OrderDO::getSubOrderStatus, 0)
                .eq(OrderDO::getIsReturn, 0)
                .orderByDesc(OrderDO::getCreateTime));
        List<OrderRespVO> voList = BeanUtils.toBean(orders, OrderRespVO.class);
        // 填充工地名称
        Set<Long> projectIds = orders.stream()
                .map(OrderDO::getProjectId).filter(pid -> pid != null).collect(Collectors.toSet());
        if (CollUtil.isNotEmpty(projectIds)) {
            Map<Long, cn.iocoder.stmc.module.erp.dal.dataobject.project.ProjectDO> projectMap =
                    projectService.getProjectMap(projectIds);
            voList.forEach(vo -> {
                if (vo.getProjectId() != null) {
                    cn.iocoder.stmc.module.erp.dal.dataobject.project.ProjectDO p = projectMap.get(vo.getProjectId());
                    if (p != null) vo.setProjectName(p.getName());
                }
            });
        }
        return success(voList);
    }

    @GetMapping("/pending-sub-order-count")
    @Operation(summary = "查询待录入副订单数量")
    @PreAuthorize("@ss.hasPermission('erp:order:query')")
    public CommonResult<Long> getPendingSubOrderCount() {
        Long count = orderMapper.selectCount(new LambdaQueryWrapperX<OrderDO>()
                .eq(OrderDO::getOrderCategory, 0)
                .eq(OrderDO::getSubOrderStatus, 0)
                .eq(OrderDO::getIsReturn, 0));
        return success(count);
    }

    @PostMapping("/sub-order/create")
    @Operation(summary = "创建副订单（B角色录入）")
    @PreAuthorize("@ss.hasPermission('erp:order:create')")
    public CommonResult<Long> createSubOrder(@Valid @RequestBody SubOrderSaveReqVO reqVO) {
        return success(orderService.createSubOrder(reqVO));
    }

    @GetMapping("/sub-order/get-by-parent")
    @Operation(summary = "根据主订单ID查询副订单")
    @Parameter(name = "parentOrderId", description = "主订单ID", required = true)
    @PreAuthorize("@ss.hasPermission('erp:order:query')")
    public CommonResult<OrderRespVO> getSubOrderByParent(@RequestParam Long parentOrderId) {
        OrderDO subOrder = orderMapper.selectOne(new LambdaQueryWrapperX<OrderDO>()
                .eq(OrderDO::getParentOrderId, parentOrderId)
                .eq(OrderDO::getOrderCategory, 1)
                .eq(OrderDO::getIsReturn, 0));
        if (subOrder == null) {
            return success(null);
        }
        OrderRespVO vo = BeanUtils.toBean(subOrder, OrderRespVO.class);
        List<OrderItemDO> items = orderService.getOrderItemList(subOrder.getId());
        vo.setItems(BeanUtils.toBean(items, OrderItemRespVO.class));
        return success(vo);
    }

    // ========== 退货相关接口 ==========

    @PostMapping("/create-return")
    @Operation(summary = "创建退货单")
    @PreAuthorize("@ss.hasPermission('erp:order:create')")
    public CommonResult<Long> createReturnOrder(@Valid @RequestBody ReturnOrderReqVO reqVO) {
        return success(orderService.createReturnOrder(reqVO.getOrderId(), reqVO.getItems()));
    }

    /**
     * 判断用户是否为管理员（可查看全部数据）
     */
    private boolean isAdmin(Long userId) {
        if (userId == null) {
            return false;
        }
        return permissionApi.hasAnyRoles(userId, ADMIN_ROLES);
    }

    /**
     * 判断用户是否为B角色（熙汇达鑫）
     */
    private boolean isRoleB(Long userId) {
        if (userId == null) {
            return false;
        }
        return permissionApi.hasAnyRoles(userId, ROLE_B);
    }

}
