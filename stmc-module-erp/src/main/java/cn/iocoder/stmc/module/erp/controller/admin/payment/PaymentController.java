package cn.iocoder.stmc.module.erp.controller.admin.payment;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.stmc.framework.common.biz.system.permission.PermissionCommonApi;
import cn.iocoder.stmc.framework.common.pojo.CommonResult;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.stmc.module.erp.controller.admin.payment.vo.PaymentPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.payment.vo.PaymentRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.payment.vo.PaymentSaveReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.payment.vo.PaymentSupplierSummaryRespVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.customer.CustomerDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import cn.iocoder.stmc.module.erp.dal.mysql.order.OrderMapper;
import cn.iocoder.stmc.module.erp.dal.dataobject.payment.PaymentDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.supplier.SupplierDO;
import cn.iocoder.stmc.module.erp.service.customer.CustomerService;
import cn.iocoder.stmc.module.erp.service.order.OrderService;
import cn.iocoder.stmc.module.erp.service.payment.PaymentService;
import cn.iocoder.stmc.module.erp.service.supplier.SupplierService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;

import static cn.iocoder.stmc.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - ERP 付款")
@RestController
@RequestMapping("/erp/payment")
@Validated
public class PaymentController {

    private static final String[] ADMIN_ROLES = {"super_admin", "honghengsheng"};
    private static final String[] ROLE_B = {"xihuidaxin"};

    @Resource
    private PaymentService paymentService;

    @Resource
    private SupplierService supplierService;

    @Resource
    private CustomerService customerService;

    @Resource
    private OrderService orderService;

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private PermissionCommonApi permissionApi;

    @PostMapping("/create")
    @Operation(summary = "创建付款")
    @PreAuthorize("@ss.hasPermission('erp:payment:create')")
    public CommonResult<Long> createPayment(@Valid @RequestBody PaymentSaveReqVO createReqVO) {
        return success(paymentService.createPayment(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新付款")
    @PreAuthorize("@ss.hasPermission('erp:payment:update')")
    public CommonResult<Boolean> updatePayment(@Valid @RequestBody PaymentSaveReqVO updateReqVO) {
        paymentService.updatePayment(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除付款")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:payment:delete')")
    public CommonResult<Boolean> deletePayment(@RequestParam("id") Long id) {
        paymentService.deletePayment(id);
        return success(true);
    }

    @DeleteMapping("/delete-list")
    @Operation(summary = "批量删除付款")
    @Parameter(name = "ids", description = "编号列表", required = true)
    @PreAuthorize("@ss.hasPermission('erp:payment:delete')")
    public CommonResult<Boolean> deletePaymentList(@RequestParam("ids") List<Long> ids) {
        paymentService.deletePaymentList(ids);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得付款")
    @Parameter(name = "id", description = "编号", required = true, example = "1024")
    @PreAuthorize("@ss.hasPermission('erp:payment:query')")
    public CommonResult<PaymentRespVO> getPayment(@RequestParam("id") Long id) {
        PaymentDO payment = paymentService.getPayment(id);
        if (payment == null || !canAccessOrder(payment.getOrderId())) {
            return success(null);
        }
        return success(BeanUtils.toBean(payment, PaymentRespVO.class));
    }

    @GetMapping("/page")
    @Operation(summary = "获得付款分页")
    @PreAuthorize("@ss.hasPermission('erp:payment:query')")
    public CommonResult<PageResult<PaymentRespVO>> getPaymentPage(@Valid PaymentPageReqVO pageVO) {
        pageVO.setVisibleOrderIds(new ArrayList<>(getVisibleOrderIds()));
        PageResult<PaymentDO> pageResult = paymentService.getPaymentPage(pageVO);
        PageResult<PaymentRespVO> voPageResult = BeanUtils.toBean(pageResult, PaymentRespVO.class);
        // 填充关联信息
        fillPaymentInfo(voPageResult.getList());
        return success(voPageResult);
    }

    @GetMapping("/list-by-order")
    @Operation(summary = "根据订单获取付款列表")
    @Parameter(name = "orderId", description = "订单编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:payment:query')")
    public CommonResult<List<PaymentRespVO>> getPaymentListByOrderId(@RequestParam("orderId") Long orderId) {
        if (!canAccessOrder(orderId)) {
            return success(Collections.emptyList());
        }
        List<PaymentDO> list = paymentService.getPaymentListByOrderId(orderId);
        List<PaymentRespVO> voList = BeanUtils.toBean(list, PaymentRespVO.class);
        fillPaymentInfo(voList);
        return success(voList);
    }

    @GetMapping("/unpaid-supplier-summary")
    @Operation(summary = "获得供应商未付款汇总")
    @PreAuthorize("@ss.hasPermission('erp:payment:query')")
    public CommonResult<List<PaymentSupplierSummaryRespVO>> getUnpaidSupplierSummary() {
        return success(paymentService.getUnpaidSupplierSummary());
    }

    /**
     * 填充付款关联信息（供应商名称、订单号、客户名称、业务员）
     */
    private void fillPaymentInfo(List<PaymentRespVO> list) {
        if (CollUtil.isEmpty(list)) {
            return;
        }
        // 获取供应商ID集合
        Set<Long> supplierIds = list.stream()
                .map(PaymentRespVO::getSupplierId)
                .filter(id -> id != null)
                .collect(Collectors.toSet());
        // 获取订单ID集合
        Set<Long> orderIds = list.stream()
                .map(PaymentRespVO::getOrderId)
                .filter(id -> id != null)
                .collect(Collectors.toSet());
        // 批量查询供应商
        Map<Long, SupplierDO> supplierMap = CollUtil.isEmpty(supplierIds) ?
                Collections.emptyMap() :
                supplierService.getSupplierMap(supplierIds);
        // 批量查询订单
        Map<Long, OrderDO> orderMap = CollUtil.isEmpty(orderIds) ?
                Collections.emptyMap() :
                orderService.getOrderMap(orderIds);
        // 从订单中提取客户ID
        Set<Long> customerIds = orderMap.values().stream()
                .map(OrderDO::getCustomerId)
                .filter(id -> id != null)
                .collect(Collectors.toSet());
        // 批量查询客户
        Map<Long, CustomerDO> customerMap = CollUtil.isEmpty(customerIds) ?
                Collections.emptyMap() :
                customerService.getCustomerMap(customerIds);
        // 填充数据
        for (PaymentRespVO vo : list) {
            if (vo.getSupplierId() != null) {
                SupplierDO supplier = supplierMap.get(vo.getSupplierId());
                vo.setSupplierName(supplier != null ? supplier.getName() : null);
            }
            if (vo.getOrderId() != null) {
                OrderDO order = orderMap.get(vo.getOrderId());
                if (order != null) {
                    vo.setOrderNo(order.getOrderNo());
                    vo.setSalesmanName(order.getSalesmanName());
                    // 从客户表获取客户名称
                    if (order.getCustomerId() != null) {
                        CustomerDO customer = customerMap.get(order.getCustomerId());
                        vo.setCustomerName(customer != null ? customer.getName() : null);
                    }
                }
            }
        }
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
