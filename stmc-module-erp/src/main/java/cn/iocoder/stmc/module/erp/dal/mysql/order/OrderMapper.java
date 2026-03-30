package cn.iocoder.stmc.module.erp.dal.mysql.order;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.module.erp.controller.admin.home.vo.OrderStatisticsVO;
import cn.iocoder.stmc.module.erp.controller.admin.order.vo.OrderPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.CustomerStatisticsRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.ProductSalesRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.ProjectProfitRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.statistics.vo.SalesmanStatisticsRespVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.order.OrderDO;
import org.apache.ibatis.annotations.*;

import java.time.LocalDateTime;
import java.util.List;

/**
 * ERP 订单 Mapper
 *
 * @author stmc
 */
@Mapper
public interface OrderMapper extends BaseMapperX<OrderDO> {

    default PageResult<OrderDO> selectPage(OrderPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<OrderDO>()
                .likeIfPresent(OrderDO::getOrderNo, reqVO.getOrderNo())
                .eqIfPresent(OrderDO::getCustomerId, reqVO.getCustomerId())
                .eqIfPresent(OrderDO::getOrderType, reqVO.getOrderType())
                .eqIfPresent(OrderDO::getStatus, reqVO.getStatus())
                .eqIfPresent(OrderDO::getInvoiceCompany, reqVO.getInvoiceCompany())
                .eqIfPresent(OrderDO::getProjectId, reqVO.getProjectId())
                .eqIfPresent(OrderDO::getIsReturn, reqVO.getIsReturn())
                .eqIfPresent(OrderDO::getSalesmanId, reqVO.getSalesmanId()) // 按业务员过滤
                .eqIfPresent(OrderDO::getOrderCategory, reqVO.getOrderCategory()) // 按订单类别过滤
                .betweenIfPresent(OrderDO::getOrderDate, reqVO.getOrderDate())
                .betweenIfPresent(OrderDO::getCreateTime, reqVO.getCreateTime())
                .last("ORDER BY FIELD(status, 0, 10, 20, 50), create_time DESC"));
    }

    default OrderDO selectByOrderNo(String orderNo) {
        return selectOne(OrderDO::getOrderNo, orderNo);
    }

    /**
     * 统计指定时间范围内的订单数据
     *
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @return 统计结果
     */
    @Select("SELECT " +
            "COUNT(*) as order_count, " +
            "COALESCE(SUM(payable_amount), 0) as sales_amount, " +
            "COALESCE(SUM(total_purchase_amount), 0) as cost_amount, " +
            "COALESCE(SUM(total_gross_profit), 0) as gross_profit, " +
            "COALESCE(SUM(total_net_profit), 0) as net_profit " +
            "FROM erp_order " +
            "WHERE deleted = 0 " +
            "AND parent_order_id IS NULL " +
            "AND order_category = #{orderCategory} " +
            "AND order_date >= #{startTime} " +
            "AND order_date < #{endTime}")
    @Results({
            @Result(column = "order_count", property = "orderCount"),
            @Result(column = "sales_amount", property = "salesAmount"),
            @Result(column = "cost_amount", property = "costAmount"),
            @Result(column = "gross_profit", property = "grossProfit"),
            @Result(column = "net_profit", property = "netProfit")
    })
    OrderStatisticsVO selectStatisticsByDateRange(@Param("startTime") LocalDateTime startTime,
                                                   @Param("endTime") LocalDateTime endTime,
                                                   @Param("orderCategory") Integer orderCategory);

    /**
     * 统计指定状态的订单数量
     *
     * @param status 订单状态
     * @return 订单数量
     */
    default Long selectCountByStatus(Integer status) {
        return selectCount(new LambdaQueryWrapperX<OrderDO>()
                .eq(OrderDO::getStatus, status)
                .isNull(OrderDO::getParentOrderId));
    }

    /**
     * 按业务员统计订单数量
     *
     * @param salesmanId 业务员ID（为空时统计全部）
     * @return 订单数量
     */
    @Select("<script>" +
            "SELECT COUNT(*) FROM erp_order WHERE deleted = 0 " +
            "<if test='orderCategory == 0'> AND parent_order_id IS NULL </if>" +
            "<if test='orderCategory == 1'> AND parent_order_id IS NOT NULL </if>" +
            "<if test='salesmanId != null'>" +
            "  AND salesman_id = #{salesmanId} " +
            "</if>" +
            "</script>")
    Long selectCountBySalesman(@Param("salesmanId") Long salesmanId,
                               @Param("orderCategory") Integer orderCategory);

    /**
     * 统计指定时间范围内的订单数据（支持按业务员过滤）
     *
     * @param startTime  开始时间
     * @param endTime    结束时间
     * @param salesmanId 业务员ID（为空时统计全部）
     * @return 统计结果
     */
    @Select("<script>" +
            "SELECT " +
            "  COUNT(*) as order_count, " +
            "  COALESCE(SUM(payable_amount), 0) as sales_amount, " +
            "  COALESCE(SUM(total_purchase_amount), 0) as cost_amount, " +
            "  COALESCE(SUM(total_gross_profit), 0) as gross_profit, " +
            "  COALESCE(SUM(total_net_profit), 0) as net_profit " +
            "FROM erp_order " +
            "WHERE deleted = 0 " +
            "  <if test='orderCategory == 0'> AND parent_order_id IS NULL </if>" +
            "  <if test='orderCategory == 1'> AND parent_order_id IS NOT NULL </if>" +
            "  AND order_category = #{orderCategory} " +
            "  AND order_date &gt;= #{startTime} " +
            "  AND order_date &lt; #{endTime} " +
            "<if test='salesmanId != null'>" +
            "  AND salesman_id = #{salesmanId} " +
            "</if>" +
            "</script>")
    @Results({
            @Result(column = "order_count", property = "orderCount"),
            @Result(column = "sales_amount", property = "salesAmount"),
            @Result(column = "cost_amount", property = "costAmount"),
            @Result(column = "gross_profit", property = "grossProfit"),
            @Result(column = "net_profit", property = "netProfit")
    })
    OrderStatisticsVO selectStatisticsByDateRangeAndSalesman(
            @Param("startTime") LocalDateTime startTime,
            @Param("endTime") LocalDateTime endTime,
            @Param("salesmanId") Long salesmanId,
            @Param("orderCategory") Integer orderCategory);

    /**
     * 按业务员分组统计销售数据
     *
     * @param startTime    开始时间（可为空）
     * @param endTime      结束时间（可为空）
     * @param salesmanName 业务员名称（可为空，模糊查询）
     * @param mobile       手机号（可为空，模糊查询）
     * @return 业务员统计列表
     */
    @Select("<script>" +
            "SELECT " +
            "  o.salesman_id as salesmanId, " +
            "  o.salesman_name as salesmanName, " +
            "  d.name as deptName, " +
            "  u.mobile as mobile, " +
            "  COUNT(*) as orderCount, " +
            "  COALESCE(SUM(o.payable_amount), 0) as salesAmount, " +
            "  COALESCE(SUM(o.total_purchase_amount), 0) as costAmount, " +
            "  COALESCE(SUM(o.total_gross_profit), 0) as grossProfit, " +
            "  COALESCE(SUM(o.total_net_profit), 0) as netProfit " +
            "FROM erp_order o " +
            "LEFT JOIN system_users u ON o.salesman_id = u.id " +
            "LEFT JOIN system_dept d ON u.dept_id = d.id " +
            "WHERE o.deleted = 0 " +
            "  <if test='orderCategory == 0'> AND o.parent_order_id IS NULL </if>" +
            "  <if test='orderCategory == 1'> AND o.parent_order_id IS NOT NULL </if>" +
            "  AND o.salesman_id IS NOT NULL " +
            "  AND o.order_category = #{orderCategory} " +
            "  <if test='startTime != null'>" +
            "    AND o.create_time &gt;= #{startTime} " +
            "  </if>" +
            "  <if test='endTime != null'>" +
            "    AND o.create_time &lt; #{endTime} " +
            "  </if>" +
            "  <if test='salesmanName != null and salesmanName != \"\"'>" +
            "    AND o.salesman_name LIKE CONCAT('%', #{salesmanName}, '%') " +
            "  </if>" +
            "  <if test='mobile != null and mobile != \"\"'>" +
            "    AND u.mobile LIKE CONCAT('%', #{mobile}, '%') " +
            "  </if>" +
            "GROUP BY o.salesman_id, o.salesman_name, d.name, u.mobile " +
            "ORDER BY salesAmount DESC" +
            "</script>")
    List<SalesmanStatisticsRespVO> selectSalesmanStatistics(
            @Param("startTime") LocalDateTime startTime,
            @Param("endTime") LocalDateTime endTime,
            @Param("salesmanName") String salesmanName,
            @Param("mobile") String mobile,
            @Param("orderCategory") Integer orderCategory);

    /**
     * 按客户分组统计销售数据
     *
     * @param startTime    开始时间（可为空）
     * @param endTime      结束时间（可为空）
     * @param customerName 客户名称（可为空，模糊查询）
     * @param mobile       手机号（可为空，模糊查询）
     * @return 客户统计列表
     */
    @Select("<script>" +
            "SELECT " +
            "  o.customer_id as customerId, " +
            "  c.name as customerName, " +
            "  c.code as customerCode, " +
            "  c.contact as contact, " +
            "  c.mobile as mobile, " +
            "  COUNT(*) as orderCount, " +
            "  COALESCE(SUM(o.payable_amount), 0) as salesAmount, " +
            "  COALESCE(SUM(o.total_purchase_amount), 0) as costAmount, " +
            "  COALESCE(SUM(o.total_gross_profit), 0) as grossProfit, " +
            "  COALESCE(SUM(o.total_net_profit), 0) as netProfit " +
            "FROM erp_order o " +
            "LEFT JOIN erp_customer c ON o.customer_id = c.id " +
            "WHERE o.deleted = 0 " +
            "  <if test='orderCategory == 0'> AND o.parent_order_id IS NULL </if>" +
            "  <if test='orderCategory == 1'> AND o.parent_order_id IS NOT NULL </if>" +
            "  AND o.customer_id IS NOT NULL " +
            "  AND o.order_category = #{orderCategory} " +
            "  <if test='startTime != null'>" +
            "    AND o.create_time &gt;= #{startTime} " +
            "  </if>" +
            "  <if test='endTime != null'>" +
            "    AND o.create_time &lt; #{endTime} " +
            "  </if>" +
            "  <if test='customerName != null and customerName != \"\"'>" +
            "    AND c.name LIKE CONCAT('%', #{customerName}, '%') " +
            "  </if>" +
            "  <if test='mobile != null and mobile != \"\"'>" +
            "    AND c.mobile LIKE CONCAT('%', #{mobile}, '%') " +
            "  </if>" +
            "GROUP BY o.customer_id, c.name, c.code, c.contact, c.mobile " +
            "ORDER BY salesAmount DESC" +
            "</script>")
    List<CustomerStatisticsRespVO> selectCustomerStatistics(
            @Param("startTime") LocalDateTime startTime,
            @Param("endTime") LocalDateTime endTime,
            @Param("customerName") String customerName,
            @Param("mobile") String mobile,
            @Param("orderCategory") Integer orderCategory);

    /**
     * 按项目分组统计利润数据
     */
    @Select("<script>" +
            "SELECT " +
            "  o.project_id as projectId, " +
            "  p.name as projectName, " +
            "  c.name as customerName, " +
            "  COUNT(*) as orderCount, " +
            "  COALESCE(SUM(o.payable_amount), 0) as salesAmount, " +
            "  COALESCE(SUM(o.total_purchase_amount), 0) as purchaseAmount, " +
            "  COALESCE(SUM(o.shipping_fee), 0) as freightAmount, " +
            "  COALESCE(SUM(o.total_quantity), 0) as totalQuantity, " +
            "  COALESCE(SUM(w.order_weight), 0) as totalWeight, " +
            "  COALESCE(SUM(o.total_net_profit), 0) as netProfit " +
            "FROM erp_order o " +
            "LEFT JOIN erp_project p ON o.project_id = p.id " +
            "LEFT JOIN erp_customer c ON o.customer_id = c.id " +
            "LEFT JOIN (SELECT order_id, SUM(weight) as order_weight FROM erp_order_item WHERE deleted = 0 AND item_type = 0 GROUP BY order_id) w ON w.order_id = o.id " +
            "WHERE o.deleted = 0 " +
            "  <if test='orderCategory == 0'> AND o.parent_order_id IS NULL </if>" +
            "  <if test='orderCategory == 1'> AND o.parent_order_id IS NOT NULL </if>" +
            "  AND o.project_id IS NOT NULL " +
            "  AND o.order_category = #{orderCategory} " +
            "  <if test='startTime != null'>" +
            "    AND o.create_time &gt;= #{startTime} " +
            "  </if>" +
            "  <if test='endTime != null'>" +
            "    AND o.create_time &lt; #{endTime} " +
            "  </if>" +
            "  <if test='projectName != null and projectName != \"\"'>" +
            "    AND p.name LIKE CONCAT('%', #{projectName}, '%') " +
            "  </if>" +
            "GROUP BY o.project_id, p.name, c.name " +
            "ORDER BY salesAmount DESC" +
            "</script>")
    List<ProjectProfitRespVO> selectProjectProfitStatistics(
            @Param("startTime") LocalDateTime startTime,
            @Param("endTime") LocalDateTime endTime,
            @Param("projectName") String projectName,
            @Param("orderCategory") Integer orderCategory);

    /**
     * 按产品/规格分组统计销售数据
     */
    @Select("<script>" +
            "SELECT " +
            "  oi.product_name as productName, " +
            "  oi.spec as spec, " +
            "  SUM(oi.sale_quantity) as totalQuantity, " +
            "  COALESCE(SUM(oi.weight), 0) as totalWeight, " +
            "  SUM(oi.sale_amount) as salesAmount, " +
            "  COUNT(DISTINCT oi.order_id) as orderCount " +
            "FROM erp_order_item oi " +
            "INNER JOIN erp_order o ON oi.order_id = o.id " +
            "WHERE oi.deleted = 0 AND o.deleted = 0 AND oi.item_type = 0 " +
            "  <if test='orderCategory == 0'> AND o.parent_order_id IS NULL </if>" +
            "  <if test='orderCategory == 1'> AND o.parent_order_id IS NOT NULL </if>" +
            "  AND o.order_category = #{orderCategory} " +
            "  <if test='startTime != null'>" +
            "    AND o.create_time &gt;= #{startTime} " +
            "  </if>" +
            "  <if test='endTime != null'>" +
            "    AND o.create_time &lt; #{endTime} " +
            "  </if>" +
            "  <if test='productName != null and productName != \"\"'>" +
            "    AND oi.product_name LIKE CONCAT('%', #{productName}, '%') " +
            "  </if>" +
            "GROUP BY oi.product_name, oi.spec " +
            "ORDER BY salesAmount DESC" +
            "</script>")
    List<ProductSalesRespVO> selectProductSalesStatistics(
            @Param("startTime") LocalDateTime startTime,
            @Param("endTime") LocalDateTime endTime,
            @Param("productName") String productName,
            @Param("orderCategory") Integer orderCategory);

}
