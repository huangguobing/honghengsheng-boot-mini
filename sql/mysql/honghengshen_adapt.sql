-- ============================================================
-- 鸿恒盛 ERP 适配增量 SQL 脚本
-- 日期: 2026-03-05
-- 说明: 新增项目/工地、采购单、费用支出、票据凭证、操作日志表
--       扩展现有订单表和付款计划表
-- ============================================================

-- -----------------------------------------------------------
-- 1. 新增表: erp_project (项目/工地表)
-- -----------------------------------------------------------
CREATE TABLE `erp_project` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '项目编号',
  `customer_id` bigint NOT NULL COMMENT '所属客户ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目/工地名称',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '工地地址',
  `contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '现场联系人',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '现场联系电话',
  `investment_type` tinyint NOT NULL DEFAULT 0 COMMENT '投资模式: 0=单独投资 1=合作投资',
  `partner_info` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '合作方信息(investment_type=1时)',
  `contract_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '合同编号',
  `contract_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '合同金额',
  `print_template_id` tinyint NOT NULL DEFAULT 1 COMMENT '打印模板: 1/2/3',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态: 0=进行中 1=已完工',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_customer_id`(`customer_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP项目/工地表' ROW_FORMAT = Dynamic;

-- -----------------------------------------------------------
-- 2. 新增表: erp_purchase_order (采购单表)
-- -----------------------------------------------------------
CREATE TABLE `erp_purchase_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '采购单编号',
  `purchase_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '采购单号',
  `order_id` bigint NOT NULL COMMENT '关联销售订单ID',
  `supplier_id` bigint NOT NULL COMMENT '供应商ID',
  `total_amount` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '采购总金额',
  `delivery_note_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '送货单号',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态: 0=待采购 1=已采购 2=已完成',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_purchase_no`(`purchase_no` ASC) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_supplier_id`(`supplier_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP采购单表' ROW_FORMAT = Dynamic;

-- -----------------------------------------------------------
-- 3. 新增表: erp_purchase_order_item (采购单明细表)
-- -----------------------------------------------------------
CREATE TABLE `erp_purchase_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细编号',
  `purchase_order_id` bigint NOT NULL COMMENT '采购单ID',
  `order_item_id` bigint NULL DEFAULT NULL COMMENT '关联销售订单明细ID',
  `product_id` bigint NULL DEFAULT NULL COMMENT '产品ID',
  `spec_id` bigint NULL DEFAULT NULL COMMENT '规格ID',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `spec_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规格',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单位',
  `quantity` decimal(10, 2) NOT NULL COMMENT '采购数量',
  `purchase_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '采购单价',
  `purchase_amount` decimal(12, 2) NOT NULL COMMENT '采购金额',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_purchase_order_id`(`purchase_order_id` ASC) USING BTREE,
  INDEX `idx_order_item_id`(`order_item_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP采购单明细表' ROW_FORMAT = Dynamic;

-- -----------------------------------------------------------
-- 4. 新增表: erp_expense (费用/运费支出表)
-- -----------------------------------------------------------
CREATE TABLE `erp_expense` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '费用编号',
  `order_id` bigint NULL DEFAULT NULL COMMENT '关联销售订单ID',
  `purchase_order_id` bigint NULL DEFAULT NULL COMMENT '关联采购单ID',
  `expense_date` date NOT NULL COMMENT '费用日期',
  `freight` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '运费',
  `crane_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '吊装费',
  `copy_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '复印费',
  `other_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '其他费用',
  `total_expense` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '总支出',
  `vehicle_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '车号',
  `payer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '付款人',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_expense_date`(`expense_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP费用/运费支出表' ROW_FORMAT = Dynamic;

-- -----------------------------------------------------------
-- 5. 新增表: erp_voucher (票据凭证表)
-- -----------------------------------------------------------
CREATE TABLE `erp_voucher` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '票据编号',
  `order_id` bigint NULL DEFAULT NULL COMMENT '关联订单ID',
  `purchase_order_id` bigint NULL DEFAULT NULL COMMENT '关联采购单ID',
  `voucher_type` tinyint NOT NULL COMMENT '票据类型: 1=专用发票 2=普通发票 3=送货单 4=采购单 5=其他',
  `direction` tinyint NOT NULL COMMENT '方向: 0=进项(采购) 1=销项(销售)',
  `invoice_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发票号',
  `amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '金额',
  `tax_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '税额',
  `invoice_date` date NULL DEFAULT NULL COMMENT '开票日期',
  `buyer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购方',
  `seller` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售方',
  `file_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件URL',
  `file_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件名',
  `reconcile_status` tinyint NOT NULL DEFAULT 0 COMMENT '核销状态: 0=未核销 1=已核销 2=不匹配',
  `reconcile_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '核销备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_purchase_order_id`(`purchase_order_id` ASC) USING BTREE,
  INDEX `idx_voucher_type`(`voucher_type` ASC) USING BTREE,
  INDEX `idx_direction`(`direction` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP票据凭证表' ROW_FORMAT = Dynamic;

-- -----------------------------------------------------------
-- 6. 新增表: erp_operation_log (操作日志表)
-- -----------------------------------------------------------
CREATE TABLE `erp_operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模块名',
  `business_id` bigint NOT NULL COMMENT '业务ID',
  `business_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务单号',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `before_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '修改前数据(JSON)',
  `after_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '修改后数据(JSON)',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作描述',
  `operator_id` bigint NULL DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人姓名',
  `operate_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作IP',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_module_business`(`module` ASC, `business_id` ASC) USING BTREE,
  INDEX `idx_operate_time`(`operate_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP操作日志表' ROW_FORMAT = Dynamic;

-- -----------------------------------------------------------
-- 7. 修改现有表: erp_order 新增字段
-- -----------------------------------------------------------
ALTER TABLE `erp_order`
  ADD COLUMN `project_id` bigint NULL DEFAULT NULL COMMENT '项目/工地ID' AFTER `customer_id`,
  ADD COLUMN `invoice_company` tinyint NULL DEFAULT NULL COMMENT '开票公司: 1=熙汇达鑫 2=鸿恒盛' AFTER `project_id`,
  ADD COLUMN `has_purchase_cycle` tinyint NULL DEFAULT 0 COMMENT '是否有采购周期: 0=否 1=是' AFTER `remark`,
  ADD COLUMN `purchase_cycle_note` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购周期备注' AFTER `has_purchase_cycle`,
  ADD COLUMN `parent_order_id` bigint NULL DEFAULT NULL COMMENT '原订单ID(退货单关联)' AFTER `purchase_cycle_note`,
  ADD COLUMN `is_return` tinyint NOT NULL DEFAULT 0 COMMENT '是否退货单: 0=否 1=是' AFTER `parent_order_id`,
  ADD INDEX `idx_project_id`(`project_id` ASC);

-- -----------------------------------------------------------
-- 8. 修改现有表: erp_payment_plan 新增字段
-- -----------------------------------------------------------
ALTER TABLE `erp_payment_plan`
  ADD COLUMN `type` tinyint NOT NULL DEFAULT 0 COMMENT '类型: 0=应付 1=应收' AFTER `id`,
  ADD COLUMN `purchase_order_id` bigint NULL DEFAULT NULL COMMENT '关联采购单ID' AFTER `order_id`,
  ADD COLUMN `customer_id` bigint NULL DEFAULT NULL COMMENT '客户ID(应收时)' AFTER `supplier_id`,
  ADD COLUMN `project_id` bigint NULL DEFAULT NULL COMMENT '项目ID(应收时)' AFTER `customer_id`,
  ADD COLUMN `paid_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实际已付/已收金额' AFTER `actual_amount`,
  ADD COLUMN `payment_method` tinyint NULL DEFAULT NULL COMMENT '方式: 1=对公 2=对私 3=现金 4=微信 5=支付宝 6=承兑' AFTER `paid_amount`;

-- -----------------------------------------------------------
-- 9. 菜单数据: 项目管理
-- -----------------------------------------------------------
INSERT INTO `system_menu` VALUES (5100, '项目管理', '', 2, 15, 0, '/project', 'ep:office-building', 'erp/project/index', 'ErpProject', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5101, '项目查询', 'erp:project:query', 3, 1, 5100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5102, '项目新增', 'erp:project:create', 3, 2, 5100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5103, '项目修改', 'erp:project:update', 3, 3, 5100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5104, '项目删除', 'erp:project:delete', 3, 4, 5100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- -----------------------------------------------------------
-- 10. 菜单数据: 采购管理
-- -----------------------------------------------------------
INSERT INTO `system_menu` VALUES (5110, '采购管理', '', 2, 35, 0, '/purchase-order', 'ep:shopping-cart', 'erp/purchaseOrder/index', 'ErpPurchaseOrder', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5111, '采购查询', 'erp:purchase-order:query', 3, 1, 5110, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5112, '采购新增', 'erp:purchase-order:create', 3, 2, 5110, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5113, '采购修改', 'erp:purchase-order:update', 3, 3, 5110, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5114, '采购删除', 'erp:purchase-order:delete', 3, 4, 5110, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- -----------------------------------------------------------
-- 11. 菜单数据: 费用支出
-- -----------------------------------------------------------
INSERT INTO `system_menu` VALUES (5120, '费用支出', '', 2, 45, 0, '/expense', 'ep:coin', 'erp/expense/index', 'ErpExpense', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5121, '费用查询', 'erp:expense:query', 3, 1, 5120, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5122, '费用新增', 'erp:expense:create', 3, 2, 5120, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5123, '费用修改', 'erp:expense:update', 3, 3, 5120, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5124, '费用删除', 'erp:expense:delete', 3, 4, 5120, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- -----------------------------------------------------------
-- 12. 菜单数据: 票据管理
-- -----------------------------------------------------------
INSERT INTO `system_menu` VALUES (5130, '票据管理', '', 2, 57, 0, '/voucher', 'ep:document', 'erp/voucher/index', 'ErpVoucher', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5131, '票据查询', 'erp:voucher:query', 3, 1, 5130, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5132, '票据新增', 'erp:voucher:create', 3, 2, 5130, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5133, '票据修改', 'erp:voucher:update', 3, 3, 5130, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` VALUES (5134, '票据删除', 'erp:voucher:delete', 3, 4, 5130, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
