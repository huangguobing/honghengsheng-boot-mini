-- stmc-boot-mini/sql/mysql/product_management.sql

-- 1. 产品表
CREATE TABLE `erp_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '产品编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '产品名称',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态(0启用 1停用)',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP产品表' ROW_FORMAT = Dynamic;

-- 2. 产品规格表
CREATE TABLE `erp_product_spec` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '规格编号',
  `product_id` bigint NOT NULL COMMENT '产品编号',
  `spec` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规格',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '单位',
  `manufacturer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生产厂家',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态(0启用 1停用)',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP产品规格表' ROW_FORMAT = Dynamic;

-- 3. 订单明细表新增 item_type 字段
ALTER TABLE `erp_order_item` ADD COLUMN `item_type` tinyint NOT NULL DEFAULT 0 COMMENT '明细类型(0商品 1费用)' AFTER `order_id`;

-- 4. 菜单数据（parent_id=0 表示一级菜单，与现有菜单结构一致）
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(5100, '产品管理', '', 2, 5, 0, '/product/manage', 'ep:goods', 'erp/product/index', 'ErpProduct', 0, b'1', b'1', b'1', '1', NOW(), '1', NOW(), b'0'),
(5101, '产品查询', 'erp:product:query', 3, 1, 5100, '', '', '', '', 0, b'1', b'1', b'1', '1', NOW(), '1', NOW(), b'0'),
(5102, '产品新增', 'erp:product:create', 3, 2, 5100, '', '', '', '', 0, b'1', b'1', b'1', '1', NOW(), '1', NOW(), b'0'),
(5103, '产品修改', 'erp:product:update', 3, 3, 5100, '', '', '', '', 0, b'1', b'1', b'1', '1', NOW(), '1', NOW(), b'0'),
(5104, '产品删除', 'erp:product:delete', 3, 4, 5100, '', '', '', '', 0, b'1', b'1', b'1', '1', NOW(), '1', NOW(), b'0');

-- 5. 给管理员角色授权产品管理菜单
INSERT INTO `system_role_menu` (`role_id`, `menu_id`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`)
SELECT role_id, menu_id, '1', NOW(), '1', NOW(), b'0', 1
FROM (
  SELECT r.id as role_id, m.id as menu_id
  FROM system_role r
  CROSS JOIN (SELECT 5100 as id UNION SELECT 5101 UNION SELECT 5102 UNION SELECT 5103 UNION SELECT 5104) m
  WHERE r.code IN ('super_admin', 'tenant_admin', 'boss') AND r.deleted = 0
) t;
