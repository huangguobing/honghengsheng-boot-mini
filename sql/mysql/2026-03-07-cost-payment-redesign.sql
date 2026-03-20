-- ============================================================
-- 订单成本填充与应收应付业务重构 - 增量SQL变更脚本
-- 日期: 2026-03-07
-- 说明:
--   1. erp_operation_log 补全 BaseDO 字段(针对旧版建表缺失的情况)
--   2. erp_payment_plan 确保应收应付相关字段存在
--   3. erp_order_item 的 payment_date / is_paid 字段标记废弃
-- 前置依赖: honghengshen_adapt.sql
-- ============================================================

-- -----------------------------------------------------------
-- 1. erp_operation_log: 补全 BaseDO 所需字段
--    (honghengshen_adapt.sql 的 CREATE TABLE 已包含这些列,
--     此处仅针对更早版本建表后缺失这些列的数据库实例)
--    如列已存在则会报 Duplicate column name 错误，可安全跳过
-- -----------------------------------------------------------

-- 使用存储过程安全添加列，避免重复添加报错
DROP PROCEDURE IF EXISTS `sp_safe_add_column`;

DELIMITER $$
CREATE PROCEDURE `sp_safe_add_column`(
    IN p_table_name VARCHAR(128),
    IN p_column_name VARCHAR(128),
    IN p_column_def  VARCHAR(500)
)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    SELECT COUNT(*) INTO v_exists
      FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = DATABASE()
       AND TABLE_NAME   = p_table_name
       AND COLUMN_NAME  = p_column_name;

    IF v_exists = 0 THEN
        SET @ddl = CONCAT('ALTER TABLE `', p_table_name, '` ADD COLUMN `', p_column_name, '` ', p_column_def);
        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$
DELIMITER ;

-- 1.1 erp_operation_log 补全字段
CALL sp_safe_add_column('erp_operation_log', 'creator',     "varchar(64) DEFAULT '' COMMENT '创建者'");
CALL sp_safe_add_column('erp_operation_log', 'updater',     "varchar(64) DEFAULT '' COMMENT '更新者'");
CALL sp_safe_add_column('erp_operation_log', 'create_time', "datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'");
CALL sp_safe_add_column('erp_operation_log', 'update_time', "datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'");
CALL sp_safe_add_column('erp_operation_log', 'deleted',     "bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除'");

-- -----------------------------------------------------------
-- 2. erp_payment_plan: 确保应收应付相关字段存在
--    (honghengshen_adapt.sql 第8节已有 ALTER TABLE 添加这些列,
--     此处做幂等保护，确保无论执行顺序如何都不会出错)
-- -----------------------------------------------------------
CALL sp_safe_add_column('erp_payment_plan', 'type',             "tinyint NOT NULL DEFAULT 0 COMMENT '类型: 0=应付 1=应收' AFTER `id`");
CALL sp_safe_add_column('erp_payment_plan', 'purchase_order_id',"bigint NULL DEFAULT NULL COMMENT '关联采购单ID' AFTER `order_id`");
CALL sp_safe_add_column('erp_payment_plan', 'customer_id',      "bigint NULL DEFAULT NULL COMMENT '客户ID(应收时)' AFTER `supplier_id`");
CALL sp_safe_add_column('erp_payment_plan', 'project_id',       "bigint NULL DEFAULT NULL COMMENT '项目ID(应收时)' AFTER `customer_id`");
CALL sp_safe_add_column('erp_payment_plan', 'paid_amount',      "decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实际已付/已收金额' AFTER `actual_amount`");
CALL sp_safe_add_column('erp_payment_plan', 'payment_method',   "tinyint NULL DEFAULT NULL COMMENT '方式: 1=对公 2=对私 3=现金 4=微信 5=支付宝 6=承兑' AFTER `paid_amount`");

-- -----------------------------------------------------------
-- 3. erp_order_item: 将 payment_date / is_paid 字段标记为废弃
--    这两个字段不再由业务代码使用，付款信息已迁移至
--    erp_payment_plan 表独立管理。
--    仅修改列注释，不删除数据，保证向后兼容。
-- -----------------------------------------------------------
ALTER TABLE `erp_order_item`
  MODIFY COLUMN `payment_date` date NULL DEFAULT NULL COMMENT '[废弃] 付款日期 - 已迁移至 erp_payment_plan',
  MODIFY COLUMN `is_paid` tinyint(1) NULL DEFAULT 0 COMMENT '[废弃] 是否已付款 - 已迁移至 erp_payment_plan';

-- -----------------------------------------------------------
-- 清理: 删除辅助存储过程
-- -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_safe_add_column`;

-- ============================================================
-- 执行完毕
-- ============================================================
