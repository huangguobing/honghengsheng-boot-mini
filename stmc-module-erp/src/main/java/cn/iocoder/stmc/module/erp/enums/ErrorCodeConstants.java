package cn.iocoder.stmc.module.erp.enums;

import cn.iocoder.stmc.framework.common.exception.ErrorCode;

/**
 * ERP 模块错误码枚举类
 *
 * erp 系统，使用 1-020-000-000 段
 */
public interface ErrorCodeConstants {

    // ========== 客户管理 1-020-001-000 ==========
    ErrorCode CUSTOMER_NOT_EXISTS = new ErrorCode(1_020_001_000, "客户不存在");
    ErrorCode CUSTOMER_NAME_EXISTS = new ErrorCode(1_020_001_001, "客户名称已存在");
    ErrorCode CUSTOMER_CODE_EXISTS = new ErrorCode(1_020_001_002, "客户编码已存在");

    // ========== 供应商管理 1-020-002-000 ==========
    ErrorCode SUPPLIER_NOT_EXISTS = new ErrorCode(1_020_002_000, "供应商不存在");
    ErrorCode SUPPLIER_NAME_EXISTS = new ErrorCode(1_020_002_001, "供应商名称已存在");
    ErrorCode SUPPLIER_CODE_EXISTS = new ErrorCode(1_020_002_002, "供应商编码已存在");

    // ========== 订单管理 1-020-003-000 ==========
    ErrorCode ORDER_NOT_EXISTS = new ErrorCode(1_020_003_000, "订单不存在");
    ErrorCode ORDER_NO_EXISTS = new ErrorCode(1_020_003_001, "订单编号已存在");
    ErrorCode ORDER_STATUS_NOT_ALLOW_UPDATE = new ErrorCode(1_020_003_002, "订单状态不允许修改");
    ErrorCode ORDER_STATUS_NOT_ALLOW_DELETE = new ErrorCode(1_020_003_003, "订单状态不允许删除");
    ErrorCode ORDER_CUSTOMER_NOT_FOUND = new ErrorCode(1_020_003_004, "销售订单必须关联客户");
    ErrorCode ORDER_SUPPLIER_NOT_FOUND = new ErrorCode(1_020_003_005, "采购订单必须关联供应商");
    ErrorCode ORDER_STATUS_INVALID_TRANSITION = new ErrorCode(1_020_003_006, "订单状态转移无效");
    ErrorCode ORDER_STATUS_NOT_ALLOW_FILL_COST = new ErrorCode(1_020_003_007, "当前订单状态不允许填充成本");
    ErrorCode ORDER_ITEM_NOT_EXISTS = new ErrorCode(1_020_003_008, "订单明细不存在");
    ErrorCode ORDER_SUPPLIER_PAYMENT_INCONSISTENT = new ErrorCode(1_020_003_009, "同一供应商的商品付款日期和付款状态必须一致");
    ErrorCode ORDER_STATUS_NOT_ALLOW_EDIT_COST = new ErrorCode(1_020_003_010, "当前订单状态不允许编辑成本");
    ErrorCode ORDER_COST_NOT_FILLED = new ErrorCode(1_020_003_011, "订单成本尚未填充，无法编辑");
    ErrorCode ORDER_STATUS_NOT_ALLOW_EDIT_ITEMS = new ErrorCode(1_020_003_012, "当前订单状态不允许编辑商品");
    ErrorCode ORDER_ITEMS_CANNOT_BE_EMPTY = new ErrorCode(1_020_003_013, "订单商品明细不能为空");
    ErrorCode ORDER_DELETE_NOT_ALLOW = new ErrorCode(1_020_003_014, "当前订单状态不允许删除，只有待审核或已取消的订单可删除");
    ErrorCode ORDER_COST_NOT_FILLED_FOR_SETTLEMENT = new ErrorCode(1_020_003_015, "订单成本尚未填充，无法进入结算");
    ErrorCode ORDER_NO_RECEIVABLE_PLAN = new ErrorCode(1_020_003_016, "订单尚未建立应收计划，无法进入结算");
    ErrorCode ORDER_NO_PAYABLE_PLAN = new ErrorCode(1_020_003_017, "订单尚未建立应付计划，无法进入结算");
    ErrorCode ORDER_RECEIVABLE_AMOUNT_MISMATCH = new ErrorCode(1_020_003_018, "应收计划总额与订单应收金额不一致");
    ErrorCode ORDER_PAYABLE_AMOUNT_MISMATCH = new ErrorCode(1_020_003_019, "应付计划总额与供应商采购金额不一致");
    ErrorCode ORDER_STATUS_NOT_ALLOW_SETTLEMENT = new ErrorCode(1_020_003_020, "当前订单状态不允许进入结算");

