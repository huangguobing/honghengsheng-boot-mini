# 订单成本填充与应收应付业务重构 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 重构订单状态流转、解耦成本填充与状态推进、建立应收应付计划闭环管理

**Architecture:** 在现有订单模块基础上渐进式重构。状态枚举新增 SETTLING(4)；fillOrderCost 解耦为纯采购信息填充；应收应付统一由 PaymentPlan 管理；新增 enterSettlement 和自动完成判定逻辑。

**Tech Stack:** Spring Boot 2.7.18, MyBatis-Plus, Vue 3 + TypeScript + Element Plus

---

## Task 1: 修改订单状态枚举 + 状态转换表

**Files:**
- Modify: `stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/enums/OrderStatusEnum.java`
- Modify: `stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/service/order/OrderServiceImpl.java:75-82` (VALID_STATUS_TRANSITIONS)

**Step 1: 修改 OrderStatusEnum.java**

将 `PENDING_LOAD(1, "待装货")` 改为 `CONFIRMED(1, "已确认")`，新增 `SETTLING(4, "结算中")`：

```java
public enum OrderStatusEnum {

    DRAFT(0, "草稿"),
    CONFIRMED(1, "已确认"),      // 原 PENDING_LOAD
    SHIPPED(2, "已发货"),
    COMPLETED(3, "已完成"),
    SETTLING(4, "结算中"),        // 新增
    CANCELLED(50, "已取消");

    // ... 其余不变
}
```

**Step 2: 修改 VALID_STATUS_TRANSITIONS**

在 `OrderServiceImpl.java` 第75-82行，更新状态转换表：

```java
private static final Map<Integer, Set<Integer>> VALID_STATUS_TRANSITIONS = new HashMap<>();
static {
    VALID_STATUS_TRANSITIONS.put(0, new HashSet<>(Arrays.asList(1, 50)));    // 草稿 -> 已确认、已取消
    VALID_STATUS_TRANSITIONS.put(1, new HashSet<>(Arrays.asList(2, 50)));    // 已确认 -> 已发货、已取消
    VALID_STATUS_TRANSITIONS.put(2, new HashSet<>(Arrays.asList(4, 50)));    // 已发货 -> 结算中、已取消
    VALID_STATUS_TRANSITIONS.put(4, new HashSet<>(Arrays.asList(3)));        // 结算中 -> 已完成
    VALID_STATUS_TRANSITIONS.put(3, Collections.emptySet());                  // 已完成 -> 无
    VALID_STATUS_TRANSITIONS.put(50, Collections.emptySet());                 // 已取消 -> 无
}
```

**Step 3: 全局搜索替换 PENDING_LOAD 引用**

在整个 stmc-module-erp 中搜索 `OrderStatusEnum.PENDING_LOAD`，全部替换为 `OrderStatusEnum.CONFIRMED`。预计涉及：
- `OrderServiceImpl.java` 第396行 fillOrderCost 中的状态校验
- `OrderServiceImpl.java` 第1035行 approveOrder 中设置状态
- 前端状态显示映射

**Step 4: 更新 approveOrder 方法注释**

```java
@Override
public void approveOrder(Long id) {
    // 提交订单（草稿 → 已确认）
    OrderDO order = validateOrderExists(id);
    if (!OrderStatusEnum.DRAFT.getStatus().equals(order.getStatus())) {
        throw exception(ORDER_STATUS_INVALID_TRANSITION);
    }
    OrderDO updateObj = new OrderDO();
    updateObj.setId(id);
    updateObj.setStatus(OrderStatusEnum.CONFIRMED.getStatus());
    orderMapper.updateById(updateObj);
    operationLogService.log("order", id, order.getOrderNo(),
            "submit", null, null, "提交订单");
}
```

**Step 5: 编译验证**

Run: `cd G:/code/honghengsheng_erp/honghengsheng-boot-mini-main && mvn compile -pl stmc-module-erp -am -DskipTests -q`
Expected: BUILD SUCCESS

**Step 6: Commit**

```bash
git add stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/enums/OrderStatusEnum.java
git add stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/service/order/OrderServiceImpl.java
git commit -m "refactor: 订单状态枚举重构，PENDING_LOAD→CONFIRMED，新增SETTLING"
```

---

## Task 2: 新增错误码 + 新增 enterSettlement 和 completeOrder 接口定义

