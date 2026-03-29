package cn.iocoder.stmc.module.erp.controller.admin.paymentplan;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.stmc.framework.common.pojo.CommonResult;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanAvailableOrderRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanAvailableOrderRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.PaymentPlanSaveReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.paymentplan.vo.ReconcileSummaryVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.customer.CustomerDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.payment.PaymentDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.paymentplan.PaymentPlanDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.supplier.SupplierDO;
import cn.iocoder.stmc.module.erp.service.customer.CustomerService;
import cn.iocoder.stmc.module.erp.service.order.OrderService;
import cn.iocoder.stmc.module.erp.service.payment.PaymentService;
import cn.iocoder.stmc.module.erp.service.paymentplan.PaymentPlanService;
import cn.iocoder.stmc.module.erp.service.supplier.SupplierService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

import static cn.iocoder.stmc.framework.common.pojo.CommonResult.success;

/**
 * 管理后台 - ERP 付款计划
 *
 * @author stmc
 */
@Tag(name = "管理后台 - ERP 付款计划")
@RestController
@RequestMapping("/erp/payment-plan")
@Validated
public class PaymentPlanController {

    @Resource
    private PaymentPlanService paymentPlanService;
    @Resource
    private SupplierService supplierService;
    @Resource
    private PaymentService paymentService;
    @Resource
    private OrderService orderService;
    @Resource
    private CustomerService customerService;
    @Resource
    private cn.iocoder.stmc.module.erp.service.project.ProjectService projectService;

    @GetMapping("/page")
    @Operation(summary = "获取付款计划分页")
    @PreAuthorize("@ss.hasPermission('erp:payment-plan:query')")
    public CommonResult<PageResult<PaymentPlanRespVO>> getPaymentPlanPage(@Validated PaymentPlanPageReqVO pageReqVO) {
        PageResult<PaymentPlanDO> pageResult = paymentPlanService.getPaymentPlanPage(pageReqVO);
        // 转换为VO并填充关联信息
        PageResult<PaymentPlanRespVO> voPageResult = BeanUtils.toBean(pageResult, PaymentPlanRespVO.class);
        fillPaymentPlanInfo(voPageResult.getList());
        return success(voPageResult);
    }

    @GetMapping("/list-by-order")
    @Operation(summary = "根据订单获取收付款计划列表")
    @Parameter(name = "orderId", description = "订单编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:payment-plan:query')")
    public CommonResult<List<PaymentPlanRespVO>> getPaymentPlansByOrderId(@RequestParam("orderId") Long orderId) {
        List<PaymentPlanDO> list = paymentPlanService.getPaymentPlansByOrderId(orderId);
        List<PaymentPlanRespVO> voList = BeanUtils.toBean(list, PaymentPlanRespVO.class);
        fillPaymentPlanInfo(voList);
        return success(voList);
    }

    @GetMapping("/list-by-payment")
    @Operation(summary = "获取付款单的付款计划列表")
    @Parameter(name = "paymentId", description = "付款单编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:payment-plan:query')")
    public CommonResult<List<PaymentPlanRespVO>> getPaymentPlansByPaymentId(@RequestParam("paymentId") Long paymentId) {
        List<PaymentPlanDO> list = paymentPlanService.getPaymentPlansByPaymentId(paymentId);
        List<PaymentPlanRespVO> voList = BeanUtils.toBean(list, PaymentPlanRespVO.class);
        fillPaymentPlanInfo(voList);
        return success(voList);
    }

    @PostMapping("/mark-paid")
    @Operation(summary = "标记付款计划为已付款")
    @PreAuthorize("@ss.hasPermission('erp:payment-plan:pay')")
    public CommonResult<Boolean> markAsPaid(@RequestParam("id") @Parameter(description = "付款计划编号") Long id) {
        paymentPlanService.markAsPaid(id);
        return success(true);
    }

    // ========== 鸿恒盛扩展接口 ==========

