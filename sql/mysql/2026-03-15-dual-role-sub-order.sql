-- ============================================================
-- A/B双角色副订单系统 数据库迁移
-- 执行日期: 2026-03-15
-- ============================================================

-- 1. erp_project 新增 parent_id 字段（父子项目结构）
ALTER TABLE `erp_project` ADD COLUMN `parent_id` bigint NULL DEFAULT NULL COMMENT '父项目ID，NULL=一级项目（工地）' AFTER `id`;
ALTER TABLE `erp_project` ADD INDEX `idx_parent_id` (`parent_id`);

-- 2. erp_order 新增 order_category 字段（主/副订单标识，数据隔离核心字段）
ALTER TABLE `erp_order` ADD COLUMN `order_category` tinyint NOT NULL DEFAULT 0 COMMENT '订单类别：0=主订单 1=副订单' AFTER `is_return`;
ALTER TABLE `erp_order` ADD INDEX `idx_order_category` (`order_category`);

-- 3. erp_order 新增 sub_order_status 字段（副单录入状态，仅主订单使用）
ALTER TABLE `erp_order` ADD COLUMN `sub_order_status` tinyint NOT NULL DEFAULT 0 COMMENT '副单录入状态：0=待录入 1=已录入' AFTER `order_category`;

-- 4. erp_order_item 新增 parent_item_id 字段（副订单商品行关联主订单商品行）
ALTER TABLE `erp_order_item` ADD COLUMN `parent_item_id` bigint NULL DEFAULT NULL COMMENT '关联主订单商品行ID' AFTER `order_id`;

-- 5. 角色数据变更：boss -> honghengsheng, salesman -> xihuidaxin
UPDATE `system_role` SET `code` = 'honghengsheng', `name` = '鸿恒盛' WHERE `code` = 'boss';
UPDATE `system_role` SET `code` = 'xihuidaxin', `name` = '熙汇达鑫', `data_scope` = 5 WHERE `code` = 'salesman';