**Files:**
- Modify: `stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/enums/ErrorCodeConstants.java`
- Modify: `stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/service/order/OrderService.java`
- Modify: `stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/controller/admin/order/OrderController.java`

**Step 1: 新增错误码**

在 `ErrorCodeConstants.java` 订单管理区域末尾新增：

```java
ErrorCode ORDER_COST_NOT_FILLED_FOR_SETTLEMENT = new ErrorCode(1_020_003_015, "订单成本尚未填充，无法进入结算");
ErrorCode ORDER_NO_RECEIVABLE_PLAN = new ErrorCode(1_020_003_016, "订单尚未建立应收计划，无法进入结算");
ErrorCode ORDER_NO_PAYABLE_PLAN = new ErrorCode(1_020_003_017, "订单尚未建立应付计划，无法进入结算");
ErrorCode ORDER_RECEIVABLE_AMOUNT_MISMATCH = new ErrorCode(1_020_003_018, "应收计划总额与订单应收金额不一致");
ErrorCode ORDER_PAYABLE_AMOUNT_MISMATCH = new ErrorCode(1_020_003_019, "应付计划总额与供应商采购金额不一致");
ErrorCode ORDER_STATUS_NOT_ALLOW_SETTLEMENT = new ErrorCode(1_020_003_020, "当前订单状态不允许进入结算");
```

**Step 2: OrderService 接口新增方法**

```java
/**
 * 进入结算（已发货 → 结算中）
 * 前置校验：成本已填充、应收应付计划已建立
 *
 * @param id 订单编号
 */
void enterSettlement(Long id);

/**
 * 手动标记订单完成（结算中 → 已完成）
 *
 * @param id 订单编号
 */
void completeOrder(Long id);

/**
 * 检查并自动完成订单（应收应付全部结清时调用）
 *
 * @param orderId 订单编号
 */
void checkAndAutoComplete(Long orderId);
```

**Step 3: OrderController 新增接口**

在"成本填充相关接口"和"付款相关接口"之间新增"结算相关接口"区域：

```java
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
```

**Step 4: Commit**

```bash
git add stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/enums/ErrorCodeConstants.java
git add stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/service/order/OrderService.java
git add stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/controller/admin/order/OrderController.java
git commit -m "feat: 新增进入结算和手动完成接口定义"
```

---

## Task 3: 重构 fillOrderCost — 解耦成本填充与状态推进

**Files:**
- Modify: `stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/controller/admin/order/vo/OrderCostFillReqVO.java`
- Modify: `stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/service/order/OrderServiceImpl.java`

**Step 1: 修改 OrderCostFillReqVO — 移除 paymentDate 和 isPaid**

```java
@Data
public static class ItemCost {

    @Schema(description = "明细ID", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "明细ID不能为空")
    private Long itemId;

    @Schema(description = "进货单位", example = "个")
    private String purchaseUnit;

    @Schema(description = "进货数量", example = "50")
    private BigDecimal purchaseQuantity;

    @Schema(description = "采购单价", example = "16")
    private BigDecimal purchasePrice;

    @Schema(description = "采购金额", example = "800")
    private BigDecimal purchaseAmount;

    @Schema(description = "采购备注", example = "")
    private String purchaseRemark;

    @Schema(description = "供应商ID", example = "1")
    private Long supplierId;

    @Schema(description = "税额（手动输入）", example = "2")
    private BigDecimal taxAmount;

    // 移除 paymentDate 和 isPaid — 付款信息由 PaymentPlan 独立管理
}
```

同时移除 `OrderCostFillReqVO` 顶部不再需要的 `import java.time.LocalDate;`。

**Step 2: 重构 fillOrderCost 方法**

核心变更：
1. 状态校验改为允许 CONFIRMED 和 SHIPPED
2. 移除 `validateSupplierPaymentConsistency` 调用
3. 移除 `item.setPaymentDate()` 和 `item.setIsPaid()`
4. 移除订单状态推进到 COMPLETED
5. 移除按供应商创建付款单的逻辑