    @PostMapping("/create")
    @Operation(summary = "创建收付款计划")
    @PreAuthorize("@ss.hasPermission('erp:payment-plan:create')")
    public CommonResult<Long> createPaymentPlan(@Valid @RequestBody PaymentPlanSaveReqVO reqVO) {
        return success(paymentPlanService.createPaymentPlan(reqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新收付款计划（已付款/部分付款仅允许改备注和方式）")
    @PreAuthorize("@ss.hasPermission('erp:payment-plan:update')")
    public CommonResult<Boolean> updatePaymentPlan(@Valid @RequestBody PaymentPlanSaveReqVO reqVO) {
        paymentPlanService.updatePaymentPlan(reqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除收付款计划（仅未付款允许删除）")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:payment-plan:delete')")
    public CommonResult<Boolean> deletePaymentPlan(@RequestParam("id") Long id) {
        paymentPlanService.deletePaymentPlan(id);
        return success(true);
    }

    @PutMapping("/partial-pay")
    @Operation(summary = "部分付款（进入部分付款或已付款状态）")
    @PreAuthorize("@ss.hasPermission('erp:payment-plan:pay')")
    public CommonResult<Boolean> partialPay(@RequestParam("id") Long id,
                                             @RequestParam("amount") BigDecimal amount,
                                             @RequestParam(value = "paymentMethod", required = false) Integer paymentMethod) {
        paymentPlanService.partialPay(id, amount, paymentMethod);
        return success(true);
    }

    @GetMapping("/reconcile-summary")
    @Operation(summary = "对账汇总")
    @Parameter(name = "type", description = "类型：0=应付 1=应收", required = true)
    @PreAuthorize("@ss.hasPermission('erp:payment-plan:query')")
    public CommonResult<List<ReconcileSummaryVO>> getReconcileSummary(@RequestParam("type") Integer type) {
        return success(paymentPlanService.getReconcileSummary(type));
    }

    @GetMapping("/available-order-list")
    @Operation(summary = "获取收付款计划可分配订单列表")
    @Parameter(name = "type", description = "类型：0=应付 1=应收", required = true)
    @PreAuthorize("@ss.hasPermission('erp:payment-plan:query')")
    public CommonResult<List<PaymentPlanAvailableOrderRespVO>> getAvailableOrderList(@RequestParam("type") Integer type) {
        return success(paymentPlanService.getAvailableOrderList(type));
    }

    /**
     * 填充付款计划关联信息（供应商名称、订单ID、客户名称、业务员）
     */
    private void fillPaymentPlanInfo(List<PaymentPlanRespVO> list) {
        if (CollUtil.isEmpty(list)) {
            return;
        }
        // 1. 获取所有供应商ID
        Set<Long> supplierIds = list.stream()
                .map(PaymentPlanRespVO::getSupplierId)
                .filter(id -> id != null)
                .collect(Collectors.toSet());
        // 2. 获取所有付款单ID
        Set<Long> paymentIds = list.stream()
                .map(PaymentPlanRespVO::getPaymentId)
                .filter(id -> id != null)
                .collect(Collectors.toSet());

        // 3. 批量查询供应商
        Map<Long, SupplierDO> supplierMap = CollUtil.isEmpty(supplierIds) ?
                Collections.emptyMap() :
                supplierService.getSupplierMap(supplierIds);

        // 4. 批量查询付款单（获取订单ID）
        Map<Long, PaymentDO> paymentMap = new HashMap<>();
        Set<Long> orderIds = new HashSet<>();

        // 先从 PaymentPlanRespVO 收集 orderId（直接关联）
        for (PaymentPlanRespVO vo : list) {
            if (vo.getOrderId() != null) {
                orderIds.add(vo.getOrderId());
            }
        }

        // 再从 PaymentDO 收集 orderId（间接关联）
        if (CollUtil.isNotEmpty(paymentIds)) {
            for (Long paymentId : paymentIds) {
                PaymentDO payment = paymentService.getPayment(paymentId);
                if (payment != null) {
                    paymentMap.put(paymentId, payment);
                    if (payment.getOrderId() != null) {
                        orderIds.add(payment.getOrderId());
                    }
                }
            }
        }

        // 5. 批量查询订单
        Map<Long, OrderDO> orderMap = CollUtil.isEmpty(orderIds) ?
                Collections.emptyMap() :
                orderService.getOrderMap(orderIds);

        // 6. 从订单和付款计划中提取客户ID
        Set<Long> customerIds = orderMap.values().stream()
                .map(OrderDO::getCustomerId)
                .filter(id -> id != null)
                .collect(Collectors.toSet());
        // 也收集付款计划中直接关联的客户ID（应收场景）
        for (PaymentPlanRespVO vo : list) {
            if (vo.getCustomerId() != null) {
                customerIds.add(vo.getCustomerId());
            }
        }

        // 7. 批量查询客户
        Map<Long, CustomerDO> customerMap = CollUtil.isEmpty(customerIds) ?
                Collections.emptyMap() :
                customerService.getCustomerMap(customerIds);

        // 7.5 收集并批量查询项目
        Set<Long> projectIds = list.stream()
                .map(PaymentPlanRespVO::getProjectId)
                .filter(id -> id != null)
                .collect(Collectors.toSet());

        // 8. 填充数据
        for (PaymentPlanRespVO vo : list) {
            // 填充供应商名称
            if (vo.getSupplierId() != null) {
                SupplierDO supplier = supplierMap.get(vo.getSupplierId());
                vo.setSupplierName(supplier != null ? supplier.getName() : null);
            }

            // 优先使用 PaymentPlanDO 中直接关联的 orderId
            Long orderId = vo.getOrderId();

            // 如果 PaymentPlanDO 没有 orderId，则从 PaymentDO 获取
            if (orderId == null && vo.getPaymentId() != null) {
                PaymentDO payment = paymentMap.get(vo.getPaymentId());
                if (payment != null && payment.getOrderId() != null) {
                    orderId = payment.getOrderId();
                    vo.setOrderId(orderId);
                }
            }

            // 填充订单相关信息
            if (orderId != null) {
                OrderDO order = orderMap.get(orderId);
                if (order != null) {
                    vo.setOrderNo(order.getOrderNo());
                    vo.setSalesmanName(order.getSalesmanName());
                    // 从客户表获取客户名称（仅当未直接设置客户名称时）
                    if (vo.getCustomerName() == null && order.getCustomerId() != null) {
                        CustomerDO customer = customerMap.get(order.getCustomerId());
                        vo.setCustomerName(customer != null ? customer.getName() : null);
                    }
                }
            }

            // 填充直接关联的客户名称（应收场景）
            if (vo.getCustomerName() == null && vo.getCustomerId() != null) {
                CustomerDO customer = customerMap.get(vo.getCustomerId());
                vo.setCustomerName(customer != null ? customer.getName() : null);
            }

            // 填充项目名称
            if (vo.getProjectId() != null) {
                cn.iocoder.stmc.module.erp.dal.dataobject.project.ProjectDO project =
                        projectService.getProject(vo.getProjectId());
                if (project != null) {
                    vo.setProjectName(project.getName());
                }
            }
        }
    }

}
