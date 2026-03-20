package cn.iocoder.stmc.module.erp.service.expense;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.module.erp.controller.admin.expense.vo.ExpensePageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.expense.vo.ExpenseSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.expense.ExpenseDO;

import javax.validation.Valid;
import java.math.BigDecimal;
import java.util.List;

/**
 * ERP 费用/运费支出 Service 接口
 *
 * @author stmc
 */
public interface ExpenseService {

    /**
     * 创建费用记录
     *
     * @param createReqVO 创建信息
     * @return 编号
     */
    Long createExpense(@Valid ExpenseSaveReqVO createReqVO);

    /**
     * 更新费用记录
     *
     * @param updateReqVO 更新信息
     */
    void updateExpense(@Valid ExpenseSaveReqVO updateReqVO);

    /**
     * 删除费用记录
     *
     * @param id 编号
     */
    void deleteExpense(Long id);

    /**
     * 获得费用记录
     *
     * @param id 编号
     * @return 费用记录
     */
    ExpenseDO getExpense(Long id);

    /**
     * 获得费用记录分页
     *
     * @param pageReqVO 分页查询
     * @return 费用记录分页
     */
    PageResult<ExpenseDO> getExpensePage(ExpensePageReqVO pageReqVO);

    /**
     * 根据订单编号获得费用列表
     *
     * @param orderId 订单编号
     * @return 费用列表
     */
    List<ExpenseDO> getExpensesByOrderId(Long orderId);

    /**
     * 根据订单编号获得总支出
     *
     * @param orderId 订单编号
     * @return 总支出金额
     */
    BigDecimal getTotalExpenseByOrderId(Long orderId);

}