```java
@Override
@Transactional(rollbackFor = Exception.class)
public void fillOrderCost(OrderCostFillReqVO fillReqVO) {
    // 1. 校验订单存在
    OrderDO order = validateOrderExists(fillReqVO.getOrderId());

    // 2. 校验订单状态（已确认 或 已发货 状态可以填充成本）
    if (!OrderStatusEnum.CONFIRMED.getStatus().equals(order.getStatus())
            && !OrderStatusEnum.SHIPPED.getStatus().equals(order.getStatus())) {
        throw exception(ORDER_STATUS_NOT_ALLOW_FILL_COST);
    }

    // 3. 获取订单明细
    List<OrderItemDO> items = orderItemMapper.selectListByOrderId(order.getId());
    Map<Long, OrderItemDO> itemMap = items.stream().collect(Collectors.toMap(OrderItemDO::getId, i -> i));

    // 4. 更新明细成本信息
    BigDecimal totalPurchaseAmount = BigDecimal.ZERO;
    BigDecimal totalGrossProfit = BigDecimal.ZERO;
    BigDecimal totalTaxAmount = BigDecimal.ZERO;
    BigDecimal totalNetProfit = BigDecimal.ZERO;

    for (OrderCostFillReqVO.ItemCost itemCost : fillReqVO.getItems()) {
        OrderItemDO item = itemMap.get(itemCost.getItemId());
        if (item == null) {
            continue;
        }

        // 更新采购信息
        item.setPurchaseUnit(itemCost.getPurchaseUnit());
        item.setPurchaseQuantity(itemCost.getPurchaseQuantity());
        item.setPurchasePrice(itemCost.getPurchasePrice());

        // 计算采购金额
        BigDecimal purchaseAmount = itemCost.getPurchaseAmount();
        if (purchaseAmount == null && itemCost.getPurchaseQuantity() != null && itemCost.getPurchasePrice() != null) {
            purchaseAmount = itemCost.getPurchaseQuantity().multiply(itemCost.getPurchasePrice());
        }
        item.setPurchaseAmount(purchaseAmount != null ? purchaseAmount : BigDecimal.ZERO);

        item.setPurchaseRemark(itemCost.getPurchaseRemark());
        item.setSupplierId(itemCost.getSupplierId());
        item.setTaxAmount(itemCost.getTaxAmount());

        // 计算毛利（销售金额 - 采购金额）
        BigDecimal grossProfit = (item.getSaleAmount() != null ? item.getSaleAmount() : BigDecimal.ZERO)
                .subtract(item.getPurchaseAmount() != null ? item.getPurchaseAmount() : BigDecimal.ZERO);
        item.setGrossProfit(grossProfit);

        // 计算净利（毛利 - 税额）
        BigDecimal taxAmount = item.getTaxAmount() != null ? item.getTaxAmount() : BigDecimal.ZERO;
        item.setNetProfit(grossProfit.subtract(taxAmount));

        orderItemMapper.updateById(item);

        // 累计汇总
        totalPurchaseAmount = totalPurchaseAmount.add(item.getPurchaseAmount());
        totalGrossProfit = totalGrossProfit.add(grossProfit);
        totalTaxAmount = totalTaxAmount.add(taxAmount);
        totalNetProfit = totalNetProfit.add(item.getNetProfit());
    }

    // 5. 更新订单汇总信息（不推状态、不创建付款单）
    OrderDO updateOrder = new OrderDO();
    updateOrder.setId(order.getId());
    updateOrder.setTotalPurchaseAmount(totalPurchaseAmount);
    updateOrder.setTotalGrossProfit(totalGrossProfit);
    updateOrder.setTotalTaxAmount(totalTaxAmount);
    BigDecimal extraCost = fillReqVO.getExtraCost() != null ? fillReqVO.getExtraCost() : BigDecimal.ZERO;
    updateOrder.setTotalNetProfit(totalNetProfit.subtract(extraCost));
    updateOrder.setExtraCost(fillReqVO.getExtraCost());
    updateOrder.setExtraCostRemark(fillReqVO.getExtraCostRemark());
    updateOrder.setCostFilled(true);
    updateOrder.setCostFilledBy(SecurityFrameworkUtils.getLoginUserId());
    updateOrder.setCostFilledTime(LocalDateTime.now());
    // 不再设置 status = COMPLETED
    orderMapper.updateById(updateOrder);

    operationLogService.log("order", order.getId(), order.getOrderNo(),
            "fill_cost", null, null,
            "填充成本，采购总额：" + totalPurchaseAmount + "，净利润：" + updateOrder.getTotalNetProfit());
}
```

**Step 3: 重构 editOrderCost 方法**

核心变更：
1. 状态校验改为允许 CONFIRMED、SHIPPED、SETTLING（不限于 COMPLETED）
2. 移除 `validateSupplierPaymentConsistency` 调用
3. 移除 `item.setPaymentDate()` 和 `item.setIsPaid()`
4. 移除旧付款单处理逻辑（整个第8步：获取现有付款单、逻辑取消、物理删除、重新创建）
5. 保留纯采购信息更新逻辑

