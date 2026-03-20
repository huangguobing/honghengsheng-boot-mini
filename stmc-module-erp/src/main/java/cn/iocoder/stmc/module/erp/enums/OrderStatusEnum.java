package cn.iocoder.stmc.module.erp.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * ERP 订单状态枚举
 *
 * @author stmc
 */
@Getter
@AllArgsConstructor
public enum OrderStatusEnum {

    DRAFT(0, "草稿"),
    CONFIRMED(1, "已确认"),
    SHIPPED(2, "已发货"),
    COMPLETED(3, "已完成"),
    SETTLING(4, "结算中"),
    CANCELLED(50, "已取消");

    /**
     * 状态值
     */
    private final Integer status;
    /**
     * 状态名
     */
    private final String name;

}
