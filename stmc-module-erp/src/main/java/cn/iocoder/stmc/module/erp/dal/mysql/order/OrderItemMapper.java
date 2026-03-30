package cn.iocoder.stmc.module.erp.dal.mysql.order;

import cn.iocoder.stmc.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.SupplierStatisticsRespVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderItemDO;
import org.apache.ibatis.annotations.*;

import java.time.LocalDateTime;
import java.util.List;

/**
 * ERP 订单明细 Mapper
 *
 * @author stmc
 */
@Mapper
public interface OrderItemMapper extends BaseMapperX<OrderItemDO> {

    /**
     * 根据订单ID查询明细列表
     *
     * @param orderId 订单ID
     * @return 明细列表
     */
    default List<OrderItemDO> selectListByOrderId(Long orderId) {
        return selectList(new LambdaQueryWrapperX<OrderItemDO>()
                .eq(OrderItemDO::getOrderId, orderId)
                .orderByAsc(OrderItemDO::getId));
    }

    /**
     * 根据订单ID列表批量查询明细
     *
     * @param orderIds 订单ID列表
     * @return 明细列表
     */
    default List<OrderItemDO> selectListByOrderIds(List<Long> orderIds) {
        return selectList(new LambdaQueryWrapperX<OrderItemDO>()
                .in(OrderItemDO::getOrderId, orderIds)
                .orderByAsc(OrderItemDO::getId));
    }

    /**
     * 根据订单ID删除明细
     *
     * @param orderId 订单ID
     * @return 删除数量
     */
    default int deleteByOrderId(Long orderId) {
        return delete(new LambdaQueryWrapperX<OrderItemDO>()
                .eq(OrderItemDO::getOrderId, orderId));
    }

    /**
     * 根据供应商ID查询明细列表
     *
     * @param supplierId 供应商ID
     * @return 明细列表
     */
    default List<OrderItemDO> selectListBySupplierId(Long supplierId) {
        return selectList(new LambdaQueryWrapperX<OrderItemDO>()
                .eq(OrderItemDO::getSupplierId, supplierId)
                .orderByDesc(OrderItemDO::getId));
    }

    /**
     * 按供应商分组统计采购金额
     *
     * @param startTime    开始时间（可为空）
     * @param endTime      结束时间（可为空）
     * @param supplierName 供应商名称（可为空，模糊查询）
     * @return 供应商统计列表
     */
    @Select("<script>" +
            "SELECT " +
            "  oi.supplier_id as supplierId, " +
            "  s.name as supplierName, " +
            "  s.code as supplierCode, " +
            "  s.contact as contact, " +
            "  s.mobile as mobile, " +
            "  s.address as address, " +
            "  COALESCE(SUM(oi.purchase_amount), 0) as totalPurchaseAmount, " +
            "  COALESCE(SUM(oi.weight), 0) as totalWeight, " +
            "  COUNT(*) as orderItemCount " +
            "FROM erp_order_item oi " +
            "INNER JOIN erp_order o ON oi.order_id = o.id " +
            "LEFT JOIN erp_supplier s ON oi.supplier_id = s.id " +
            "WHERE oi.supplier_id IS NOT NULL " +
            "  AND oi.deleted = 0 " +
            "  AND o.deleted = 0 " +
            "  <if test='orderCategory == 0'> AND o.parent_order_id IS NULL </if>" +
            "  <if test='orderCategory == 1'> AND o.parent_order_id IS NOT NULL </if>" +
            "  AND o.order_category = #{orderCategory} " +
            "  <if test='startTime != null'>" +
            "    AND oi.create_time &gt;= #{startTime} " +
            "  </if>" +
            "  <if test='endTime != null'>" +
            "    AND oi.create_time &lt; #{endTime} " +
            "  </if>" +
            "  <if test='supplierName != null and supplierName != \"\"'>" +
            "    AND s.name LIKE CONCAT('%', #{supplierName}, '%') " +
            "  </if>" +
            "GROUP BY oi.supplier_id, s.name, s.code, s.contact, s.mobile, s.address " +
            "ORDER BY totalPurchaseAmount DESC" +
            "</script>")
    List<SupplierStatisticsRespVO> selectSupplierPurchaseStatistics(
            @Param("startTime") LocalDateTime startTime,
            @Param("endTime") LocalDateTime endTime,
            @Param("supplierName") String supplierName,
            @Param("orderCategory") Integer orderCategory);

}