```java
@Override
@Transactional(rollbackFor = Exception.class)
public void editOrderCost(OrderCostFillReqVO editReqVO) {
    // 1. 校验订单存在
    OrderDO order = validateOrderExists(editReqVO.getOrderId());

    // 2. 校验成本是否已填充
    if (!Boolean.TRUE.equals(order.getCostFilled())) {
        throw exception(ORDER_COST_NOT_FILLED);
    }

    // 3. 校验订单状态：已确认、已发货、结算中均可编辑成本
    Integer status = order.getStatus();
    if (!OrderStatusEnum.CONFIRMED.getStatus().equals(status)
            && !OrderStatusEnum.SHIPPED.getStatus().equals(status)
            && !OrderStatusEnum.SETTLING.getStatus().equals(status)
            && !OrderStatusEnum.COMPLETED.getStatus().equals(status)) {
        throw exception(ORDER_STATUS_NOT_ALLOW_EDIT_COST);
    }

    // 4. 获取订单明细
    List<OrderItemDO> items = orderItemMapper.selectListByOrderId(order.getId());
    Map<Long, OrderItemDO> itemMap = items.stream().collect(Collectors.toMap(OrderItemDO::getId, i -> i));

    // 5. 更新明细成本信息
    BigDecimal totalPurchaseAmount = BigDecimal.ZERO;
    BigDecimal totalGrossProfit = BigDecimal.ZERO;
    BigDecimal totalTaxAmount = BigDecimal.ZERO;
    BigDecimal totalNetProfit = BigDecimal.ZERO;

    for (OrderCostFillReqVO.ItemCost itemCost : editReqVO.getItems()) {
        OrderItemDO item = itemMap.get(itemCost.getItemId());
        if (item == null) {
            continue;
        }

        item.setPurchaseUnit(itemCost.getPurchaseUnit());
        item.setPurchaseQuantity(itemCost.getPurchaseQuantity());
        item.setPurchasePrice(itemCost.getPurchasePrice());

        BigDecimal purchaseAmount = itemCost.getPurchaseAmount();
        if (purchaseAmount == null && itemCost.getPurchaseQuantity() != null && itemCost.getPurchasePrice() != null) {
            purchaseAmount = itemCost.getPurchaseQuantity().multiply(itemCost.getPurchasePrice());
        }
        item.setPurchaseAmount(purchaseAmount != null ? purchaseAmount : BigDecimal.ZERO);

        item.setPurchaseRemark(itemCost.getPurchaseRemark());
        item.setSupplierId(itemCost.getSupplierId());
        item.setTaxAmount(itemCost.getTaxAmount());

        BigDecimal grossProfit = (item.getSaleAmount() != null ? item.getSaleAmount() : BigDecimal.ZERO)
                .subtract(item.getPurchaseAmount() != null ? item.getPurchaseAmount() : BigDecimal.ZERO);
        item.setGrossProfit(grossProfit);

        BigDecimal taxAmount = item.getTaxAmount() != null ? item.getTaxAmount() : BigDecimal.ZERO;
        item.setNetProfit(grossProfit.subtract(taxAmount));

        orderItemMapper.updateById(item);

        totalPurchaseAmount = totalPurchaseAmount.add(item.getPurchaseAmount());
        totalGrossProfit = totalGrossProfit.add(grossProfit);
        totalTaxAmount = totalTaxAmount.add(taxAmount);
        totalNetProfit = totalNetProfit.add(item.getNetProfit());
    }

    // 6. 更新订单汇总成本
    OrderDO updateOrder = new OrderDO();
    updateOrder.setId(order.getId());
    updateOrder.setTotalPurchaseAmount(totalPurchaseAmount);
    updateOrder.setTotalGrossProfit(totalGrossProfit);
    updateOrder.setTotalTaxAmount(totalTaxAmount);
    BigDecimal extraCost = editReqVO.getExtraCost() != null ? editReqVO.getExtraCost() : BigDecimal.ZERO;
    updateOrder.setTotalNetProfit(totalNetProfit.subtract(extraCost));
    updateOrder.setExtraCost(editReqVO.getExtraCost());
    updateOrder.setExtraCostRemark(editReqVO.getExtraCostRemark());
    orderMapper.updateById(updateOrder);

    operationLogService.log("order", order.getId(), order.getOrderNo(),
            "edit_cost", null, null,
            "编辑成本，采购总额：" + totalPurchaseAmount + "，净利润：" + updateOrder.getTotalNetProfit());
}
```

