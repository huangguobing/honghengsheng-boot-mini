-- ============================================================
-- 鸿恒盛 ERP 全量数据库 SQL
-- 生成日期: 2026-03-06
-- 说明: 包含全部 15 张 ERP 业务表 + 菜单数据
--       已合并 stmc_erp.sql / honghengshen_adapt.sql /
--       extra_cost.sql / product_management.sql 的所有变更
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 1. erp_customer (客户表)
-- ============================================================
DROP TABLE IF EXISTS `erp_customer`;
CREATE TABLE `erp_customer`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '客户编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '客户编码',
  `contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电子邮箱',
  `fax` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '传真',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开户银行',
  `bank_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '银行账号',
  `tax_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '税号',
  `credit_limit` decimal(12, 2) NULL DEFAULT NULL COMMENT '信用额度',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态(0启用 1停用)',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE,
  INDEX `idx_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP客户表' ROW_FORMAT = Dynamic;

-- ============================================================
-- 2. erp_supplier (供应商表)
-- ============================================================
DROP TABLE IF EXISTS `erp_supplier`;
CREATE TABLE `erp_supplier`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '供应商编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '供应商名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '供应商编码',
  `contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电子邮箱',
  `fax` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '传真',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开户行',
  `bank_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '银行账号',
  `tax_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '税号',
  `payment_days` int NULL DEFAULT 0 COMMENT '账期天数',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态(0启用 1停用)',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE,
  INDEX `idx_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP供应商表' ROW_FORMAT = Dynamic;

-- ============================================================
-- 3. erp_project (项目/工地表) [新增]
-- ============================================================
DROP TABLE IF EXISTS `erp_project`;
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
  `print_template_id` tinyint NOT NULL DEFAULT 1 COMMENT '打印模板: 1=鸿恒盛 2=熙汇达鑫 3=尚泰铭成',
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

-- ============================================================
-- 4. erp_product (产品表) [新增]
-- ============================================================
DROP TABLE IF EXISTS `erp_product`;
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

-- ============================================================
-- 5. erp_product_spec (产品规格表) [新增]
-- ============================================================
DROP TABLE IF EXISTS `erp_product_spec`;
CREATE TABLE `erp_product_spec` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '规格编号',
  `product_id` bigint NOT NULL COMMENT '产品编号',
  `spec` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规格',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '单位',
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

