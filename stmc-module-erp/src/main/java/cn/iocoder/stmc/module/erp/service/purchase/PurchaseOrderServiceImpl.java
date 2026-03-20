package cn.iocoder.stmc.module.erp.service.purchase;

import cn.hutool.core.util.IdUtil;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.purchase.vo.PurchaseOrderPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.purchase.vo.PurchaseOrderSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderItemDO;
import cn.iocoder.stmc.module.erp.dal.mysql.order.OrderMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.purchase.PurchaseOrderItemMapper;
import cn.iocoder.stmc.module.erp.dal.mysql.purchase.PurchaseOrderMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import static cn.iocoder.stmc.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.stmc.module.erp.enums.ErrorCodeConstants.PURCHASE_ORDER_NOT_EXISTS;

/**
 * ERP 采购单 Service 实现类
 *
 * @author stmc
 */
@Slf4j
@Service
@Validated
public class PurchaseOrderServiceImpl implements PurchaseOrderService {

    @Resource
    private PurchaseOrderMapper purchaseOrderMapper;

    @Resource
    private PurchaseOrderItemMapper purchaseOrderItemMapper;

    @Resource
    private OrderMapper orderMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createPurchaseOrder(PurchaseOrderSaveReqVO createReqVO) {
        // 生成采购单号: PO-yyyyMMdd-xxx
        String purchaseNo = generatePurchaseNo();

        // 插入采购单主表
        PurchaseOrderDO purchaseOrder = BeanUtils.toBean(createReqVO, PurchaseOrderDO.class);
        purchaseOrder.setPurchaseNo(purchaseNo);
        // 计算总金额
        purchaseOrder.setTotalAmount(calculateTotalAmount(createReqVO));
        purchaseOrderMapper.insert(purchaseOrder);

        // 插入采购单明细
        List<PurchaseOrderItemDO> items = BeanUtils.toBean(createReqVO.getItems(), PurchaseOrderItemDO.class);
        items.forEach(item -> item.setPurchaseOrderId(purchaseOrder.getId()));
        purchaseOrderItemMapper.insertBatch(items);

        syncOrderPurchaseTotal(createReqVO.getOrderId());

        return purchaseOrder.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePurchaseOrder(PurchaseOrderSaveReqVO updateReqVO) {
        // 校验存在
        validatePurchaseOrderExists(updateReqVO.getId());

        // 更新采购单主表
        PurchaseOrderDO updateObj = BeanUtils.toBean(updateReqVO, PurchaseOrderDO.class);
        updateObj.setTotalAmount(calculateTotalAmount(updateReqVO));
        purchaseOrderMapper.updateById(updateObj);

        // 删除旧明细，插入新明细
        purchaseOrderItemMapper.delete(PurchaseOrderItemDO::getPurchaseOrderId, updateReqVO.getId());
        List<PurchaseOrderItemDO> items = BeanUtils.toBean(updateReqVO.getItems(), PurchaseOrderItemDO.class);
        items.forEach(item -> item.setPurchaseOrderId(updateReqVO.getId()));
        purchaseOrderItemMapper.insertBatch(items);

        syncOrderPurchaseTotal(updateReqVO.getOrderId());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deletePurchaseOrder(Long id) {
        PurchaseOrderDO purchaseOrder = purchaseOrderMapper.selectById(id);
        if (purchaseOrder == null) {
            throw exception(PURCHASE_ORDER_NOT_EXISTS);
        }
        purchaseOrderMapper.deleteById(id);
        purchaseOrderItemMapper.delete(PurchaseOrderItemDO::getPurchaseOrderId, id);

        syncOrderPurchaseTotal(purchaseOrder.getOrderId());
    }

    @Override
    public PurchaseOrderDO getPurchaseOrder(Long id) {
        return purchaseOrderMapper.selectById(id);
    }

    @Override
    public PageResult<PurchaseOrderDO> getPurchaseOrderPage(PurchaseOrderPageReqVO pageReqVO) {
        return purchaseOrderMapper.selectPage(pageReqVO);
    }

    @Override
    public List<PurchaseOrderDO> getPurchaseOrdersByOrderId(Long orderId) {
        return purchaseOrderMapper.selectListByOrderId(orderId);
    }

    @Override
    public List<PurchaseOrderItemDO> getPurchaseOrderItems(Long purchaseOrderId) {
        return purchaseOrderItemMapper.selectListByPurchaseOrderId(purchaseOrderId);
    }

    @Override
    public List<PurchaseOrderItemDO> getPurchaseOrderItemsByPurchaseOrderIds(Collection<Long> purchaseOrderIds) {
        if (purchaseOrderIds == null || purchaseOrderIds.isEmpty()) {
            return Collections.emptyList();
        }
        return purchaseOrderItemMapper.selectListByPurchaseOrderIds(purchaseOrderIds);
    }

    @Override
    public List<PurchaseOrderDO> getPurchaseOrderSimpleList() {
        return purchaseOrderMapper.selectList();
    }

    private void validatePurchaseOrderExists(Long id) {
        if (purchaseOrderMapper.selectById(id) == null) {
            throw exception(PURCHASE_ORDER_NOT_EXISTS);
        }
    }

    /**
     * 生成采购单号: PO-yyyyMMdd-xxx
     */
    private String generatePurchaseNo() {
        String datePart = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String snowflakePart = IdUtil.getSnowflakeNextIdStr();
        // 取雪花ID后6位作为序号
        String seqPart = snowflakePart.substring(snowflakePart.length() - 6);
        return "PO-" + datePart + "-" + seqPart;
    }

    /**
     * 同步更新关联销售订单的采购汇总金额
     * 当采购单增删改时，重新计算该订单下所有采购单的总金额并更新到 OrderDO.totalPurchaseAmount
     */
    private void syncOrderPurchaseTotal(Long orderId) {
        if (orderId == null) {
            return;
        }
        OrderDO order = orderMapper.selectById(orderId);
        if (order == null || !Boolean.TRUE.equals(order.getCostFilled())) {
            return;
        }

        List<PurchaseOrderDO> purchaseOrders = purchaseOrderMapper.selectListByOrderId(orderId);
        BigDecimal totalPurchaseFromPO = purchaseOrders.stream()
                .map(po -> po.getTotalAmount() != null ? po.getTotalAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal currentTotal = order.getTotalPurchaseAmount() != null ? order.getTotalPurchaseAmount() : BigDecimal.ZERO;
        if (totalPurchaseFromPO.compareTo(currentTotal) != 0) {
            OrderDO updateOrder = new OrderDO();
            updateOrder.setId(orderId);
            updateOrder.setTotalPurchaseAmount(totalPurchaseFromPO);

            BigDecimal saleAmount = order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO;
            BigDecimal grossProfit = saleAmount.subtract(totalPurchaseFromPO);
            updateOrder.setTotalGrossProfit(grossProfit);

            BigDecimal taxAmount = order.getTotalTaxAmount() != null ? order.getTotalTaxAmount() : BigDecimal.ZERO;
            BigDecimal extraCost = order.getExtraCost() != null ? order.getExtraCost() : BigDecimal.ZERO;
            updateOrder.setTotalNetProfit(grossProfit.subtract(taxAmount).subtract(extraCost));

            orderMapper.updateById(updateOrder);
            log.info("[syncOrderPurchaseTotal] 同步订单[{}]采购汇总：原{}→新{}", orderId, currentTotal, totalPurchaseFromPO);
        }
    }

    /**
     * 计算采购总金额
     */
    private BigDecimal calculateTotalAmount(PurchaseOrderSaveReqVO reqVO) {
        if (reqVO.getItems() == null) {
            return BigDecimal.ZERO;
        }
        return reqVO.getItems().stream()
                .map(item -> {
                    if (item.getPurchaseAmount() != null) {
                        return item.getPurchaseAmount();
                    }
                    // 如果没有直接填写金额，则用重量×单价计算
                    if (item.getPurchasePrice() != null && item.getWeight() != null) {
                        return item.getPurchasePrice().multiply(item.getWeight());
                    }
                    return BigDecimal.ZERO;
                })
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

}