**Step 4: 清理不再需要的代码**

删除 `OrderServiceImpl.java` 中的以下代码：
- `validateSupplierPaymentConsistency(List<OrderCostFillReqVO.ItemCost> items)` 方法（第942-978行）
- 同名的重载方法（如果有的话，第896-936行区域）
- `SupplierPaymentInfo` 内部类（第983-1022行）

**Step 5: 编译验证**

Run: `cd G:/code/honghengsheng_erp/honghengsheng-boot-mini-main && mvn compile -pl stmc-module-erp -am -DskipTests -q`
Expected: BUILD SUCCESS

**Step 6: Commit**

```bash
git add stmc-module-erp/
git commit -m "refactor: 解耦成本填充与状态推进，移除自动创建付款单逻辑"
```

---

## Task 4: 实现 enterSettlement + completeOrder + checkAndAutoComplete

**Files:**
- Modify: `stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/service/order/OrderServiceImpl.java`

**Step 1: 实现 enterSettlement**

在 OrderServiceImpl 的"付款相关"区域前添加"结算相关"区域：

```java
// ========== 结算相关 ==========

@Override
@Transactional(rollbackFor = Exception.class)
public void enterSettlement(Long id) {
    // 1. 校验订单存在
    OrderDO order = validateOrderExists(id);

    // 2. 校验订单状态：必须是已发货
    if (!OrderStatusEnum.SHIPPED.getStatus().equals(order.getStatus())) {
        throw exception(ORDER_STATUS_NOT_ALLOW_SETTLEMENT);
    }

    // 3. 校验成本已填充
    if (!Boolean.TRUE.equals(order.getCostFilled())) {
        throw exception(ORDER_COST_NOT_FILLED_FOR_SETTLEMENT);
    }

    // 4. 校验应收计划已建立
    List<PaymentPlanDO> receivables = paymentPlanMapper.selectList(
            new LambdaQueryWrapperX<PaymentPlanDO>()
                    .eq(PaymentPlanDO::getOrderId, id)
                    .eq(PaymentPlanDO::getType, 1) // 应收
                    .ne(PaymentPlanDO::getStatus, PaymentPlanStatusEnum.CANCELLED.getStatus())
    );
    if (CollUtil.isEmpty(receivables)) {
        throw exception(ORDER_NO_RECEIVABLE_PLAN);
    }

    // 5. 校验应付计划已建立
    List<PaymentPlanDO> payables = paymentPlanMapper.selectList(
            new LambdaQueryWrapperX<PaymentPlanDO>()
                    .eq(PaymentPlanDO::getOrderId, id)
                    .eq(PaymentPlanDO::getType, 0) // 应付
                    .ne(PaymentPlanDO::getStatus, PaymentPlanStatusEnum.CANCELLED.getStatus())
    );
    if (CollUtil.isEmpty(payables)) {
        throw exception(ORDER_NO_PAYABLE_PLAN);
    }

    // 6. 校验应收计划总额 = 订单应收金额
    BigDecimal receivableTotal = receivables.stream()
            .map(PaymentPlanDO::getPlanAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    if (order.getPayableAmount() != null && receivableTotal.compareTo(order.getPayableAmount()) != 0) {
        throw exception(ORDER_RECEIVABLE_AMOUNT_MISMATCH);
    }

    // 7. 校验应付计划按供应商汇总 = 各供应商采购总额
    // 获取订单明细，按供应商汇总采购金额
    List<OrderItemDO> items = orderItemMapper.selectListByOrderId(id);
    Map<Long, BigDecimal> supplierPurchaseMap = items.stream()
            .filter(item -> item.getSupplierId() != null && item.getPurchaseAmount() != null)
            .collect(Collectors.groupingBy(OrderItemDO::getSupplierId,
                    Collectors.reducing(BigDecimal.ZERO, OrderItemDO::getPurchaseAmount, BigDecimal::add)));

    Map<Long, BigDecimal> supplierPlanMap = payables.stream()
            .filter(p -> p.getSupplierId() != null)
            .collect(Collectors.groupingBy(PaymentPlanDO::getSupplierId,
                    Collectors.reducing(BigDecimal.ZERO, PaymentPlanDO::getPlanAmount, BigDecimal::add)));

    for (Map.Entry<Long, BigDecimal> entry : supplierPurchaseMap.entrySet()) {
        BigDecimal planTotal = supplierPlanMap.getOrDefault(entry.getKey(), BigDecimal.ZERO);
        if (planTotal.compareTo(entry.getValue()) != 0) {
            throw exception(ORDER_PAYABLE_AMOUNT_MISMATCH);
        }
    }

    // 8. 更新订单状态为结算中
    OrderDO updateObj = new OrderDO();
    updateObj.setId(id);
    updateObj.setStatus(OrderStatusEnum.SETTLING.getStatus());
    orderMapper.updateById(updateObj);

    operationLogService.log("order", id, order.getOrderNo(),
            "enter_settlement", null, null, "进入结算");
}
```