-- ============================================================
-- 6. erp_order (订单表) [已合并 honghengshen_adapt + extra_cost 的 ALTER]
-- ============================================================
DROP TABLE IF EXISTS `erp_order`;
CREATE TABLE `erp_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单编号',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `customer_id` bigint NULL DEFAULT NULL COMMENT '客户编号(销售订单)',
  `project_id` bigint NULL DEFAULT NULL COMMENT '项目/工地ID',
  `invoice_company` tinyint NULL DEFAULT NULL COMMENT '开票公司: 1=熙汇达鑫 2=鸿恒盛',
  `supplier_id` bigint NULL DEFAULT NULL COMMENT '供应商编号(采购订单)',
  `order_type` tinyint NOT NULL DEFAULT 1 COMMENT '订单类型(1销售订单 2采购订单)',
  `order_date` date NOT NULL COMMENT '订单日期',
  `delivery_date` date NULL DEFAULT NULL COMMENT '交货日期',
  `total_quantity` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '商品总数量',
  `total_amount` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '商品总金额',
  `discount_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '折扣金额',
  `payable_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '应付金额',
  `paid_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '已付金额',
  `shipping_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '运费',
  `total_purchase_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '采购总成本',
  `total_gross_profit` decimal(12, 2) NULL DEFAULT NULL COMMENT '总毛利',
  `total_tax_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '总税额',
  `total_net_profit` decimal(12, 2) NULL DEFAULT NULL COMMENT '总净利',
  `extra_cost` decimal(24, 2) NULL DEFAULT NULL COMMENT '其他费用金额',
  `extra_cost_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '其他费用备注',
  `cost_filled` bit(1) NULL DEFAULT b'0' COMMENT '成本是否已填充',
  `cost_filled_by` bigint NULL DEFAULT NULL COMMENT '成本填充人ID',
  `cost_filled_time` datetime NULL DEFAULT NULL COMMENT '成本填充时间',
  `salesman_id` bigint NULL DEFAULT NULL COMMENT '业务员ID',
  `salesman_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务员姓名',
  `contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收货地址',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `has_purchase_cycle` tinyint NULL DEFAULT 0 COMMENT '是否有采购周期: 0=否 1=是',
  `purchase_cycle_note` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购周期备注',
  `parent_order_id` bigint NULL DEFAULT NULL COMMENT '原订单ID(退货单关联)',
  `is_return` tinyint NOT NULL DEFAULT 0 COMMENT '是否退货单: 0=否 1=是',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_customer_id`(`customer_id` ASC) USING BTREE,
  INDEX `idx_project_id`(`project_id` ASC) USING BTREE,
  INDEX `idx_supplier_id`(`supplier_id` ASC) USING BTREE,
  INDEX `idx_order_type`(`order_type` ASC) USING BTREE,
  INDEX `idx_order_date`(`order_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_salesman_id`(`salesman_id` ASC) USING BTREE,
  INDEX `idx_cost_filled`(`cost_filled` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP订单表' ROW_FORMAT = Dynamic;

-- ============================================================
-- 7. erp_order_item (订单明细表) [已合并 product_management 的 ALTER]
-- ============================================================
DROP TABLE IF EXISTS `erp_order_item`;
CREATE TABLE `erp_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `item_type` tinyint NOT NULL DEFAULT 0 COMMENT '明细类型(0商品 1费用)',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `spec` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规格',
  `sale_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售单位',
  `sale_quantity` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '销售数量',
  `sale_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '销售单价',
  `sale_amount` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '销售金额',
  `sale_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售备注',
  `purchase_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '进货单位',
  `purchase_quantity` decimal(12, 2) NULL DEFAULT NULL COMMENT '进货数量',
  `purchase_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '采购单价',
  `purchase_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '采购金额',
  `purchase_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购备注',
  `supplier_id` bigint NULL DEFAULT NULL COMMENT '供应商ID',
  `gross_profit` decimal(12, 2) NULL DEFAULT NULL COMMENT '毛利',
  `tax_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '税额',
  `net_profit` decimal(12, 2) NULL DEFAULT NULL COMMENT '净利',
  `payment_date` date NULL DEFAULT NULL COMMENT '付款日期',
  `is_paid` tinyint(1) NULL DEFAULT 0 COMMENT '是否已付款(0未付款 1已付款)',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_supplier_id`(`supplier_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP订单明细表' ROW_FORMAT = Dynamic;

