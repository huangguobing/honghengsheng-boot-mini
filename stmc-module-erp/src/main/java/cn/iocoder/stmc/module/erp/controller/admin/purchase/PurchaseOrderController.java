package cn.iocoder.stmc.module.erp.controller.admin.purchase;

import cn.iocoder.stmc.framework.common.pojo.CommonResult;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.purchase.vo.*;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderDO;
import cn.iocoder.stmc.module.erp.dal.mysql.order.OrderMapper;
import cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderItemDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.supplier.SupplierDO;
import cn.iocoder.stmc.framework.common.biz.system.permission.PermissionCommonApi;
import cn.iocoder.stmc.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.stmc.module.erp.service.order.OrderService;
import cn.iocoder.stmc.module.erp.service.purchase.PurchaseOrderService;
import cn.iocoder.stmc.module.erp.service.supplier.SupplierService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.*;
import java.util.stream.Collectors;

import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;

import static cn.iocoder.stmc.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - ERP 采购单")
@RestController
@RequestMapping("/erp/purchase-order")
@Validated
public class PurchaseOrderController {

    private static final String[] ADMIN_ROLES = {"super_admin", "honghengsheng"};
    private static final String[] ROLE_B = {"xihuidaxin"};

    @Resource
    private PurchaseOrderService purchaseOrderService;

    @Resource
    private SupplierService supplierService;

    @Resource
    private OrderService orderService;

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private PermissionCommonApi permissionApi;