**Step 2: 实现 completeOrder**

```java
@Override
@Transactional(rollbackFor = Exception.class)
public void completeOrder(Long id) {
    OrderDO order = validateOrderExists(id);

    // 只有结算中状态可以手动完成
    if (!OrderStatusEnum.SETTLING.getStatus().equals(order.getStatus())) {
        throw exception(ORDER_STATUS_INVALID_TRANSITION);
    }

    OrderDO updateObj = new OrderDO();
    updateObj.setId(id);
    updateObj.setStatus(OrderStatusEnum.COMPLETED.getStatus());
    orderMapper.updateById(updateObj);

    operationLogService.log("order", id, order.getOrderNo(),
            "complete", null, null, "手动标记订单完成");
}
```

**Step 3: 实现 checkAndAutoComplete**

```java
@Override
@Transactional(rollbackFor = Exception.class)
public void checkAndAutoComplete(Long orderId) {
    OrderDO order = orderMapper.selectById(orderId);
    if (order == null || !OrderStatusEnum.SETTLING.getStatus().equals(order.getStatus())) {
        return; // 不是结算中状态，跳过
    }

    // 查询所有未取消的应收应付计划
    List<PaymentPlanDO> allPlans = paymentPlanMapper.selectList(
            new LambdaQueryWrapperX<PaymentPlanDO>()
                    .eq(PaymentPlanDO::getOrderId, orderId)
                    .ne(PaymentPlanDO::getStatus, PaymentPlanStatusEnum.CANCELLED.getStatus())
    );

    if (CollUtil.isEmpty(allPlans)) {
        return;
    }

    // 检查是否全部已付款
    boolean allPaid = allPlans.stream()
            .allMatch(p -> PaymentPlanStatusEnum.PAID.getStatus().equals(p.getStatus()));

    if (allPaid) {
        OrderDO updateObj = new OrderDO();
        updateObj.setId(orderId);
        updateObj.setStatus(OrderStatusEnum.COMPLETED.getStatus());
        orderMapper.updateById(updateObj);

        operationLogService.log("order", orderId, order.getOrderNo(),
                "auto_complete", null, null, "应收应付全部结清，订单自动完成");
    }
}
```

**Step 4: 需要导入 LambdaQueryWrapperX**

确保 OrderServiceImpl 导入了：
```java
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
```

**Step 5: 编译验证**

Run: `cd G:/code/honghengsheng_erp/honghengsheng-boot-mini-main && mvn compile -pl stmc-module-erp -am -DskipTests -q`
Expected: BUILD SUCCESS

**Step 6: Commit**

```bash
git add stmc-module-erp/
git commit -m "feat: 实现进入结算、手动完成、自动完成判定逻辑"
```

---

## Task 5: 在 PaymentPlan 核销时触发自动完成检查

**Files:**
- Modify: `stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/service/paymentplan/PaymentPlanServiceImpl.java`

**Step 1: 注入 OrderService**

在 PaymentPlanServiceImpl 中注入 OrderService（注意循环依赖，使用 @Lazy）：

```java
@Resource
@Lazy
private OrderService orderService;
```

**Step 2: 在标记付款和部分付款方法中添加自动完成检查**

在 `markAsPaid` 方法的末尾（更新状态为已付款之后），添加：

```java
// 检查订单是否可以自动完成
if (plan.getOrderId() != null) {
    orderService.checkAndAutoComplete(plan.getOrderId());
}
```

同样在 `partialPay` 方法中，当部分付款使得 paidAmount >= planAmount 时（即该期实际已付清），也添加同样的检查。

**Step 3: 编译验证**

