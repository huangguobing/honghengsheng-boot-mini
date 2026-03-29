package cn.iocoder.stmc.module.erp.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * ERP 付款计划状态枚举
 *
 * @author stmc
 */
@Getter
@AllArgsConstructor
public enum PaymentPlanStatusEnum {

    PENDING(0, "待付款"),
    PARTIAL(5, "部分付款"),
    PAID(10, "已付款"),
    OVERDUE(20, "已逾期"), // 仅历史兼容
    CANCELLED(30, "已取消"); // 仅历史兼容

    private final Integer status;
    private final String name;

    public static PaymentPlanStatusEnum valueOf(Integer status) {
        for (PaymentPlanStatusEnum value : values()) {
            if (value.getStatus().equals(status)) {
                return value;
            }
        }
        return null;
    }

}
