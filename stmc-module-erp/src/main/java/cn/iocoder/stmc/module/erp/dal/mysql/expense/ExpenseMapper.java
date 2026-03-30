package cn.iocoder.stmc.module.erp.dal.mysql.expense;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.module.erp.controller.admin.expense.vo.ExpensePageReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.expense.ExpenseDO;
import org.apache.ibatis.annotations.Mapper;

import java.math.BigDecimal;
import java.util.List;

/**
 * ERP 费用/运费支出 Mapper
 *
 * @author stmc
 */
@Mapper
public interface ExpenseMapper extends BaseMapperX<ExpenseDO> {

    default PageResult<ExpenseDO> selectPage(ExpensePageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<ExpenseDO>()
                .inIfPresent(ExpenseDO::getOrderId, reqVO.getVisibleOrderIds())
                .eqIfPresent(ExpenseDO::getOrderId, reqVO.getOrderId())
                .betweenIfPresent(ExpenseDO::getExpenseDate, reqVO.getExpenseDate())
                .orderByDesc(ExpenseDO::getId));
    }

    default List<ExpenseDO> selectListByOrderId(Long orderId) {
        return selectList(new LambdaQueryWrapperX<ExpenseDO>()
                .eq(ExpenseDO::getOrderId, orderId)
                .orderByDesc(ExpenseDO::getCreateTime));
    }

    default int deleteByOrderId(Long orderId) {
        return delete(new LambdaQueryWrapperX<ExpenseDO>()
                .eq(ExpenseDO::getOrderId, orderId));
    }

    default BigDecimal selectTotalByOrderId(Long orderId) {
        List<ExpenseDO> list = selectListByOrderId(orderId);
        return list.stream()
                .map(ExpenseDO::getTotalExpense)
                .filter(java.util.Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

}