    @PostMapping("/create")
    @Operation(summary = "创建采购单")
    @PreAuthorize("@ss.hasPermission('erp:purchase-order:create')")
    public CommonResult<Long> createPurchaseOrder(@Valid @RequestBody PurchaseOrderSaveReqVO createReqVO) {
        return success(purchaseOrderService.createPurchaseOrder(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新采购单")
    @PreAuthorize("@ss.hasPermission('erp:purchase-order:update')")
    public CommonResult<Boolean> updatePurchaseOrder(@Valid @RequestBody PurchaseOrderSaveReqVO updateReqVO) {
        purchaseOrderService.updatePurchaseOrder(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除采购单")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:purchase-order:delete')")
    public CommonResult<Boolean> deletePurchaseOrder(@RequestParam("id") Long id) {
        purchaseOrderService.deletePurchaseOrder(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得采购单")
    @Parameter(name = "id", description = "编号", required = true, example = "1024")
    @PreAuthorize("@ss.hasPermission('erp:purchase-order:query')")
    public CommonResult<PurchaseOrderRespVO> getPurchaseOrder(@RequestParam("id") Long id) {
        PurchaseOrderDO purchaseOrder = purchaseOrderService.getPurchaseOrder(id);
        if (purchaseOrder == null) {
            return success(null);
        }
        if (!canAccessOrder(purchaseOrder.getOrderId())) {
            return success(null);
        }
        PurchaseOrderRespVO respVO = BeanUtils.toBean(purchaseOrder, PurchaseOrderRespVO.class);
        // 填充明细
        List<PurchaseOrderItemDO> items = purchaseOrderService.getPurchaseOrderItems(id);
        respVO.setItems(BeanUtils.toBean(items, PurchaseOrderItemRespVO.class));
        // 填充供应商名称
        if (purchaseOrder.getSupplierId() != null) {
            SupplierDO supplier = supplierService.getSupplier(purchaseOrder.getSupplierId());
            if (supplier != null) {
                respVO.setSupplierName(supplier.getName());
            }
        }
        // 填充销售订单号
        if (purchaseOrder.getOrderId() != null) {
            OrderDO order = orderService.getOrder(purchaseOrder.getOrderId());
            if (order != null) {
                respVO.setOrderNo(order.getOrderNo());
            }
        }
        return success(respVO);
    }

    @GetMapping("/page")
    @Operation(summary = "获得采购单分页")
    @PreAuthorize("@ss.hasPermission('erp:purchase-order:query')")
    public CommonResult<PageResult<PurchaseOrderRespVO>> getPurchaseOrderPage(@Valid PurchaseOrderPageReqVO pageVO) {
        pageVO.setVisibleOrderIds(new ArrayList<>(getVisibleOrderIds()));
        PageResult<PurchaseOrderDO> pageResult = purchaseOrderService.getPurchaseOrderPage(pageVO);
        PageResult<PurchaseOrderRespVO> respPage = BeanUtils.toBean(pageResult, PurchaseOrderRespVO.class);
        // 批量填充供应商名称
        if (respPage.getList() != null && !respPage.getList().isEmpty()) {
            Set<Long> supplierIds = pageResult.getList().stream()
                    .map(PurchaseOrderDO::getSupplierId)
                    .filter(Objects::nonNull)
                    .collect(Collectors.toSet());
            Map<Long, SupplierDO> supplierMap = supplierService.getSupplierMap(supplierIds);
            Set<Long> orderIds = pageResult.getList().stream()
                    .map(PurchaseOrderDO::getOrderId)
                    .filter(Objects::nonNull)
                    .collect(Collectors.toSet());
            Map<Long, OrderDO> orderMap = orderService.getOrderMap(orderIds);
            respPage.getList().forEach(vo -> {
                if (vo.getSupplierId() != null && supplierMap.containsKey(vo.getSupplierId())) {
                    vo.setSupplierName(supplierMap.get(vo.getSupplierId()).getName());
                }
                if (vo.getOrderId() != null && orderMap.containsKey(vo.getOrderId())) {
                    vo.setOrderNo(orderMap.get(vo.getOrderId()).getOrderNo());
                }
            });
        }
        return success(respPage);
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得采购单精简列表")
    @PreAuthorize("@ss.hasPermission('erp:purchase-order:query')")
    public CommonResult<List<PurchaseOrderRespVO>> getPurchaseOrderSimpleList() {
        List<PurchaseOrderDO> list = purchaseOrderService.getPurchaseOrderSimpleList();
        List<PurchaseOrderRespVO> respList = BeanUtils.toBean(list, PurchaseOrderRespVO.class);
        // 批量填充供应商名称
        if (!respList.isEmpty()) {
            Set<Long> supplierIds = list.stream()
                    .map(PurchaseOrderDO::getSupplierId)
                    .filter(Objects::nonNull)
                    .collect(Collectors.toSet());
            Map<Long, SupplierDO> supplierMap = supplierService.getSupplierMap(supplierIds);
            respList.forEach(vo -> {
                if (vo.getSupplierId() != null && supplierMap.containsKey(vo.getSupplierId())) {
                    vo.setSupplierName(supplierMap.get(vo.getSupplierId()).getName());
                }
            });
        }
        return success(respList);
    }

    @GetMapping("/list-by-order")
    @Operation(summary = "根据销售订单获取采购单列表（含明细）")
    @Parameter(name = "orderId", description = "销售订单编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:purchase-order:query')")
    public CommonResult<List<PurchaseOrderRespVO>> getPurchaseOrderListByOrderId(@RequestParam("orderId") Long orderId) {
        if (!canAccessOrder(orderId)) {
            return success(Collections.emptyList());
        }
        List<PurchaseOrderDO> list = purchaseOrderService.getPurchaseOrdersByOrderId(orderId);
        List<PurchaseOrderRespVO> respList = BeanUtils.toBean(list, PurchaseOrderRespVO.class);
        if (!respList.isEmpty()) {
            // 批量填充供应商名称
            Set<Long> supplierIds = list.stream()
                    .map(PurchaseOrderDO::getSupplierId)
                    .filter(Objects::nonNull)
                    .collect(Collectors.toSet());
            Map<Long, SupplierDO> supplierMap = supplierService.getSupplierMap(supplierIds);
            respList.forEach(vo -> {
                if (vo.getSupplierId() != null && supplierMap.containsKey(vo.getSupplierId())) {
                    vo.setSupplierName(supplierMap.get(vo.getSupplierId()).getName());
                }
            });

            // 批量填充采购明细（修复：原接口未返回 items 导致前端剩余量计算错误）
            Set<Long> poIds = respList.stream().map(PurchaseOrderRespVO::getId).collect(Collectors.toSet());
            List<PurchaseOrderItemDO> allItems = purchaseOrderService.getPurchaseOrderItemsByPurchaseOrderIds(poIds);
            Map<Long, List<PurchaseOrderItemDO>> itemsGrouped = allItems.stream()
                    .collect(Collectors.groupingBy(PurchaseOrderItemDO::getPurchaseOrderId));
            respList.forEach(vo -> vo.setItems(
                    BeanUtils.toBean(itemsGrouped.getOrDefault(vo.getId(), Collections.emptyList()),
                            PurchaseOrderItemRespVO.class)
            ));
        }
        return success(respList);
    }

    private boolean canAccessOrder(Long orderId) {
        return getVisibleOrderIds().contains(orderId);
    }

    private Set<Long> getVisibleOrderIds() {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        LambdaQueryWrapperX<OrderDO> wrapper = new LambdaQueryWrapperX<OrderDO>();
        if (userId != null && permissionApi.hasAnyRoles(userId, ROLE_B)) {
            wrapper.eq(OrderDO::getOrderCategory, 1).isNotNull(OrderDO::getParentOrderId);
        } else {
            wrapper.eq(OrderDO::getOrderCategory, 0).isNull(OrderDO::getParentOrderId);
        }
        return orderMapper.selectList(wrapper).stream().map(OrderDO::getId).collect(Collectors.toSet());
    }

}
