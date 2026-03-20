package cn.iocoder.stmc.module.erp.service.purchase;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.module.erp.controller.admin.purchase.vo.PurchaseOrderPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.purchase.vo.PurchaseOrderSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.purchase.PurchaseOrderItemDO;

import javax.validation.Valid;
import java.util.Collection;
import java.util.List;

/**
 * ERP 采购单 Service 接口
 *
 * @author stmc
 */
public interface PurchaseOrderService {

    /**
     * 创建采购单
     *
     * @param createReqVO 创建信息
     * @return 编号
     */
    Long createPurchaseOrder(@Valid PurchaseOrderSaveReqVO createReqVO);

    /**
     * 更新采购单
     *
     * @param updateReqVO 更新信息
     */
    void updatePurchaseOrder(@Valid PurchaseOrderSaveReqVO updateReqVO);

    /**
     * 删除采购单
     *
     * @param id 编号
     */
    void deletePurchaseOrder(Long id);

    /**
     * 获得采购单
     *
     * @param id 编号
     * @return 采购单
     */
    PurchaseOrderDO getPurchaseOrder(Long id);

    /**
     * 获得采购单分页
     *
     * @param pageReqVO 分页查询
     * @return 采购单分页
     */
    PageResult<PurchaseOrderDO> getPurchaseOrderPage(PurchaseOrderPageReqVO pageReqVO);

    /**
     * 根据销售订单获取采购单列表
     *
     * @param orderId 销售订单编号
     * @return 采购单列表
     */
    List<PurchaseOrderDO> getPurchaseOrdersByOrderId(Long orderId);

    /**
     * 获取采购单明细列表
     *
     * @param purchaseOrderId 采购单编号
     * @return 明细列表
     */
    List<PurchaseOrderItemDO> getPurchaseOrderItems(Long purchaseOrderId);

    /**
     * 批量获取多个采购单的明细列表
     *
     * @param purchaseOrderIds 采购单编号集合
     * @return 明细列表
     */
    List<PurchaseOrderItemDO> getPurchaseOrderItemsByPurchaseOrderIds(Collection<Long> purchaseOrderIds);

    /**
     * 获得采购单精简列表（用于下拉选择）
     *
     * @return 采购单列表
     */
    List<PurchaseOrderDO> getPurchaseOrderSimpleList();

}
