package cn.iocoder.stmc.module.erp.service.expense;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.expense.vo.ExpensePageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.expense.vo.ExpenseSaveReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.expense.ExpenseDO;
import cn.iocoder.stmc.module.erp.dal.mysql.expense.ExpenseMapper;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;

import static cn.iocoder.stmc.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.stmc.module.erp.enums.ErrorCodeConstants.EXPENSE_NOT_EXISTS;

/**
 * ERP 费用/运费支出 Service 实现类
 *
 * @author stmc
 */
@Service
@Validated
public class ExpenseServiceImpl implements ExpenseService {

    @Resource
    private ExpenseMapper expenseMapper;

    @Override
    public Long createExpense(ExpenseSaveReqVO createReqVO) {
        // 插入
        ExpenseDO expense = BeanUtils.toBean(createReqVO, ExpenseDO.class);
        // 自动计算总支出
        expense.setTotalExpense(calculateTotalExpense(expense));
        expenseMapper.insert(expense);
        return expense.getId();
    }

    @Override
    public void updateExpense(ExpenseSaveReqVO updateReqVO) {
        // 校验存在
        validateExpenseExists(updateReqVO.getId());
        // 更新
        ExpenseDO updateObj = BeanUtils.toBean(updateReqVO, ExpenseDO.class);
        // 自动计算总支出
        updateObj.setTotalExpense(calculateTotalExpense(updateObj));
        expenseMapper.updateById(updateObj);
    }

    @Override
    public void deleteExpense(Long id) {
        // 校验存在
        validateExpenseExists(id);
        // 删除
        expenseMapper.deleteById(id);
    }

    private void validateExpenseExists(Long id) {
        if (expenseMapper.selectById(id) == null) {
            throw exception(EXPENSE_NOT_EXISTS);
        }
    }

    /**
     * 计算总支出 = 运费 + 吊车费 + 复印费 + 其他费用（null 当 0）
     */
    private BigDecimal calculateTotalExpense(ExpenseDO expense) {
        BigDecimal freight = expense.getFreight() != null ? expense.getFreight() : BigDecimal.ZERO;
        BigDecimal craneFee = expense.getCraneFee() != null ? expense.getCraneFee() : BigDecimal.ZERO;
        BigDecimal copyFee = expense.getCopyFee() != null ? expense.getCopyFee() : BigDecimal.ZERO;
        BigDecimal otherFee = expense.getOtherFee() != null ? expense.getOtherFee() : BigDecimal.ZERO;
        return freight.add(craneFee).add(copyFee).add(otherFee);
    }

    @Override
    public ExpenseDO getExpense(Long id) {
        return expenseMapper.selectById(id);
    }

    @Override
    public PageResult<ExpenseDO> getExpensePage(ExpensePageReqVO pageReqVO) {
        return expenseMapper.selectPage(pageReqVO);
    }

    @Override
    public List<ExpenseDO> getExpensesByOrderId(Long orderId) {
        return expenseMapper.selectListByOrderId(orderId);
    }

    @Override
    public BigDecimal getTotalExpenseByOrderId(Long orderId) {
        return expenseMapper.selectTotalByOrderId(orderId);
    }

}