Run: `cd G:/code/honghengsheng_erp/honghengsheng-boot-mini-main && mvn compile -pl stmc-module-erp -am -DskipTests -q`
Expected: BUILD SUCCESS

**Step 4: Commit**

```bash
git add stmc-module-erp/
git commit -m "feat: PaymentPlan核销时触发订单自动完成检查"
```

---

## Task 6: 移除 markOrderAsPaid 并清理废弃代码

**Files:**
- Modify: `stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/service/order/OrderService.java`
- Modify: `stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/service/order/OrderServiceImpl.java`
- Modify: `stmc-module-erp/src/main/java/cn/iocoder/stmc/module/erp/controller/admin/order/OrderController.java`

**Step 1: 删除 OrderService 接口中的 markOrderAsPaid 方法声明**

删除 `OrderService.java` 中：
```java
void markOrderAsPaid(Long id);
```

**Step 2: 删除 OrderServiceImpl 中的 markOrderAsPaid 实现**

删除 `OrderServiceImpl.java` 第2080-2095行的 `markOrderAsPaid` 方法。

**Step 3: 删除 OrderController 中的 mark-paid 接口**

删除 `OrderController.java` 第331-340行的 `/mark-paid` 接口。

**Step 4: 清理 OrderItemDO 中的废弃字段（标记废弃，暂不物理删除）**

在 `OrderItemDO.java` 中为 `paymentDate` 和 `isPaid` 字段添加 `@Deprecated` 注解：

```java
@Deprecated // 废弃：付款信息已由 PaymentPlan 独立管理
private LocalDate paymentDate;

@Deprecated // 废弃：付款信息已由 PaymentPlan 独立管理
private Boolean isPaid;
```

**Step 5: editOrderItems 方法中的状态校验调整**

将 `editOrderItems` 方法中的状态校验从只允许 COMPLETED 改为允许 COMPLETED 和 SETTLING：

```java
if (!OrderStatusEnum.COMPLETED.getStatus().equals(order.getStatus())
        && !OrderStatusEnum.SETTLING.getStatus().equals(order.getStatus())) {
    throw exception(ORDER_STATUS_NOT_ALLOW_EDIT_ITEMS);
}
```

**Step 6: 编译验证**

Run: `cd G:/code/honghengsheng_erp/honghengsheng-boot-mini-main && mvn compile -pl stmc-module-erp -am -DskipTests -q`
Expected: BUILD SUCCESS

**Step 7: Commit**

```bash
git add stmc-module-erp/
git commit -m "refactor: 移除markOrderAsPaid，标记废弃字段，调整editOrderItems状态校验"
```

---

## Task 7: 前端 — 订单状态显示和 API 更新

**Files:**
- Modify: `honghengsheng-ui-admin-vue3-main/src/api/erp/order/index.ts`
- Modify: `honghengsheng-ui-admin-vue3-main/src/views/erp/order/index.vue`

**Step 1: 更新前端 API 定义**

在 `src/api/erp/order/index.ts` 中：
- 新增 `enterSettlement` API
- 新增 `completeOrder` API
- 移除 `markOrderAsPaid` API

```typescript
// 进入结算
enterSettlement: async (id: number) => {
  return await request.put({ url: `/erp/order/enter-settlement?id=${id}` })
},

// 手动标记完成
completeOrder: async (id: number) => {
  return await request.put({ url: `/erp/order/complete?id=${id}` })
},
```

**Step 2: 更新订单列表页状态显示**

在 `src/views/erp/order/index.vue` 中：
- 搜索状态映射字典，将 `1: '待装货'` 改为 `1: '已确认'`，新增 `4: '结算中'`
- 搜索 `标注已收款` 按钮，移除该按钮
- 新增 `进入结算` 按钮（仅在已发货状态显示）
- 新增 `标记完成` 按钮（仅在结算中状态显示）

状态 Tag 颜色建议：
```
0 草稿 → info
1 已确认 → warning
2 已发货 → primary
4 结算中 → danger
3 已完成 → success
50 已取消 → info
```

**Step 3: Commit**

```bash
git add honghengsheng-ui-admin-vue3-main/src/api/erp/order/index.ts
git add honghengsheng-ui-admin-vue3-main/src/views/erp/order/index.vue
git commit -m "feat: 前端订单状态显示更新，新增结算和完成按钮"
```

---

## Task 8: 前端 — 成本填充表单移除付款字段