-- ============================================================
-- 8. erp_payment (付款单表)
-- ============================================================
DROP TABLE IF EXISTS `erp_payment`;
CREATE TABLE `erp_payment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '付款单编号',
  `payment_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '付款单号',
  `supplier_id` bigint NOT NULL COMMENT '供应商编号',
  `payment_type` tinyint NULL DEFAULT 1 COMMENT '付款类型(1采购付款 2费用付款)',
  `order_id` bigint NULL DEFAULT NULL COMMENT '关联订单ID',
  `amount` decimal(12, 2) NOT NULL COMMENT '付款金额',
  `payment_method` tinyint NULL DEFAULT NULL COMMENT '付款方式(1银行转账 2现金 3支票 4其他)',
  `payment_account` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '付款账户',
  `payment_date` date NOT NULL COMMENT '付款日期(计算账期起始日)',
  `approver` bigint NULL DEFAULT NULL COMMENT '审批人',
  `approve_time` datetime NULL DEFAULT NULL COMMENT '审批时间',
  `approve_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审批意见',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态(0待付款 10部分付款 20已付款 30已取消)',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_payment_no`(`payment_no` ASC) USING BTREE,
  INDEX `idx_supplier_id`(`supplier_id` ASC) USING BTREE,
  INDEX `idx_payment_date`(`payment_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP付款单表' ROW_FORMAT = Dynamic;

-- ============================================================
-- 9. erp_payment_plan (付款计划表) [已合并 honghengshen_adapt 的 ALTER]
-- ============================================================
DROP TABLE IF EXISTS `erp_payment_plan`;
CREATE TABLE `erp_payment_plan`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '计划编号',
  `type` tinyint NOT NULL DEFAULT 0 COMMENT '类型: 0=应付 1=应收',
  `plan_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '计划单号',
  `payment_id` bigint NOT NULL COMMENT '付款单编号',
  `payment_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '付款单号',
  `supplier_id` bigint NOT NULL COMMENT '供应商编号',
  `customer_id` bigint NULL DEFAULT NULL COMMENT '客户ID(应收时)',
  `project_id` bigint NULL DEFAULT NULL COMMENT '项目ID(应收时)',
  `order_id` bigint NULL DEFAULT NULL COMMENT '订单ID',
  `purchase_order_id` bigint NULL DEFAULT NULL COMMENT '关联采购单ID',
  `config_id` bigint NULL DEFAULT NULL COMMENT '配置编号',
  `stage` int NOT NULL COMMENT '期数',
  `plan_amount` decimal(12, 2) NOT NULL COMMENT '计划付款金额',
  `plan_date` date NOT NULL COMMENT '计划付款日期',
  `actual_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实际付款金额',
  `paid_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实际已付/已收金额',
  `payment_method` tinyint NULL DEFAULT NULL COMMENT '方式: 1=对公 2=对私 3=现金 4=微信 5=支付宝 6=承兑',
  `actual_date` datetime NULL DEFAULT NULL COMMENT '实际付款日期',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态(0待付款 10已付款 20已逾期 30已取消)',
  `notify_status` tinyint NOT NULL DEFAULT 0 COMMENT '通知状态(0未通知 1已通知即将到期 2已通知当日到期 3已通知逾期)',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_plan_no`(`plan_no` ASC) USING BTREE,
  INDEX `idx_payment_id`(`payment_id` ASC) USING BTREE,
  INDEX `idx_supplier_id`(`supplier_id` ASC) USING BTREE,
  INDEX `idx_plan_date`(`plan_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP付款计划表' ROW_FORMAT = Dynamic;

-- ============================================================
-- 10. erp_payment_term_config (采购账期分期配置表)
-- ============================================================
DROP TABLE IF EXISTS `erp_payment_term_config`;
CREATE TABLE `erp_payment_term_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置编号',
  `supplier_id` bigint NOT NULL COMMENT '供应商编号',
  `stage` int NOT NULL COMMENT '期数',
  `days_after_order` int NOT NULL COMMENT '订单后天数',
  `percentage` decimal(5, 2) NOT NULL COMMENT '付款比例(%)',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态(0启用 1停用)',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_supplier_id`(`supplier_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP采购账期分期配置表' ROW_FORMAT = Dynamic;

-- ============================================================
-- 11. erp_purchase_order (采购单表) [新增]
-- ============================================================
DROP TABLE IF EXISTS `erp_purchase_order`;
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

-- ============================================================
-- 12. erp_purchase_order_item (采购单明细表) [新增]
-- ============================================================
DROP TABLE IF EXISTS `erp_purchase_order_item`;
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

-- ============================================================
-- 13. erp_expense (费用/运费支出表) [新增]
-- ============================================================
DROP TABLE IF EXISTS `erp_expense`;
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

-- ============================================================
-- 14. erp_voucher (票据凭证表) [新增]
-- ============================================================
DROP TABLE IF EXISTS `erp_voucher`;
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

-- ============================================================
-- 15. erp_operation_log (操作日志表) [新增，无公共字段]
-- ============================================================
DROP TABLE IF EXISTS `erp_operation_log`;
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
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_module_business`(`module` ASC, `business_id` ASC) USING BTREE,
  INDEX `idx_operate_time`(`operate_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP操作日志表' ROW_FORMAT = Dynamic;

-- ============================================================
-- 菜单数据 (ERP 模块)
-- 注意: 产品管理 5140-5144, 项目管理 5100-5104, 采购管理 5110-5114,
--       费用支出 5120-5124, 票据管理 5130-5134, 统计报表 5150-5158
-- ============================================================

-- 项目管理 (5100-5104)
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(5100, '项目管理', '', 2, 15, 0, '/project', 'ep:office-building', 'erp/project/index', 'ErpProject', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5101, '项目查询', 'erp:project:query', 3, 1, 5100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5102, '项目新增', 'erp:project:create', 3, 2, 5100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5103, '项目修改', 'erp:project:update', 3, 3, 5100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5104, '项目删除', 'erp:project:delete', 3, 4, 5100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- 采购管理 (5110-5114)
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(5110, '采购管理', '', 2, 35, 0, '/purchase-order', 'ep:shopping-cart', 'erp/purchaseOrder/index', 'ErpPurchaseOrder', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5111, '采购查询', 'erp:purchase-order:query', 3, 1, 5110, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5112, '采购新增', 'erp:purchase-order:create', 3, 2, 5110, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5113, '采购修改', 'erp:purchase-order:update', 3, 3, 5110, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5114, '采购删除', 'erp:purchase-order:delete', 3, 4, 5110, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- 费用支出 (5120-5124)
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(5120, '费用支出', '', 2, 45, 0, '/expense', 'ep:coin', 'erp/expense/index', 'ErpExpense', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5121, '费用查询', 'erp:expense:query', 3, 1, 5120, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5122, '费用新增', 'erp:expense:create', 3, 2, 5120, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5123, '费用修改', 'erp:expense:update', 3, 3, 5120, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5124, '费用删除', 'erp:expense:delete', 3, 4, 5120, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- 票据管理 (5130-5134)
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(5130, '票据管理', '', 2, 57, 0, '/voucher', 'ep:document', 'erp/voucher/index', 'ErpVoucher', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5131, '票据查询', 'erp:voucher:query', 3, 1, 5130, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5132, '票据新增', 'erp:voucher:create', 3, 2, 5130, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5133, '票据修改', 'erp:voucher:update', 3, 3, 5130, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5134, '票据删除', 'erp:voucher:delete', 3, 4, 5130, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- 产品管理 (5140-5144) [避免与项目管理5100冲突]
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(5140, '产品管理', '', 2, 5, 0, '/product/manage', 'ep:goods', 'erp/product/index', 'ErpProduct', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5141, '产品查询', 'erp:product:query', 3, 1, 5140, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5142, '产品新增', 'erp:product:create', 3, 2, 5140, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5143, '产品修改', 'erp:product:update', 3, 3, 5140, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5144, '产品删除', 'erp:product:delete', 3, 4, 5140, '', '', '', '', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- 统计报表子菜单 (挂到已有的5070统计报表下, 5071/5073/5075已存在)
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(5152, '项目利润统计', 'erp:statistics:project-profit', 2, 4, 5070, 'projectProfit', '', 'erp/statistics/projectProfit/index', 'ProjectProfit', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5153, '产品销量统计', 'erp:statistics:product-sales', 2, 5, 5070, 'productSales', '', 'erp/statistics/productSales/index', 'ProductSales', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5154, '应收应付统计', 'erp:statistics:receivable-payable', 2, 6, 5070, 'receivablePayable', '', 'erp/statistics/receivablePayable/index', 'ReceivablePayable', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(5155, '发票汇总', 'erp:statistics:invoice-summary', 2, 7, 5070, 'invoiceSummary', '', 'erp/statistics/invoiceSummary/index', 'InvoiceSummary', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- ============================================================
-- 管理员角色授权 (给 super_admin / tenant_admin / boss 授权所有ERP菜单)
-- ============================================================
INSERT INTO `system_role_menu` (`role_id`, `menu_id`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`)
SELECT r.id as role_id, m.id as menu_id, '1', NOW(), '1', NOW(), b'0', 1
FROM system_role r
CROSS JOIN (
  SELECT 5100 as id UNION SELECT 5101 UNION SELECT 5102 UNION SELECT 5103 UNION SELECT 5104
  UNION SELECT 5110 UNION SELECT 5111 UNION SELECT 5112 UNION SELECT 5113 UNION SELECT 5114
  UNION SELECT 5120 UNION SELECT 5121 UNION SELECT 5122 UNION SELECT 5123 UNION SELECT 5124
  UNION SELECT 5130 UNION SELECT 5131 UNION SELECT 5132 UNION SELECT 5133 UNION SELECT 5134
  UNION SELECT 5140 UNION SELECT 5141 UNION SELECT 5142 UNION SELECT 5143 UNION SELECT 5144
  UNION SELECT 5152 UNION SELECT 5153 UNION SELECT 5154 UNION SELECT 5155
) m
WHERE r.code IN ('super_admin', 'tenant_admin', 'boss') AND r.deleted = 0;

SET FOREIGN_KEY_CHECKS = 1;