    // ========== 付款管理 1-020-004-000 ==========
    ErrorCode PAYMENT_NOT_EXISTS = new ErrorCode(1_020_004_000, "付款记录不存在");
    ErrorCode PAYMENT_STATUS_NOT_ALLOW_UPDATE = new ErrorCode(1_020_004_001, "付款状态不允许修改");
    ErrorCode PAYMENT_STATUS_NOT_ALLOW_DELETE = new ErrorCode(1_020_004_002, "付款状态不允许删除");
    ErrorCode PAYMENT_SUPPLIER_NOT_FOUND = new ErrorCode(1_020_004_003, "付款供应商不存在");
    ErrorCode PAYMENT_ORDER_NOT_FOUND = new ErrorCode(1_020_004_004, "付款订单不存在");
    ErrorCode PAYMENT_AMOUNT_EXCEEDS = new ErrorCode(1_020_004_005, "付款金额超过应付金额");
    ErrorCode PAYMENT_HAS_PAID_PLAN = new ErrorCode(1_020_004_006, "该付款单存在已付款的计划，不允许删除");
    ErrorCode PAYMENT_ALREADY_PAID_CANNOT_CANCEL = new ErrorCode(1_020_004_007, "付款单已付款，无法取消");
    ErrorCode PAYMENT_ALREADY_PAID_CANNOT_EDIT = new ErrorCode(1_020_004_008, "付款单已付款，无法修改金额");

    // ========== 账期配置 1-020-005-000 ==========
    ErrorCode PAYMENT_TERM_CONFIG_PERCENTAGE_NOT_100 = new ErrorCode(1_020_005_000, "分期付款比例总和必须等于100%");

    // ========== 付款计划 1-020-006-000 ==========
    ErrorCode PAYMENT_PLAN_NOT_EXISTS = new ErrorCode(1_020_006_000, "付款计划不存在");
    ErrorCode PAYMENT_PLAN_ALREADY_PAID = new ErrorCode(1_020_006_001, "付款计划已付款，不能重复操作");
    ErrorCode PAYMENT_PLAN_ALREADY_PAID_CANNOT_EDIT = new ErrorCode(1_020_006_002, "付款计划已付款，无法修改");
    ErrorCode PAYMENT_PLAN_PARTIAL_PAY_EXCEEDS = new ErrorCode(1_020_006_003,
            "付款金额超过剩余应付金额（计划{}，已付{}，剩余{}，本次付款{}）");

    // ========== 产品管理 1-020-007-000 ==========
    ErrorCode PRODUCT_NOT_EXISTS = new ErrorCode(1_020_007_000, "产品不存在");
    ErrorCode PRODUCT_NAME_EXISTS = new ErrorCode(1_020_007_001, "产品名称已存在");
    ErrorCode PRODUCT_SPEC_NOT_EXISTS = new ErrorCode(1_020_007_002, "产品规格不存在");

    // ========== 项目/工地管理 1-020-008-000 ==========
    ErrorCode PROJECT_NOT_EXISTS = new ErrorCode(1_020_008_000, "项目/工地不存在");
    ErrorCode PROJECT_NAME_EXISTS = new ErrorCode(1_020_008_001, "同一客户下项目名称已存在");
    ErrorCode PROJECT_COMPLETED = new ErrorCode(1_020_008_002, "项目/工地已完工，不可继续开单");

    // ========== 采购单管理 1-020-009-000 ==========
    ErrorCode PURCHASE_ORDER_NOT_EXISTS = new ErrorCode(1_020_009_000, "采购单不存在");

    // ========== 费用管理 1-020-010-000 ==========
    ErrorCode EXPENSE_NOT_EXISTS = new ErrorCode(1_020_010_000, "费用记录不存在");

    // ========== 票据管理 1-020-011-000 ==========
    ErrorCode VOUCHER_NOT_EXISTS = new ErrorCode(1_020_011_000, "票据不存在");

    // ========== 订单附件 1-020-012-000 ==========
    ErrorCode ORDER_ATTACHMENT_NOT_EXISTS = new ErrorCode(1_020_012_000, "订单附件不存在");

}