**Files:**
- Modify: `honghengsheng-ui-admin-vue3-main/src/views/erp/order/CostForm.vue`

**Step 1: 移除成本填充表单中的付款字段**

在 `CostForm.vue` 中：
- 移除表格中的「付款日期」列（绑定 paymentDate 的 el-date-picker）
- 移除表格中的「是否已付款」列（绑定 isPaid 的 el-switch 或 el-checkbox）
- 移除提交数据中的 paymentDate 和 isPaid 字段

**Step 2: Commit**

```bash
git add honghengsheng-ui-admin-vue3-main/src/views/erp/order/CostForm.vue
git commit -m "refactor: 成本填充表单移除付款日期和已付款字段"
```

---

## Task 9: 前端 — 订单详情页新增应收应付 Tab

**Files:**
- Modify: `honghengsheng-ui-admin-vue3-main/src/views/erp/order/OrderDetail.vue`

**Step 1: 新增应收计划 Tab**

在订单详情页的 el-tabs 中新增「应收计划」Tab：
- 显示客户分期收款计划列表
- 列：期数、计划金额、计划日期、实际金额、实际日期、状态、操作
- 新增应收计划按钮（弹窗创建，填写金额和日期）
- 核销按钮（登记实际收款）
- 调用 PaymentPlanApi 的 create（type=1）和 markPaid 接口

**Step 2: 新增应付计划 Tab**

在订单详情页的 el-tabs 中新增「应付计划」Tab：
- 按供应商分组展示
- 列：供应商、期数、计划金额、计划日期、实际金额、实际日期、状态、操作
- 新增应付计划按钮（弹窗创建，选择供应商，填写金额和日期）
- 核销按钮（登记实际付款）
- 调用 PaymentPlanApi 的 create（type=0）和 markPaid 接口

**Step 3: 新增结算操作区**

在订单详情页底部操作区：
- 已发货状态显示「进入结算」按钮
- 结算中状态显示「手动完成」按钮
- 显示结算进度：应收已结清 X/Y、应付已结清 X/Y

**Step 4: Commit**

```bash
git add honghengsheng-ui-admin-vue3-main/src/views/erp/order/OrderDetail.vue
git commit -m "feat: 订单详情页新增应收应付计划Tab和结算操作区"
```

---

## Task 10: SQL 变更脚本

**Files:**
- Create: `stmc-module-erp/../sql/mysql/2026-03-07-cost-payment-redesign.sql`

**Step 1: 编写增量 SQL**

```sql
-- =====================================================
-- 订单成本填充与应收应付业务重构 - 增量SQL
-- 日期: 2026-03-07
-- =====================================================

-- 1. erp_operation_log 表补充 BaseDO 必需字段（修复已知bug）
ALTER TABLE `erp_operation_log`
  ADD COLUMN IF NOT EXISTS `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  ADD COLUMN IF NOT EXISTS `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  ADD COLUMN IF NOT EXISTS `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  ADD COLUMN IF NOT EXISTS `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  ADD COLUMN IF NOT EXISTS `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除';

-- 2. 无需新建表，PaymentPlan 表已支持 type=0(应付)/type=1(应收) 模式
-- 3. OrderItemDO 的 paymentDate 和 isPaid 字段暂不删除，保留历史数据
```

**Step 2: Commit**

```bash
git add sql/
git commit -m "chore: 增量SQL脚本 - 修复erp_operation_log表字段"
```

---

## Task 11: 端到端验证

**Step 1: 启动后端服务**

Run: `cd G:/code/honghengsheng_erp/honghengsheng-boot-mini-main && mvn spring-boot:run -pl stmc-server -DskipTests`

**Step 2: 启动前端服务**

Run: `cd G:/code/honghengsheng_erp/honghengsheng-ui-admin-vue3-main && npm run dev`

**Step 3: 验证完整业务流程**

1. 创建订单（草稿）→ 提交（已确认）
2. 填充采购成本（不推状态，订单仍为已确认）
3. 发货（已发货）
4. 创建应收计划（手动填写金额和日期）
5. 创建应付计划（按供应商，手动填写）
6. 进入结算（前置校验通过后 → 结算中）
7. 逐笔核销应收和应付
8. 全部结清后 → 自动完成

**Step 4: 验证错误场景**

- 未填充成本时尝试进入结算 → 报错
- 未建立应收计划时进入结算 → 报错
- 金额不匹配时进入结算 → 报错
- 非已发货状态点击进入结算 → 报错
