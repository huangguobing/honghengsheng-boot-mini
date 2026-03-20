/*
 Navicat Premium Dump SQL

 Source Server         : 47.109.47.47(慎重操作)
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : 47.109.47.47:3306
 Source Schema         : stmc_erp

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 15/01/2026 18:41:49
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for erp_customer
-- ----------------------------
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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP客户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of erp_customer
-- ----------------------------
INSERT INTO `erp_customer` VALUES (1, '四川益捷聚兴建筑工程有限公司', '01', '秦总', '15984785999', '', '', '', '', '', '', 0.00, 0, 0, '', '147', '2026-01-15 09:33:25', '147', '2026-01-15 09:33:25', b'0', 1);
INSERT INTO `erp_customer` VALUES (2, '成都武城装饰工程有限责任公司', '', '李姐', '13350312736', '', '', '', '', '', '', 0.00, 0, 0, '', '148', '2026-01-15 09:56:19', '148', '2026-01-15 09:56:19', b'0', 1);
INSERT INTO `erp_customer` VALUES (3, '四川科友电力安装工程有限公司', '', '王丽', '13158855994', '', '', '', '', '', '', 0.00, 0, 0, '', '148', '2026-01-15 10:12:56', '148', '2026-01-15 10:12:56', b'0', 1);

-- ----------------------------
-- Table structure for erp_order
-- ----------------------------
DROP TABLE IF EXISTS `erp_order`;
CREATE TABLE `erp_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单编号',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `customer_id` bigint NULL DEFAULT NULL COMMENT '客户编号(销售订单)',
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
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_customer_id`(`customer_id` ASC) USING BTREE,
  INDEX `idx_supplier_id`(`supplier_id` ASC) USING BTREE,
  INDEX `idx_order_type`(`order_type` ASC) USING BTREE,
  INDEX `idx_order_date`(`order_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_salesman_id`(`salesman_id` ASC) USING BTREE,
  INDEX `idx_cost_filled`(`cost_filled` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of erp_order
-- ----------------------------
INSERT INTO `erp_order` VALUES (1, 'SO202601154720', 1, NULL, 1, '2026-01-15', '2026-01-15', 4025.00, 142487.50, 0.00, 142487.50, 0.00, 0.00, 127719.54, 14767.96, 308.42, 14459.54, b'1', 1, '2026-01-15 10:07:36', 147, '邓强', '秦总', '15984785999', '', 20, '', '147', '2026-01-15 09:38:10', '1', '2026-01-15 10:07:36', b'0', 1);
INSERT INTO `erp_order` VALUES (2, 'SO202601152032', 2, NULL, 1, '2026-01-15', '2026-01-15', 63922.00, 85972.00, 0.00, 85972.00, 0.00, 0.00, NULL, NULL, NULL, NULL, b'0', NULL, NULL, 148, '袁光华', '李姐', '13350312736', '', 0, '', '148', '2026-01-15 10:04:35', '148', '2026-01-15 10:05:22', b'1', 1);
INSERT INTO `erp_order` VALUES (3, 'SO202601153360', 2, NULL, 1, '2026-01-15', '2026-01-15', 63922.00, 85972.00, 0.00, 85972.00, 0.00, 0.00, NULL, NULL, NULL, NULL, b'0', NULL, NULL, 148, '袁光华', '李姐', '13350312736', '', 0, '', '148', '2026-01-15 10:05:18', '148', '2026-01-15 10:06:34', b'1', 1);
INSERT INTO `erp_order` VALUES (4, 'SO202601156960', 2, NULL, 1, '2026-01-15', '2026-01-15', 63922.00, 85972.00, 0.00, 85972.00, 0.00, 0.00, NULL, NULL, NULL, NULL, b'0', NULL, NULL, 148, '袁光华', '李姐', '13350312736', '', 0, '', '148', '2026-01-15 10:06:28', '148', '2026-01-15 10:07:18', b'1', 1);
INSERT INTO `erp_order` VALUES (5, 'SO202601159648', 2, NULL, 1, '2026-01-15', '2026-01-15', 63922.00, 85972.00, 0.00, 85972.00, 0.00, 0.00, NULL, NULL, NULL, NULL, b'0', NULL, NULL, 148, '袁光华', '李姐', '13350312736', '', 10, '', '148', '2026-01-15 10:06:54', '1', '2026-01-15 10:07:40', b'0', 1);
INSERT INTO `erp_order` VALUES (6, 'SO202601154080', 2, NULL, 1, '2026-01-15', '2026-01-15', 278.00, 24678.00, 0.00, 24678.00, 0.00, 0.00, NULL, NULL, NULL, NULL, b'0', NULL, NULL, 148, '袁光华', '李姐', '13350312736', '', 10, '', '148', '2026-01-15 10:10:13', '1', '2026-01-15 10:23:24', b'0', 1);

-- ----------------------------
-- Table structure for erp_order_item
-- ----------------------------
DROP TABLE IF EXISTS `erp_order_item`;
CREATE TABLE `erp_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `spec` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规格',
  `sale_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售单位',
  `sale_quantity` decimal(12, 2) NOT NULL COMMENT '销售数量',
  `sale_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '销售单价',
  `sale_amount` decimal(12, 2) NOT NULL COMMENT '销售金额',
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
) ENGINE = InnoDB AUTO_INCREMENT = 50 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP订单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of erp_order_item
-- ----------------------------
INSERT INTO `erp_order_item` VALUES (1, 1, '热镀锌方矩管', '50*100*5', '支', 125.00, 277.50, 34687.50, '', '吨', 7.83, 3940.00, 30842.32, '', 1, 3845.18, 308.42, 3536.76, '2026-01-16', 0, '147', '2026-01-15 09:38:10', '147', '2026-01-15 09:38:10', b'0', 0);
INSERT INTO `erp_order_item` VALUES (2, 1, '热镀锌槽钢加工件', '100*100', '个', 450.00, 4.10, 1845.00, '', '吨', 0.37, 3780.00, 1398.60, '', 2, 446.40, 0.00, 446.40, '2026-01-31', 0, '147', '2026-01-15 09:38:10', '147', '2026-01-15 09:38:10', b'0', 0);
INSERT INTO `erp_order_item` VALUES (3, 1, '热镀锌槽钢加工件', '100*100', '个', 150.00, 4.10, 615.00, '', '吨', 0.12, 3780.00, 468.72, '', 2, 146.28, 0.00, 146.28, '2026-01-31', 0, '147', '2026-01-15 09:38:10', '147', '2026-01-15 09:38:10', b'0', 0);
INSERT INTO `erp_order_item` VALUES (4, 1, '热镀锌预埋板', '200*300*8', '个', 300.00, 16.00, 4800.00, '', '个', 300.00, 13.77, 4131.00, '', 4, 669.00, 0.00, 669.00, '2026-01-31', 0, '147', '2026-01-15 09:38:10', '147', '2026-01-15 09:38:10', b'0', 0);
INSERT INTO `erp_order_item` VALUES (5, 1, '热镀锌角钢', '50*50*4', '支', 1000.00, 71.50, 71500.00, '', '吨', 17.24, 3750.00, 64657.50, '', 2, 6842.50, 0.00, 6842.50, '2026-01-31', 0, '147', '2026-01-15 09:38:10', '147', '2026-01-15 09:38:10', b'0', 0);
INSERT INTO `erp_order_item` VALUES (6, 1, '热镀锌角钢', '50*50*5', '支', 300.00, 86.70, 26010.00, '', '吨', 6.43, 3700.00, 23783.60, '', 2, 2226.40, 0.00, 2226.40, '2026-01-31', 0, '147', '2026-01-15 09:38:10', '147', '2026-01-15 09:38:10', b'0', 0);
INSERT INTO `erp_order_item` VALUES (7, 1, '不锈钢膨胀螺栓', 'M12*100', '个', 500.00, 2.70, 1350.00, '', '个', 500.00, 2.61, 1305.00, '', 4, 45.00, 0.00, 45.00, '2026-01-31', 0, '147', '2026-01-15 09:38:10', '147', '2026-01-15 09:38:10', b'0', 0);
INSERT INTO `erp_order_item` VALUES (8, 1, '厚切膨胀螺栓', 'M12*120', '个', 1200.00, 1.40, 1680.00, '', '个', 1200.00, 0.94, 1132.80, '', 4, 547.20, 0.00, 547.20, '2026-01-31', 0, '147', '2026-01-15 09:38:10', '147', '2026-01-15 09:38:10', b'0', 0);
INSERT INTO `erp_order_item` VALUES (9, 2, '预埋件', '300*250*10', '块', 1000.00, 25.70, 25700.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:04:35', '148', '2026-01-15 10:05:22', b'1', 0);
INSERT INTO `erp_order_item` VALUES (10, 2, '预埋件', '300*200*10', '块', 500.00, 21.00, 10500.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:04:35', '148', '2026-01-15 10:05:22', b'1', 0);
INSERT INTO `erp_order_item` VALUES (11, 2, '直角预埋件', '210+150*300*10', '块', 480.00, 38.00, 18240.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:04:35', '148', '2026-01-15 10:05:22', b'1', 0);
INSERT INTO `erp_order_item` VALUES (12, 2, '机械锚栓', 'M12*120', '颗', 8000.00, 1.09, 8720.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:04:35', '148', '2026-01-15 10:05:22', b'1', 0);
INSERT INTO `erp_order_item` VALUES (13, 2, '垫片', '30*30', '块', 50000.00, 0.11, 5500.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:04:35', '148', '2026-01-15 10:05:22', b'1', 0);
INSERT INTO `erp_order_item` VALUES (14, 2, '插芯', '50+100*4*200', '个', 600.00, 12.70, 7620.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:04:35', '148', '2026-01-15 10:05:22', b'1', 0);
INSERT INTO `erp_order_item` VALUES (15, 2, '304不锈钢螺栓', '12*120', '颗', 3300.00, 2.35, 7755.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:04:35', '148', '2026-01-15 10:05:22', b'1', 0);
INSERT INTO `erp_order_item` VALUES (16, 2, '彩钢围挡', '2米高*3.7米长', '米', 41.00, 46.00, 1886.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:04:35', '148', '2026-01-15 10:05:22', b'1', 0);
INSERT INTO `erp_order_item` VALUES (17, 2, '彩钢围挡柱', '/', '根', 1.00, 51.00, 51.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:04:35', '148', '2026-01-15 10:05:22', b'1', 0);
INSERT INTO `erp_order_item` VALUES (18, 3, '预埋件', '300*250*10', '块', 1000.00, 25.70, 25700.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:05:18', '148', '2026-01-15 10:06:34', b'1', 0);
INSERT INTO `erp_order_item` VALUES (19, 3, '预埋件', '300*200*10', '块', 500.00, 21.00, 10500.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:05:18', '148', '2026-01-15 10:06:34', b'1', 0);
INSERT INTO `erp_order_item` VALUES (20, 3, '直角预埋件', '210+150*300*10', '块', 480.00, 38.00, 18240.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:05:18', '148', '2026-01-15 10:06:34', b'1', 0);
INSERT INTO `erp_order_item` VALUES (21, 3, '机械锚栓', 'M12*120', '颗', 8000.00, 1.09, 8720.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:05:18', '148', '2026-01-15 10:06:34', b'1', 0);
INSERT INTO `erp_order_item` VALUES (22, 3, '垫片', '30*30', '块', 50000.00, 0.11, 5500.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:05:18', '148', '2026-01-15 10:06:34', b'1', 0);
INSERT INTO `erp_order_item` VALUES (23, 3, '插芯', '50+100*4*200', '个', 600.00, 12.70, 7620.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:05:18', '148', '2026-01-15 10:06:34', b'1', 0);
INSERT INTO `erp_order_item` VALUES (24, 3, '304不锈钢螺栓', '12*120', '颗', 3300.00, 2.35, 7755.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:05:18', '148', '2026-01-15 10:06:34', b'1', 0);
INSERT INTO `erp_order_item` VALUES (25, 3, '彩钢围挡', '2米高*3.7米长', '米', 41.00, 46.00, 1886.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:05:18', '148', '2026-01-15 10:06:34', b'1', 0);
INSERT INTO `erp_order_item` VALUES (26, 3, '彩钢围挡柱', '/', '根', 1.00, 51.00, 51.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:05:18', '148', '2026-01-15 10:06:34', b'1', 0);
INSERT INTO `erp_order_item` VALUES (27, 4, '预埋件', '300*250*10', '块', 1000.00, 25.70, 25700.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:28', '148', '2026-01-15 10:07:17', b'1', 0);
INSERT INTO `erp_order_item` VALUES (28, 4, '预埋件', '300*200*10', '块', 500.00, 21.00, 10500.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:28', '148', '2026-01-15 10:07:17', b'1', 0);
INSERT INTO `erp_order_item` VALUES (29, 4, '直角预埋件', '210+150*300*10', '块', 480.00, 38.00, 18240.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:28', '148', '2026-01-15 10:07:17', b'1', 0);
INSERT INTO `erp_order_item` VALUES (30, 4, '机械锚栓', 'M12*120', '颗', 8000.00, 1.09, 8720.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:28', '148', '2026-01-15 10:07:17', b'1', 0);
INSERT INTO `erp_order_item` VALUES (31, 4, '垫片', '30*30', '块', 50000.00, 0.11, 5500.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:28', '148', '2026-01-15 10:07:17', b'1', 0);
INSERT INTO `erp_order_item` VALUES (32, 4, '插芯', '50+100*4*200', '个', 600.00, 12.70, 7620.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:28', '148', '2026-01-15 10:07:17', b'1', 0);
INSERT INTO `erp_order_item` VALUES (33, 4, '304不锈钢螺栓', '12*120', '颗', 3300.00, 2.35, 7755.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:28', '148', '2026-01-15 10:07:17', b'1', 0);
INSERT INTO `erp_order_item` VALUES (34, 4, '彩钢围挡', '2米高*3.7米长', '米', 41.00, 46.00, 1886.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:28', '148', '2026-01-15 10:07:17', b'1', 0);
INSERT INTO `erp_order_item` VALUES (35, 4, '彩钢围挡柱', '/', '根', 1.00, 51.00, 51.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:28', '148', '2026-01-15 10:07:17', b'1', 0);
INSERT INTO `erp_order_item` VALUES (36, 5, '预埋件', '300*250*10', '块', 1000.00, 25.70, 25700.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:54', '148', '2026-01-15 10:06:54', b'0', 0);
INSERT INTO `erp_order_item` VALUES (37, 5, '预埋件', '300*200*10', '块', 500.00, 21.00, 10500.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:54', '148', '2026-01-15 10:06:54', b'0', 0);
INSERT INTO `erp_order_item` VALUES (38, 5, '直角预埋件', '210+150*300*10', '块', 480.00, 38.00, 18240.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:54', '148', '2026-01-15 10:06:54', b'0', 0);
INSERT INTO `erp_order_item` VALUES (39, 5, '机械锚栓', 'M12*120', '颗', 8000.00, 1.09, 8720.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:54', '148', '2026-01-15 10:06:54', b'0', 0);
INSERT INTO `erp_order_item` VALUES (40, 5, '垫片', '30*30', '块', 50000.00, 0.11, 5500.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:54', '148', '2026-01-15 10:06:54', b'0', 0);
INSERT INTO `erp_order_item` VALUES (41, 5, '插芯', '50+100*4*200', '个', 600.00, 12.70, 7620.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:54', '148', '2026-01-15 10:06:54', b'0', 0);
INSERT INTO `erp_order_item` VALUES (42, 5, '304不锈钢螺栓', '12*120', '颗', 3300.00, 2.35, 7755.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:54', '148', '2026-01-15 10:06:54', b'0', 0);
INSERT INTO `erp_order_item` VALUES (43, 5, '彩钢围挡', '2米高*3.7米长', '米', 41.00, 46.00, 1886.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:54', '148', '2026-01-15 10:06:54', b'0', 0);
INSERT INTO `erp_order_item` VALUES (44, 5, '彩钢围挡柱', '/', '根', 1.00, 51.00, 51.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:06:54', '148', '2026-01-15 10:06:54', b'0', 0);
INSERT INTO `erp_order_item` VALUES (45, 6, '预埋件', '240+300*300*10', '块', 44.00, 55.00, 2420.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:10:13', '148', '2026-01-15 10:10:13', b'0', 0);
INSERT INTO `erp_order_item` VALUES (46, 6, '预埋件', '200+300*300*12', '块', 150.00, 98.00, 14700.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:10:13', '148', '2026-01-15 10:10:13', b'0', 0);
INSERT INTO `erp_order_item` VALUES (47, 6, '预埋件', '200+300*300*12', '块', 79.00, 92.00, 7268.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:10:13', '148', '2026-01-15 10:10:13', b'0', 0);
INSERT INTO `erp_order_item` VALUES (48, 6, '预埋件', '200+300*400*12', '颗', 1.00, 130.00, 130.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:10:13', '148', '2026-01-15 10:10:13', b'0', 0);
INSERT INTO `erp_order_item` VALUES (49, 6, '灭火器', '30', '个', 4.00, 40.00, 160.00, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '148', '2026-01-15 10:10:13', '148', '2026-01-15 10:10:13', b'0', 0);

-- ----------------------------
-- Table structure for erp_payment
-- ----------------------------
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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP付款单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of erp_payment
-- ----------------------------
INSERT INTO `erp_payment` VALUES (1, 'PAY202601158416', 1, 1, 1, 30842.32, 1, '', '2026-01-16', NULL, NULL, NULL, 0, NULL, '1', '2026-01-15 10:07:36', '1', '2026-01-15 10:07:36', b'0', 1);
INSERT INTO `erp_payment` VALUES (2, 'PAY202601151584', 2, 1, 1, 90308.42, 1, '', '2026-01-31', NULL, NULL, NULL, 0, NULL, '1', '2026-01-15 10:07:36', '1', '2026-01-15 10:07:36', b'0', 1);
INSERT INTO `erp_payment` VALUES (3, 'PAY202601154624', 4, 1, 1, 6568.80, 1, '', '2026-01-31', NULL, NULL, NULL, 0, NULL, '1', '2026-01-15 10:07:36', '1', '2026-01-15 10:07:36', b'0', 1);

-- ----------------------------
-- Table structure for erp_payment_plan
-- ----------------------------
DROP TABLE IF EXISTS `erp_payment_plan`;
CREATE TABLE `erp_payment_plan`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '计划编号',
  `plan_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '计划单号',
  `payment_id` bigint NOT NULL COMMENT '付款单编号',
  `payment_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '付款单号',
  `supplier_id` bigint NOT NULL COMMENT '供应商编号',
  `order_id` bigint NULL DEFAULT NULL COMMENT '订单ID',
  `config_id` bigint NULL DEFAULT NULL COMMENT '配置编号',
  `stage` int NOT NULL COMMENT '期数',
  `plan_amount` decimal(12, 2) NOT NULL COMMENT '计划付款金额',
  `plan_date` date NOT NULL COMMENT '计划付款日期',
  `actual_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实际付款金额',
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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP付款计划表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of erp_payment_plan
-- ----------------------------
INSERT INTO `erp_payment_plan` VALUES (1, 'PP2011621253569388544', 1, 'PAY202601158416', 1, 1, NULL, 1, 30842.32, '2026-01-16', 0.00, NULL, 0, 0, NULL, '1', '2026-01-15 10:07:36', '1', '2026-01-15 10:07:36', b'0', 1);
INSERT INTO `erp_payment_plan` VALUES (2, 'PP2011621253619720192', 2, 'PAY202601151584', 2, 1, NULL, 1, 90308.42, '2026-01-31', 0.00, NULL, 0, 0, NULL, '1', '2026-01-15 10:07:36', '1', '2026-01-15 10:07:36', b'0', 1);
INSERT INTO `erp_payment_plan` VALUES (3, 'PP2011621253657468928', 3, 'PAY202601154624', 4, 1, NULL, 1, 6568.80, '2026-01-31', 0.00, NULL, 0, 0, NULL, '1', '2026-01-15 10:07:36', '1', '2026-01-15 10:07:36', b'0', 1);

-- ----------------------------
-- Table structure for erp_payment_term_config
-- ----------------------------
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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP采购账期分期配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of erp_payment_term_config
-- ----------------------------

-- ----------------------------
-- Table structure for erp_supplier
-- ----------------------------
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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ERP供应商表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of erp_supplier
-- ----------------------------
INSERT INTO `erp_supplier` VALUES (1, '四川众鑫', '', '陶平', '13408406884', '', '', '', '', '', '', 0, 0, 0, '', '1', '2026-01-15 09:48:17', '1', '2026-01-15 09:48:17', b'0', 1);
INSERT INTO `erp_supplier` VALUES (2, '雄华', '', '胡兰', '', '', '', '', '', '', '', 0, 0, 0, '', '1', '2026-01-15 09:48:48', '1', '2026-01-15 09:48:48', b'0', 1);
INSERT INTO `erp_supplier` VALUES (3, '扬泰加工', '', '李小钰', '', '', '', '', '', '', '', 0, 0, 0, '', '1', '2026-01-15 09:51:10', '1', '2026-01-15 09:51:23', b'0', 1);
INSERT INTO `erp_supplier` VALUES (4, '蜀旺', '', '旺旺', '', '', '', '', '', '', '', 0, 0, 0, '', '1', '2026-01-15 09:52:22', '1', '2026-01-15 09:52:22', b'0', 1);

-- ----------------------------
-- Table structure for infra_api_access_log
-- ----------------------------
DROP TABLE IF EXISTS `infra_api_access_log`;
CREATE TABLE `infra_api_access_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `trace_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '链路追踪编号',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '用户编号',
  `user_type` tinyint NOT NULL DEFAULT 0 COMMENT '用户类型',
  `application_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用名',
  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求方法名',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求地址',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '请求参数',
  `response_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '响应结果',
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户 IP',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '浏览器 UA',
  `operate_module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作模块',
  `operate_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作名',
  `operate_type` tinyint NULL DEFAULT 0 COMMENT '操作分类',
  `begin_time` datetime NOT NULL COMMENT '开始请求时间',
  `end_time` datetime NOT NULL COMMENT '结束请求时间',
  `duration` int NOT NULL COMMENT '执行时长',
  `result_code` int NOT NULL DEFAULT 0 COMMENT '结果码',
  `result_msg` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '结果提示',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'API 访问日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_api_access_log
-- ----------------------------

-- ----------------------------
-- Table structure for infra_api_error_log
-- ----------------------------
DROP TABLE IF EXISTS `infra_api_error_log`;
CREATE TABLE `infra_api_error_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `trace_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '链路追踪编号',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '用户编号',
  `user_type` tinyint NOT NULL DEFAULT 0 COMMENT '用户类型',
  `application_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用名',
  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求方法名',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求地址',
  `request_params` varchar(8000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求参数',
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户 IP',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '浏览器 UA',
  `exception_time` datetime NOT NULL COMMENT '异常发生时间',
  `exception_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '异常名',
  `exception_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '异常导致的消息',
  `exception_root_cause_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '异常导致的根消息',
  `exception_stack_trace` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '异常的栈轨迹',
  `exception_class_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '异常发生的类全名',
  `exception_file_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '异常发生的类文件',
  `exception_method_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '异常发生的方法名',
  `exception_line_number` int NOT NULL COMMENT '异常发生的方法所在行',
  `process_status` tinyint NOT NULL COMMENT '处理状态',
  `process_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `process_user_id` int NULL DEFAULT 0 COMMENT '处理用户编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23216 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统异常日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_api_error_log
-- ----------------------------

-- ----------------------------
-- Table structure for infra_codegen_column
-- ----------------------------
DROP TABLE IF EXISTS `infra_codegen_column`;
CREATE TABLE `infra_codegen_column`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NOT NULL COMMENT '表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字段名',
  `data_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字段类型',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字段描述',
  `nullable` bit(1) NOT NULL COMMENT '是否允许为空',
  `primary_key` bit(1) NOT NULL COMMENT '是否主键',
  `ordinal_position` int NOT NULL COMMENT '排序',
  `java_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Java 属性类型',
  `java_field` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Java 属性名',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `example` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '数据示例',
  `create_operation` bit(1) NOT NULL COMMENT '是否为 Create 创建操作的字段',
  `update_operation` bit(1) NOT NULL COMMENT '是否为 Update 更新操作的字段',
  `list_operation` bit(1) NOT NULL COMMENT '是否为 List 查询操作的字段',
  `list_operation_condition` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '=' COMMENT 'List 查询操作的条件类型',
  `list_operation_result` bit(1) NOT NULL COMMENT '是否为 List 查询操作的返回字段',
  `html_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '显示类型',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码生成表字段定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_codegen_column
-- ----------------------------

-- ----------------------------
-- Table structure for infra_codegen_table
-- ----------------------------
DROP TABLE IF EXISTS `infra_codegen_table`;
CREATE TABLE `infra_codegen_table`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `data_source_config_id` bigint NOT NULL COMMENT '数据源配置的编号',
  `scene` tinyint NOT NULL DEFAULT 1 COMMENT '生成场景',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '表描述',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '类名称',
  `class_comment` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类描述',
  `author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '作者',
  `template_type` tinyint NOT NULL DEFAULT 1 COMMENT '模板类型',
  `front_type` tinyint NOT NULL COMMENT '前端类型',
  `parent_menu_id` bigint NULL DEFAULT NULL COMMENT '父菜单编号',
  `master_table_id` bigint NULL DEFAULT NULL COMMENT '主表的编号',
  `sub_join_column_id` bigint NULL DEFAULT NULL COMMENT '子表关联主表的字段编号',
  `sub_join_many` bit(1) NULL DEFAULT NULL COMMENT '主表与子表是否一对多',
  `tree_parent_column_id` bigint NULL DEFAULT NULL COMMENT '树表的父字段编号',
  `tree_name_column_id` bigint NULL DEFAULT NULL COMMENT '树表的名字字段编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码生成表定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_codegen_table
-- ----------------------------

-- ----------------------------
-- Table structure for infra_config
-- ----------------------------
DROP TABLE IF EXISTS `infra_config`;
CREATE TABLE `infra_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '参数分组',
  `type` tinyint NOT NULL COMMENT '参数类型',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '参数键名',
  `value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '参数键值',
  `visible` bit(1) NOT NULL COMMENT '是否可见',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_config
-- ----------------------------
INSERT INTO `infra_config` VALUES (2, 'biz', 1, '用户管理-账号初始密码', 'system.user.init-password', '123456', b'0', '初始化密码 123456', 'admin', '2021-01-05 17:03:48', '1', '2024-07-20 17:22:47', b'0');
INSERT INTO `infra_config` VALUES (7, 'url', 2, 'MySQL 监控的地址', 'url.druid', '', b'1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:33:38', b'0');
INSERT INTO `infra_config` VALUES (8, 'url', 2, 'SkyWalking 监控的地址', 'url.skywalking', '', b'1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:57:03', b'0');
INSERT INTO `infra_config` VALUES (9, 'url', 2, 'Spring Boot Admin 监控的地址', 'url.spring-boot-admin', '', b'1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:52:07', b'0');
INSERT INTO `infra_config` VALUES (10, 'url', 2, 'Swagger 接口文档的地址', 'url.swagger', '', b'1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:59:00', b'0');
INSERT INTO `infra_config` VALUES (11, 'ui', 2, '腾讯地图 key', 'tencent.lbs.key', 'TVDBZ-TDILD-4ON4B-PFDZA-RNLKH-VVF6E', b'1', '腾讯地图 key', '1', '2023-06-03 19:16:27', '1', '2023-06-03 19:16:27', b'0');
INSERT INTO `infra_config` VALUES (12, 'test2', 2, 'test3', 'test4', 'test5', b'1', 'test6', '1', '2023-12-03 09:55:16', '1', '2025-04-06 21:00:09', b'0');
INSERT INTO `infra_config` VALUES (13, '用户管理-账号初始密码', 2, '用户管理-注册开关', 'system.user.register-enabled', 'true', b'0', '', '1', '2025-04-26 17:23:41', '1', '2025-04-26 17:23:41', b'0');

-- ----------------------------
-- Table structure for infra_data_source_config
-- ----------------------------
DROP TABLE IF EXISTS `infra_data_source_config`;
CREATE TABLE `infra_data_source_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '参数名称',
  `url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '数据源连接',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '数据源配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_data_source_config
-- ----------------------------

-- ----------------------------
-- Table structure for infra_file
-- ----------------------------
DROP TABLE IF EXISTS `infra_file`;
CREATE TABLE `infra_file`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文件编号',
  `config_id` bigint NULL DEFAULT NULL COMMENT '配置编号',
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件名',
  `path` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路径',
  `url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件 URL',
  `type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件类型',
  `size` int NOT NULL COMMENT '文件大小',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2151 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_file
-- ----------------------------
INSERT INTO `infra_file` VALUES (2142, 22, 'blob.png', '20260112/blob_1768197924792.png', 'http://test.yudao.iocoder.cn/20260112/blob_1768197924792.png', 'image/png', 535461, '1', '2026-01-12 14:05:28', '1', '2026-01-12 14:05:28', b'0');
INSERT INTO `infra_file` VALUES (2143, 22, 'blob.png', '20260114/blob_1768359018014.png', 'http://test.yudao.iocoder.cn/20260114/blob_1768359018014.png', 'image/png', 525803, '1', '2026-01-14 10:50:21', '1', '2026-01-14 10:50:21', b'0');
INSERT INTO `infra_file` VALUES (2144, 22, 'blob.png', '20260114/blob_1768359035604.png', 'http://test.yudao.iocoder.cn/20260114/blob_1768359035604.png', 'image/png', 587647, '1', '2026-01-14 10:50:36', '1', '2026-01-14 10:50:36', b'0');
INSERT INTO `infra_file` VALUES (2145, 22, 'blob.png', '20260114/blob_1768359322897.png', 'http://test.yudao.iocoder.cn/20260114/blob_1768359322897.png', 'image/png', 599755, '1', '2026-01-14 10:55:24', '1', '2026-01-14 10:55:24', b'0');
INSERT INTO `infra_file` VALUES (2146, 22, 'blob.png', '20260114/blob_1768360316696.png', 'http://test.yudao.iocoder.cn/20260114/blob_1768360316696.png', 'image/png', 554491, '1', '2026-01-14 11:11:58', '1', '2026-01-14 11:11:58', b'0');
INSERT INTO `infra_file` VALUES (2147, 22, 'blob.png', '20260114/blob_1768390143460.png', 'http://test.yudao.iocoder.cn/20260114/blob_1768390143460.png', 'image/png', 539090, '1', '2026-01-14 19:29:07', '1', '2026-01-14 19:29:07', b'0');
INSERT INTO `infra_file` VALUES (2148, 22, 'blob.png', '20260114/blob_1768390164104.png', 'http://test.yudao.iocoder.cn/20260114/blob_1768390164104.png', 'image/png', 531710, '1', '2026-01-14 19:29:25', '1', '2026-01-14 19:29:25', b'0');
INSERT INTO `infra_file` VALUES (2149, 22, 'blob.png', '20260114/blob_1768390454621.png', 'http://test.yudao.iocoder.cn/20260114/blob_1768390454621.png', 'image/png', 536137, '1', '2026-01-14 19:34:16', '1', '2026-01-14 19:34:16', b'0');
INSERT INTO `infra_file` VALUES (2150, 29, 'blob.png', '20260114/blob_1768390905397.png', 'http://8.156.76.187:48080/admin-api/infra/file/29/get/20260114/blob_1768390905397.png', 'image/png', 545416, '1', '2026-01-14 19:41:46', '1', '2026-01-14 19:41:46', b'0');

-- ----------------------------
-- Table structure for infra_file_config
-- ----------------------------
DROP TABLE IF EXISTS `infra_file_config`;
CREATE TABLE `infra_file_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置名',
  `storage` tinyint NOT NULL COMMENT '存储器',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `master` bit(1) NOT NULL COMMENT '是否为主配置',
  `config` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '存储配置',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文件配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_file_config
-- ----------------------------
INSERT INTO `infra_file_config` VALUES (4, '数据库（示例）', 1, '我是数据库', b'0', '{\"@class\":\"cn.iocoder.yudao.module.infra.framework.file.core.client.db.DBFileClientConfig\",\"domain\":\"http://127.0.0.1:48080\"}', '1', '2022-03-15 23:56:24', '1', '2025-11-24 20:57:14', b'0');
INSERT INTO `infra_file_config` VALUES (22, '七牛存储器（示例）', 20, '请换成你自己的密钥！！！', b'0', '{\"@class\":\"cn.iocoder.yudao.module.infra.framework.file.core.client.s3.S3FileClientConfig\",\"endpoint\":\"s3.cn-south-1.qiniucs.com\",\"domain\":\"http://test.yudao.iocoder.cn\",\"bucket\":\"ruoyi-vue-pro\",\"accessKey\":\"3TvrJ70gl2Gt6IBe7_IZT1F6i_k0iMuRtyEv4EyS\",\"accessSecret\":\"wd0tbVBYlp0S-ihA8Qg2hPLncoP83wyrIq24OZuY\",\"enablePathStyleAccess\":false,\"enablePublicAccess\":true}', '1', '2024-01-13 22:11:12', '1', '2026-01-14 11:33:02', b'0');
INSERT INTO `infra_file_config` VALUES (24, '腾讯云存储（示例）', 20, '请换成你的密钥！！！', b'0', '{\"@class\":\"cn.iocoder.yudao.module.infra.framework.file.core.client.s3.S3FileClientConfig\",\"endpoint\":\"https://cos.ap-shanghai.myqcloud.com\",\"domain\":\"http://tengxun-oss.iocoder.cn\",\"bucket\":\"aoteman-1255880240\",\"accessKey\":\"AKIDAF6WSh1uiIjwqtrOsGSN3WryqTM6cTMt\",\"accessSecret\":\"X\",\"enablePathStyleAccess\":false,\"enablePublicAccess\":true}', '1', '2024-11-09 16:03:22', '1', '2025-11-24 20:57:14', b'0');
INSERT INTO `infra_file_config` VALUES (25, '阿里云存储（示例）', 20, '', b'0', '{\"@class\":\"cn.iocoder.yudao.module.infra.framework.file.core.client.s3.S3FileClientConfig\",\"endpoint\":\"oss-cn-beijing.aliyuncs.com\",\"domain\":\"http://ali-oss.iocoder.cn\",\"bucket\":\"yunai-aoteman\",\"accessKey\":\"LTAI5tEQLgnDyjh3WpNcdMKA\",\"accessSecret\":\"X\",\"enablePathStyleAccess\":false,\"enablePublicAccess\":true}', '1', '2024-11-09 16:47:08', '1', '2025-11-24 20:57:14', b'0');
INSERT INTO `infra_file_config` VALUES (26, '火山云存储（示例）', 20, '', b'0', '{\"@class\":\"cn.iocoder.yudao.module.infra.framework.file.core.client.s3.S3FileClientConfig\",\"endpoint\":\"tos-s3-cn-beijing.volces.com\",\"domain\":null,\"bucket\":\"yunai\",\"accessKey\":\"AKLTZjc3Zjc4MzZmMjU3NDk0ZTgxYmIyMmFkNTIwMDI1ZGE\",\"accessSecret\":\"X==\",\"enablePathStyleAccess\":false,\"enablePublicAccess\":true}', '1', '2024-11-09 16:56:42', '1', '2025-11-24 20:57:14', b'0');
INSERT INTO `infra_file_config` VALUES (27, '华为云存储（示例）', 20, '', b'0', '{\"@class\":\"cn.iocoder.yudao.module.infra.framework.file.core.client.s3.S3FileClientConfig\",\"endpoint\":\"obs.cn-east-3.myhuaweicloud.com\",\"domain\":\"\",\"bucket\":\"yudao\",\"accessKey\":\"PVDONDEIOTW88LF8DC4U\",\"accessSecret\":\"X\",\"enablePathStyleAccess\":false,\"enablePublicAccess\":true}', '1', '2024-11-09 17:18:41', '1', '2025-11-24 20:57:14', b'0');
INSERT INTO `infra_file_config` VALUES (28, 'MinIO 存储（示例）', 20, '', b'0', '{\"@class\":\"cn.iocoder.yudao.module.infra.framework.file.core.client.s3.S3FileClientConfig\",\"endpoint\":\"http://127.0.0.1:9000\",\"domain\":\"http://127.0.0.1:9000/yudao\",\"bucket\":\"yudao\",\"accessKey\":\"admin\",\"accessSecret\":\"password\",\"enablePathStyleAccess\":false,\"enablePublicAccess\":true}', '1', '2024-11-09 17:43:10', '1', '2025-11-24 20:57:14', b'0');
INSERT INTO `infra_file_config` VALUES (29, '本地存储（示例）', 10, 'mac/linux 使用 /，windows 使用 \\', b'1', '{\"@class\":\"cn.iocoder.yudao.module.infra.framework.file.core.client.local.LocalFileClientConfig\",\"basePath\":\"/app/files\",\"domain\":\"http://8.156.76.187:48080\"}', '1', '2025-05-02 11:25:45', '1', '2026-01-14 11:33:03', b'0');
INSERT INTO `infra_file_config` VALUES (30, 'SFTP 存储（示例）', 12, '', b'0', '{\"@class\":\"cn.iocoder.yudao.module.infra.framework.file.core.client.sftp.SftpFileClientConfig\",\"basePath\":\"/upload\",\"domain\":\"http://127.0.0.1:48080\",\"host\":\"127.0.0.1\",\"port\":2222,\"username\":\"foo\",\"password\":\"pass\"}', '1', '2025-05-02 16:34:10', '1', '2025-11-24 20:57:14', b'0');
INSERT INTO `infra_file_config` VALUES (34, '七牛云存储【私有】（示例）', 20, '请换成你自己的密钥！！！', b'0', '{\"@class\":\"cn.iocoder.yudao.module.infra.framework.file.core.client.s3.S3FileClientConfig\",\"endpoint\":\"s3.cn-south-1.qiniucs.com\",\"domain\":\"http://t151glocd.hn-bkt.clouddn.com\",\"bucket\":\"ruoyi-vue-pro-private\",\"accessKey\":\"3TvrJ70gl2Gt6IBe7_IZT1F6i_k0iMuRtyEv4EyS\",\"accessSecret\":\"wd0tbVBYlp0S-ihA8Qg2hPLncoP83wyrIq24OZuY\",\"enablePathStyleAccess\":false,\"enablePublicAccess\":false}', '1', '2025-08-17 21:22:00', '1', '2025-11-24 20:57:14', b'0');
INSERT INTO `infra_file_config` VALUES (35, '1', 20, '1', b'0', '{\"@class\":\"cn.iocoder.yudao.module.infra.framework.file.core.client.s3.S3FileClientConfig\",\"endpoint\":\"http://www.baidu.com\",\"domain\":\"http://www.xxx.com\",\"bucket\":\"1\",\"accessKey\":\"2\",\"accessSecret\":\"3\",\"enablePathStyleAccess\":false,\"enablePublicAccess\":false}', '1', '2025-10-02 14:32:12', '1', '2025-11-24 20:57:14', b'0');

-- ----------------------------
-- Table structure for infra_file_content
-- ----------------------------
DROP TABLE IF EXISTS `infra_file_content`;
CREATE TABLE `infra_file_content`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `config_id` bigint NOT NULL COMMENT '配置编号',
  `path` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路径',
  `content` mediumblob NOT NULL COMMENT '文件内容',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_file_content
-- ----------------------------

-- ----------------------------
-- Table structure for infra_job
-- ----------------------------
DROP TABLE IF EXISTS `infra_job`;
CREATE TABLE `infra_job`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务编号',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `status` tinyint NOT NULL COMMENT '任务状态',
  `handler_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '处理器的名字',
  `handler_param` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '处理器的参数',
  `cron_expression` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'CRON 表达式',
  `retry_count` int NOT NULL DEFAULT 0 COMMENT '重试次数',
  `retry_interval` int NOT NULL DEFAULT 0 COMMENT '重试间隔',
  `monitor_timeout` int NOT NULL DEFAULT 0 COMMENT '监控超时时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_job
-- ----------------------------
INSERT INTO `infra_job` VALUES (5, '支付通知 Job', 2, 'payNotifyJob', NULL, '* * * * * ?', 0, 0, 0, '1', '2021-10-27 08:34:42', '1', '2024-09-12 13:32:48', b'0');
INSERT INTO `infra_job` VALUES (17, '支付订单同步 Job', 2, 'payOrderSyncJob', NULL, '0 0/1 * * * ?', 0, 0, 0, '1', '2023-07-22 14:36:26', '1', '2023-07-22 15:39:08', b'0');
INSERT INTO `infra_job` VALUES (18, '支付订单过期 Job', 2, 'payOrderExpireJob', NULL, '0 0/1 * * * ?', 0, 0, 0, '1', '2023-07-22 15:36:23', '1', '2023-07-22 15:39:54', b'0');
INSERT INTO `infra_job` VALUES (19, '退款订单的同步 Job', 2, 'payRefundSyncJob', NULL, '0 0/1 * * * ?', 0, 0, 0, '1', '2023-07-23 21:03:44', '1', '2023-07-23 21:09:00', b'0');
INSERT INTO `infra_job` VALUES (21, 'Mall 交易订单的自动过期 Job', 2, 'tradeOrderAutoCancelJob', '', '0 * * * * ?', 3, 0, 0, '1', '2023-09-25 23:43:26', '1', '2025-10-02 11:08:34', b'0');
INSERT INTO `infra_job` VALUES (22, 'Mall 交易订单的自动收货 Job', 2, 'tradeOrderAutoReceiveJob', '', '0 * * * * ?', 3, 0, 0, '1', '2023-09-26 19:23:53', '1', '2025-10-02 11:08:36', b'0');
INSERT INTO `infra_job` VALUES (23, 'Mall 交易订单的自动评论 Job', 2, 'tradeOrderAutoCommentJob', '', '0 * * * * ?', 3, 0, 0, '1', '2023-09-26 23:38:29', '1', '2025-10-02 11:08:38', b'0');
INSERT INTO `infra_job` VALUES (24, 'Mall 佣金解冻 Job', 2, 'brokerageRecordUnfreezeJob', '', '0 * * * * ?', 3, 0, 0, '1', '2023-09-28 22:01:46', '1', '2025-10-02 11:08:04', b'0');
INSERT INTO `infra_job` VALUES (25, '访问日志清理 Job', 2, 'accessLogCleanJob', '', '0 0 0 * * ?', 3, 0, 0, '1', '2023-10-03 10:59:41', '1', '2023-10-03 11:01:10', b'0');
INSERT INTO `infra_job` VALUES (26, '错误日志清理 Job', 2, 'errorLogCleanJob', '', '0 0 0 * * ?', 3, 0, 0, '1', '2023-10-03 11:00:43', '1', '2023-10-03 11:01:12', b'0');
INSERT INTO `infra_job` VALUES (27, '任务日志清理 Job', 2, 'jobLogCleanJob', '', '0 0 0 * * ?', 3, 0, 0, '1', '2023-10-03 11:01:33', '1', '2024-09-12 13:40:34', b'0');
INSERT INTO `infra_job` VALUES (33, 'demoJob', 2, 'demoJob', '', '0 * * * * ?', 1, 1, 0, '1', '2024-10-27 19:38:46', '1', '2025-05-10 18:13:54', b'0');
INSERT INTO `infra_job` VALUES (35, '转账订单的同步 Job', 2, 'payTransferSyncJob', '', '0 * * * * ?', 0, 0, 0, '1', '2025-05-10 17:35:54', '1', '2025-05-10 18:13:52', b'0');
INSERT INTO `infra_job` VALUES (36, 'IoT 设备离线检查 Job', 2, 'iotDeviceOfflineCheckJob', '', '0 * * * * ?', 0, 0, 0, '1', '2025-07-03 23:48:44', '\"1\"', '2025-07-03 23:48:47', b'0');
INSERT INTO `infra_job` VALUES (37, 'IoT OTA 升级推送 Job', 2, 'iotOtaUpgradeJob', '', '0 * * * * ?', 0, 0, 0, '1', '2025-07-03 23:49:07', '\"1\"', '2025-07-03 23:49:13', b'0');
INSERT INTO `infra_job` VALUES (38, 'Mall 拼团过期 Job', 2, 'combinationRecordExpireJob', '', '0 * * * * ?', 0, 0, 0, '1', '2025-10-02 11:07:11', '1', '2025-10-02 11:07:14', b'0');
INSERT INTO `infra_job` VALUES (39, 'Mall 优惠券过期 Job', 2, 'couponExpireJob', '', '0 * * * * ?', 0, 0, 0, '1', '2025-10-02 11:07:34', '1', '2025-10-02 11:07:37', b'0');
INSERT INTO `infra_job` VALUES (40, 'Mall 商品统计 Job', 2, 'productStatisticsJob', '', '0 0 0 * * ?', 0, 0, 0, '1', '2025-11-22 18:51:25', '1', '2025-11-22 18:56:21', b'0');

-- ----------------------------
-- Table structure for infra_job_log
-- ----------------------------
DROP TABLE IF EXISTS `infra_job_log`;
CREATE TABLE `infra_job_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号',
  `job_id` bigint NOT NULL COMMENT '任务编号',
  `handler_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '处理器的名字',
  `handler_param` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '处理器的参数',
  `execute_index` tinyint NOT NULL DEFAULT 1 COMMENT '第几次执行',
  `begin_time` datetime NOT NULL COMMENT '开始执行时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束执行时间',
  `duration` int NULL DEFAULT NULL COMMENT '执行时长',
  `status` tinyint NOT NULL COMMENT '任务状态',
  `result` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '结果数据',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for system_dept
-- ----------------------------
DROP TABLE IF EXISTS `system_dept`;
CREATE TABLE `system_dept`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '部门名称',
  `parent_id` bigint NOT NULL DEFAULT 0 COMMENT '父部门id',
  `sort` int NOT NULL DEFAULT 0 COMMENT '显示顺序',
  `leader_user_id` bigint NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` tinyint NOT NULL COMMENT '部门状态（0正常 1停用）',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 119 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_dept
-- ----------------------------
INSERT INTO `system_dept` VALUES (116, '尚泰铭成', 0, 0, 1, '13076027080', '', 0, '1', '2026-01-11 21:09:18', '1', '2026-01-14 20:17:33', b'0', 1);
INSERT INTO `system_dept` VALUES (117, '业务一部', 116, 0, 143, '', '', 0, '1', '2026-01-12 14:14:30', '1', '2026-01-14 20:17:15', b'1', 1);
INSERT INTO `system_dept` VALUES (118, '业务二部', 116, 0, 144, '', '', 0, '1', '2026-01-12 14:16:37', '1', '2026-01-14 20:17:17', b'1', 1);

-- ----------------------------
-- Table structure for system_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `system_dict_data`;
CREATE TABLE `system_dict_data`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `sort` int NOT NULL DEFAULT 0 COMMENT '字典排序',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典标签',
  `value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典类型',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态（0正常 1停用）',
  `color_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '颜色类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'css 样式',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3035 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_dict_data
-- ----------------------------
INSERT INTO `system_dict_data` VALUES (1, 1, '男', '1', 'system_user_sex', 0, 'default', 'A', '性别男', 'admin', '2021-01-05 17:03:48', '1', '2022-03-29 00:14:39', b'0');
INSERT INTO `system_dict_data` VALUES (2, 2, '女', '2', 'system_user_sex', 0, 'success', '', '性别女', 'admin', '2021-01-05 17:03:48', '1', '2023-11-15 23:30:37', b'0');
INSERT INTO `system_dict_data` VALUES (8, 1, '正常', '1', 'infra_job_status', 0, 'success', '', '正常状态', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 19:33:38', b'0');
INSERT INTO `system_dict_data` VALUES (9, 2, '暂停', '2', 'infra_job_status', 0, 'danger', '', '停用状态', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 19:33:45', b'0');
INSERT INTO `system_dict_data` VALUES (12, 1, '系统内置', '1', 'infra_config_type', 0, 'danger', '', '参数类型 - 系统内置', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 19:06:02', b'0');
INSERT INTO `system_dict_data` VALUES (13, 2, '自定义', '2', 'infra_config_type', 0, 'primary', '', '参数类型 - 自定义', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 19:06:07', b'0');
INSERT INTO `system_dict_data` VALUES (14, 1, '通知', '1', 'system_notice_type', 0, 'success', '', '通知', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 13:05:57', b'0');
INSERT INTO `system_dict_data` VALUES (15, 2, '公告', '2', 'system_notice_type', 0, 'info', '', '公告', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 13:06:01', b'0');
INSERT INTO `system_dict_data` VALUES (16, 0, '其它', '0', 'infra_operate_type', 0, 'default', '', '其它操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:19', b'0');
INSERT INTO `system_dict_data` VALUES (17, 1, '查询', '1', 'infra_operate_type', 0, 'info', '', '查询操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:20', b'0');
INSERT INTO `system_dict_data` VALUES (18, 2, '新增', '2', 'infra_operate_type', 0, 'primary', '', '新增操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:21', b'0');
INSERT INTO `system_dict_data` VALUES (19, 3, '修改', '3', 'infra_operate_type', 0, 'warning', '', '修改操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:22', b'0');
INSERT INTO `system_dict_data` VALUES (20, 4, '删除', '4', 'infra_operate_type', 0, 'danger', '', '删除操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:23', b'0');
INSERT INTO `system_dict_data` VALUES (22, 5, '导出', '5', 'infra_operate_type', 0, 'default', '', '导出操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:24', b'0');
INSERT INTO `system_dict_data` VALUES (23, 6, '导入', '6', 'infra_operate_type', 0, 'default', '', '导入操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:25', b'0');
INSERT INTO `system_dict_data` VALUES (27, 1, '开启', '0', 'common_status', 0, 'primary', '', '开启状态', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 08:00:39', b'0');
INSERT INTO `system_dict_data` VALUES (28, 2, '关闭', '1', 'common_status', 0, 'info', '', '关闭状态', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 08:00:44', b'0');
INSERT INTO `system_dict_data` VALUES (29, 1, '目录', '1', 'system_menu_type', 0, '', '', '目录', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:43:45', b'0');
INSERT INTO `system_dict_data` VALUES (30, 2, '菜单', '2', 'system_menu_type', 0, '', '', '菜单', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:43:41', b'0');
INSERT INTO `system_dict_data` VALUES (31, 3, '按钮', '3', 'system_menu_type', 0, '', '', '按钮', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:43:39', b'0');
INSERT INTO `system_dict_data` VALUES (32, 1, '内置', '1', 'system_role_type', 0, 'danger', '', '内置角色', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 13:02:08', b'0');
INSERT INTO `system_dict_data` VALUES (33, 2, '自定义', '2', 'system_role_type', 0, 'primary', '', '自定义角色', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 13:02:12', b'0');
INSERT INTO `system_dict_data` VALUES (34, 1, '全部数据权限', '1', 'system_data_scope', 0, '', '', '全部数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:17', b'0');
INSERT INTO `system_dict_data` VALUES (35, 2, '指定部门数据权限', '2', 'system_data_scope', 0, '', '', '指定部门数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:18', b'0');
INSERT INTO `system_dict_data` VALUES (36, 3, '本部门数据权限', '3', 'system_data_scope', 0, '', '', '本部门数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:16', b'0');
INSERT INTO `system_dict_data` VALUES (37, 4, '本部门及以下数据权限', '4', 'system_data_scope', 0, '', '', '本部门及以下数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:21', b'0');
INSERT INTO `system_dict_data` VALUES (38, 5, '仅本人数据权限', '5', 'system_data_scope', 0, '', '', '仅本人数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:23', b'0');
INSERT INTO `system_dict_data` VALUES (39, 0, '成功', '0', 'system_login_result', 0, 'success', '', '登陆结果 - 成功', '', '2021-01-18 06:17:36', '1', '2022-02-16 13:23:49', b'0');
INSERT INTO `system_dict_data` VALUES (40, 10, '账号或密码不正确', '10', 'system_login_result', 0, 'primary', '', '登陆结果 - 账号或密码不正确', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:24:27', b'0');
INSERT INTO `system_dict_data` VALUES (41, 20, '用户被禁用', '20', 'system_login_result', 0, 'warning', '', '登陆结果 - 用户被禁用', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:23:57', b'0');
INSERT INTO `system_dict_data` VALUES (42, 30, '验证码不存在', '30', 'system_login_result', 0, 'info', '', '登陆结果 - 验证码不存在', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:24:07', b'0');
INSERT INTO `system_dict_data` VALUES (43, 31, '验证码不正确', '31', 'system_login_result', 0, 'info', '', '登陆结果 - 验证码不正确', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:24:11', b'0');
INSERT INTO `system_dict_data` VALUES (44, 100, '未知异常', '100', 'system_login_result', 0, 'danger', '', '登陆结果 - 未知异常', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:24:23', b'0');
INSERT INTO `system_dict_data` VALUES (45, 1, '是', 'true', 'infra_boolean_string', 0, 'danger', '', 'Boolean 是否类型 - 是', '', '2021-01-19 03:20:55', '1', '2022-03-15 23:01:45', b'0');
INSERT INTO `system_dict_data` VALUES (46, 1, '否', 'false', 'infra_boolean_string', 0, 'info', '', 'Boolean 是否类型 - 否', '', '2021-01-19 03:20:55', '1', '2022-03-15 23:09:45', b'0');
INSERT INTO `system_dict_data` VALUES (50, 1, '单表（增删改查）', '1', 'infra_codegen_template_type', 0, '', '', NULL, '', '2021-02-05 07:09:06', '', '2022-03-10 16:33:15', b'0');
INSERT INTO `system_dict_data` VALUES (51, 2, '树表（增删改查）', '2', 'infra_codegen_template_type', 0, '', '', NULL, '', '2021-02-05 07:14:46', '', '2022-03-10 16:33:19', b'0');
INSERT INTO `system_dict_data` VALUES (53, 0, '初始化中', '0', 'infra_job_status', 0, 'primary', '', NULL, '', '2021-02-07 07:46:49', '1', '2022-02-16 19:33:29', b'0');
INSERT INTO `system_dict_data` VALUES (57, 0, '运行中', '0', 'infra_job_log_status', 0, 'primary', '', 'RUNNING', '', '2021-02-08 10:04:24', '1', '2022-02-16 19:07:48', b'0');
INSERT INTO `system_dict_data` VALUES (58, 1, '成功', '1', 'infra_job_log_status', 0, 'success', '', NULL, '', '2021-02-08 10:06:57', '1', '2022-02-16 19:07:52', b'0');
INSERT INTO `system_dict_data` VALUES (59, 2, '失败', '2', 'infra_job_log_status', 0, 'warning', '', '失败', '', '2021-02-08 10:07:38', '1', '2022-02-16 19:07:56', b'0');
INSERT INTO `system_dict_data` VALUES (60, 1, '会员', '1', 'user_type', 0, 'primary', '', NULL, '', '2021-02-26 00:16:27', '1', '2022-02-16 10:22:19', b'0');
INSERT INTO `system_dict_data` VALUES (61, 2, '管理员', '2', 'user_type', 0, 'success', '', NULL, '', '2021-02-26 00:16:34', '1', '2025-04-06 18:37:43', b'0');
INSERT INTO `system_dict_data` VALUES (62, 0, '未处理', '0', 'infra_api_error_log_process_status', 0, 'primary', '', NULL, '', '2021-02-26 07:07:19', '1', '2022-02-16 20:14:17', b'0');
INSERT INTO `system_dict_data` VALUES (63, 1, '已处理', '1', 'infra_api_error_log_process_status', 0, 'success', '', NULL, '', '2021-02-26 07:07:26', '1', '2022-02-16 20:14:08', b'0');
INSERT INTO `system_dict_data` VALUES (64, 2, '已忽略', '2', 'infra_api_error_log_process_status', 0, 'danger', '', NULL, '', '2021-02-26 07:07:34', '1', '2022-02-16 20:14:14', b'0');
INSERT INTO `system_dict_data` VALUES (66, 1, '阿里云', 'ALIYUN', 'system_sms_channel_code', 0, 'primary', '', NULL, '1', '2021-04-05 01:05:26', '1', '2024-07-22 22:23:25', b'0');
INSERT INTO `system_dict_data` VALUES (67, 1, '验证码', '1', 'system_sms_template_type', 0, 'warning', '', NULL, '1', '2021-04-05 21:50:57', '1', '2022-02-16 12:48:30', b'0');
INSERT INTO `system_dict_data` VALUES (68, 2, '通知', '2', 'system_sms_template_type', 0, 'primary', '', NULL, '1', '2021-04-05 21:51:08', '1', '2022-02-16 12:48:27', b'0');
INSERT INTO `system_dict_data` VALUES (69, 0, '营销', '3', 'system_sms_template_type', 0, 'danger', '', NULL, '1', '2021-04-05 21:51:15', '1', '2022-02-16 12:48:22', b'0');
INSERT INTO `system_dict_data` VALUES (70, 0, '初始化', '0', 'system_sms_send_status', 0, 'primary', '', NULL, '1', '2021-04-11 20:18:33', '1', '2022-02-16 10:26:07', b'0');
INSERT INTO `system_dict_data` VALUES (71, 1, '发送成功', '10', 'system_sms_send_status', 0, 'success', '', NULL, '1', '2021-04-11 20:18:43', '1', '2022-02-16 10:25:56', b'0');
INSERT INTO `system_dict_data` VALUES (72, 2, '发送失败', '20', 'system_sms_send_status', 0, 'danger', '', NULL, '1', '2021-04-11 20:18:49', '1', '2022-02-16 10:26:03', b'0');
INSERT INTO `system_dict_data` VALUES (73, 3, '不发送', '30', 'system_sms_send_status', 0, 'info', '', NULL, '1', '2021-04-11 20:19:44', '1', '2022-02-16 10:26:10', b'0');
INSERT INTO `system_dict_data` VALUES (74, 0, '等待结果', '0', 'system_sms_receive_status', 0, 'primary', '', NULL, '1', '2021-04-11 20:27:43', '1', '2022-02-16 10:28:24', b'0');
INSERT INTO `system_dict_data` VALUES (75, 1, '接收成功', '10', 'system_sms_receive_status', 0, 'success', '', NULL, '1', '2021-04-11 20:29:25', '1', '2022-02-16 10:28:28', b'0');
INSERT INTO `system_dict_data` VALUES (76, 2, '接收失败', '20', 'system_sms_receive_status', 0, 'danger', '', NULL, '1', '2021-04-11 20:29:31', '1', '2022-02-16 10:28:32', b'0');
INSERT INTO `system_dict_data` VALUES (77, 0, '调试(钉钉)', 'DEBUG_DING_TALK', 'system_sms_channel_code', 0, 'info', '', NULL, '1', '2021-04-13 00:20:37', '1', '2022-02-16 10:10:00', b'0');
INSERT INTO `system_dict_data` VALUES (80, 100, '账号登录', '100', 'system_login_type', 0, 'primary', '', '账号登录', '1', '2021-10-06 00:52:02', '1', '2022-02-16 13:11:34', b'0');
INSERT INTO `system_dict_data` VALUES (81, 101, '社交登录', '101', 'system_login_type', 0, 'info', '', '社交登录', '1', '2021-10-06 00:52:17', '1', '2022-02-16 13:11:40', b'0');
INSERT INTO `system_dict_data` VALUES (83, 200, '主动登出', '200', 'system_login_type', 0, 'primary', '', '主动登出', '1', '2021-10-06 00:52:58', '1', '2022-02-16 13:11:49', b'0');
INSERT INTO `system_dict_data` VALUES (85, 202, '强制登出', '202', 'system_login_type', 0, 'danger', '', '强制退出', '1', '2021-10-06 00:53:41', '1', '2022-02-16 13:11:57', b'0');
INSERT INTO `system_dict_data` VALUES (86, 0, '病假', '1', 'bpm_oa_leave_type', 0, 'primary', '', NULL, '1', '2021-09-21 22:35:28', '1', '2022-02-16 10:00:41', b'0');
INSERT INTO `system_dict_data` VALUES (87, 1, '事假', '2', 'bpm_oa_leave_type', 0, 'info', '', NULL, '1', '2021-09-21 22:36:11', '1', '2022-02-16 10:00:49', b'0');
INSERT INTO `system_dict_data` VALUES (88, 2, '婚假', '3', 'bpm_oa_leave_type', 0, 'warning', '', NULL, '1', '2021-09-21 22:36:38', '1', '2022-02-16 10:00:53', b'0');
INSERT INTO `system_dict_data` VALUES (112, 0, '微信 Wap 网站支付', 'wx_wap', 'pay_channel_code', 0, 'success', '', '微信 Wap 网站支付', '1', '2023-07-19 20:08:06', '1', '2023-07-19 20:09:08', b'0');
INSERT INTO `system_dict_data` VALUES (113, 1, '微信公众号支付', 'wx_pub', 'pay_channel_code', 0, 'success', '', '微信公众号支付', '1', '2021-12-03 10:40:24', '1', '2023-07-19 20:08:47', b'0');
INSERT INTO `system_dict_data` VALUES (114, 2, '微信小程序支付', 'wx_lite', 'pay_channel_code', 0, 'success', '', '微信小程序支付', '1', '2021-12-03 10:41:06', '1', '2023-07-19 20:08:50', b'0');
INSERT INTO `system_dict_data` VALUES (115, 3, '微信 App 支付', 'wx_app', 'pay_channel_code', 0, 'success', '', '微信 App 支付', '1', '2021-12-03 10:41:20', '1', '2023-07-19 20:08:56', b'0');
INSERT INTO `system_dict_data` VALUES (116, 10, '支付宝 PC 网站支付', 'alipay_pc', 'pay_channel_code', 0, 'primary', '', '支付宝 PC 网站支付', '1', '2021-12-03 10:42:09', '1', '2023-07-19 20:09:12', b'0');
INSERT INTO `system_dict_data` VALUES (117, 11, '支付宝 Wap 网站支付', 'alipay_wap', 'pay_channel_code', 0, 'primary', '', '支付宝 Wap 网站支付', '1', '2021-12-03 10:42:26', '1', '2023-07-19 20:09:16', b'0');
INSERT INTO `system_dict_data` VALUES (118, 12, '支付宝 App 支付', 'alipay_app', 'pay_channel_code', 0, 'primary', '', '支付宝 App 支付', '1', '2021-12-03 10:42:55', '1', '2023-07-19 20:09:20', b'0');
INSERT INTO `system_dict_data` VALUES (119, 14, '支付宝扫码支付', 'alipay_qr', 'pay_channel_code', 0, 'primary', '', '支付宝扫码支付', '1', '2021-12-03 10:43:10', '1', '2023-07-19 20:09:28', b'0');
INSERT INTO `system_dict_data` VALUES (120, 10, '通知成功', '10', 'pay_notify_status', 0, 'success', '', '通知成功', '1', '2021-12-03 11:02:41', '1', '2023-07-19 10:08:19', b'0');
INSERT INTO `system_dict_data` VALUES (121, 20, '通知失败', '20', 'pay_notify_status', 0, 'danger', '', '通知失败', '1', '2021-12-03 11:02:59', '1', '2023-07-19 10:08:21', b'0');
INSERT INTO `system_dict_data` VALUES (122, 0, '等待通知', '0', 'pay_notify_status', 0, 'info', '', '未通知', '1', '2021-12-03 11:03:10', '1', '2023-07-19 10:08:24', b'0');
INSERT INTO `system_dict_data` VALUES (123, 10, '支付成功', '10', 'pay_order_status', 0, 'success', '', '支付成功', '1', '2021-12-03 11:18:29', '1', '2023-07-19 18:04:28', b'0');
INSERT INTO `system_dict_data` VALUES (124, 30, '支付关闭', '30', 'pay_order_status', 0, 'info', '', '支付关闭', '1', '2021-12-03 11:18:42', '1', '2023-07-19 18:05:07', b'0');
INSERT INTO `system_dict_data` VALUES (125, 0, '等待支付', '0', 'pay_order_status', 0, 'info', '', '未支付', '1', '2021-12-03 11:18:18', '1', '2023-07-19 18:04:15', b'0');
INSERT INTO `system_dict_data` VALUES (600, 5, '首页', '1', 'promotion_banner_position', 0, 'warning', '', '', '1', '2023-10-11 07:45:24', '1', '2023-10-11 07:45:38', b'0');
INSERT INTO `system_dict_data` VALUES (601, 4, '秒杀活动页', '2', 'promotion_banner_position', 0, 'warning', '', '', '1', '2023-10-11 07:45:24', '1', '2023-10-11 07:45:38', b'0');
INSERT INTO `system_dict_data` VALUES (602, 3, '砍价活动页', '3', 'promotion_banner_position', 0, 'warning', '', '', '1', '2023-10-11 07:45:24', '1', '2023-10-11 07:45:38', b'0');
INSERT INTO `system_dict_data` VALUES (603, 2, '限时折扣页', '4', 'promotion_banner_position', 0, 'warning', '', '', '1', '2023-10-11 07:45:24', '1', '2023-10-11 07:45:38', b'0');
INSERT INTO `system_dict_data` VALUES (604, 1, '满减送页', '5', 'promotion_banner_position', 0, 'warning', '', '', '1', '2023-10-11 07:45:24', '1', '2023-10-11 07:45:38', b'0');
INSERT INTO `system_dict_data` VALUES (1118, 0, '等待退款', '0', 'pay_refund_status', 0, 'info', '', '等待退款', '1', '2021-12-10 16:44:59', '1', '2023-07-19 10:14:39', b'0');
INSERT INTO `system_dict_data` VALUES (1119, 20, '退款失败', '20', 'pay_refund_status', 0, 'danger', '', '退款失败', '1', '2021-12-10 16:45:10', '1', '2023-07-19 10:15:10', b'0');
INSERT INTO `system_dict_data` VALUES (1124, 10, '退款成功', '10', 'pay_refund_status', 0, 'success', '', '退款成功', '1', '2021-12-10 16:46:26', '1', '2023-07-19 10:15:00', b'0');
INSERT INTO `system_dict_data` VALUES (1127, 1, '审批中', '1', 'bpm_process_instance_status', 0, 'default', '', '流程实例的状态 - 进行中', '1', '2022-01-07 23:47:22', '1', '2024-03-16 16:11:45', b'0');
INSERT INTO `system_dict_data` VALUES (1128, 2, '审批通过', '2', 'bpm_process_instance_status', 0, 'success', '', '流程实例的状态 - 已完成', '1', '2022-01-07 23:47:49', '1', '2024-03-16 16:11:54', b'0');
INSERT INTO `system_dict_data` VALUES (1129, 1, '审批中', '1', 'bpm_task_status', 0, 'primary', '', '流程实例的结果 - 处理中', '1', '2022-01-07 23:48:32', '1', '2024-03-08 22:41:37', b'0');
INSERT INTO `system_dict_data` VALUES (1130, 2, '审批通过', '2', 'bpm_task_status', 0, 'success', '', '流程实例的结果 - 通过', '1', '2022-01-07 23:48:45', '1', '2024-03-08 22:41:38', b'0');
INSERT INTO `system_dict_data` VALUES (1131, 3, '审批不通过', '3', 'bpm_task_status', 0, 'danger', '', '流程实例的结果 - 不通过', '1', '2022-01-07 23:48:55', '1', '2024-03-08 22:41:38', b'0');
INSERT INTO `system_dict_data` VALUES (1132, 4, '已取消', '4', 'bpm_task_status', 0, 'info', '', '流程实例的结果 - 撤销', '1', '2022-01-07 23:49:06', '1', '2024-03-08 22:41:39', b'0');
INSERT INTO `system_dict_data` VALUES (1133, 10, '流程表单', '10', 'bpm_model_form_type', 0, '', '', '流程的表单类型 - 流程表单', '103', '2022-01-11 23:51:30', '103', '2022-01-11 23:51:30', b'0');
INSERT INTO `system_dict_data` VALUES (1134, 20, '业务表单', '20', 'bpm_model_form_type', 0, '', '', '流程的表单类型 - 业务表单', '103', '2022-01-11 23:51:47', '103', '2022-01-11 23:51:47', b'0');
INSERT INTO `system_dict_data` VALUES (1135, 10, '角色', '10', 'bpm_task_candidate_strategy', 0, 'info', '', '任务分配规则的类型 - 角色', '103', '2022-01-12 23:21:22', '1', '2024-03-06 02:53:16', b'0');
INSERT INTO `system_dict_data` VALUES (1136, 20, '部门的成员', '20', 'bpm_task_candidate_strategy', 0, 'primary', '', '任务分配规则的类型 - 部门的成员', '103', '2022-01-12 23:21:47', '1', '2024-03-06 02:53:17', b'0');
INSERT INTO `system_dict_data` VALUES (1137, 21, '部门的负责人', '21', 'bpm_task_candidate_strategy', 0, 'primary', '', '任务分配规则的类型 - 部门的负责人', '103', '2022-01-12 23:33:36', '1', '2024-03-06 02:53:18', b'0');
INSERT INTO `system_dict_data` VALUES (1138, 30, '用户', '30', 'bpm_task_candidate_strategy', 0, 'info', '', '任务分配规则的类型 - 用户', '103', '2022-01-12 23:34:02', '1', '2024-03-06 02:53:19', b'0');
INSERT INTO `system_dict_data` VALUES (1139, 40, '用户组', '40', 'bpm_task_candidate_strategy', 0, 'warning', '', '任务分配规则的类型 - 用户组', '103', '2022-01-12 23:34:21', '1', '2024-03-06 02:53:20', b'0');
INSERT INTO `system_dict_data` VALUES (1140, 60, '流程表达式', '60', 'bpm_task_candidate_strategy', 0, 'danger', '', '任务分配规则的类型 - 流程表达式', '103', '2022-01-12 23:34:43', '1', '2024-03-06 02:53:20', b'0');
INSERT INTO `system_dict_data` VALUES (1141, 22, '岗位', '22', 'bpm_task_candidate_strategy', 0, 'success', '', '任务分配规则的类型 - 岗位', '103', '2022-01-14 18:41:55', '1', '2024-03-06 02:53:21', b'0');
INSERT INTO `system_dict_data` VALUES (1145, 1, '管理后台', '1', 'infra_codegen_scene', 0, '', '', '代码生成的场景枚举 - 管理后台', '1', '2022-02-02 13:15:06', '1', '2022-03-10 16:32:59', b'0');
INSERT INTO `system_dict_data` VALUES (1146, 2, '用户 APP', '2', 'infra_codegen_scene', 0, '', '', '代码生成的场景枚举 - 用户 APP', '1', '2022-02-02 13:15:19', '1', '2022-03-10 16:33:03', b'0');
INSERT INTO `system_dict_data` VALUES (1150, 1, '数据库', '1', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:25:28', '1', '2022-03-15 00:25:28', b'0');
INSERT INTO `system_dict_data` VALUES (1151, 10, '本地磁盘', '10', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:25:41', '1', '2022-03-15 00:25:56', b'0');
INSERT INTO `system_dict_data` VALUES (1152, 11, 'FTP 服务器', '11', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:26:06', '1', '2022-03-15 00:26:10', b'0');
INSERT INTO `system_dict_data` VALUES (1153, 12, 'SFTP 服务器', '12', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:26:22', '1', '2022-03-15 00:26:22', b'0');
INSERT INTO `system_dict_data` VALUES (1154, 20, 'S3 对象存储', '20', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:26:31', '1', '2022-03-15 00:26:45', b'0');
INSERT INTO `system_dict_data` VALUES (1155, 103, '短信登录', '103', 'system_login_type', 0, 'default', '', NULL, '1', '2022-05-09 23:57:58', '1', '2022-05-09 23:58:09', b'0');
INSERT INTO `system_dict_data` VALUES (1156, 1, 'password', 'password', 'system_oauth2_grant_type', 0, 'default', '', '密码模式', '1', '2022-05-12 00:22:05', '1', '2022-05-11 16:26:01', b'0');
INSERT INTO `system_dict_data` VALUES (1157, 2, 'authorization_code', 'authorization_code', 'system_oauth2_grant_type', 0, 'primary', '', '授权码模式', '1', '2022-05-12 00:22:59', '1', '2022-05-11 16:26:02', b'0');
INSERT INTO `system_dict_data` VALUES (1158, 3, 'implicit', 'implicit', 'system_oauth2_grant_type', 0, 'success', '', '简化模式', '1', '2022-05-12 00:23:40', '1', '2022-05-11 16:26:05', b'0');
INSERT INTO `system_dict_data` VALUES (1159, 4, 'client_credentials', 'client_credentials', 'system_oauth2_grant_type', 0, 'default', '', '客户端模式', '1', '2022-05-12 00:23:51', '1', '2022-05-11 16:26:08', b'0');
INSERT INTO `system_dict_data` VALUES (1160, 5, 'refresh_token', 'refresh_token', 'system_oauth2_grant_type', 0, 'info', '', '刷新模式', '1', '2022-05-12 00:24:02', '1', '2022-05-11 16:26:11', b'0');
INSERT INTO `system_dict_data` VALUES (1162, 1, '销售中', '1', 'product_spu_status', 0, 'success', '', '商品 SPU 状态 - 销售中', '1', '2022-10-24 21:19:47', '1', '2022-10-24 21:20:38', b'0');
INSERT INTO `system_dict_data` VALUES (1163, 0, '仓库中', '0', 'product_spu_status', 0, 'info', '', '商品 SPU 状态 - 仓库中', '1', '2022-10-24 21:20:54', '1', '2022-10-24 21:21:22', b'0');
INSERT INTO `system_dict_data` VALUES (1164, 0, '回收站', '-1', 'product_spu_status', 0, 'default', '', '商品 SPU 状态 - 回收站', '1', '2022-10-24 21:21:11', '1', '2022-10-24 21:21:11', b'0');
INSERT INTO `system_dict_data` VALUES (1165, 1, '满减', '1', 'promotion_discount_type', 0, 'success', '', '优惠类型 - 满减', '1', '2022-11-01 12:46:41', '1', '2022-11-01 12:50:11', b'0');
INSERT INTO `system_dict_data` VALUES (1166, 2, '折扣', '2', 'promotion_discount_type', 0, 'primary', '', '优惠类型 - 折扣', '1', '2022-11-01 12:46:51', '1', '2022-11-01 12:50:08', b'0');
INSERT INTO `system_dict_data` VALUES (1167, 1, '固定日期', '1', 'promotion_coupon_template_validity_type', 0, 'default', '', '优惠劵模板的有限期类型 - 固定日期', '1', '2022-11-02 00:07:34', '1', '2022-11-04 00:07:49', b'0');
INSERT INTO `system_dict_data` VALUES (1168, 2, '领取之后', '2', 'promotion_coupon_template_validity_type', 0, 'default', '', '优惠劵模板的有限期类型 - 领取之后', '1', '2022-11-02 00:07:54', '1', '2022-11-04 00:07:52', b'0');
INSERT INTO `system_dict_data` VALUES (1169, 1, '通用劵', '1', 'promotion_product_scope', 0, 'default', '', '营销的商品范围 - 全部商品参与', '1', '2022-11-02 00:28:22', '1', '2023-09-28 00:27:42', b'0');
INSERT INTO `system_dict_data` VALUES (1170, 2, '商品劵', '2', 'promotion_product_scope', 0, 'default', '', '营销的商品范围 - 指定商品参与', '1', '2022-11-02 00:28:34', '1', '2023-09-28 00:27:44', b'0');
INSERT INTO `system_dict_data` VALUES (1171, 1, '未使用', '1', 'promotion_coupon_status', 0, 'primary', '', '优惠劵的状态 - 已领取', '1', '2022-11-04 00:15:08', '1', '2023-10-03 12:54:38', b'0');
INSERT INTO `system_dict_data` VALUES (1172, 2, '已使用', '2', 'promotion_coupon_status', 0, 'success', '', '优惠劵的状态 - 已使用', '1', '2022-11-04 00:15:21', '1', '2022-11-04 19:16:08', b'0');
INSERT INTO `system_dict_data` VALUES (1173, 3, '已过期', '3', 'promotion_coupon_status', 0, 'info', '', '优惠劵的状态 - 已过期', '1', '2022-11-04 00:15:43', '1', '2022-11-04 19:16:12', b'0');
INSERT INTO `system_dict_data` VALUES (1174, 1, '直接领取', '1', 'promotion_coupon_take_type', 0, 'primary', '', '优惠劵的领取方式 - 直接领取', '1', '2022-11-04 19:13:00', '1', '2022-11-04 19:13:25', b'0');
INSERT INTO `system_dict_data` VALUES (1175, 2, '指定发放', '2', 'promotion_coupon_take_type', 0, 'success', '', '优惠劵的领取方式 - 指定发放', '1', '2022-11-04 19:13:13', '1', '2022-11-04 19:14:48', b'0');
INSERT INTO `system_dict_data` VALUES (1176, 10, '未开始', '10', 'promotion_activity_status', 0, 'primary', '', '促销活动的状态枚举 - 未开始', '1', '2022-11-04 22:54:49', '1', '2022-11-04 22:55:53', b'0');
INSERT INTO `system_dict_data` VALUES (1177, 20, '进行中', '20', 'promotion_activity_status', 0, 'success', '', '促销活动的状态枚举 - 进行中', '1', '2022-11-04 22:55:06', '1', '2022-11-04 22:55:20', b'0');
INSERT INTO `system_dict_data` VALUES (1178, 30, '已结束', '30', 'promotion_activity_status', 0, 'info', '', '促销活动的状态枚举 - 已结束', '1', '2022-11-04 22:55:41', '1', '2022-11-04 22:55:41', b'0');
INSERT INTO `system_dict_data` VALUES (1179, 40, '已关闭', '40', 'promotion_activity_status', 0, 'warning', '', '促销活动的状态枚举 - 已关闭', '1', '2022-11-04 22:56:10', '1', '2022-11-04 22:56:18', b'0');
INSERT INTO `system_dict_data` VALUES (1180, 10, '满 N 元', '10', 'promotion_condition_type', 0, 'primary', '', '营销的条件类型 - 满 N 元', '1', '2022-11-04 22:59:45', '1', '2022-11-04 22:59:45', b'0');
INSERT INTO `system_dict_data` VALUES (1181, 20, '满 N 件', '20', 'promotion_condition_type', 0, 'success', '', '营销的条件类型 - 满 N 件', '1', '2022-11-04 23:00:02', '1', '2022-11-04 23:00:02', b'0');
INSERT INTO `system_dict_data` VALUES (1182, 10, '申请售后', '10', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 申请售后', '1', '2022-11-19 20:53:33', '1', '2022-11-19 20:54:42', b'0');
INSERT INTO `system_dict_data` VALUES (1183, 20, '商品待退货', '20', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 商品待退货', '1', '2022-11-19 20:54:36', '1', '2022-11-19 20:58:58', b'0');
INSERT INTO `system_dict_data` VALUES (1184, 30, '商家待收货', '30', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 商家待收货', '1', '2022-11-19 20:56:56', '1', '2022-11-19 20:59:20', b'0');
INSERT INTO `system_dict_data` VALUES (1185, 40, '等待退款', '40', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 等待退款', '1', '2022-11-19 20:59:54', '1', '2022-11-19 21:00:01', b'0');
INSERT INTO `system_dict_data` VALUES (1186, 50, '退款成功', '50', 'trade_after_sale_status', 0, 'default', '', '交易售后状态 - 退款成功', '1', '2022-11-19 21:00:33', '1', '2022-11-19 21:00:33', b'0');
INSERT INTO `system_dict_data` VALUES (1187, 61, '买家取消', '61', 'trade_after_sale_status', 0, 'info', '', '交易售后状态 - 买家取消', '1', '2022-11-19 21:01:29', '1', '2022-11-19 21:01:29', b'0');
INSERT INTO `system_dict_data` VALUES (1188, 62, '商家拒绝', '62', 'trade_after_sale_status', 0, 'info', '', '交易售后状态 - 商家拒绝', '1', '2022-11-19 21:02:17', '1', '2022-11-19 21:02:17', b'0');
INSERT INTO `system_dict_data` VALUES (1189, 63, '商家拒收货', '63', 'trade_after_sale_status', 0, 'info', '', '交易售后状态 - 商家拒收货', '1', '2022-11-19 21:02:37', '1', '2022-11-19 21:03:07', b'0');
INSERT INTO `system_dict_data` VALUES (1190, 10, '售中退款', '10', 'trade_after_sale_type', 0, 'success', '', '交易售后的类型 - 售中退款', '1', '2022-11-19 21:05:05', '1', '2022-11-19 21:38:23', b'0');
INSERT INTO `system_dict_data` VALUES (1191, 20, '售后退款', '20', 'trade_after_sale_type', 0, 'primary', '', '交易售后的类型 - 售后退款', '1', '2022-11-19 21:05:32', '1', '2022-11-19 21:38:32', b'0');
INSERT INTO `system_dict_data` VALUES (1192, 10, '仅退款', '10', 'trade_after_sale_way', 0, 'primary', '', '交易售后的方式 - 仅退款', '1', '2022-11-19 21:39:19', '1', '2022-11-19 21:39:19', b'0');
INSERT INTO `system_dict_data` VALUES (1193, 20, '退货退款', '20', 'trade_after_sale_way', 0, 'success', '', '交易售后的方式 - 退货退款', '1', '2022-11-19 21:39:38', '1', '2022-11-19 21:39:49', b'0');
INSERT INTO `system_dict_data` VALUES (1194, 10, '微信小程序', '10', 'terminal', 0, 'default', '', '终端 - 微信小程序', '1', '2022-12-10 10:51:11', '1', '2022-12-10 10:51:57', b'0');
INSERT INTO `system_dict_data` VALUES (1195, 20, 'H5 网页', '20', 'terminal', 0, 'default', '', '终端 - H5 网页', '1', '2022-12-10 10:51:30', '1', '2022-12-10 10:51:59', b'0');
INSERT INTO `system_dict_data` VALUES (1196, 11, '微信公众号', '11', 'terminal', 0, 'default', '', '终端 - 微信公众号', '1', '2022-12-10 10:54:16', '1', '2022-12-10 10:52:01', b'0');
INSERT INTO `system_dict_data` VALUES (1197, 31, '苹果 App', '31', 'terminal', 0, 'default', '', '终端 - 苹果 App', '1', '2022-12-10 10:54:42', '1', '2022-12-10 10:52:18', b'0');
INSERT INTO `system_dict_data` VALUES (1198, 32, '安卓 App', '32', 'terminal', 0, 'default', '', '终端 - 安卓 App', '1', '2022-12-10 10:55:02', '1', '2022-12-10 10:59:17', b'0');
INSERT INTO `system_dict_data` VALUES (1199, 0, '普通订单', '0', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 普通订单', '1', '2022-12-10 16:34:14', '1', '2022-12-10 16:34:14', b'0');
INSERT INTO `system_dict_data` VALUES (1200, 1, '秒杀订单', '1', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 秒杀订单', '1', '2022-12-10 16:34:26', '1', '2022-12-10 16:34:26', b'0');
INSERT INTO `system_dict_data` VALUES (1201, 2, '砍价订单', '2', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 拼团订单', '1', '2022-12-10 16:34:36', '1', '2024-09-07 14:18:39', b'0');
INSERT INTO `system_dict_data` VALUES (1202, 3, '拼团订单', '3', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 砍价订单', '1', '2022-12-10 16:34:48', '1', '2024-09-07 14:18:32', b'0');
INSERT INTO `system_dict_data` VALUES (1203, 0, '待支付', '0', 'trade_order_status', 0, 'default', '', '交易订单状态 - 待支付', '1', '2022-12-10 16:49:29', '1', '2022-12-10 16:49:29', b'0');
INSERT INTO `system_dict_data` VALUES (1204, 10, '待发货', '10', 'trade_order_status', 0, 'primary', '', '交易订单状态 - 待发货', '1', '2022-12-10 16:49:53', '1', '2022-12-10 16:51:17', b'0');
INSERT INTO `system_dict_data` VALUES (1205, 20, '已发货', '20', 'trade_order_status', 0, 'primary', '', '交易订单状态 - 已发货', '1', '2022-12-10 16:50:13', '1', '2022-12-10 16:51:31', b'0');
INSERT INTO `system_dict_data` VALUES (1206, 30, '已完成', '30', 'trade_order_status', 0, 'success', '', '交易订单状态 - 已完成', '1', '2022-12-10 16:50:30', '1', '2022-12-10 16:51:06', b'0');
INSERT INTO `system_dict_data` VALUES (1207, 40, '已取消', '40', 'trade_order_status', 0, 'danger', '', '交易订单状态 - 已取消', '1', '2022-12-10 16:50:50', '1', '2022-12-10 16:51:00', b'0');
INSERT INTO `system_dict_data` VALUES (1208, 0, '未售后', '0', 'trade_order_item_after_sale_status', 0, 'info', '', '交易订单项的售后状态 - 未售后', '1', '2022-12-10 20:58:42', '1', '2022-12-10 20:59:29', b'0');
INSERT INTO `system_dict_data` VALUES (1209, 10, '售后中', '10', 'trade_order_item_after_sale_status', 0, 'primary', '', '交易订单项的售后状态 - 售后中', '1', '2022-12-10 20:59:21', '1', '2024-07-21 17:01:24', b'0');
INSERT INTO `system_dict_data` VALUES (1210, 20, '已退款', '20', 'trade_order_item_after_sale_status', 0, 'success', '', '交易订单项的售后状态 - 已退款', '1', '2022-12-10 20:59:46', '1', '2024-07-21 17:01:35', b'0');
INSERT INTO `system_dict_data` VALUES (1211, 1, '完全匹配', '1', 'mp_auto_reply_request_match', 0, 'primary', '', '公众号自动回复的请求关键字匹配模式 - 完全匹配', '1', '2023-01-16 23:30:39', '1', '2023-01-16 23:31:00', b'0');
INSERT INTO `system_dict_data` VALUES (1212, 2, '半匹配', '2', 'mp_auto_reply_request_match', 0, 'success', '', '公众号自动回复的请求关键字匹配模式 - 半匹配', '1', '2023-01-16 23:30:55', '1', '2023-01-16 23:31:10', b'0');
INSERT INTO `system_dict_data` VALUES (1213, 1, '文本', 'text', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 文本', '1', '2023-01-17 22:17:32', '1', '2023-01-17 22:17:39', b'0');
INSERT INTO `system_dict_data` VALUES (1214, 2, '图片', 'image', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 图片', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:19:47', b'0');
INSERT INTO `system_dict_data` VALUES (1215, 3, '语音', 'voice', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 语音', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:20:08', b'0');
INSERT INTO `system_dict_data` VALUES (1216, 4, '视频', 'video', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 视频', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:21:08', b'0');
INSERT INTO `system_dict_data` VALUES (1217, 5, '小视频', 'shortvideo', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 小视频', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:19:59', b'0');
INSERT INTO `system_dict_data` VALUES (1218, 6, '图文', 'news', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 图文', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:22:54', b'0');
INSERT INTO `system_dict_data` VALUES (1219, 7, '音乐', 'music', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 音乐', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:22:54', b'0');
INSERT INTO `system_dict_data` VALUES (1220, 8, '地理位置', 'location', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 地理位置', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:23:51', b'0');
INSERT INTO `system_dict_data` VALUES (1221, 9, '链接', 'link', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 链接', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:24:49', b'0');
INSERT INTO `system_dict_data` VALUES (1222, 10, '事件', 'event', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 事件', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:24:49', b'0');
INSERT INTO `system_dict_data` VALUES (1223, 0, '初始化', '0', 'system_mail_send_status', 0, 'primary', '', '邮件发送状态 - 初始化\n', '1', '2023-01-26 09:53:49', '1', '2023-01-26 16:36:14', b'0');
INSERT INTO `system_dict_data` VALUES (1224, 10, '发送成功', '10', 'system_mail_send_status', 0, 'success', '', '邮件发送状态 - 发送成功', '1', '2023-01-26 09:54:28', '1', '2023-01-26 16:36:22', b'0');
INSERT INTO `system_dict_data` VALUES (1225, 20, '发送失败', '20', 'system_mail_send_status', 0, 'danger', '', '邮件发送状态 - 发送失败', '1', '2023-01-26 09:54:50', '1', '2023-01-26 16:36:26', b'0');
INSERT INTO `system_dict_data` VALUES (1226, 30, '不发送', '30', 'system_mail_send_status', 0, 'info', '', '邮件发送状态 -  不发送', '1', '2023-01-26 09:55:06', '1', '2023-01-26 16:36:36', b'0');
INSERT INTO `system_dict_data` VALUES (1227, 1, '通知公告', '1', 'system_notify_template_type', 0, 'primary', '', '站内信模版的类型 - 通知公告', '1', '2023-01-28 10:35:59', '1', '2023-01-28 10:35:59', b'0');
INSERT INTO `system_dict_data` VALUES (1228, 2, '系统消息', '2', 'system_notify_template_type', 0, 'success', '', '站内信模版的类型 - 系统消息', '1', '2023-01-28 10:36:20', '1', '2023-01-28 10:36:25', b'0');
INSERT INTO `system_dict_data` VALUES (1230, 13, '支付宝条码支付', 'alipay_bar', 'pay_channel_code', 0, 'primary', '', '支付宝条码支付', '1', '2023-02-18 23:32:24', '1', '2023-07-19 20:09:23', b'0');
INSERT INTO `system_dict_data` VALUES (1231, 10, 'Vue2 Element UI 标准模版', '10', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:03:55', '1', '2023-04-13 00:03:55', b'0');
INSERT INTO `system_dict_data` VALUES (1232, 20, 'Vue3 Element Plus 标准模版', '20', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:04:08', '1', '2023-04-13 00:04:08', b'0');
INSERT INTO `system_dict_data` VALUES (1234, 30, 'Vben2.0 Ant Design Schema 模版', '30', 'infra_codegen_front_type', 1, '', '', '', '1', '2023-04-13 00:04:26', '1', '2025-07-27 10:55:14', b'0');
INSERT INTO `system_dict_data` VALUES (1244, 0, '按件', '1', 'trade_delivery_express_charge_mode', 0, '', '', '', '1', '2023-05-21 22:46:40', '1', '2023-05-21 22:46:40', b'0');
INSERT INTO `system_dict_data` VALUES (1245, 1, '按重量', '2', 'trade_delivery_express_charge_mode', 0, '', '', '', '1', '2023-05-21 22:46:58', '1', '2023-05-21 22:46:58', b'0');
INSERT INTO `system_dict_data` VALUES (1246, 2, '按体积', '3', 'trade_delivery_express_charge_mode', 0, '', '', '', '1', '2023-05-21 22:47:18', '1', '2023-05-21 22:47:18', b'0');
INSERT INTO `system_dict_data` VALUES (1335, 11, '订单积分抵扣', '11', 'member_point_biz_type', 0, '', '', '', '1', '2023-06-10 12:15:27', '1', '2023-10-11 07:41:43', b'0');
INSERT INTO `system_dict_data` VALUES (1336, 1, '签到', '1', 'member_point_biz_type', 0, '', '', '', '1', '2023-06-10 12:15:48', '1', '2023-08-20 11:59:53', b'0');
INSERT INTO `system_dict_data` VALUES (1341, 20, '已退款', '20', 'pay_order_status', 0, 'danger', '', '已退款', '1', '2023-07-19 18:05:37', '1', '2023-07-19 18:05:37', b'0');
INSERT INTO `system_dict_data` VALUES (1342, 21, '请求成功，但是结果失败', '21', 'pay_notify_status', 0, 'warning', '', '请求成功，但是结果失败', '1', '2023-07-19 18:10:47', '1', '2023-07-19 18:11:38', b'0');
INSERT INTO `system_dict_data` VALUES (1343, 22, '请求失败', '22', 'pay_notify_status', 0, 'warning', '', NULL, '1', '2023-07-19 18:11:05', '1', '2023-07-19 18:11:27', b'0');
INSERT INTO `system_dict_data` VALUES (1344, 4, '微信扫码支付', 'wx_native', 'pay_channel_code', 0, 'success', '', '微信扫码支付', '1', '2023-07-19 20:07:47', '1', '2023-07-19 20:09:03', b'0');
INSERT INTO `system_dict_data` VALUES (1345, 5, '微信条码支付', 'wx_bar', 'pay_channel_code', 0, 'success', '', '微信条码支付\n', '1', '2023-07-19 20:08:06', '1', '2023-07-19 20:09:08', b'0');
INSERT INTO `system_dict_data` VALUES (1346, 1, '支付单', '1', 'pay_notify_type', 0, 'primary', '', '支付单', '1', '2023-07-20 12:23:17', '1', '2023-07-20 12:23:17', b'0');
INSERT INTO `system_dict_data` VALUES (1347, 2, '退款单', '2', 'pay_notify_type', 0, 'danger', '', NULL, '1', '2023-07-20 12:23:26', '1', '2023-07-20 12:23:26', b'0');
INSERT INTO `system_dict_data` VALUES (1348, 20, '模拟支付', 'mock', 'pay_channel_code', 0, 'default', '', '模拟支付', '1', '2023-07-29 11:10:51', '1', '2023-07-29 03:14:10', b'0');
INSERT INTO `system_dict_data` VALUES (1349, 12, '订单积分抵扣（整单取消）', '12', 'member_point_biz_type', 0, '', '', '', '1', '2023-08-20 12:00:03', '1', '2023-10-11 07:42:01', b'0');
INSERT INTO `system_dict_data` VALUES (1350, 0, '管理员调整', '0', 'member_experience_biz_type', 0, '', '', NULL, '', '2023-08-22 12:41:01', '', '2023-08-22 12:41:01', b'0');
INSERT INTO `system_dict_data` VALUES (1351, 1, '邀新奖励', '1', 'member_experience_biz_type', 0, '', '', NULL, '', '2023-08-22 12:41:01', '', '2023-08-22 12:41:01', b'0');
INSERT INTO `system_dict_data` VALUES (1352, 11, '下单奖励', '11', 'member_experience_biz_type', 0, 'success', '', NULL, '', '2023-08-22 12:41:01', '1', '2023-10-11 07:45:09', b'0');
INSERT INTO `system_dict_data` VALUES (1353, 12, '下单奖励（整单取消）', '12', 'member_experience_biz_type', 0, 'warning', '', NULL, '', '2023-08-22 12:41:01', '1', '2023-10-11 07:45:01', b'0');
INSERT INTO `system_dict_data` VALUES (1354, 4, '签到奖励', '4', 'member_experience_biz_type', 0, '', '', NULL, '', '2023-08-22 12:41:01', '', '2023-08-22 12:41:01', b'0');
INSERT INTO `system_dict_data` VALUES (1355, 5, '抽奖奖励', '5', 'member_experience_biz_type', 0, '', '', NULL, '', '2023-08-22 12:41:01', '', '2023-08-22 12:41:01', b'0');
INSERT INTO `system_dict_data` VALUES (1356, 1, '快递发货', '1', 'trade_delivery_type', 0, '', '', '', '1', '2023-08-23 00:04:55', '1', '2023-08-23 00:04:55', b'0');
INSERT INTO `system_dict_data` VALUES (1357, 2, '用户自提', '2', 'trade_delivery_type', 0, '', '', '', '1', '2023-08-23 00:05:05', '1', '2023-08-23 00:05:05', b'0');
INSERT INTO `system_dict_data` VALUES (1358, 3, '品类劵', '3', 'promotion_product_scope', 0, 'default', '', '', '1', '2023-09-01 23:43:07', '1', '2023-09-28 00:27:47', b'0');
INSERT INTO `system_dict_data` VALUES (1359, 1, '人人分销', '1', 'brokerage_enabled_condition', 0, '', '', '所有用户都可以分销', '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1360, 2, '指定分销', '2', 'brokerage_enabled_condition', 0, '', '', '仅可后台手动设置推广员', '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1361, 1, '首次绑定', '1', 'brokerage_bind_mode', 0, '', '', '只要用户没有推广人，随时都可以绑定推广关系', '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1362, 2, '注册绑定', '2', 'brokerage_bind_mode', 0, '', '', '仅新用户注册时才能绑定推广关系', '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1363, 3, '覆盖绑定', '3', 'brokerage_bind_mode', 0, '', '', '如果用户已经有推广人，推广人会被变更', '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1364, 1, '钱包', '1', 'brokerage_withdraw_type', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1365, 2, '银行卡', '2', 'brokerage_withdraw_type', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1366, 3, '微信收款码', '3', 'brokerage_withdraw_type', 0, '', '', '手动打款', '', '2023-09-28 02:46:05', '1', '2025-05-10 08:24:25', b'0');
INSERT INTO `system_dict_data` VALUES (1367, 4, '支付宝收款码', '4', 'brokerage_withdraw_type', 0, '', '', '手动打款', '', '2023-09-28 02:46:05', '1', '2025-05-10 08:24:37', b'0');
INSERT INTO `system_dict_data` VALUES (1368, 1, '订单返佣', '1', 'brokerage_record_biz_type', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1369, 2, '申请提现', '2', 'brokerage_record_biz_type', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1370, 3, '申请提现驳回', '3', 'brokerage_record_biz_type', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1371, 0, '待结算', '0', 'brokerage_record_status', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1372, 1, '已结算', '1', 'brokerage_record_status', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1373, 2, '已取消', '2', 'brokerage_record_status', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1374, 0, '审核中', '0', 'brokerage_withdraw_status', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1375, 10, '审核通过', '10', 'brokerage_withdraw_status', 0, 'success', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1376, 11, '提现成功', '11', 'brokerage_withdraw_status', 0, 'success', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1377, 20, '审核不通过', '20', 'brokerage_withdraw_status', 0, 'danger', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1378, 21, '提现失败', '21', 'brokerage_withdraw_status', 0, 'danger', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1379, 0, '工商银行', '0', 'brokerage_bank_name', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1380, 1, '建设银行', '1', 'brokerage_bank_name', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1381, 2, '农业银行', '2', 'brokerage_bank_name', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1382, 3, '中国银行', '3', 'brokerage_bank_name', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1383, 4, '交通银行', '4', 'brokerage_bank_name', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1384, 5, '招商银行', '5', 'brokerage_bank_name', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0');
INSERT INTO `system_dict_data` VALUES (1385, 21, '钱包', 'wallet', 'pay_channel_code', 0, 'primary', '', '', '1', '2023-10-01 21:46:19', '1', '2023-10-01 21:48:01', b'0');
INSERT INTO `system_dict_data` VALUES (1386, 1, '砍价中', '1', 'promotion_bargain_record_status', 0, 'default', '', '', '1', '2023-10-05 10:41:26', '1', '2023-10-05 10:41:26', b'0');
INSERT INTO `system_dict_data` VALUES (1387, 2, '砍价成功', '2', 'promotion_bargain_record_status', 0, 'success', '', '', '1', '2023-10-05 10:41:39', '1', '2023-10-05 10:41:39', b'0');
INSERT INTO `system_dict_data` VALUES (1388, 3, '砍价失败', '3', 'promotion_bargain_record_status', 0, 'warning', '', '', '1', '2023-10-05 10:41:57', '1', '2023-10-05 10:41:57', b'0');
INSERT INTO `system_dict_data` VALUES (1389, 0, '拼团中', '0', 'promotion_combination_record_status', 0, '', '', '', '1', '2023-10-08 07:24:44', '1', '2024-10-13 10:08:17', b'0');
INSERT INTO `system_dict_data` VALUES (1390, 1, '拼团成功', '1', 'promotion_combination_record_status', 0, 'success', '', '', '1', '2023-10-08 07:24:56', '1', '2024-10-13 10:08:20', b'0');
INSERT INTO `system_dict_data` VALUES (1391, 2, '拼团失败', '2', 'promotion_combination_record_status', 0, 'warning', '', '', '1', '2023-10-08 07:25:11', '1', '2024-10-13 10:08:24', b'0');
INSERT INTO `system_dict_data` VALUES (1392, 2, '管理员修改', '2', 'member_point_biz_type', 0, 'default', '', '', '1', '2023-10-11 07:41:34', '1', '2023-10-11 07:41:34', b'0');
INSERT INTO `system_dict_data` VALUES (1393, 13, '订单积分抵扣（单个退款）', '13', 'member_point_biz_type', 0, '', '', '', '1', '2023-10-11 07:42:29', '1', '2023-10-11 07:42:29', b'0');
INSERT INTO `system_dict_data` VALUES (1394, 21, '订单积分奖励', '21', 'member_point_biz_type', 0, 'default', '', '', '1', '2023-10-11 07:42:44', '1', '2023-10-11 07:42:44', b'0');
INSERT INTO `system_dict_data` VALUES (1395, 22, '订单积分奖励（整单取消）', '22', 'member_point_biz_type', 0, 'default', '', '', '1', '2023-10-11 07:42:55', '1', '2023-10-11 07:43:01', b'0');
INSERT INTO `system_dict_data` VALUES (1396, 23, '订单积分奖励（单个退款）', '23', 'member_point_biz_type', 0, 'default', '', '', '1', '2023-10-11 07:43:16', '1', '2023-10-11 07:43:16', b'0');
INSERT INTO `system_dict_data` VALUES (1397, 13, '下单奖励（单个退款）', '13', 'member_experience_biz_type', 0, 'warning', '', '', '1', '2023-10-11 07:45:24', '1', '2023-10-11 07:45:38', b'0');
INSERT INTO `system_dict_data` VALUES (1398, 5, '网上转账', '5', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:55:24', '1', '2023-10-18 21:55:24', b'0');
INSERT INTO `system_dict_data` VALUES (1399, 6, '支付宝', '6', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:55:38', '1', '2023-10-18 21:55:38', b'0');
INSERT INTO `system_dict_data` VALUES (1400, 7, '微信支付', '7', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:55:53', '1', '2023-10-18 21:55:53', b'0');
INSERT INTO `system_dict_data` VALUES (1401, 8, '其他', '8', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:56:06', '1', '2023-10-18 21:56:06', b'0');
INSERT INTO `system_dict_data` VALUES (1402, 1, 'IT', '1', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:02:15', '1', '2024-02-18 23:30:38', b'0');
INSERT INTO `system_dict_data` VALUES (1403, 2, '金融业', '2', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:02:29', '1', '2024-02-18 23:30:43', b'0');
INSERT INTO `system_dict_data` VALUES (1404, 3, '房地产', '3', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:02:41', '1', '2024-02-18 23:30:48', b'0');
INSERT INTO `system_dict_data` VALUES (1405, 4, '商业服务', '4', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:02:54', '1', '2024-02-18 23:30:54', b'0');
INSERT INTO `system_dict_data` VALUES (1406, 5, '运输/物流', '5', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:03:03', '1', '2024-02-18 23:31:00', b'0');
INSERT INTO `system_dict_data` VALUES (1407, 6, '生产', '6', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:03:13', '1', '2024-02-18 23:31:08', b'0');
INSERT INTO `system_dict_data` VALUES (1408, 7, '政府', '7', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:03:27', '1', '2024-02-18 23:31:13', b'0');
INSERT INTO `system_dict_data` VALUES (1409, 8, '文化传媒', '8', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:03:37', '1', '2024-02-18 23:31:20', b'0');
INSERT INTO `system_dict_data` VALUES (1422, 1, 'A （重点客户）', '1', 'crm_customer_level', 0, 'primary', '', '', '1', '2023-10-28 23:07:13', '1', '2023-10-28 23:07:13', b'0');
INSERT INTO `system_dict_data` VALUES (1423, 2, 'B （普通客户）', '2', 'crm_customer_level', 0, 'info', '', '', '1', '2023-10-28 23:07:35', '1', '2023-10-28 23:07:35', b'0');
INSERT INTO `system_dict_data` VALUES (1424, 3, 'C （非优先客户）', '3', 'crm_customer_level', 0, 'default', '', '', '1', '2023-10-28 23:07:53', '1', '2023-10-28 23:07:53', b'0');
INSERT INTO `system_dict_data` VALUES (1425, 1, '促销', '1', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:08:29', '1', '2023-10-28 23:08:29', b'0');
INSERT INTO `system_dict_data` VALUES (1426, 2, '搜索引擎', '2', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:08:39', '1', '2023-10-28 23:08:39', b'0');
INSERT INTO `system_dict_data` VALUES (1427, 3, '广告', '3', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:08:47', '1', '2023-10-28 23:08:47', b'0');
INSERT INTO `system_dict_data` VALUES (1428, 4, '转介绍', '4', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:08:58', '1', '2023-10-28 23:08:58', b'0');
INSERT INTO `system_dict_data` VALUES (1429, 5, '线上注册', '5', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:09:12', '1', '2023-10-28 23:09:12', b'0');
INSERT INTO `system_dict_data` VALUES (1430, 6, '线上咨询', '6', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:09:22', '1', '2023-10-28 23:09:22', b'0');
INSERT INTO `system_dict_data` VALUES (1431, 7, '预约上门', '7', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:09:39', '1', '2023-10-28 23:09:39', b'0');
INSERT INTO `system_dict_data` VALUES (1432, 8, '陌拜', '8', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:10:04', '1', '2023-10-28 23:10:04', b'0');
INSERT INTO `system_dict_data` VALUES (1433, 9, '电话咨询', '9', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:10:18', '1', '2023-10-28 23:10:18', b'0');
INSERT INTO `system_dict_data` VALUES (1434, 10, '邮件咨询', '10', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:10:33', '1', '2023-10-28 23:10:33', b'0');
INSERT INTO `system_dict_data` VALUES (1435, 10, 'Gitee', '10', 'system_social_type', 0, '', '', '', '1', '2023-11-04 13:04:42', '1', '2023-11-04 13:04:42', b'0');
INSERT INTO `system_dict_data` VALUES (1436, 20, '钉钉', '20', 'system_social_type', 0, '', '', '', '1', '2023-11-04 13:04:54', '1', '2023-11-04 13:04:54', b'0');
INSERT INTO `system_dict_data` VALUES (1437, 30, '企业微信', '30', 'system_social_type', 0, '', '', '', '1', '2023-11-04 13:05:09', '1', '2023-11-04 13:05:09', b'0');
INSERT INTO `system_dict_data` VALUES (1438, 31, '微信公众平台', '31', 'system_social_type', 0, '', '', '', '1', '2023-11-04 13:05:18', '1', '2023-11-04 13:05:18', b'0');
INSERT INTO `system_dict_data` VALUES (1439, 32, '微信开放平台', '32', 'system_social_type', 0, '', '', '', '1', '2023-11-04 13:05:30', '1', '2023-11-04 13:05:30', b'0');
INSERT INTO `system_dict_data` VALUES (1440, 34, '微信小程序', '34', 'system_social_type', 0, '', '', '', '1', '2023-11-04 13:05:38', '1', '2023-11-04 13:07:16', b'0');
INSERT INTO `system_dict_data` VALUES (1441, 1, '上架', '1', 'crm_product_status', 0, 'success', '', '', '1', '2023-10-30 21:49:34', '1', '2023-10-30 21:49:34', b'0');
INSERT INTO `system_dict_data` VALUES (1442, 0, '下架', '0', 'crm_product_status', 0, 'success', '', '', '1', '2023-10-30 21:49:13', '1', '2023-10-30 21:49:13', b'0');
INSERT INTO `system_dict_data` VALUES (1443, 15, '子表', '15', 'infra_codegen_template_type', 0, 'default', '', '', '1', '2023-11-13 23:06:16', '1', '2023-11-13 23:06:16', b'0');
INSERT INTO `system_dict_data` VALUES (1444, 10, '主表（标准模式）', '10', 'infra_codegen_template_type', 0, 'default', '', '', '1', '2023-11-14 12:32:49', '1', '2023-11-14 12:32:49', b'0');
INSERT INTO `system_dict_data` VALUES (1445, 11, '主表（ERP 模式）', '11', 'infra_codegen_template_type', 0, 'default', '', '', '1', '2023-11-14 12:33:05', '1', '2023-11-14 12:33:05', b'0');
INSERT INTO `system_dict_data` VALUES (1446, 12, '主表（内嵌模式）', '12', 'infra_codegen_template_type', 0, '', '', '', '1', '2023-11-14 12:33:31', '1', '2023-11-14 12:33:31', b'0');
INSERT INTO `system_dict_data` VALUES (1447, 1, '负责人', '1', 'crm_permission_level', 0, 'default', '', '', '1', '2023-11-30 09:53:12', '1', '2023-11-30 09:53:12', b'0');
INSERT INTO `system_dict_data` VALUES (1448, 2, '只读', '2', 'crm_permission_level', 0, '', '', '', '1', '2023-11-30 09:53:29', '1', '2023-11-30 09:53:29', b'0');
INSERT INTO `system_dict_data` VALUES (1449, 3, '读写', '3', 'crm_permission_level', 0, '', '', '', '1', '2023-11-30 09:53:36', '1', '2023-11-30 09:53:36', b'0');
INSERT INTO `system_dict_data` VALUES (1450, 0, '未提交', '0', 'crm_audit_status', 0, '', '', '', '1', '2023-11-30 18:56:59', '1', '2023-11-30 18:56:59', b'0');
INSERT INTO `system_dict_data` VALUES (1451, 10, '审批中', '10', 'crm_audit_status', 0, '', '', '', '1', '2023-11-30 18:57:10', '1', '2023-11-30 18:57:10', b'0');
INSERT INTO `system_dict_data` VALUES (1452, 20, '审核通过', '20', 'crm_audit_status', 0, '', '', '', '1', '2023-11-30 18:57:24', '1', '2023-11-30 18:57:24', b'0');
INSERT INTO `system_dict_data` VALUES (1453, 30, '审核不通过', '30', 'crm_audit_status', 0, '', '', '', '1', '2023-11-30 18:57:32', '1', '2023-11-30 18:57:32', b'0');
INSERT INTO `system_dict_data` VALUES (1454, 40, '已取消', '40', 'crm_audit_status', 0, '', '', '', '1', '2023-11-30 18:57:42', '1', '2023-11-30 18:57:42', b'0');
INSERT INTO `system_dict_data` VALUES (1456, 1, '支票', '1', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:54:29', '1', '2023-10-18 21:54:29', b'0');
INSERT INTO `system_dict_data` VALUES (1457, 2, '现金', '2', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:54:41', '1', '2023-10-18 21:54:41', b'0');
INSERT INTO `system_dict_data` VALUES (1458, 3, '邮政汇款', '3', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:54:53', '1', '2023-10-18 21:54:53', b'0');
INSERT INTO `system_dict_data` VALUES (1459, 4, '电汇', '4', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:55:07', '1', '2023-10-18 21:55:07', b'0');
INSERT INTO `system_dict_data` VALUES (1461, 1, '个', '1', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:02:26', '1', '2023-12-05 23:02:26', b'0');
INSERT INTO `system_dict_data` VALUES (1462, 2, '块', '2', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:02:34', '1', '2023-12-05 23:02:34', b'0');
INSERT INTO `system_dict_data` VALUES (1463, 3, '只', '3', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:02:57', '1', '2023-12-05 23:02:57', b'0');
INSERT INTO `system_dict_data` VALUES (1464, 4, '把', '4', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:03:05', '1', '2023-12-05 23:03:05', b'0');
INSERT INTO `system_dict_data` VALUES (1465, 5, '枚', '5', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:03:14', '1', '2023-12-05 23:03:14', b'0');
INSERT INTO `system_dict_data` VALUES (1466, 6, '瓶', '6', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:03:20', '1', '2023-12-05 23:03:20', b'0');
INSERT INTO `system_dict_data` VALUES (1467, 7, '盒', '7', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:03:30', '1', '2023-12-05 23:03:30', b'0');
INSERT INTO `system_dict_data` VALUES (1468, 8, '台', '8', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:03:41', '1', '2023-12-05 23:03:41', b'0');
INSERT INTO `system_dict_data` VALUES (1469, 9, '吨', '9', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:03:48', '1', '2023-12-05 23:03:48', b'0');
INSERT INTO `system_dict_data` VALUES (1470, 10, '千克', '10', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:04:03', '1', '2023-12-05 23:04:03', b'0');
INSERT INTO `system_dict_data` VALUES (1471, 11, '米', '11', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:04:12', '1', '2023-12-05 23:04:12', b'0');
INSERT INTO `system_dict_data` VALUES (1472, 12, '箱', '12', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:04:25', '1', '2023-12-05 23:04:25', b'0');
INSERT INTO `system_dict_data` VALUES (1473, 13, '套', '13', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:04:34', '1', '2023-12-05 23:04:34', b'0');
INSERT INTO `system_dict_data` VALUES (1474, 1, '打电话', '1', 'crm_follow_up_type', 0, '', '', '', '1', '2024-01-15 20:48:20', '1', '2024-01-15 20:48:20', b'0');
INSERT INTO `system_dict_data` VALUES (1475, 2, '发短信', '2', 'crm_follow_up_type', 0, '', '', '', '1', '2024-01-15 20:48:31', '1', '2024-01-15 20:48:31', b'0');
INSERT INTO `system_dict_data` VALUES (1476, 3, '上门拜访', '3', 'crm_follow_up_type', 0, '', '', '', '1', '2024-01-15 20:49:07', '1', '2024-01-15 20:49:07', b'0');
INSERT INTO `system_dict_data` VALUES (1477, 4, '微信沟通', '4', 'crm_follow_up_type', 0, '', '', '', '1', '2024-01-15 20:49:15', '1', '2024-01-15 20:49:15', b'0');
INSERT INTO `system_dict_data` VALUES (1482, 4, '转账失败', '20', 'pay_transfer_status', 0, 'warning', '', '', '1', '2023-10-28 16:24:16', '1', '2025-05-08 12:59:01', b'0');
INSERT INTO `system_dict_data` VALUES (1483, 3, '转账成功', '10', 'pay_transfer_status', 0, 'success', '', '', '1', '2023-10-28 16:23:50', '1', '2025-05-08 12:58:58', b'0');
INSERT INTO `system_dict_data` VALUES (1484, 2, '转账进行中', '5', 'pay_transfer_status', 0, 'info', '', '', '1', '2023-10-28 16:23:12', '1', '2025-05-08 12:58:54', b'0');
INSERT INTO `system_dict_data` VALUES (1485, 1, '等待转账', '0', 'pay_transfer_status', 0, 'default', '', '', '1', '2023-10-28 16:21:43', '1', '2023-10-28 16:23:22', b'0');
INSERT INTO `system_dict_data` VALUES (1486, 10, '其它入库', '10', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-05 18:07:25', '1', '2024-02-05 18:07:43', b'0');
INSERT INTO `system_dict_data` VALUES (1487, 11, '其它入库（作废）', '11', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-05 18:08:07', '1', '2024-02-05 19:20:16', b'0');
INSERT INTO `system_dict_data` VALUES (1488, 20, '其它出库', '20', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-05 18:08:51', '1', '2024-02-05 18:08:51', b'0');
INSERT INTO `system_dict_data` VALUES (1489, 21, '其它出库（作废）', '21', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-05 18:09:00', '1', '2024-02-05 19:20:10', b'0');
INSERT INTO `system_dict_data` VALUES (1490, 10, '未审核', '10', 'erp_audit_status', 0, 'default', '', '', '1', '2024-02-06 00:00:21', '1', '2024-02-06 00:00:21', b'0');
INSERT INTO `system_dict_data` VALUES (1491, 20, '已审核', '20', 'erp_audit_status', 0, 'success', '', '', '1', '2024-02-06 00:00:35', '1', '2024-02-06 00:00:35', b'0');
INSERT INTO `system_dict_data` VALUES (1492, 30, '调拨入库', '30', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-07 20:34:19', '1', '2024-02-07 12:36:31', b'0');
INSERT INTO `system_dict_data` VALUES (1493, 31, '调拨入库（作废）', '31', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-07 20:34:29', '1', '2024-02-07 20:37:11', b'0');
INSERT INTO `system_dict_data` VALUES (1494, 32, '调拨出库', '32', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-07 20:34:38', '1', '2024-02-07 12:36:33', b'0');
INSERT INTO `system_dict_data` VALUES (1495, 33, '调拨出库（作废）', '33', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-07 20:34:49', '1', '2024-02-07 20:37:06', b'0');
INSERT INTO `system_dict_data` VALUES (1496, 40, '盘盈入库', '40', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-08 08:53:00', '1', '2024-02-08 08:53:09', b'0');
INSERT INTO `system_dict_data` VALUES (1497, 41, '盘盈入库（作废）', '41', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-08 08:53:39', '1', '2024-02-16 19:40:54', b'0');
INSERT INTO `system_dict_data` VALUES (1498, 42, '盘亏出库', '42', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-08 08:54:16', '1', '2024-02-08 08:54:16', b'0');
INSERT INTO `system_dict_data` VALUES (1499, 43, '盘亏出库（作废）', '43', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-08 08:54:31', '1', '2024-02-16 19:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (1500, 50, '销售出库', '50', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-11 21:47:25', '1', '2024-02-11 21:50:40', b'0');
INSERT INTO `system_dict_data` VALUES (1501, 51, '销售出库（作废）', '51', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-11 21:47:37', '1', '2024-02-11 21:51:12', b'0');
INSERT INTO `system_dict_data` VALUES (1502, 60, '销售退货入库', '60', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-12 06:51:05', '1', '2024-02-12 06:51:05', b'0');
INSERT INTO `system_dict_data` VALUES (1503, 61, '销售退货入库（作废）', '61', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-12 06:51:18', '1', '2024-02-12 06:51:18', b'0');
INSERT INTO `system_dict_data` VALUES (1504, 70, '采购入库', '70', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-16 13:10:02', '1', '2024-02-16 13:10:02', b'0');
INSERT INTO `system_dict_data` VALUES (1505, 71, '采购入库（作废）', '71', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-16 13:10:10', '1', '2024-02-16 19:40:40', b'0');
INSERT INTO `system_dict_data` VALUES (1506, 80, '采购退货出库', '80', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-16 13:10:17', '1', '2024-02-16 13:10:17', b'0');
INSERT INTO `system_dict_data` VALUES (1507, 81, '采购退货出库（作废）', '81', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-16 13:10:26', '1', '2024-02-16 19:40:33', b'0');
INSERT INTO `system_dict_data` VALUES (1509, 3, '审批不通过', '3', 'bpm_process_instance_status', 0, 'danger', '', '', '1', '2024-03-16 16:12:06', '1', '2024-03-16 16:12:06', b'0');
INSERT INTO `system_dict_data` VALUES (1510, 4, '已取消', '4', 'bpm_process_instance_status', 0, 'warning', '', '', '1', '2024-03-16 16:12:22', '1', '2024-03-16 16:12:22', b'0');
INSERT INTO `system_dict_data` VALUES (1511, 5, '已退回', '5', 'bpm_task_status', 0, 'warning', '', '', '1', '2024-03-16 19:10:46', '1', '2024-03-08 22:41:40', b'0');
INSERT INTO `system_dict_data` VALUES (1512, 6, '委派中', '6', 'bpm_task_status', 0, 'primary', '', '', '1', '2024-03-17 10:06:22', '1', '2024-03-08 22:41:40', b'0');
INSERT INTO `system_dict_data` VALUES (1513, 7, '审批通过中', '7', 'bpm_task_status', 0, 'success', '', '', '1', '2024-03-17 10:06:47', '1', '2024-03-08 22:41:41', b'0');
INSERT INTO `system_dict_data` VALUES (1514, 0, '待审批', '0', 'bpm_task_status', 0, 'info', '', '', '1', '2024-03-17 10:07:11', '1', '2024-03-08 22:41:42', b'0');
INSERT INTO `system_dict_data` VALUES (1515, 35, '发起人自选', '35', 'bpm_task_candidate_strategy', 0, '', '', '', '1', '2024-03-22 19:45:16', '1', '2024-03-22 19:45:16', b'0');
INSERT INTO `system_dict_data` VALUES (1516, 1, '执行监听器', 'execution', 'bpm_process_listener_type', 0, 'primary', '', '', '1', '2024-03-23 12:54:03', '1', '2024-03-23 19:14:19', b'0');
INSERT INTO `system_dict_data` VALUES (1517, 1, '任务监听器', 'task', 'bpm_process_listener_type', 0, 'success', '', '', '1', '2024-03-23 12:54:13', '1', '2024-03-23 19:14:24', b'0');
INSERT INTO `system_dict_data` VALUES (1526, 1, 'Java 类', 'class', 'bpm_process_listener_value_type', 0, 'primary', '', '', '1', '2024-03-23 15:08:45', '1', '2024-03-23 19:14:32', b'0');
INSERT INTO `system_dict_data` VALUES (1527, 2, '表达式', 'expression', 'bpm_process_listener_value_type', 0, 'success', '', '', '1', '2024-03-23 15:09:06', '1', '2024-03-23 19:14:38', b'0');
INSERT INTO `system_dict_data` VALUES (1528, 3, '代理表达式', 'delegateExpression', 'bpm_process_listener_value_type', 0, 'info', '', '', '1', '2024-03-23 15:11:23', '1', '2024-03-23 19:14:41', b'0');
INSERT INTO `system_dict_data` VALUES (1529, 1, '天', '1', 'date_interval', 0, '', '', '', '1', '2024-03-29 22:50:26', '1', '2024-03-29 22:50:26', b'0');
INSERT INTO `system_dict_data` VALUES (1530, 2, '周', '2', 'date_interval', 0, '', '', '', '1', '2024-03-29 22:50:36', '1', '2024-03-29 22:50:36', b'0');
INSERT INTO `system_dict_data` VALUES (1531, 3, '月', '3', 'date_interval', 0, '', '', '', '1', '2024-03-29 22:50:46', '1', '2024-03-29 22:50:54', b'0');
INSERT INTO `system_dict_data` VALUES (1532, 4, '季度', '4', 'date_interval', 0, '', '', '', '1', '2024-03-29 22:51:01', '1', '2024-03-29 22:51:01', b'0');
INSERT INTO `system_dict_data` VALUES (1533, 5, '年', '5', 'date_interval', 0, '', '', '', '1', '2024-03-29 22:51:07', '1', '2024-03-29 22:51:07', b'0');
INSERT INTO `system_dict_data` VALUES (1534, 1, '赢单', '1', 'crm_business_end_status_type', 0, 'success', '', '', '1', '2024-04-13 23:26:57', '1', '2024-04-13 23:26:57', b'0');
INSERT INTO `system_dict_data` VALUES (1535, 2, '输单', '2', 'crm_business_end_status_type', 0, 'primary', '', '', '1', '2024-04-13 23:27:31', '1', '2024-04-13 23:27:31', b'0');
INSERT INTO `system_dict_data` VALUES (1536, 3, '无效', '3', 'crm_business_end_status_type', 0, 'info', '', '', '1', '2024-04-13 23:27:59', '1', '2024-04-13 23:27:59', b'0');
INSERT INTO `system_dict_data` VALUES (1537, 1, 'OpenAI', 'OpenAI', 'ai_platform', 0, '', '', '', '1', '2024-05-09 22:33:47', '1', '2024-05-09 22:58:46', b'0');
INSERT INTO `system_dict_data` VALUES (1538, 2, 'Ollama', 'Ollama', 'ai_platform', 0, '', '', '', '1', '2024-05-17 23:02:55', '1', '2024-05-17 23:02:55', b'0');
INSERT INTO `system_dict_data` VALUES (1539, 3, '文心一言', 'YiYan', 'ai_platform', 0, '', '', '', '1', '2024-05-18 09:24:20', '1', '2024-05-18 09:29:01', b'0');
INSERT INTO `system_dict_data` VALUES (1540, 4, '讯飞星火', 'XingHuo', 'ai_platform', 0, '', '', '', '1', '2024-05-18 10:08:56', '1', '2024-05-18 10:08:56', b'0');
INSERT INTO `system_dict_data` VALUES (1541, 5, '通义千问', 'TongYi', 'ai_platform', 0, '', '', '', '1', '2024-05-18 10:32:29', '1', '2024-07-06 15:42:29', b'0');
INSERT INTO `system_dict_data` VALUES (1542, 6, 'StableDiffusion', 'StableDiffusion', 'ai_platform', 0, '', '', '', '1', '2024-06-01 15:09:31', '1', '2024-06-01 15:10:25', b'0');
INSERT INTO `system_dict_data` VALUES (1543, 10, '进行中', '10', 'ai_image_status', 0, 'primary', '', '', '1', '2024-06-26 20:51:41', '1', '2024-06-26 20:52:48', b'0');
INSERT INTO `system_dict_data` VALUES (1544, 20, '已完成', '20', 'ai_image_status', 0, 'success', '', '', '1', '2024-06-26 20:52:07', '1', '2024-06-26 20:52:41', b'0');
INSERT INTO `system_dict_data` VALUES (1545, 30, '已失败', '30', 'ai_image_status', 0, 'warning', '', '', '1', '2024-06-26 20:52:25', '1', '2024-06-26 20:52:35', b'0');
INSERT INTO `system_dict_data` VALUES (1546, 7, 'Midjourney', 'Midjourney', 'ai_platform', 0, '', '', '', '1', '2024-06-26 22:14:46', '1', '2024-06-26 22:14:46', b'0');
INSERT INTO `system_dict_data` VALUES (1547, 10, '进行中', '10', 'ai_music_status', 0, 'primary', '', '', '1', '2024-06-27 22:45:22', '1', '2024-06-28 00:56:17', b'0');
INSERT INTO `system_dict_data` VALUES (1548, 20, '已完成', '20', 'ai_music_status', 0, 'success', '', '', '1', '2024-06-27 22:45:33', '1', '2024-06-28 00:56:18', b'0');
INSERT INTO `system_dict_data` VALUES (1549, 30, '已失败', '30', 'ai_music_status', 0, 'danger', '', '', '1', '2024-06-27 22:45:44', '1', '2024-06-28 00:56:19', b'0');
INSERT INTO `system_dict_data` VALUES (1550, 1, '歌词模式', '1', 'ai_generate_mode', 0, '', '', '', '1', '2024-06-27 22:46:31', '1', '2024-06-28 01:22:25', b'0');
INSERT INTO `system_dict_data` VALUES (1551, 2, '描述模式', '2', 'ai_generate_mode', 0, '', '', '', '1', '2024-06-27 22:46:37', '1', '2024-06-28 01:22:24', b'0');
INSERT INTO `system_dict_data` VALUES (1552, 8, 'Suno', 'Suno', 'ai_platform', 0, '', '', '', '1', '2024-06-29 09:13:36', '1', '2024-06-29 09:13:41', b'0');
INSERT INTO `system_dict_data` VALUES (1553, 9, 'DeepSeek', 'DeepSeek', 'ai_platform', 0, '', '', '', '1', '2024-07-06 12:04:30', '1', '2024-07-06 12:05:20', b'0');
INSERT INTO `system_dict_data` VALUES (1554, 13, '智谱', 'ZhiPu', 'ai_platform', 0, '', '', '', '1', '2024-07-06 18:00:35', '1', '2025-02-24 20:18:41', b'0');
INSERT INTO `system_dict_data` VALUES (1555, 4, '长', '4', 'ai_write_length', 0, '', '', '', '1', '2024-07-07 15:49:03', '1', '2024-07-07 15:49:03', b'0');
INSERT INTO `system_dict_data` VALUES (1556, 5, '段落', '5', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:49:54', '1', '2024-07-07 15:49:54', b'0');
INSERT INTO `system_dict_data` VALUES (1557, 6, '文章', '6', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:50:05', '1', '2024-07-07 15:50:05', b'0');
INSERT INTO `system_dict_data` VALUES (1558, 7, '博客文章', '7', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:50:23', '1', '2024-07-07 15:50:23', b'0');
INSERT INTO `system_dict_data` VALUES (1559, 8, '想法', '8', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:50:31', '1', '2024-07-07 15:50:31', b'0');
INSERT INTO `system_dict_data` VALUES (1560, 9, '大纲', '9', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:50:37', '1', '2024-07-07 15:50:37', b'0');
INSERT INTO `system_dict_data` VALUES (1561, 1, '自动', '1', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:51:06', '1', '2024-07-07 15:51:06', b'0');
INSERT INTO `system_dict_data` VALUES (1562, 2, '友善', '2', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:51:19', '1', '2024-07-07 15:51:19', b'0');
INSERT INTO `system_dict_data` VALUES (1563, 3, '随意', '3', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:51:27', '1', '2024-07-07 15:51:27', b'0');
INSERT INTO `system_dict_data` VALUES (1564, 4, '友好', '4', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:51:37', '1', '2024-07-07 15:51:37', b'0');
INSERT INTO `system_dict_data` VALUES (1565, 5, '专业', '5', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:51:49', '1', '2024-07-07 15:52:02', b'0');
INSERT INTO `system_dict_data` VALUES (1566, 6, '诙谐', '6', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:52:15', '1', '2024-07-07 15:52:15', b'0');
INSERT INTO `system_dict_data` VALUES (1567, 7, '有趣', '7', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:52:24', '1', '2024-07-07 15:52:24', b'0');
INSERT INTO `system_dict_data` VALUES (1568, 8, '正式', '8', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:54:33', '1', '2024-07-07 15:54:33', b'0');
INSERT INTO `system_dict_data` VALUES (1569, 5, '段落', '5', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:49:54', '1', '2024-07-07 15:49:54', b'0');
INSERT INTO `system_dict_data` VALUES (1570, 1, '自动', '1', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:19:34', '1', '2024-07-07 15:19:34', b'0');
INSERT INTO `system_dict_data` VALUES (1571, 2, '电子邮件', '2', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:19:50', '1', '2024-07-07 15:49:30', b'0');
INSERT INTO `system_dict_data` VALUES (1572, 3, '消息', '3', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:20:01', '1', '2024-07-07 15:49:38', b'0');
INSERT INTO `system_dict_data` VALUES (1573, 4, '评论', '4', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:20:13', '1', '2024-07-07 15:49:45', b'0');
INSERT INTO `system_dict_data` VALUES (1574, 1, '自动', '1', 'ai_write_language', 0, '', '', '', '1', '2024-07-07 15:44:18', '1', '2024-07-07 15:44:18', b'0');
INSERT INTO `system_dict_data` VALUES (1575, 2, '中文', '2', 'ai_write_language', 0, '', '', '', '1', '2024-07-07 15:44:28', '1', '2024-07-07 15:44:28', b'0');
INSERT INTO `system_dict_data` VALUES (1576, 3, '英文', '3', 'ai_write_language', 0, '', '', '', '1', '2024-07-07 15:44:37', '1', '2024-07-07 15:44:37', b'0');
INSERT INTO `system_dict_data` VALUES (1577, 4, '韩语', '4', 'ai_write_language', 0, '', '', '', '1', '2024-07-07 15:46:28', '1', '2024-07-07 15:46:28', b'0');
INSERT INTO `system_dict_data` VALUES (1578, 5, '日语', '5', 'ai_write_language', 0, '', '', '', '1', '2024-07-07 15:46:44', '1', '2024-07-07 15:46:44', b'0');
INSERT INTO `system_dict_data` VALUES (1579, 1, '自动', '1', 'ai_write_length', 0, '', '', '', '1', '2024-07-07 15:48:34', '1', '2024-07-07 15:48:34', b'0');
INSERT INTO `system_dict_data` VALUES (1580, 2, '短', '2', 'ai_write_length', 0, '', '', '', '1', '2024-07-07 15:48:44', '1', '2024-07-07 15:48:44', b'0');
INSERT INTO `system_dict_data` VALUES (1581, 3, '中等', '3', 'ai_write_length', 0, '', '', '', '1', '2024-07-07 15:48:52', '1', '2024-07-07 15:48:52', b'0');
INSERT INTO `system_dict_data` VALUES (1582, 4, '长', '4', 'ai_write_length', 0, '', '', '', '1', '2024-07-07 15:49:03', '1', '2024-07-07 15:49:03', b'0');
INSERT INTO `system_dict_data` VALUES (1584, 1, '撰写', '1', 'ai_write_type', 0, '', '', '', '1', '2024-07-10 21:26:00', '1', '2024-07-10 21:26:00', b'0');
INSERT INTO `system_dict_data` VALUES (1585, 2, '回复', '2', 'ai_write_type', 0, '', '', '', '1', '2024-07-10 21:26:06', '1', '2024-07-10 21:26:06', b'0');
INSERT INTO `system_dict_data` VALUES (1586, 2, '腾讯云', 'TENCENT', 'system_sms_channel_code', 0, '', '', '', '1', '2024-07-22 22:23:16', '1', '2024-07-22 22:23:16', b'0');
INSERT INTO `system_dict_data` VALUES (1587, 3, '华为云', 'HUAWEI', 'system_sms_channel_code', 0, '', '', '', '1', '2024-07-22 22:23:46', '1', '2024-07-22 22:23:53', b'0');
INSERT INTO `system_dict_data` VALUES (1588, 1, 'OpenAI 微软', 'AzureOpenAI', 'ai_platform', 0, '', '', '', '1', '2024-08-10 14:07:41', '1', '2024-08-10 14:07:41', b'0');
INSERT INTO `system_dict_data` VALUES (1589, 10, 'BPMN 设计器', '10', 'bpm_model_type', 0, 'primary', '', '', '1', '2024-08-26 15:22:17', '1', '2024-08-26 16:46:02', b'0');
INSERT INTO `system_dict_data` VALUES (1590, 20, 'SIMPLE 设计器', '20', 'bpm_model_type', 0, 'success', '', '', '1', '2024-08-26 15:22:27', '1', '2024-08-26 16:45:58', b'0');
INSERT INTO `system_dict_data` VALUES (1591, 4, '七牛云', 'QINIU', 'system_sms_channel_code', 0, '', '', '', '1', '2024-08-31 08:45:03', '1', '2024-08-31 08:45:24', b'0');
INSERT INTO `system_dict_data` VALUES (1592, 3, '新人券', '3', 'promotion_coupon_take_type', 0, 'info', '', '新人注册后，自动发放', '1', '2024-09-03 11:57:16', '1', '2024-09-03 11:57:28', b'0');
INSERT INTO `system_dict_data` VALUES (1593, 5, '微信零钱', '5', 'brokerage_withdraw_type', 0, '', '', 'API 打款', '1', '2024-10-13 11:06:48', '1', '2025-05-10 08:24:55', b'0');
INSERT INTO `system_dict_data` VALUES (1683, 10, '字节豆包', 'DouBao', 'ai_platform', 0, '', '', '', '1', '2025-02-23 19:51:40', '1', '2025-02-23 19:52:02', b'0');
INSERT INTO `system_dict_data` VALUES (1684, 11, '腾讯混元', 'HunYuan', 'ai_platform', 0, '', '', '', '1', '2025-02-23 20:58:04', '1', '2025-02-23 20:58:04', b'0');
INSERT INTO `system_dict_data` VALUES (1685, 12, '硅基流动', 'SiliconFlow', 'ai_platform', 0, '', '', '', '1', '2025-02-24 20:19:09', '1', '2025-02-24 20:19:09', b'0');
INSERT INTO `system_dict_data` VALUES (1686, 1, '聊天', '1', 'ai_model_type', 0, '', '', '', '1', '2025-03-03 12:26:34', '1', '2025-03-03 12:26:34', b'0');
INSERT INTO `system_dict_data` VALUES (1687, 2, '图像', '2', 'ai_model_type', 0, '', '', '', '1', '2025-03-03 12:27:23', '1', '2025-03-03 12:27:23', b'0');
INSERT INTO `system_dict_data` VALUES (1688, 3, '音频', '3', 'ai_model_type', 0, '', '', '', '1', '2025-03-03 12:27:51', '1', '2025-03-03 12:27:51', b'0');
INSERT INTO `system_dict_data` VALUES (1689, 4, '视频', '4', 'ai_model_type', 0, '', '', '', '1', '2025-03-03 12:28:03', '1', '2025-03-03 12:28:03', b'0');
INSERT INTO `system_dict_data` VALUES (1690, 5, '向量', '5', 'ai_model_type', 0, '', '', '', '1', '2025-03-03 12:28:15', '1', '2025-03-03 12:28:15', b'0');
INSERT INTO `system_dict_data` VALUES (1691, 6, '重排', '6', 'ai_model_type', 0, '', '', '', '1', '2025-03-03 12:28:26', '1', '2025-03-03 12:28:26', b'0');
INSERT INTO `system_dict_data` VALUES (1692, 14, 'MiniMax', 'MiniMax', 'ai_platform', 0, '', '', '', '1', '2025-03-11 20:04:51', '1', '2025-03-11 20:04:51', b'0');
INSERT INTO `system_dict_data` VALUES (1693, 15, '月之暗面', 'Moonshot', 'ai_platform', 0, '', '', '', '1', '2025-03-11 20:05:08', '1', '2025-11-24 07:17:39', b'0');
INSERT INTO `system_dict_data` VALUES (2002, 0, '直连设备', '0', 'iot_product_device_type', 0, 'default', '', '', '1', '2024-08-10 11:54:58', '1', '2025-03-17 09:28:22', b'0');
INSERT INTO `system_dict_data` VALUES (2003, 2, '网关设备', '2', 'iot_product_device_type', 0, 'default', '', '', '1', '2024-08-10 11:55:08', '1', '2025-03-17 09:28:28', b'0');
INSERT INTO `system_dict_data` VALUES (2004, 1, '网关子设备', '1', 'iot_product_device_type', 0, 'default', '', '', '1', '2024-08-10 11:55:20', '1', '2025-03-17 09:28:31', b'0');
INSERT INTO `system_dict_data` VALUES (2005, 1, '已发布', '1', 'iot_product_status', 0, 'success', '', '', '1', '2024-08-10 12:10:33', '1', '2025-03-17 09:28:34', b'0');
INSERT INTO `system_dict_data` VALUES (2006, 0, '开发中', '0', 'iot_product_status', 0, 'default', '', '', '1', '2024-08-10 14:19:18', '1', '2025-03-17 09:28:39', b'0');
INSERT INTO `system_dict_data` VALUES (2009, 0, 'Wi-Fi', '0', 'iot_net_type', 0, '', '', '', '1', '2024-09-06 22:04:47', '1', '2025-03-17 09:28:47', b'0');
INSERT INTO `system_dict_data` VALUES (2010, 1, '移动网络', '1', 'iot_net_type', 0, '', '', '', '1', '2024-09-06 22:05:14', '1', '2025-06-12 23:27:19', b'0');
INSERT INTO `system_dict_data` VALUES (2011, 2, '以太网', '2', 'iot_net_type', 0, '', '', '', '1', '2024-09-06 22:05:35', '1', '2025-03-17 09:28:51', b'0');
INSERT INTO `system_dict_data` VALUES (2012, 3, '其他', '3', 'iot_net_type', 0, '', '', '', '1', '2024-09-06 22:05:52', '1', '2025-03-17 09:28:54', b'0');
INSERT INTO `system_dict_data` VALUES (2018, 0, '未激活', '0', 'iot_device_state', 0, '', '', '', '1', '2024-09-21 08:13:34', '1', '2025-03-17 09:29:09', b'0');
INSERT INTO `system_dict_data` VALUES (2019, 1, '在线', '1', 'iot_device_state', 0, '', '', '', '1', '2024-09-21 08:13:48', '1', '2025-03-17 09:29:12', b'0');
INSERT INTO `system_dict_data` VALUES (2020, 2, '离线', '2', 'iot_device_state', 0, '', '', '', '1', '2024-09-21 08:13:59', '1', '2025-03-17 09:29:14', b'0');
INSERT INTO `system_dict_data` VALUES (2021, 1, '属性', '1', 'iot_thing_model_type', 0, '', '', '', '1', '2024-09-29 20:03:01', '1', '2025-03-17 09:29:24', b'0');
INSERT INTO `system_dict_data` VALUES (2022, 2, '服务', '2', 'iot_thing_model_type', 0, '', '', '', '1', '2024-09-29 20:03:11', '1', '2025-03-17 09:29:27', b'0');
INSERT INTO `system_dict_data` VALUES (2023, 3, '事件', '3', 'iot_thing_model_type', 0, '', '', '', '1', '2024-09-29 20:03:20', '1', '2025-03-17 09:29:29', b'0');
INSERT INTO `system_dict_data` VALUES (2030, 1, '升每分钟', 'L/min', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:34:24', b'0');
INSERT INTO `system_dict_data` VALUES (2031, 2, '毫克每千克', 'mg/kg', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:34:27', b'0');
INSERT INTO `system_dict_data` VALUES (2032, 3, '浊度', 'NTU', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:34:31', b'0');
INSERT INTO `system_dict_data` VALUES (2033, 4, 'PH值', 'pH', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:34:36', b'0');
INSERT INTO `system_dict_data` VALUES (2034, 5, '土壤EC值', 'dS/m', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:34:43', b'0');
INSERT INTO `system_dict_data` VALUES (2035, 6, '太阳总辐射', 'W/㎡', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:36:20', b'0');
INSERT INTO `system_dict_data` VALUES (2036, 7, '降雨量', 'mm/hour', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:36:24', b'0');
INSERT INTO `system_dict_data` VALUES (2037, 8, '乏', 'var', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:36:27', b'0');
INSERT INTO `system_dict_data` VALUES (2038, 9, '厘泊', 'cP', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:36:33', b'0');
INSERT INTO `system_dict_data` VALUES (2039, 10, '饱和度', 'aw', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:11', b'0');
INSERT INTO `system_dict_data` VALUES (2040, 11, '个', 'pcs', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:19', b'0');
INSERT INTO `system_dict_data` VALUES (2041, 12, '厘斯', 'cst', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:22', b'0');
INSERT INTO `system_dict_data` VALUES (2042, 13, '巴', 'bar', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:24', b'0');
INSERT INTO `system_dict_data` VALUES (2043, 14, '纳克每升', 'ppt', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:27', b'0');
INSERT INTO `system_dict_data` VALUES (2044, 15, '微克每升', 'ppb', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:31', b'0');
INSERT INTO `system_dict_data` VALUES (2045, 16, '微西每厘米', 'uS/cm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:34', b'0');
INSERT INTO `system_dict_data` VALUES (2046, 17, '牛顿每库仑', 'N/C', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:38', b'0');
INSERT INTO `system_dict_data` VALUES (2047, 18, '伏特每米', 'V/m', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:43', b'0');
INSERT INTO `system_dict_data` VALUES (2048, 19, '滴速', 'ml/min', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:46', b'0');
INSERT INTO `system_dict_data` VALUES (2049, 20, '毫米汞柱', 'mmHg', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:48', b'0');
INSERT INTO `system_dict_data` VALUES (2050, 21, '血糖', 'mmol/L', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:54', b'0');
INSERT INTO `system_dict_data` VALUES (2051, 22, '毫米每秒', 'mm/s', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:02', b'0');
INSERT INTO `system_dict_data` VALUES (2052, 23, '转每分钟', 'turn/m', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:07', b'0');
INSERT INTO `system_dict_data` VALUES (2053, 24, '次', 'count', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:09', b'0');
INSERT INTO `system_dict_data` VALUES (2054, 25, '档', 'gear', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:11', b'0');
INSERT INTO `system_dict_data` VALUES (2055, 26, '步', 'stepCount', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:13', b'0');
INSERT INTO `system_dict_data` VALUES (2056, 27, '标准立方米每小时', 'Nm3/h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:15', b'0');
INSERT INTO `system_dict_data` VALUES (2057, 28, '千伏', 'kV', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:20', b'0');
INSERT INTO `system_dict_data` VALUES (2058, 29, '千伏安', 'kVA', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:24', b'0');
INSERT INTO `system_dict_data` VALUES (2060, 30, '千乏', 'kVar', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2061, 31, '微瓦每平方厘米', 'uw/cm2', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2062, 32, '只', '只', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2063, 33, '相对湿度', '%RH', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2064, 34, '立方米每秒', 'm³/s', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2065, 35, '公斤每秒', 'kg/s', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2066, 36, '转每分钟', 'r/min', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2067, 37, '吨每小时', 't/h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2068, 38, '千卡每小时', 'KCL/h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2069, 39, '升每秒', 'L/s', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2070, 40, '兆帕', 'Mpa', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2071, 41, '立方米每小时', 'm³/h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2072, 42, '千乏时', 'kvarh', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2073, 43, '微克每升', 'μg/L', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2074, 44, '千卡路里', 'kcal', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2075, 45, '吉字节', 'GB', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2076, 46, '兆字节', 'MB', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2077, 47, '千字节', 'KB', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2078, 48, '字节', 'B', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2079, 49, '微克每平方分米每天', 'μg/(d㎡·d)', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2080, 50, '无', '', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2081, 51, '百万分率', 'ppm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2082, 52, '像素', 'pixel', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2083, 53, '照度', 'Lux', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2084, 54, '重力加速度', 'grav', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2085, 55, '分贝', 'dB', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2086, 56, '百分比', '%', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2087, 57, '流明', 'lm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2088, 58, '比特', 'bit', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2089, 59, '克每毫升', 'g/mL', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2090, 60, '克每升', 'g/L', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2091, 61, '毫克每升', 'mg/L', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2092, 62, '微克每立方米', 'μg/m³', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2093, 63, '毫克每立方米', 'mg/m³', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2094, 64, '克每立方米', 'g/m³', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2095, 65, '千克每立方米', 'kg/m³', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2096, 66, '纳法', 'nF', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2097, 67, '皮法', 'pF', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2098, 68, '微法', 'μF', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2099, 69, '法拉', 'F', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2100, 70, '欧姆', 'Ω', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2101, 71, '微安', 'μA', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2102, 72, '毫安', 'mA', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2103, 73, '千安', 'kA', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2104, 74, '安培', 'A', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2105, 75, '毫伏', 'mV', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2106, 76, '伏特', 'V', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2107, 77, '毫秒', 'ms', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2108, 78, '秒', 's', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2109, 79, '分钟', 'min', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2110, 80, '小时', 'h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2111, 81, '日', 'day', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2112, 82, '周', 'week', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2113, 83, '月', 'month', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2114, 84, '年', 'year', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2115, 85, '节', 'kn', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2116, 86, '千米每小时', 'km/h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2117, 87, '米每秒', 'm/s', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2118, 88, '秒', '″', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2119, 89, '分', '′', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2120, 90, '度', '°', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2121, 91, '弧度', 'rad', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2122, 92, '赫兹', 'Hz', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2123, 93, '微瓦', 'μW', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2124, 94, '毫瓦', 'mW', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2125, 95, '千瓦特', 'kW', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2126, 96, '瓦特', 'W', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2127, 97, '卡路里', 'cal', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2128, 98, '千瓦时', 'kW·h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2129, 99, '瓦时', 'Wh', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2130, 100, '电子伏', 'eV', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2131, 101, '千焦', 'kJ', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2132, 102, '焦耳', 'J', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2133, 103, '华氏度', '℉', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2134, 104, '开尔文', 'K', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2135, 105, '吨', 't', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2136, 106, '摄氏度', '°C', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2137, 107, '毫帕', 'mPa', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2138, 108, '百帕', 'hPa', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2139, 109, '千帕', 'kPa', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2140, 110, '帕斯卡', 'Pa', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2141, 111, '毫克', 'mg', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2142, 112, '克', 'g', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2143, 113, '千克', 'kg', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2144, 114, '牛', 'N', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2145, 115, '毫升', 'mL', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2146, 116, '升', 'L', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2147, 117, '立方毫米', 'mm³', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2148, 118, '立方厘米', 'cm³', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2149, 119, '立方千米', 'km³', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2150, 120, '立方米', 'm³', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2151, 121, '公顷', 'h㎡', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2152, 122, '平方厘米', 'c㎡', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2153, 123, '平方毫米', 'm㎡', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2154, 124, '平方千米', 'k㎡', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2155, 125, '平方米', '㎡', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2156, 126, '纳米', 'nm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2157, 127, '微米', 'μm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2158, 128, '毫米', 'mm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2159, 129, '厘米', 'cm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2160, 130, '分米', 'dm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2161, 131, '千米', 'km', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2162, 132, '米', 'm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', b'0');
INSERT INTO `system_dict_data` VALUES (2165, 1, 'HTTP', '1', 'iot_data_sink_type_enum', 0, 'default', '', '', '1', '2025-03-09 12:39:54', '1', '2025-06-24 12:44:47', b'0');
INSERT INTO `system_dict_data` VALUES (2166, 2, 'TCP', '2', 'iot_data_sink_type_enum', 0, 'default', '', '', '1', '2025-03-09 12:40:06', '1', '2025-06-24 12:44:46', b'0');
INSERT INTO `system_dict_data` VALUES (2167, 3, 'WebSocket', '3', 'iot_data_sink_type_enum', 0, 'default', '', '', '1', '2025-03-09 12:40:24', '1', '2025-06-24 12:44:45', b'0');
INSERT INTO `system_dict_data` VALUES (2168, 10, 'MQTT', '10', 'iot_data_sink_type_enum', 0, 'default', '', '', '1', '2025-03-09 12:40:37', '1', '2025-06-24 12:44:44', b'0');
INSERT INTO `system_dict_data` VALUES (2169, 20, 'Database', '20', 'iot_data_sink_type_enum', 0, 'default', '', '', '1', '2025-03-09 12:41:05', '1', '2025-06-24 12:44:44', b'0');
INSERT INTO `system_dict_data` VALUES (2170, 21, 'Redis Stream', '21', 'iot_data_sink_type_enum', 0, 'default', '', '', '1', '2025-03-09 12:41:18', '1', '2025-06-24 12:44:43', b'0');
INSERT INTO `system_dict_data` VALUES (2171, 30, 'RocketMQ', '30', 'iot_data_sink_type_enum', 0, 'default', '', '', '1', '2025-03-09 12:41:30', '1', '2025-06-24 12:44:42', b'0');
INSERT INTO `system_dict_data` VALUES (2172, 31, 'RabbitMQ', '31', 'iot_data_sink_type_enum', 0, 'default', '', '', '1', '2025-03-09 12:41:47', '1', '2025-06-24 12:44:41', b'0');
INSERT INTO `system_dict_data` VALUES (2173, 32, 'Kafka', '32', 'iot_data_sink_type_enum', 0, 'default', '', '', '1', '2025-03-09 12:41:59', '1', '2025-06-24 12:44:39', b'0');
INSERT INTO `system_dict_data` VALUES (2174, 1, '设备上下线变更', '1', 'iot_rule_scene_trigger_type_enum', 0, 'primary', '', '', '1', '2025-03-20 15:00:01', '\"1\"', '2025-07-06 10:28:16', b'0');
INSERT INTO `system_dict_data` VALUES (2175, 2, '物模型属性上报', '2', 'iot_rule_scene_trigger_type_enum', 0, 'primary', '', '', '1', '2025-03-20 15:00:09', '\"1\"', '2025-07-06 10:28:22', b'0');
INSERT INTO `system_dict_data` VALUES (2176, 1, '设备状态', 'state', 'iot_device_message_type_enum', 0, 'primary', '', '', '1', '2025-03-20 15:24:58', '1', '2025-03-20 15:24:58', b'0');
INSERT INTO `system_dict_data` VALUES (2177, 2, '设备属性', 'property', 'iot_device_message_type_enum', 0, 'primary', '', '', '1', '2025-03-20 15:25:09', '1', '2025-03-20 15:25:09', b'0');
INSERT INTO `system_dict_data` VALUES (2178, 3, '设备事件', 'event', 'iot_device_message_type_enum', 0, 'primary', '', '', '1', '2025-03-20 15:25:23', '1', '2025-03-20 15:25:23', b'0');
INSERT INTO `system_dict_data` VALUES (2179, 4, '设备服务', 'service', 'iot_device_message_type_enum', 0, 'primary', '', '', '1', '2025-03-20 15:25:39', '1', '2025-03-20 15:25:39', b'0');
INSERT INTO `system_dict_data` VALUES (2180, 5, '设备配置', 'config', 'iot_device_message_type_enum', 0, 'primary', '', '', '1', '2025-03-20 15:25:51', '1', '2025-03-20 15:25:57', b'0');
INSERT INTO `system_dict_data` VALUES (2181, 6, '设备 OTA', 'ota', 'iot_device_message_type_enum', 0, 'primary', '', '', '1', '2025-03-20 15:26:17', '1', '2025-03-20 15:26:17', b'0');
INSERT INTO `system_dict_data` VALUES (2182, 7, '设备注册', 'register', 'iot_device_message_type_enum', 0, 'primary', '', '', '1', '2025-03-20 15:26:35', '1', '2025-03-20 15:26:35', b'0');
INSERT INTO `system_dict_data` VALUES (2183, 8, '设备拓扑', 'topology', 'iot_device_message_type_enum', 0, 'primary', '', '', '1', '2025-03-20 15:26:46', '1', '2025-03-20 15:26:46', b'0');
INSERT INTO `system_dict_data` VALUES (2184, 1, '设备属性设置', '1', 'iot_rule_scene_action_type_enum', 0, 'primary', '', '', '1', '2025-03-28 15:27:12', '\"1\"', '2025-07-06 10:37:33', b'0');
INSERT INTO `system_dict_data` VALUES (2185, 2, '设备服务调用', '2', 'iot_rule_scene_action_type_enum', 0, 'primary', '', '', '1', '2025-03-28 15:27:25', '\"1\"', '2025-07-06 10:37:41', b'0');
INSERT INTO `system_dict_data` VALUES (2186, 100, '告警触发', '100', 'iot_rule_scene_action_type_enum', 0, 'primary', '', '', '1', '2025-03-28 15:27:35', '\"1\"', '2025-07-06 10:37:50', b'0');
INSERT INTO `system_dict_data` VALUES (3000, 16, '百川智能', 'BaiChuan', 'ai_platform', 0, '', '', '', '1', '2025-03-23 12:15:46', '1', '2025-03-23 12:15:46', b'0');
INSERT INTO `system_dict_data` VALUES (3001, 40, 'Vben5.0 Ant Design Schema 模版', '40', 'infra_codegen_front_type', 0, '', '', NULL, '1', '2025-04-23 21:47:47', '1', '2025-09-04 23:25:12', b'0');
INSERT INTO `system_dict_data` VALUES (3002, 6, '支付宝余额', '6', 'brokerage_withdraw_type', 0, '', '', 'API 打款', '1', '2025-05-10 08:24:49', '1', '2025-05-10 08:24:49', b'0');
INSERT INTO `system_dict_data` VALUES (3003, 1, 'Alink', 'Alink', 'iot_codec_type', 0, '', '', '阿里云 Alink', '1', '2025-06-12 22:56:06', '1', '2025-06-12 23:22:24', b'0');
INSERT INTO `system_dict_data` VALUES (3004, 3, 'WARN', '3', 'iot_alert_level', 0, 'warning', '', '', '1', '2025-06-27 20:32:22', '1', '2025-06-27 20:34:31', b'0');
INSERT INTO `system_dict_data` VALUES (3005, 1, 'INFO', '1', 'iot_alert_level', 0, 'primary', '', '', '1', '2025-06-27 20:33:28', '1', '2025-06-27 20:34:35', b'0');
INSERT INTO `system_dict_data` VALUES (3006, 5, 'ERROR', '5', 'iot_alert_level', 0, 'danger', '', '', '1', '2025-06-27 20:33:50', '1', '2025-06-27 20:33:50', b'0');
INSERT INTO `system_dict_data` VALUES (3007, 1, '短信', '1', 'iot_alert_receive_type', 0, '', '', '', '1', '2025-06-27 22:49:30', '1', '2025-06-27 22:49:30', b'0');
INSERT INTO `system_dict_data` VALUES (3008, 2, '邮箱', '2', 'iot_alert_receive_type', 0, '', '', '', '1', '2025-06-27 22:49:39', '1', '2025-06-27 22:50:07', b'0');
INSERT INTO `system_dict_data` VALUES (3009, 3, '站内信', '3', 'iot_alert_receive_type', 0, '', '', '', '1', '2025-06-27 22:50:20', '1', '2025-06-27 22:50:20', b'0');
INSERT INTO `system_dict_data` VALUES (3010, 1, '全部设备', '1', 'iot_ota_task_device_scope', 0, '', '', '', '1', '2025-07-02 09:43:09', '1', '2025-07-02 09:43:09', b'0');
INSERT INTO `system_dict_data` VALUES (3011, 2, '指定设备', '2', 'iot_ota_task_device_scope', 0, '', '', '', '1', '2025-07-02 09:43:15', '1', '2025-07-02 09:43:15', b'0');
INSERT INTO `system_dict_data` VALUES (3012, 10, '进行中', '10', 'iot_ota_task_status', 0, 'primary', '', '', '1', '2025-07-02 09:44:01', '\"1\"', '2025-07-02 09:44:21', b'0');
INSERT INTO `system_dict_data` VALUES (3013, 20, '已结束', '20', 'iot_ota_task_status', 0, 'success', '', '', '1', '2025-07-02 09:44:14', '\"1\"', '2025-07-02 23:56:12', b'0');
INSERT INTO `system_dict_data` VALUES (3014, 30, '已取消', '30', 'iot_ota_task_status', 0, 'danger', '', '', '1', '2025-07-02 09:44:36', '1', '2025-07-02 09:44:36', b'0');
INSERT INTO `system_dict_data` VALUES (3015, 0, '待推送', '0', 'iot_ota_task_record_status', 0, '', '', '', '1', '2025-07-02 09:45:16', '1', '2025-07-02 09:45:16', b'0');
INSERT INTO `system_dict_data` VALUES (3016, 10, '已推送', '10', 'iot_ota_task_record_status', 0, '', '', '', '1', '2025-07-02 09:45:25', '1', '2025-07-02 09:45:25', b'0');
INSERT INTO `system_dict_data` VALUES (3017, 20, '升级中', '20', 'iot_ota_task_record_status', 0, 'primary', '', '', '1', '2025-07-02 09:45:37', '1', '2025-07-02 09:45:37', b'0');
INSERT INTO `system_dict_data` VALUES (3018, 30, '升级成功', '30', 'iot_ota_task_record_status', 0, 'success', '', '', '1', '2025-07-02 09:45:47', '1', '2025-07-02 09:45:47', b'0');
INSERT INTO `system_dict_data` VALUES (3019, 40, '升级失败', '40', 'iot_ota_task_record_status', 0, 'danger', '', '', '1', '2025-07-02 09:46:02', '1', '2025-07-02 09:46:02', b'0');
INSERT INTO `system_dict_data` VALUES (3020, 50, '升级取消', '50', 'iot_ota_task_record_status', 0, 'warning', '', '', '1', '2025-07-02 09:46:09', '\"1\"', '2025-07-02 09:46:27', b'0');
INSERT INTO `system_dict_data` VALUES (3021, 1, 'IP 定位', '1', 'iot_location_type', 0, '', '', '', '1', '2025-07-05 09:56:46', '1', '2025-07-05 09:56:46', b'0');
INSERT INTO `system_dict_data` VALUES (3022, 2, '设备上报', '2', 'iot_location_type', 0, '', '', '', '1', '2025-07-05 09:56:57', '1', '2025-07-05 09:56:57', b'0');
INSERT INTO `system_dict_data` VALUES (3023, 3, '手动定位', '3', 'iot_location_type', 0, '', '', '', '1', '2025-07-05 09:57:05', '1', '2025-07-05 09:57:05', b'0');
INSERT INTO `system_dict_data` VALUES (3024, 3, '设备事件上报', '3', 'iot_rule_scene_trigger_type_enum', 0, '', '', '', '1', '2025-07-06 10:28:29', '1', '2025-07-06 10:28:29', b'0');
INSERT INTO `system_dict_data` VALUES (3025, 4, '设备服务调用', '4', 'iot_rule_scene_trigger_type_enum', 0, '', '', '', '1', '2025-07-06 10:28:35', '1', '2025-07-06 10:28:35', b'0');
INSERT INTO `system_dict_data` VALUES (3026, 100, '定时触发', '100', 'iot_rule_scene_trigger_type_enum', 0, '', '', '', '1', '2025-07-06 10:28:48', '1', '2025-07-06 10:28:48', b'0');
INSERT INTO `system_dict_data` VALUES (3027, 101, '告警恢复', '101', 'iot_rule_scene_action_type_enum', 0, '', '', '', '1', '2025-07-06 10:37:57', '1', '2025-07-06 10:37:57', b'0');
INSERT INTO `system_dict_data` VALUES (3028, 2, 'Anthropic', 'Anthropic', 'ai_platform', 0, '', '', '', '1', '2025-08-21 22:54:24', '1', '2025-08-21 22:57:58', b'0');
INSERT INTO `system_dict_data` VALUES (3029, 2, '谷歌 Gemini', 'Gemini', 'ai_platform', 0, '', '', '', '1', '2025-08-22 22:39:35', '1', '2025-08-22 22:44:49', b'0');
INSERT INTO `system_dict_data` VALUES (3030, 1, '文件系统', 'filesystem', 'ai_mcp_client_name', 0, '', '', '', '1', '2025-08-28 13:58:43', '1', '2025-08-28 21:19:42', b'0');
INSERT INTO `system_dict_data` VALUES (3031, 41, 'Vben5.0 Ant Design 标准模版', '41', 'infra_codegen_front_type', 0, '', '', '', '1', '2025-09-04 23:26:07', '1', '2025-09-04 23:26:07', b'0');
INSERT INTO `system_dict_data` VALUES (3032, 50, 'Vben5.0 Element Plus Schema 模版', '50', 'infra_codegen_front_type', 0, '', '', '', '1', '2025-09-04 23:26:38', '1', '2025-09-04 23:26:38', b'0');
INSERT INTO `system_dict_data` VALUES (3033, 51, 'Vben5.0 Element Plus 标准模版', '51', 'infra_codegen_front_type', 0, '', '', '', '1', '2025-09-04 23:26:49', '1', '2025-09-04 23:26:49', b'0');
INSERT INTO `system_dict_data` VALUES (3034, 1, 'ttt', 'tt', 'iot_ota_task_record_status', 0, 'success', '', NULL, '1', '2025-09-06 00:02:21', '1', '2025-09-06 00:02:31', b'0');

-- ----------------------------
-- Table structure for system_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `system_dict_type`;
CREATE TABLE `system_dict_type`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典名称',
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典类型',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态（0正常 1停用）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2008 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_dict_type
-- ----------------------------
INSERT INTO `system_dict_type` VALUES (1, '用户性别', 'system_user_sex', 0, NULL, 'admin', '2021-01-05 17:03:48', '1', '2022-05-16 20:29:32', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (6, '参数类型', 'infra_config_type', 0, NULL, 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:36:54', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (7, '通知类型', 'system_notice_type', 0, NULL, 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:35:26', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (9, '操作类型', 'infra_operate_type', 0, NULL, 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:01', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (10, '系统状态', 'common_status', 0, NULL, 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:21:28', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (11, 'Boolean 是否类型', 'infra_boolean_string', 0, 'boolean 转是否', '', '2021-01-19 03:20:08', '', '2022-02-01 16:37:10', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (104, '登陆结果', 'system_login_result', 0, '登陆结果', '', '2021-01-18 06:17:11', '', '2022-02-01 16:36:00', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (106, '代码生成模板类型', 'infra_codegen_template_type', 0, NULL, '', '2021-02-05 07:08:06', '1', '2022-05-16 20:26:50', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (107, '定时任务状态', 'infra_job_status', 0, NULL, '', '2021-02-07 07:44:16', '', '2022-02-01 16:51:11', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (108, '定时任务日志状态', 'infra_job_log_status', 0, NULL, '', '2021-02-08 10:03:51', '', '2022-02-01 16:50:43', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (109, '用户类型', 'user_type', 0, NULL, '', '2021-02-26 00:15:51', '', '2021-02-26 00:15:51', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (110, 'API 异常数据的处理状态', 'infra_api_error_log_process_status', 0, NULL, '', '2021-02-26 07:07:01', '', '2022-02-01 16:50:53', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (111, '短信渠道编码', 'system_sms_channel_code', 0, NULL, '1', '2021-04-05 01:04:50', '1', '2022-02-16 02:09:08', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (112, '短信模板的类型', 'system_sms_template_type', 0, NULL, '1', '2021-04-05 21:50:43', '1', '2022-02-01 16:35:06', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (113, '短信发送状态', 'system_sms_send_status', 0, NULL, '1', '2021-04-11 20:18:03', '1', '2022-02-01 16:35:09', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (114, '短信接收状态', 'system_sms_receive_status', 0, NULL, '1', '2021-04-11 20:27:14', '1', '2022-02-01 16:35:14', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (116, '登陆日志的类型', 'system_login_type', 0, '登陆日志的类型', '1', '2021-10-06 00:50:46', '1', '2022-02-01 16:35:56', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (117, 'OA 请假类型', 'bpm_oa_leave_type', 0, NULL, '1', '2021-09-21 22:34:33', '1', '2022-01-22 10:41:37', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (130, '支付渠道编码类型', 'pay_channel_code', 0, '支付渠道的编码', '1', '2021-12-03 10:35:08', '1', '2023-07-10 10:11:39', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (131, '支付回调状态', 'pay_notify_status', 0, '支付回调状态（包括退款回调）', '1', '2021-12-03 10:53:29', '1', '2023-07-19 18:09:43', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (132, '支付订单状态', 'pay_order_status', 0, '支付订单状态', '1', '2021-12-03 11:17:50', '1', '2021-12-03 11:17:50', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (134, '退款订单状态', 'pay_refund_status', 0, '退款订单状态', '1', '2021-12-10 16:42:50', '1', '2023-07-19 10:13:17', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (139, '流程实例的状态', 'bpm_process_instance_status', 0, '流程实例的状态', '1', '2022-01-07 23:46:42', '1', '2022-01-07 23:46:42', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (140, '流程实例的结果', 'bpm_task_status', 0, '流程实例的结果', '1', '2022-01-07 23:48:10', '1', '2024-03-08 22:42:03', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (141, '流程的表单类型', 'bpm_model_form_type', 0, '流程的表单类型', '103', '2022-01-11 23:50:45', '103', '2022-01-11 23:50:45', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (142, '任务分配规则的类型', 'bpm_task_candidate_strategy', 0, 'BPM 任务的候选人的策略', '103', '2022-01-12 23:21:04', '103', '2024-03-06 02:53:59', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (144, '代码生成的场景枚举', 'infra_codegen_scene', 0, '代码生成的场景枚举', '1', '2022-02-02 13:14:45', '1', '2022-03-10 16:33:46', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (145, '角色类型', 'system_role_type', 0, '角色类型', '1', '2022-02-16 13:01:46', '1', '2022-02-16 13:01:46', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (146, '文件存储器', 'infra_file_storage', 0, '文件存储器', '1', '2022-03-15 00:24:38', '1', '2022-03-15 00:24:38', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (147, 'OAuth 2.0 授权类型', 'system_oauth2_grant_type', 0, 'OAuth 2.0 授权类型（模式）', '1', '2022-05-12 00:20:52', '1', '2022-05-11 16:25:49', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (149, '商品 SPU 状态', 'product_spu_status', 0, '商品 SPU 状态', '1', '2022-10-24 21:19:04', '1', '2022-10-24 21:19:08', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (150, '优惠类型', 'promotion_discount_type', 0, '优惠类型', '1', '2022-11-01 12:46:06', '1', '2022-11-01 12:46:06', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (151, '优惠劵模板的有限期类型', 'promotion_coupon_template_validity_type', 0, '优惠劵模板的有限期类型', '1', '2022-11-02 00:06:20', '1', '2022-11-04 00:08:26', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (152, '营销的商品范围', 'promotion_product_scope', 0, '营销的商品范围', '1', '2022-11-02 00:28:01', '1', '2022-11-02 00:28:01', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (153, '优惠劵的状态', 'promotion_coupon_status', 0, '优惠劵的状态', '1', '2022-11-04 00:14:49', '1', '2022-11-04 00:14:49', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (154, '优惠劵的领取方式', 'promotion_coupon_take_type', 0, '优惠劵的领取方式', '1', '2022-11-04 19:12:27', '1', '2022-11-04 19:12:27', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (155, '促销活动的状态', 'promotion_activity_status', 0, '促销活动的状态', '1', '2022-11-04 22:54:23', '1', '2022-11-04 22:54:23', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (156, '营销的条件类型', 'promotion_condition_type', 0, '营销的条件类型', '1', '2022-11-04 22:59:23', '1', '2022-11-04 22:59:23', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (157, '交易售后状态', 'trade_after_sale_status', 0, '交易售后状态', '1', '2022-11-19 20:52:56', '1', '2022-11-19 20:52:56', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (158, '交易售后的类型', 'trade_after_sale_type', 0, '交易售后的类型', '1', '2022-11-19 21:04:09', '1', '2022-11-19 21:04:09', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (159, '交易售后的方式', 'trade_after_sale_way', 0, '交易售后的方式', '1', '2022-11-19 21:39:04', '1', '2022-11-19 21:39:04', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (160, '终端', 'terminal', 0, '终端', '1', '2022-12-10 10:50:50', '1', '2022-12-10 10:53:11', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (161, '交易订单的类型', 'trade_order_type', 0, '交易订单的类型', '1', '2022-12-10 16:33:54', '1', '2022-12-10 16:33:54', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (162, '交易订单的状态', 'trade_order_status', 0, '交易订单的状态', '1', '2022-12-10 16:48:44', '1', '2022-12-10 16:48:44', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (163, '交易订单项的售后状态', 'trade_order_item_after_sale_status', 0, '交易订单项的售后状态', '1', '2022-12-10 20:58:08', '1', '2022-12-10 20:58:08', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (164, '公众号自动回复的请求关键字匹配模式', 'mp_auto_reply_request_match', 0, '公众号自动回复的请求关键字匹配模式', '1', '2023-01-16 23:29:56', '1', '2023-01-16 23:29:56', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (165, '公众号的消息类型', 'mp_message_type', 0, '公众号的消息类型', '1', '2023-01-17 22:17:09', '1', '2023-01-17 22:17:09', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (166, '邮件发送状态', 'system_mail_send_status', 0, '邮件发送状态', '1', '2023-01-26 09:53:13', '1', '2023-01-26 09:53:13', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (167, '站内信模版的类型', 'system_notify_template_type', 0, '站内信模版的类型', '1', '2023-01-28 10:35:10', '1', '2023-01-28 10:35:10', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (168, '代码生成的前端类型', 'infra_codegen_front_type', 0, '', '1', '2023-04-12 23:57:52', '1', '2023-04-12 23:57:52', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (170, '快递计费方式', 'trade_delivery_express_charge_mode', 0, '用于商城交易模块配送管理', '1', '2023-05-21 22:45:03', '1', '2023-05-21 22:45:03', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (171, '积分业务类型', 'member_point_biz_type', 0, '', '1', '2023-06-10 12:15:00', '1', '2023-06-28 13:48:20', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (173, '支付通知类型', 'pay_notify_type', 0, NULL, '1', '2023-07-20 12:23:03', '1', '2023-07-20 12:23:03', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (174, '会员经验业务类型', 'member_experience_biz_type', 0, NULL, '', '2023-08-22 12:41:01', '', '2023-08-22 12:41:01', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (175, '交易配送类型', 'trade_delivery_type', 0, '', '1', '2023-08-23 00:03:14', '1', '2023-08-23 00:03:14', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (176, '分佣模式', 'brokerage_enabled_condition', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (177, '分销关系绑定模式', 'brokerage_bind_mode', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (178, '佣金提现类型', 'brokerage_withdraw_type', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (179, '佣金记录业务类型', 'brokerage_record_biz_type', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (180, '佣金记录状态', 'brokerage_record_status', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (181, '佣金提现状态', 'brokerage_withdraw_status', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (182, '佣金提现银行', 'brokerage_bank_name', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (183, '砍价记录的状态', 'promotion_bargain_record_status', 0, '', '1', '2023-10-05 10:41:08', '1', '2023-10-05 10:41:08', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (184, '拼团记录的状态', 'promotion_combination_record_status', 0, '', '1', '2023-10-08 07:24:25', '1', '2023-10-08 07:24:25', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (185, '回款-回款方式', 'crm_receivable_return_type', 0, '回款-回款方式', '1', '2023-10-18 21:54:10', '1', '2023-10-18 21:54:10', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (186, 'CRM 客户行业', 'crm_customer_industry', 0, 'CRM 客户所属行业', '1', '2023-10-28 22:57:07', '1', '2024-02-18 23:30:22', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (187, '客户等级', 'crm_customer_level', 0, 'CRM 客户等级', '1', '2023-10-28 22:59:12', '1', '2023-10-28 15:11:16', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (188, '客户来源', 'crm_customer_source', 0, 'CRM 客户来源', '1', '2023-10-28 23:00:34', '1', '2023-10-28 15:11:16', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (600, 'Banner 位置', 'promotion_banner_position', 0, '', '1', '2023-10-08 07:24:25', '1', '2023-11-04 13:04:02', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (601, '社交类型', 'system_social_type', 0, '', '1', '2023-11-04 13:03:54', '1', '2023-11-04 13:03:54', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (604, '产品状态', 'crm_product_status', 0, '', '1', '2023-10-30 21:47:59', '1', '2023-10-30 21:48:45', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (605, 'CRM 数据权限的级别', 'crm_permission_level', 0, '', '1', '2023-11-30 09:51:59', '1', '2023-11-30 09:51:59', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (606, 'CRM 审批状态', 'crm_audit_status', 0, '', '1', '2023-11-30 18:56:23', '1', '2023-11-30 18:56:23', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (607, 'CRM 产品单位', 'crm_product_unit', 0, '', '1', '2023-12-05 23:01:51', '1', '2023-12-05 23:01:51', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (608, 'CRM 跟进方式', 'crm_follow_up_type', 0, '', '1', '2024-01-15 20:48:05', '1', '2024-01-15 20:48:05', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (610, '转账订单状态', 'pay_transfer_status', 0, '', '1', '2023-10-28 16:18:32', '1', '2023-10-28 16:18:32', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (611, 'ERP 库存明细的业务类型', 'erp_stock_record_biz_type', 0, 'ERP 库存明细的业务类型', '1', '2024-02-05 18:07:02', '1', '2024-02-05 18:07:02', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (612, 'ERP 审批状态', 'erp_audit_status', 0, '', '1', '2024-02-06 00:00:07', '1', '2024-02-06 00:00:07', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (613, 'BPM 监听器类型', 'bpm_process_listener_type', 0, '', '1', '2024-03-23 12:52:24', '1', '2024-03-09 15:54:28', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (615, 'BPM 监听器值类型', 'bpm_process_listener_value_type', 0, '', '1', '2024-03-23 13:00:31', '1', '2024-03-23 13:00:31', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (616, '时间间隔', 'date_interval', 0, '', '1', '2024-03-29 22:50:09', '1', '2024-03-29 22:50:09', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (619, 'CRM 商机结束状态类型', 'crm_business_end_status_type', 0, '', '1', '2024-04-13 23:23:00', '1', '2024-04-13 23:23:00', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (620, 'AI 模型平台', 'ai_platform', 0, '', '1', '2024-05-09 22:27:38', '1', '2024-05-09 22:27:38', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (621, 'AI 绘画状态', 'ai_image_status', 0, '', '1', '2024-06-26 20:51:23', '1', '2024-06-26 20:51:23', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (622, 'AI 音乐状态', 'ai_music_status', 0, '', '1', '2024-06-27 22:45:07', '1', '2024-06-28 00:56:27', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (623, 'AI 音乐生成模式', 'ai_generate_mode', 0, '', '1', '2024-06-27 22:46:21', '1', '2024-06-28 01:22:29', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (624, '写作语气', 'ai_write_tone', 0, '', '1', '2024-07-07 15:19:02', '1', '2024-07-07 15:19:02', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (625, '写作语言', 'ai_write_language', 0, '', '1', '2024-07-07 15:18:52', '1', '2024-07-07 15:18:52', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (626, '写作长度', 'ai_write_length', 0, '', '1', '2024-07-07 15:18:41', '1', '2024-07-07 15:18:41', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (627, '写作格式', 'ai_write_format', 0, '', '1', '2024-07-07 15:14:34', '1', '2024-07-07 15:14:34', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (628, 'AI 写作类型', 'ai_write_type', 0, '', '1', '2024-07-10 21:25:29', '1', '2024-07-10 21:25:29', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (629, 'BPM 流程模型类型', 'bpm_model_type', 0, '', '1', '2024-08-26 15:21:43', '1', '2024-08-26 15:21:43', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (640, 'AI 模型类型', 'ai_model_type', 0, '', '1', '2025-03-03 12:24:07', '1', '2025-03-03 12:24:07', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (1001, 'IoT 产品设备类型', 'iot_product_device_type', 0, '', '1', '2024-08-10 11:54:30', '1', '2025-03-17 09:25:08', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (1002, 'IoT 产品状态', 'iot_product_status', 0, '', '1', '2024-08-10 12:06:09', '1', '2025-03-17 09:25:10', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (1004, 'IoT 联网方式', 'iot_net_type', 0, '', '1', '2024-09-06 22:04:13', '1', '2025-03-17 09:25:14', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (1006, 'IoT 设备状态', 'iot_device_state', 0, '', '1', '2024-09-21 08:12:55', '1', '2025-03-17 09:25:19', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (1007, 'IoT 物模型功能类型', 'iot_thing_model_type', 0, '', '1', '2024-09-29 20:02:36', '1', '2025-03-17 09:25:24', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (1011, 'IoT 物模型单位', 'iot_thing_model_unit', 0, '', '1', '2024-12-25 17:36:46', '1', '2025-03-17 09:25:35', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (1013, 'IoT 数据流转目的的类型枚举', 'iot_data_sink_type_enum', 0, '', '1', '2025-03-09 12:39:36', '1', '2025-06-24 12:45:24', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (1014, 'IoT 场景流转的触发类型枚举', 'iot_rule_scene_trigger_type_enum', 0, '', '1', '2025-03-20 14:59:44', '1', '2025-03-20 14:59:44', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (1015, 'IoT 设备消息类型枚举', 'iot_device_message_type_enum', 0, '', '1', '2025-03-20 15:01:15', '1', '2025-03-20 15:01:15', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (1016, 'IoT 规则场景的触发类型枚举', 'iot_rule_scene_action_type_enum', 0, '', '1', '2025-03-28 15:26:54', '1', '2025-03-28 15:29:13', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (2000, 'IoT 数据格式', 'iot_codec_type', 0, 'IoT 编解码器类型', '1', '2025-06-12 22:55:46', '1', '2025-06-12 22:55:46', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (2001, 'IoT 告警级别', 'iot_alert_level', 0, '', '1', '2025-06-27 20:30:57', '1', '2025-06-27 20:30:57', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (2002, 'IoT 告警', 'iot_alert_receive_type', 0, '', '1', '2025-06-27 22:49:19', '1', '2025-06-27 22:49:19', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (2003, 'IoT 固件设备范围', 'iot_ota_task_device_scope', 0, '', '1', '2025-07-02 09:42:49', '1', '2025-07-02 09:42:49', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (2004, 'IoT 固件升级任务状态', 'iot_ota_task_status', 0, '', '1', '2025-07-02 09:43:43', '1', '2025-07-02 09:43:43', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (2005, 'IoT 固件升级记录状态', 'iot_ota_task_record_status', 0, '', '1', '2025-07-02 09:45:02', '1', '2025-07-02 09:45:02', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (2006, 'IoT 定位类型', 'iot_location_type', 0, '', '1', '2025-07-05 09:56:25', '1', '2025-07-05 09:56:25', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (2007, 'AI MCP 客户端名字', 'ai_mcp_client_name', 0, '', '1', '2025-08-28 13:57:40', '1', '2025-08-28 13:57:40', b'0', '1970-01-01 00:00:00');

-- ----------------------------
-- Table structure for system_login_log
-- ----------------------------
DROP TABLE IF EXISTS `system_login_log`;
CREATE TABLE `system_login_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `log_type` bigint NOT NULL COMMENT '日志类型',
  `trace_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '链路追踪编号',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '用户编号',
  `user_type` tinyint NOT NULL DEFAULT 0 COMMENT '用户类型',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户账号',
  `result` tinyint NOT NULL COMMENT '登陆结果',
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户 IP',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '浏览器 UA',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_login_log
-- ----------------------------
INSERT INTO `system_login_log` VALUES (1, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-12 14:04:09', '1', '2026-01-12 14:04:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (2, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-12 14:04:09', '1', '2026-01-12 14:04:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (3, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-12 14:04:14', NULL, '2026-01-12 14:04:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (4, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-12 15:36:21', '1', '2026-01-12 15:36:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (5, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-12 15:36:23', NULL, '2026-01-12 15:36:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (6, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-12 15:43:45', '1', '2026-01-12 15:43:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (7, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-12 15:43:47', NULL, '2026-01-12 15:43:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (8, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-12 15:45:53', '1', '2026-01-12 15:45:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (9, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-12 15:45:54', NULL, '2026-01-12 15:45:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (10, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-12 18:22:06', '1', '2026-01-12 18:22:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (11, 100, '', 143, 2, 'zhangsan', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-12 18:22:20', NULL, '2026-01-12 18:22:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (12, 200, '', 143, 2, 'zhangsan', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '143', '2026-01-13 08:37:05', '143', '2026-01-13 08:37:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (13, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 08:37:14', NULL, '2026-01-13 08:37:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (14, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 08:40:48', '1', '2026-01-13 08:40:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (15, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 08:41:01', NULL, '2026-01-13 08:41:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (16, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 08:56:18', '1', '2026-01-13 08:56:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (17, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 08:56:20', NULL, '2026-01-13 08:56:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (18, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 11:16:40', '1', '2026-01-13 11:16:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (19, 100, '', 143, 2, 'zhangsan', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 11:16:52', NULL, '2026-01-13 11:16:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (20, 200, '', 143, 2, 'zhangsan', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '143', '2026-01-13 13:51:13', '143', '2026-01-13 13:51:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (21, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 13:54:02', NULL, '2026-01-13 13:54:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (22, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 14:14:58', '1', '2026-01-13 14:14:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (23, 100, '', 144, 2, 'lisi', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:15:07', NULL, '2026-01-13 14:15:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (24, 200, '', 144, 2, 'lisi', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '144', '2026-01-13 14:19:29', '144', '2026-01-13 14:19:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (25, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:19:37', NULL, '2026-01-13 14:19:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (26, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 14:23:53', '1', '2026-01-13 14:23:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (27, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:23:55', NULL, '2026-01-13 14:23:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (28, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:28:41', NULL, '2026-01-13 14:28:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (29, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 14:28:52', '1', '2026-01-13 14:28:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (30, 100, '', 143, 2, 'zhangsan', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:28:59', NULL, '2026-01-13 14:28:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (31, 200, '', 143, 2, 'zhangsan', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '143', '2026-01-13 14:29:06', '143', '2026-01-13 14:29:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (32, 100, '', 1, 2, 'admin', 10, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:29:13', NULL, '2026-01-13 14:29:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (33, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:29:17', NULL, '2026-01-13 14:29:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (34, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 14:33:52', '1', '2026-01-13 14:33:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (35, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:33:55', NULL, '2026-01-13 14:33:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (36, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:39:41', NULL, '2026-01-13 14:39:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (37, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 14:41:11', '1', '2026-01-13 14:41:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (38, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:41:13', NULL, '2026-01-13 14:41:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (39, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 14:42:18', '1', '2026-01-13 14:42:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (40, 100, '', 144, 2, 'lisi', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:42:25', NULL, '2026-01-13 14:42:25', b'0', 0);
INSERT INTO `system_login_log` VALUES (41, 200, '', 144, 2, 'lisi', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '144', '2026-01-13 14:42:34', '144', '2026-01-13 14:42:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (42, 100, '', 144, 2, 'lisi', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:42:48', NULL, '2026-01-13 14:42:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (43, 200, '', 144, 2, 'lisi', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '144', '2026-01-13 14:42:52', '144', '2026-01-13 14:42:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (44, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:43:01', NULL, '2026-01-13 14:43:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (45, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 14:43:23', '1', '2026-01-13 14:43:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (46, 100, '', 144, 2, 'lisi', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:43:27', NULL, '2026-01-13 14:43:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (47, 200, '', 144, 2, 'lisi', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '144', '2026-01-13 14:43:43', '144', '2026-01-13 14:43:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (48, 100, '', 1, 2, 'admin', 10, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:43:47', NULL, '2026-01-13 14:43:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (49, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 14:43:50', NULL, '2026-01-13 14:43:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (50, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 17:00:36', NULL, '2026-01-13 17:00:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (51, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 17:07:12', NULL, '2026-01-13 17:07:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (52, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 17:45:53', '1', '2026-01-13 17:45:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (53, 100, '', 144, 2, 'lisi', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-13 17:45:59', NULL, '2026-01-13 17:45:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (54, 100, '', 1, 2, 'admin', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-14 10:47:35', NULL, '2026-01-14 10:47:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (55, 100, '', 1, 2, 'admin', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', NULL, '2026-01-14 10:52:04', NULL, '2026-01-14 10:52:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (56, 100, '', 1, 2, 'admin', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254160e) XWEB/18055 Flue', NULL, '2026-01-14 11:24:40', NULL, '2026-01-14 11:24:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (57, 200, '', 144, 2, 'lisi', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '144', '2026-01-14 14:20:42', '144', '2026-01-14 14:20:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (58, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-14 14:20:49', NULL, '2026-01-14 14:20:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (59, 100, '', 1, 2, 'admin', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-14 19:41:12', NULL, '2026-01-14 19:41:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (60, 100, '', 1, 2, 'admin', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-14 20:16:44', NULL, '2026-01-14 20:16:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (61, 200, '', 1, 2, 'admin', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-14 20:24:28', '1', '2026-01-14 20:24:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (62, 100, '', 1, 2, 'admin', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-14 20:24:37', NULL, '2026-01-14 20:24:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (63, 200, '', 1, 2, 'admin', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-14 20:25:08', '1', '2026-01-14 20:25:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (64, 100, '', 1, 2, 'admin', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-14 20:32:22', NULL, '2026-01-14 20:32:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (65, 200, '', 1, 2, 'admin', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-14 20:33:04', '1', '2026-01-14 20:33:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (66, 100, '', 145, 2, 'lisi', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-14 20:33:10', NULL, '2026-01-14 20:33:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (67, 200, '', 145, 2, 'lisi', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '145', '2026-01-14 20:36:41', '145', '2026-01-14 20:36:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (68, 100, '', 1, 2, 'admin', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-14 20:36:48', NULL, '2026-01-14 20:36:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (69, 200, '', 1, 2, 'admin', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-14 20:37:16', '1', '2026-01-14 20:37:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (70, 100, '', 145, 2, 'lisi', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-14 20:37:22', NULL, '2026-01-14 20:37:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (71, 200, '', 145, 2, 'lisi', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '145', '2026-01-14 20:37:49', '145', '2026-01-14 20:37:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (72, 100, '', 1, 2, 'admin', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-14 20:37:53', NULL, '2026-01-14 20:37:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (73, 100, '', 1, 2, 'admin', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', NULL, '2026-01-15 08:49:15', NULL, '2026-01-15 08:49:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (74, 100, '', 146, 2, 'zhou123', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254160e) XWEB/18055 Flue', NULL, '2026-01-15 08:57:34', NULL, '2026-01-15 08:57:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (75, 200, '', 1, 2, 'admin', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', '1', '2026-01-15 09:07:24', '1', '2026-01-15 09:07:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (76, 100, '', 149, 2, 'jp123', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', NULL, '2026-01-15 09:07:39', NULL, '2026-01-15 09:07:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (77, 200, '', 149, 2, 'jp123', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', '149', '2026-01-15 09:08:32', '149', '2026-01-15 09:08:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (78, 100, '', 1, 2, 'admin', 10, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', NULL, '2026-01-15 09:08:55', NULL, '2026-01-15 09:08:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (79, 100, '', 1, 2, 'admin', 10, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', NULL, '2026-01-15 09:09:06', NULL, '2026-01-15 09:09:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (80, 100, '', 1, 2, 'admin', 10, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', NULL, '2026-01-15 09:09:40', NULL, '2026-01-15 09:09:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (81, 100, '', 1, 2, 'admin', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', NULL, '2026-01-15 09:10:16', NULL, '2026-01-15 09:10:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (82, 200, '', 146, 2, 'zhou123', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254160e) XWEB/18055 Flue', '146', '2026-01-15 09:11:44', '146', '2026-01-15 09:11:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (83, 100, '', 149, 2, 'jp123', 10, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254160e) XWEB/18055 Flue', NULL, '2026-01-15 09:12:11', NULL, '2026-01-15 09:12:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (84, 100, '', 149, 2, 'jp123', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254160e) XWEB/18055 Flue', NULL, '2026-01-15 09:12:27', NULL, '2026-01-15 09:12:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (85, 100, '', 147, 2, 'deng123', 10, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254162e) XWEB/18151 NT/6.1 Flue', NULL, '2026-01-15 09:30:30', NULL, '2026-01-15 09:30:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (86, 100, '', 147, 2, 'deng123', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254162e) XWEB/18151 NT/6.1 Flue', NULL, '2026-01-15 09:30:41', NULL, '2026-01-15 09:30:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (87, 100, '', 1, 2, 'admin', 10, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090c37) XWEB/14315 Flue', NULL, '2026-01-15 09:52:44', NULL, '2026-01-15 09:52:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (88, 100, '', 148, 2, 'yuan123', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090c37) XWEB/14315 Flue', NULL, '2026-01-15 09:53:15', NULL, '2026-01-15 09:53:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (89, 200, '', 149, 2, 'jp123', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254160e) XWEB/18055 Flue', '149', '2026-01-15 09:57:19', '149', '2026-01-15 09:57:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (90, 100, '', 146, 2, 'zhou123', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254160e) XWEB/18055 Flue', NULL, '2026-01-15 09:57:37', NULL, '2026-01-15 09:57:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (91, 200, '', 146, 2, 'zhou123', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254160e) XWEB/18055 Flue', '146', '2026-01-15 10:12:09', '146', '2026-01-15 10:12:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (92, 100, '', 149, 2, 'jp123', 0, '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254160e) XWEB/18055 Flue', NULL, '2026-01-15 10:12:23', NULL, '2026-01-15 10:12:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (93, 200, '', 1, 2, 'admin', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-15 10:27:55', '1', '2026-01-15 10:27:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (94, 100, '', 149, 2, 'jp123', 10, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-15 10:28:07', NULL, '2026-01-15 10:28:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (95, 100, '', 1, 2, 'admin', 10, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-15 10:28:23', NULL, '2026-01-15 10:28:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (96, 100, '', 1, 2, 'admin', 10, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-15 10:28:27', NULL, '2026-01-15 10:28:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (97, 100, '', 1, 2, 'admin', 10, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-15 10:28:28', NULL, '2026-01-15 10:28:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (98, 100, '', 1, 2, 'admin', 10, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-15 10:28:34', NULL, '2026-01-15 10:28:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (99, 100, '', 149, 2, 'jp123', 0, '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL, '2026-01-15 10:29:03', NULL, '2026-01-15 10:29:03', b'0', 0);

-- ----------------------------
-- Table structure for system_mail_account
-- ----------------------------
DROP TABLE IF EXISTS `system_mail_account`;
CREATE TABLE `system_mail_account`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `host` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'SMTP 服务器域名',
  `port` int NOT NULL COMMENT 'SMTP 服务器端口',
  `ssl_enable` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否开启 SSL',
  `starttls_enable` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否开启 STARTTLS',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '邮箱账号表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_mail_account
-- ----------------------------
INSERT INTO `system_mail_account` VALUES (1, '7684413@qq.com', '7684413@qq.com', '1234576', '127.0.0.1', 8080, b'0', b'0', '1', '2023-01-25 17:39:52', '1', '2025-04-04 16:34:40', b'0');
INSERT INTO `system_mail_account` VALUES (2, 'ydym_test@163.com', 'ydym_test@163.com', 'WBZTEINMIFVRYSOE', 'smtp.163.com', 465, b'1', b'0', '1', '2023-01-26 01:26:03', '1', '2025-07-26 21:57:55', b'0');
INSERT INTO `system_mail_account` VALUES (3, '76854114@qq.com', '3335', '11234', 'yunai1.cn', 466, b'0', b'0', '1', '2023-01-27 15:06:38', '1', '2023-01-27 07:08:36', b'1');
INSERT INTO `system_mail_account` VALUES (4, '7685413x@qq.com', '2', '3', '4', 5, b'1', b'0', '1', '2023-04-12 23:05:06', '1', '2023-04-12 15:05:11', b'1');

-- ----------------------------
-- Table structure for system_mail_log
-- ----------------------------
DROP TABLE IF EXISTS `system_mail_log`;
CREATE TABLE `system_mail_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户编号',
  `user_type` tinyint NULL DEFAULT NULL COMMENT '用户类型',
  `to_mails` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '接收邮箱地址',
  `cc_mails` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '抄送邮箱地址',
  `bcc_mails` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密送邮箱地址',
  `account_id` bigint NOT NULL COMMENT '邮箱账号编号',
  `from_mail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发送邮箱地址',
  `template_id` bigint NOT NULL COMMENT '模板编号',
  `template_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板编码',
  `template_nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '模版发送人名称',
  `template_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮件标题',
  `template_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮件内容',
  `template_params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮件参数',
  `send_status` tinyint NOT NULL DEFAULT 0 COMMENT '发送状态',
  `send_time` datetime NULL DEFAULT NULL COMMENT '发送时间',
  `send_message_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发送返回的消息 ID',
  `send_exception` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发送异常',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '邮件日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_mail_log
-- ----------------------------

-- ----------------------------
-- Table structure for system_mail_template
-- ----------------------------
DROP TABLE IF EXISTS `system_mail_template`;
CREATE TABLE `system_mail_template`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称',
  `code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板编码',
  `account_id` bigint NOT NULL COMMENT '发送的邮箱账号编号',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发送人名称',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板标题',
  `content` varchar(10240) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板内容',
  `params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '参数数组',
  `status` tinyint NOT NULL COMMENT '开启状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '邮件模版表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_mail_template
-- ----------------------------
INSERT INTO `system_mail_template` VALUES (13, '后台用户短信登录', 'admin-sms-login', 1, '奥特曼', '你猜我猜', '<p>您的验证码是{code}，名字是{name}</p>', '[\"code\",\"name\"]', 0, '3', '1', '2021-10-11 08:10:00', '1', '2023-12-02 19:51:14', b'0');
INSERT INTO `system_mail_template` VALUES (14, '测试模版', 'test_01', 2, '芋艿', '一个标题', '<p>你是 {key01} 吗？</p><p><br></p><p>是的话，赶紧 {key02} 一下！</p>', '[\"key01\",\"key02\"]', 0, NULL, '1', '2023-01-26 01:27:40', '1', '2025-07-26 21:48:45', b'0');
INSERT INTO `system_mail_template` VALUES (15, '3', '2', 2, '7', '4', '<p>45</p>', '[]', 1, '80', '1', '2023-01-27 15:50:35', '1', '2025-07-26 21:47:49', b'1');

-- ----------------------------
-- Table structure for system_menu
-- ----------------------------
DROP TABLE IF EXISTS `system_menu`;
CREATE TABLE `system_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `permission` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '权限标识',
  `type` tinyint NOT NULL COMMENT '菜单类型',
  `sort` int NOT NULL DEFAULT 0 COMMENT '显示顺序',
  `parent_id` bigint NOT NULL DEFAULT 0 COMMENT '父菜单ID',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '路由地址',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '组件路径',
  `component_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '组件名',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '菜单状态',
  `visible` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否可见',
  `keep_alive` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否缓存',
  `always_show` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否总是显示',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5077 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_menu
-- ----------------------------
INSERT INTO `system_menu` VALUES (1, '系统管理', '', 1, 100, 0, '/system', 'ep:setting', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (100, '用户管理', '', 2, 1, 1, 'user', 'ep:user', 'system/user/index', 'SystemUser', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (101, '角色管理', '', 2, 2, 1, 'role', 'ep:user-filled', 'system/role/index', 'SystemRole', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (104, '部门管理', '', 2, 3, 1, 'dept', 'ep:office-building', 'system/dept/index', 'SystemDept', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1001, '用户查询', 'system:user:query', 3, 1, 100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1002, '用户新增', 'system:user:create', 3, 2, 100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1003, '用户修改', 'system:user:update', 3, 3, 100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1004, '用户删除', 'system:user:delete', 3, 4, 100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1005, '用户导出', 'system:user:export', 3, 5, 100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1006, '用户导入', 'system:user:import', 3, 6, 100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1007, '重置密码', 'system:user:update-password', 3, 7, 100, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1013, '角色查询', 'system:role:query', 3, 1, 101, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1014, '角色新增', 'system:role:create', 3, 2, 101, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1015, '角色修改', 'system:role:update', 3, 3, 101, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1016, '角色删除', 'system:role:delete', 3, 4, 101, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1017, '角色导出', 'system:role:export', 3, 5, 101, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1063, '部门查询', 'system:dept:query', 3, 1, 104, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1064, '部门新增', 'system:dept:create', 3, 2, 104, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1065, '部门修改', 'system:dept:update', 3, 3, 104, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (1066, '部门删除', 'system:dept:delete', 3, 4, 104, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5001, '客户管理', '', 2, 10, 0, '/customer', 'ep:user', 'erp/customer/index', 'ErpCustomer', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5002, '客户查询', 'erp:customer:query', 3, 1, 5001, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5003, '客户新增', 'erp:customer:create', 3, 2, 5001, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5004, '客户修改', 'erp:customer:update', 3, 3, 5001, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5005, '客户删除', 'erp:customer:delete', 3, 4, 5001, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5010, '供应商管理', '', 2, 20, 0, '/supplier', 'ep:shop', 'erp/supplier/index', 'ErpSupplier', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5011, '供应商查询', 'erp:supplier:query', 3, 1, 5010, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5012, '供应商新增', 'erp:supplier:create', 3, 2, 5010, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5013, '供应商修改', 'erp:supplier:update', 3, 3, 5010, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5014, '供应商删除', 'erp:supplier:delete', 3, 4, 5010, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5020, '销售开单', '', 2, 30, 0, '/order/create', 'ep:edit', 'erp/order/create', 'ErpOrderCreate', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5021, '订单新增', 'erp:order:create', 3, 1, 5020, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5040, '订单管理', '', 2, 40, 0, '/order/manage', 'ep:folder-opened', 'erp/order/index', 'ErpOrder', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-13 06:42:46', b'0');
INSERT INTO `system_menu` VALUES (5041, '订单查询', 'erp:order:query', 3, 1, 5040, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5042, '订单新增', 'erp:order:create', 3, 2, 5040, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5043, '订单修改', 'erp:order:update', 3, 3, 5040, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5044, '订单删除', 'erp:order:delete', 3, 4, 5040, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5045, '订单审核', 'erp:order:approve', 3, 5, 5040, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-12 07:34:34', b'0');
INSERT INTO `system_menu` VALUES (5046, '填充成本', 'erp:order:fill-cost', 3, 6, 5040, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-12 07:34:34', b'0');
INSERT INTO `system_menu` VALUES (5047, '补充采购信息', 'erp:order:add-purchase', 3, 7, 5040, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5048, '导出Excel', 'erp:order:export', 3, 8, 5040, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5049, '标记客户已付款', 'erp:order:mark-paid', 3, 9, 5040, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5050, '采购付款', '', 2, 50, 0, '/payment', 'ep:money', 'erp/payment/index', 'ErpPayment', 0, b'0', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-13 01:34:32', b'0');
INSERT INTO `system_menu` VALUES (5051, '付款查询', 'erp:payment:query', 3, 1, 5050, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5052, '付款新增', 'erp:payment:create', 3, 2, 5050, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5053, '付款修改', 'erp:payment:update', 3, 3, 5050, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5054, '标记已付款', 'erp:payment:pay', 3, 4, 5050, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5055, '付款删除', 'erp:payment:delete', 3, 5, 5050, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5056, '导出报表', 'erp:payment:export', 3, 6, 5050, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5060, '收付款管理', '', 2, 55, 0, '/payment-plan', 'ep:calendar', 'erp/paymentPlan/index', 'ErpPaymentPlan', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-13 01:35:59', b'0');
INSERT INTO `system_menu` VALUES (5061, '付款计划查询', 'erp:payment-plan:query', 3, 1, 5060, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5062, '标记已付款', 'erp:payment-plan:pay', 3, 2, 5060, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_menu` VALUES (5070, '统计报表', '', 1, 60, 0, '/statistics', 'ep:data-analysis', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-13 00:40:02', 'admin', '2026-01-13 00:40:02', b'0');
INSERT INTO `system_menu` VALUES (5071, '供应商采购统计', '', 2, 1, 5070, 'supplier-purchase', '', 'erp/statistics/supplierPurchase/index', 'ErpSupplierPurchaseStatistics', 0, b'1', b'1', b'1', 'admin', '2026-01-13 00:40:02', 'admin', '2026-01-13 00:40:02', b'0');
INSERT INTO `system_menu` VALUES (5072, '统计查询', 'erp:statistics:query', 3, 1, 5071, '', '', '', '', 0, b'1', b'1', b'1', 'admin', '2026-01-13 00:40:02', 'admin', '2026-01-13 00:40:02', b'0');
INSERT INTO `system_menu` VALUES (5075, '客户销售统计', 'erp:statistics:query', 2, 2, 5070, 'customerSales', '', 'erp/statistics/customerSales/index', 'ErpCustomerSalesStatistics', 0, b'1', b'1', b'1', '1', '2026-01-13 02:31:05', '1', '2026-01-13 02:37:58', b'0');
INSERT INTO `system_menu` VALUES (5076, '订单编辑', 'erp:order:update', 2, 3, 0, '/order/edit/:id', '', 'erp/order/create', 'ErpOrderEdit', 0, b'0', b'1', b'0', '1', '2026-01-13 05:50:02', '1', '2026-01-13 06:37:38', b'0');

-- ----------------------------
-- Table structure for system_notice
-- ----------------------------
DROP TABLE IF EXISTS `system_notice`;
CREATE TABLE `system_notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告内容',
  `type` tinyint NOT NULL COMMENT '公告类型（1通知 2公告）',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '公告状态（0正常 1关闭）',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_notice
-- ----------------------------
INSERT INTO `system_notice` VALUES (1, '芋道的公众', '<p>新版本内容133222</p>', 1, 0, 'admin', '2021-01-05 17:03:48', '\"1\"', '2025-08-31 09:38:22', b'0', 1);
INSERT INTO `system_notice` VALUES (2, '维护通知：2018-07-01 系统凌晨维护', '<p><img src=\"http://test.yudao.iocoder.cn/b7cb3cf49b4b3258bf7309a09dd2f4e5.jpg\" alt=\"\" data-href=\"\">11112222<img src=\"http://test.yudao.iocoder.cn/fe44fc7bdb82ca421184b2eebbaee9e2148d4a1827479a4eb4521e11d2a062ba.png\" alt=\"image\" data-href=\"http://test.yudao.iocoder.cn/fe44fc7bdb82ca421184b2eebbaee9e2148d4a1827479a4eb4521e11d2a062ba.png\">3333</p>', 2, 1, 'admin', '2021-01-05 17:03:48', '1', '2025-04-18 23:56:40', b'0', 1);
INSERT INTO `system_notice` VALUES (4, '我是测试标题', '<p>哈哈哈哈123</p>', 1, 0, '110', '2022-02-22 01:01:25', '110', '2022-02-22 01:01:46', b'0', 121);

-- ----------------------------
-- Table structure for system_notify_message
-- ----------------------------
DROP TABLE IF EXISTS `system_notify_message`;
CREATE TABLE `system_notify_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `template_id` bigint NOT NULL COMMENT '模版编号',
  `template_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板编码',
  `template_nickname` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模版发送人名称',
  `template_content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模版内容',
  `template_type` int NOT NULL COMMENT '模版类型',
  `template_params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模版参数',
  `read_status` bit(1) NOT NULL COMMENT '是否已读',
  `read_time` datetime NULL DEFAULT NULL COMMENT '阅读时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '站内信消息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_notify_message
-- ----------------------------

-- ----------------------------
-- Table structure for system_notify_template
-- ----------------------------
DROP TABLE IF EXISTS `system_notify_template`;
CREATE TABLE `system_notify_template`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模版编码',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发送人名称',
  `content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模版内容',
  `type` tinyint NOT NULL COMMENT '类型',
  `params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '参数数组',
  `status` tinyint NOT NULL COMMENT '状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1004 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '站内信模板表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_notify_template
-- ----------------------------
INSERT INTO `system_notify_template` VALUES (1001, '付款计划即将到期提醒', 'payment_plan_upcoming', '系统通知', '付款单【{orderNo}】的第{stage}期付款计划将于3天后到期，供应商：{supplierName}，应付金额：{planAmount}元', 2, '[\"orderNo\",\"stage\",\"supplierName\",\"planAmount\"]', 0, '提前3天提醒', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');
INSERT INTO `system_notify_template` VALUES (1002, '付款计划今日到期提醒', 'payment_plan_due_today', '系统通知', '{salesmanName}业务员的付款计划今日到期，供应商：{supplierName}，应付金额：{planAmount}元', 2, '[\"salesmanName\",\"supplierName\",\"planAmount\"]', 0, '当日到期提醒', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-13 06:52:13', b'0');
INSERT INTO `system_notify_template` VALUES (1003, '付款计划已逾期警告', 'payment_plan_overdue', '系统通知', '付款单【{orderNo}】的第{stage}期付款计划已逾期{overdueDays}天，供应商：{supplierName}，应付金额：{planAmount}元', 2, '[\"orderNo\",\"stage\",\"supplierName\",\"planAmount\",\"overdueDays\"]', 0, '逾期警告', 'admin', '2026-01-11 13:06:55', 'admin', '2026-01-11 13:06:55', b'0');

-- ----------------------------
-- Table structure for system_oauth2_access_token
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_access_token`;
CREATE TABLE `system_oauth2_access_token`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `user_info` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户信息',
  `access_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '访问令牌',
  `refresh_token` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '刷新令牌',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
  `scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '授权范围',
  `expires_time` datetime NOT NULL COMMENT '过期时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_access_token`(`access_token` ASC) USING BTREE,
  INDEX `idx_refresh_token`(`refresh_token` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39926 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 访问令牌' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_oauth2_access_token
-- ----------------------------
INSERT INTO `system_oauth2_access_token` VALUES (39737, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', 'eec20b61913340fd93e6d69e59574063', '48ee41c02152434195befb5ad69e2fec', 'default', NULL, '2026-01-12 14:26:16', NULL, '2026-01-12 13:56:16', '1', '2026-01-12 14:04:08', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39738, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', '6c7396a7089d41f6858d6edde7652b12', '912851bdaf0a4999a4f8a2022ac1e09c', 'default', NULL, '2026-01-12 14:34:14', NULL, '2026-01-12 14:04:14', NULL, '2026-01-12 14:35:34', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39739, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', '2de5aa67c72c4c3c8076ca36e77b6c60', '912851bdaf0a4999a4f8a2022ac1e09c', 'default', NULL, '2026-01-12 15:05:34', NULL, '2026-01-12 14:35:34', NULL, '2026-01-12 15:05:54', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39740, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', '32c33a267939466c906f79212ff61da5', '912851bdaf0a4999a4f8a2022ac1e09c', 'default', NULL, '2026-01-12 15:35:54', NULL, '2026-01-12 15:05:54', NULL, '2026-01-12 15:36:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39741, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', '85da1463550543a08cfa837d5f6aa27f', '912851bdaf0a4999a4f8a2022ac1e09c', 'default', NULL, '2026-01-12 16:06:14', NULL, '2026-01-12 15:36:14', '1', '2026-01-12 15:36:21', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39742, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', '3cac2fb53ca7421bb42481ef03ae3105', '615a894750a24179ae55e16923e51191', 'default', NULL, '2026-01-12 16:06:23', NULL, '2026-01-12 15:36:23', '1', '2026-01-12 15:43:45', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39743, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', 'dadccf934e5843129a8b5e40c94b7bf9', '0ff8636dfa1e461bb50bb80a345b496c', 'default', NULL, '2026-01-12 16:13:47', NULL, '2026-01-12 15:43:47', '1', '2026-01-12 15:45:53', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39744, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', '235475f5825f4bd793618e056dc4ab4f', '49bba04a52da4261a24e94bd33595c51', 'default', NULL, '2026-01-12 16:15:54', NULL, '2026-01-12 15:45:54', NULL, '2026-01-12 16:17:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39745, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', '9eff8ba623f2408a810ac3257b0e0677', '49bba04a52da4261a24e94bd33595c51', 'default', NULL, '2026-01-12 16:47:11', NULL, '2026-01-12 16:17:11', NULL, '2026-01-12 16:47:25', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39746, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', 'c1bf3d27eb12435ab16b6919f8cc93bb', '49bba04a52da4261a24e94bd33595c51', 'default', NULL, '2026-01-12 17:17:25', NULL, '2026-01-12 16:47:25', NULL, '2026-01-12 17:18:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39747, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', '98abb714be7f43d78a52328556a6c71f', '49bba04a52da4261a24e94bd33595c51', 'default', NULL, '2026-01-12 17:48:11', NULL, '2026-01-12 17:18:11', NULL, '2026-01-12 17:48:50', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39748, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', '23cb85106ef34112b672d539fc4f77d4', '49bba04a52da4261a24e94bd33595c51', 'default', NULL, '2026-01-12 18:18:50', NULL, '2026-01-12 17:48:50', NULL, '2026-01-12 18:19:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39749, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', 'a4e0479a33d7412f9240652ff6e210f8', '49bba04a52da4261a24e94bd33595c51', 'default', NULL, '2026-01-12 18:49:11', NULL, '2026-01-12 18:19:11', '1', '2026-01-12 18:22:06', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39750, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'dffc0f6b9a6948b89eca26c19fa4581a', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-12 18:52:20', NULL, '2026-01-12 18:22:20', NULL, '2026-01-12 18:53:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39751, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'c5cfc31362414fb3876d90d1df0da9ac', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-12 19:23:11', NULL, '2026-01-12 18:53:11', NULL, '2026-01-12 19:23:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39752, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '2938e2541abd4153bfcfa7e7893e49b8', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-12 19:53:11', NULL, '2026-01-12 19:23:11', NULL, '2026-01-12 19:53:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39753, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'b7cd1db9123d4d19b584ad87da922851', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-12 20:23:11', NULL, '2026-01-12 19:53:11', NULL, '2026-01-12 20:23:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39754, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'a57e8ad167a34f86aca806103bd5866a', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-12 20:53:11', NULL, '2026-01-12 20:23:11', NULL, '2026-01-12 20:53:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39755, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'fe1d22453ca14485a87756ce3a310671', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-12 21:23:11', NULL, '2026-01-12 20:53:11', NULL, '2026-01-12 21:23:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39756, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '56f7ce6b902f430b85d516d505ba241d', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-12 21:53:11', NULL, '2026-01-12 21:23:11', NULL, '2026-01-12 21:53:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39757, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'a32dc77b33554e559dfd8845299ee28a', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-12 22:23:11', NULL, '2026-01-12 21:53:11', NULL, '2026-01-12 22:23:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39758, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'e3b410f0ecfa469aa0f83de3546ee1f8', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-12 22:53:11', NULL, '2026-01-12 22:23:11', NULL, '2026-01-12 22:53:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39759, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'ef021e34ba6f4945bdc981c534c7c40e', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-12 23:23:11', NULL, '2026-01-12 22:53:11', NULL, '2026-01-12 23:23:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39760, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '2598569309e64362aaeb104811d847d8', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-12 23:53:11', NULL, '2026-01-12 23:23:11', NULL, '2026-01-12 23:53:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39761, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '14b486ae1597479585e6d86bbb930354', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 00:23:11', NULL, '2026-01-12 23:53:11', NULL, '2026-01-13 00:23:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39762, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '8467904e2d7e45e0ba81a5de2ae612c3', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 00:53:11', NULL, '2026-01-13 00:23:11', NULL, '2026-01-13 00:53:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39763, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '0a8662a7a9804ea8986df67d5a2b27c9', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 01:23:11', NULL, '2026-01-13 00:53:11', NULL, '2026-01-13 01:23:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39764, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '5720c64047ab4ce4bfaf5917e046b3e0', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 01:53:11', NULL, '2026-01-13 01:23:11', NULL, '2026-01-13 01:53:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39765, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '469fc56a63714a84b0405067b195fcfe', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 02:23:11', NULL, '2026-01-13 01:53:11', NULL, '2026-01-13 02:23:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39766, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '208b916eb5304ecc994780392389e081', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 02:53:11', NULL, '2026-01-13 02:23:11', NULL, '2026-01-13 02:53:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39767, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'bdc50cb7a41c4ea1af2101a41bebaa37', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 03:23:11', NULL, '2026-01-13 02:53:11', NULL, '2026-01-13 03:23:11', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39768, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '4a4f17c285f44b9d8c2b9c23f52940aa', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 03:53:11', NULL, '2026-01-13 03:23:11', NULL, '2026-01-13 03:53:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39769, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'aba99e123eba47e5a96313dfdaef6f3e', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 04:23:14', NULL, '2026-01-13 03:53:14', NULL, '2026-01-13 04:23:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39770, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '733a726d7ecb4288ab34ce4c0c3d300e', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 04:53:14', NULL, '2026-01-13 04:23:14', NULL, '2026-01-13 04:53:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39771, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'af3d63e362814427a80b239190cde24a', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 05:23:14', NULL, '2026-01-13 04:53:14', NULL, '2026-01-13 05:23:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39772, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '2e62a7623d0d430b8033b47c08e113ec', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 05:53:14', NULL, '2026-01-13 05:23:14', NULL, '2026-01-13 05:53:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39773, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '5678f96ab78a4ba28255658746069be3', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 06:23:14', NULL, '2026-01-13 05:53:14', NULL, '2026-01-13 06:23:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39774, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'f589d57ebb614233890ec76169d69fa5', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 06:53:14', NULL, '2026-01-13 06:23:14', NULL, '2026-01-13 06:53:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39775, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'f6f92eff70b24cbc8782205bd3ea4336', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 07:23:14', NULL, '2026-01-13 06:53:14', NULL, '2026-01-13 07:23:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39776, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', '8e06b6c44f234ff2b0930f24438a0bcb', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 07:53:14', NULL, '2026-01-13 07:23:14', NULL, '2026-01-13 07:53:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39777, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'ffcacc51007c4607b1ec5e2c9f886d80', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 08:23:14', NULL, '2026-01-13 07:53:14', NULL, '2026-01-13 08:23:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39778, 143, 2, '{\"nickname\":\"张三\",\"deptId\":null}', 'c4ebb44040bb41329d7726c1e6e858f0', 'a2caf384d66946849ea656ed17ce820d', 'default', NULL, '2026-01-13 08:53:14', NULL, '2026-01-13 08:23:14', '143', '2026-01-13 08:37:05', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39779, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', '4caeca9088de4e01adbba35953410e84', '8d315ab4abc2428ab73f4bfb4df25d69', 'default', NULL, '2026-01-13 09:07:14', NULL, '2026-01-13 08:37:14', '1', '2026-01-13 08:40:48', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39780, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":null}', '4ad6504088b74c7d9096fc22329a2a07', '954db1fd9ab24e19b619c9f500e5a042', 'default', NULL, '2026-01-13 09:11:01', NULL, '2026-01-13 08:41:01', '1', '2026-01-13 08:56:18', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39781, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '013d37ad6fa34386adb3f748a6e23e33', 'aedd849820db4d06aec9623cf7c4a741', 'default', NULL, '2026-01-13 09:26:20', NULL, '2026-01-13 08:56:20', NULL, '2026-01-13 09:27:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39782, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'b1a450a09ffe4e4e94a8ec4b7f7fd682', 'aedd849820db4d06aec9623cf7c4a741', 'default', NULL, '2026-01-13 09:57:14', NULL, '2026-01-13 09:27:14', NULL, '2026-01-13 10:29:22', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39783, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '5792ab3002e54ce78cc6885f35ae2ae2', 'aedd849820db4d06aec9623cf7c4a741', 'default', NULL, '2026-01-13 10:59:22', NULL, '2026-01-13 10:29:22', NULL, '2026-01-13 10:59:33', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39784, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '7bbe9365e4b84955853968f0b28092f9', 'aedd849820db4d06aec9623cf7c4a741', 'default', NULL, '2026-01-13 11:29:33', NULL, '2026-01-13 10:59:33', '1', '2026-01-13 11:16:40', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39785, 143, 2, '{\"nickname\":\"张三\",\"deptId\":\"118\"}', 'd8a474b162b84ccd982464519ec38a3f', 'da679510b8cf455083f43d1c40c35f1c', 'default', NULL, '2026-01-13 11:46:52', NULL, '2026-01-13 11:16:52', NULL, '2026-01-13 11:47:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39786, 143, 2, '{\"nickname\":\"张三\",\"deptId\":\"118\"}', 'eade6f4b660b48d28417ae64ada599a8', 'da679510b8cf455083f43d1c40c35f1c', 'default', NULL, '2026-01-13 12:17:14', NULL, '2026-01-13 11:47:14', NULL, '2026-01-13 12:17:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39787, 143, 2, '{\"nickname\":\"张三\",\"deptId\":\"118\"}', '171b448e393c4e5ab9d274c65a3ec811', 'da679510b8cf455083f43d1c40c35f1c', 'default', NULL, '2026-01-13 12:47:14', NULL, '2026-01-13 12:17:14', NULL, '2026-01-13 12:47:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39788, 143, 2, '{\"nickname\":\"张三\",\"deptId\":\"118\"}', '89b4a669aa0548e4adf52a906690287e', 'da679510b8cf455083f43d1c40c35f1c', 'default', NULL, '2026-01-13 13:17:14', NULL, '2026-01-13 12:47:14', NULL, '2026-01-13 13:17:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39789, 143, 2, '{\"nickname\":\"张三\",\"deptId\":\"118\"}', '2e9fcffe4c9d4b8b9a010c720e287e2a', 'da679510b8cf455083f43d1c40c35f1c', 'default', NULL, '2026-01-13 13:47:14', NULL, '2026-01-13 13:17:14', NULL, '2026-01-13 13:47:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39790, 143, 2, '{\"nickname\":\"张三\",\"deptId\":\"118\"}', '0f75fb7e274f461cbc9f887548a01c38', 'da679510b8cf455083f43d1c40c35f1c', 'default', NULL, '2026-01-13 14:17:14', NULL, '2026-01-13 13:47:14', '143', '2026-01-13 13:51:13', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39791, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'd04aad1c78724e40ab20b3a933e04b59', 'ca0cf700e68a4f2e8c5363228fc58def', 'default', NULL, '2026-01-13 14:24:03', NULL, '2026-01-13 13:54:03', '1', '2026-01-13 14:14:58', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39792, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '60ca891bba06489e868d4d19bf0f55b3', '718fd22155f24e689a97366eb94c5280', 'default', NULL, '2026-01-13 14:45:07', NULL, '2026-01-13 14:15:07', '144', '2026-01-13 14:19:29', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39793, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'b4172aeb38f94dd58aba17a40bf7a733', '64c478008d1947d984fdf2a8e62990ed', 'default', NULL, '2026-01-13 14:49:37', NULL, '2026-01-13 14:19:37', '1', '2026-01-13 14:23:53', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39794, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '164ccbc86f524e9ab65f38c5b38d44ce', 'aceaed2b3aec4c768a1ea0f21e8c9361', 'default', NULL, '2026-01-13 14:53:55', NULL, '2026-01-13 14:23:55', NULL, '2026-01-13 14:23:55', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39795, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'd2fd650a39ab4d8695698453bfcf86af', '883ef91adea1426d9835b87e07119622', 'default', NULL, '2026-01-13 14:58:42', NULL, '2026-01-13 14:28:42', '1', '2026-01-13 14:28:52', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39796, 143, 2, '{\"nickname\":\"张三\",\"deptId\":\"118\"}', '5fdf8d1580da4beea52630fcb46c2a3e', 'bb302dd0cf0a4c18b90829a22c98fd5b', 'default', NULL, '2026-01-13 14:58:59', NULL, '2026-01-13 14:28:59', '143', '2026-01-13 14:29:06', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39797, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '33a564ee8abd4309b7b20a23e05e6789', '7e38675e91564bbab0d1d55968a6ac8f', 'default', NULL, '2026-01-13 14:59:17', NULL, '2026-01-13 14:29:17', '1', '2026-01-13 14:33:52', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39798, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'a976c9d9a7d140be99e57942a108446a', 'ba8de4af0ca74fbdacfb8446667fbcfc', 'default', NULL, '2026-01-13 15:03:55', NULL, '2026-01-13 14:33:55', NULL, '2026-01-13 14:33:55', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39799, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '285b4372681542879639cf99eb5c4212', '0a63733ef00e4c0e8b37e16f91043951', 'default', NULL, '2026-01-13 15:09:41', NULL, '2026-01-13 14:39:41', '1', '2026-01-13 14:41:10', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39800, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '420a5d6122ce4a8a86690f2dabc17362', '4698341c6da34314875d0194d275b932', 'default', NULL, '2026-01-13 15:11:13', NULL, '2026-01-13 14:41:13', '1', '2026-01-13 14:42:18', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39801, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '67078600e23e4794a9f997d846552dfb', 'afcacde8dbd94da19d6883e0fbfca468', 'default', NULL, '2026-01-13 15:12:25', NULL, '2026-01-13 14:42:25', '144', '2026-01-13 14:42:34', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39802, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', 'f752c230849442629e197c065590d25a', '80edb98773c3483fb3047b5a78ec6fef', 'default', NULL, '2026-01-13 15:12:48', NULL, '2026-01-13 14:42:48', '144', '2026-01-13 14:42:52', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39803, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'd80c5cc79fc94496be6e39ec9827a43c', '19f7f7a1670d40659710c063b3004148', 'default', NULL, '2026-01-13 15:13:01', NULL, '2026-01-13 14:43:01', '1', '2026-01-13 14:43:23', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39804, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', 'ec967b04e1de491b9ddb6d8473e4664e', '2369aba685bf42c492fc23d361b6018b', 'default', NULL, '2026-01-13 15:13:27', NULL, '2026-01-13 14:43:27', '144', '2026-01-13 14:43:43', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39805, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'eeb4764686f547848090d1bc4767bf81', '65915561e46b423fb7d42d8109d4056e', 'default', NULL, '2026-01-13 15:13:50', NULL, '2026-01-13 14:43:50', NULL, '2026-01-13 15:15:37', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39806, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '4f991220bc694e98b534820ee8cbe076', '65915561e46b423fb7d42d8109d4056e', 'default', NULL, '2026-01-13 15:45:37', NULL, '2026-01-13 15:15:37', NULL, '2026-01-13 15:45:46', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39807, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '41e1ce2ce1a84de7b0edd6c433434908', '65915561e46b423fb7d42d8109d4056e', 'default', NULL, '2026-01-13 16:15:46', NULL, '2026-01-13 15:45:46', NULL, '2026-01-13 16:16:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39808, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'be5c3105939b4fe78382d0b8d2aa74cb', '65915561e46b423fb7d42d8109d4056e', 'default', NULL, '2026-01-13 16:46:14', NULL, '2026-01-13 16:16:14', NULL, '2026-01-13 16:46:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39809, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'c9a11c09b45846018be6dcaf259b85d0', '65915561e46b423fb7d42d8109d4056e', 'default', NULL, '2026-01-13 17:16:14', NULL, '2026-01-13 16:46:14', NULL, '2026-01-13 16:46:14', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39810, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '13727220ab894e29a0a916d624ddbcbf', '3b4535bd10954f83af363b99e117ccab', 'default', NULL, '2026-01-13 17:30:37', NULL, '2026-01-13 17:00:37', NULL, '2026-01-13 17:00:37', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39811, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'ca088ba498954f0db0454f424cd876ff', '677c141ab083411dadc7b173323aa0f6', 'default', NULL, '2026-01-13 17:37:12', NULL, '2026-01-13 17:07:12', NULL, '2026-01-13 17:37:27', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39812, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'a4d0563c5ec147419623e58512f792b0', '677c141ab083411dadc7b173323aa0f6', 'default', NULL, '2026-01-13 18:07:28', NULL, '2026-01-13 17:37:28', '1', '2026-01-13 17:45:53', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39813, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '96f9472581bc450181f9cd159765fbfd', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-13 18:15:59', NULL, '2026-01-13 17:45:59', NULL, '2026-01-13 18:16:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39814, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', 'e8ab9b107be448969b773db4f741d7a2', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-13 18:46:14', NULL, '2026-01-13 18:16:14', NULL, '2026-01-13 18:46:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39815, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '6683d7358c774c0d9700fb6e4c664c32', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-13 19:16:14', NULL, '2026-01-13 18:46:14', NULL, '2026-01-13 19:16:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39816, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '3e909b5cde754e78bd0a1562f9f353a7', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-13 19:46:14', NULL, '2026-01-13 19:16:14', NULL, '2026-01-13 19:46:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39817, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '62a9d1483fa7442988c3fac69f7c01ca', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-13 20:16:14', NULL, '2026-01-13 19:46:14', NULL, '2026-01-13 20:16:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39818, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', 'cc6f9ad027b7471eafab3f12d29fb3e1', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-13 20:46:14', NULL, '2026-01-13 20:16:14', NULL, '2026-01-13 20:46:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39819, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '751b17dca3644b7989e270bfd58c6e0d', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-13 21:16:14', NULL, '2026-01-13 20:46:14', NULL, '2026-01-13 21:16:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39820, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '6c90a08d12f7484ea5a0e938dbda4741', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-13 21:46:14', NULL, '2026-01-13 21:16:14', NULL, '2026-01-13 21:46:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39821, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '66dafde392a84eba9b212294922b7062', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-13 22:16:14', NULL, '2026-01-13 21:46:14', NULL, '2026-01-13 22:16:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39822, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', 'f52fe7e28d464d5baee89bd237195e9e', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-13 22:46:14', NULL, '2026-01-13 22:16:14', NULL, '2026-01-13 22:46:14', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39823, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', 'b84cf799a46541859d49ac31a6ffee83', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-13 23:16:14', NULL, '2026-01-13 22:46:14', NULL, '2026-01-13 23:16:18', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39824, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '6e63d1f2d394407ba842d414c5e7133e', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-13 23:46:18', NULL, '2026-01-13 23:16:18', NULL, '2026-01-13 23:47:18', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39825, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', 'b7cc28e84afc4290b9dd021dab65979d', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-14 00:17:18', NULL, '2026-01-13 23:47:18', NULL, '2026-01-14 00:18:18', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39826, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '588166e5b4dc4be7b9b031b68d3a6fda', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-14 00:48:18', NULL, '2026-01-14 00:18:18', NULL, '2026-01-14 00:49:18', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39827, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', 'dc3c1ff8f8eb47f8b0f918dba24a2572', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-14 01:19:18', NULL, '2026-01-14 00:49:18', NULL, '2026-01-14 01:20:18', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39828, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '8c27c6d39fa648f3a9e68eeb2f727353', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-14 01:50:18', NULL, '2026-01-14 01:20:18', NULL, '2026-01-14 01:51:18', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39829, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '3145f1ea07d3470d90ace4bbf5e7eef2', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-14 02:21:18', NULL, '2026-01-14 01:51:18', NULL, '2026-01-14 02:22:18', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39830, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '20d066b4c26646e79bf9ec65fc06b7ff', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-14 02:52:18', NULL, '2026-01-14 02:22:18', NULL, '2026-01-14 02:53:18', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39831, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', '4dcd782a948f46deaa5fe90e25550b01', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-14 03:23:18', NULL, '2026-01-14 02:53:18', NULL, '2026-01-14 14:17:49', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39832, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'd6fe567fcc5b4293b10cbbedfa651767', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 11:17:35', NULL, '2026-01-14 10:47:35', NULL, '2026-01-14 11:17:40', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39833, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'eb1ca69930424ee5931b1d0bece42427', 'e79670d0f70a4a81b7dfb52e324471dd', 'default', NULL, '2026-01-14 11:22:04', NULL, '2026-01-14 10:52:04', NULL, '2026-01-14 10:52:04', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39834, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'af860f6b7d9f42bfa91aead9816fb957', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 11:47:40', NULL, '2026-01-14 11:17:40', NULL, '2026-01-14 11:49:40', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39835, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '8301310ef5e1455ebd70beac34695d49', '2c45ece118674e95b7f163c58a341455', 'default', NULL, '2026-01-14 11:54:40', NULL, '2026-01-14 11:24:40', NULL, '2026-01-14 11:24:40', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39836, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'fc770d29fe7144ab9f4394fa69cb5fe8', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 12:19:40', NULL, '2026-01-14 11:49:40', NULL, '2026-01-14 12:21:40', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39837, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'f1d38eefd56a4159888530df75309fd9', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 12:51:40', NULL, '2026-01-14 12:21:40', NULL, '2026-01-14 12:53:40', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39838, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'dea814895fe04750b9bff040ebd39b42', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 13:23:40', NULL, '2026-01-14 12:53:40', NULL, '2026-01-14 13:23:40', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39839, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'c81101c378f04f49834c517a3c10d35e', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 13:53:40', NULL, '2026-01-14 13:23:40', NULL, '2026-01-14 13:54:45', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39840, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'dbf2aa485f85408dbbc41dea0a1734f8', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 14:24:45', NULL, '2026-01-14 13:54:45', NULL, '2026-01-14 14:25:17', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39841, 144, 2, '{\"nickname\":\"李四\",\"deptId\":\"117\"}', 'db7085e7d5f34c8c861ed0c332566c2e', '458483065d45459fa774c51a3ce9363d', 'default', NULL, '2026-01-14 14:47:49', NULL, '2026-01-14 14:17:49', '144', '2026-01-14 14:20:42', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39842, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'e69da62f5832402caf936bf77e39600b', '3a88ab5ebb514e9a826425491e184be1', 'default', NULL, '2026-01-14 14:50:49', NULL, '2026-01-14 14:20:49', NULL, '2026-01-14 14:51:38', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39843, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '893b59baa78a4458b2e8ba98d6b8bcf0', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 14:55:17', NULL, '2026-01-14 14:25:17', NULL, '2026-01-14 14:55:40', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39844, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'e64d95d5686f4167b5cec2428658ee2f', '3a88ab5ebb514e9a826425491e184be1', 'default', NULL, '2026-01-14 15:21:38', NULL, '2026-01-14 14:51:38', NULL, '2026-01-14 15:22:07', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39845, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '80209e0366ba4c958568f9f2adb1187c', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 15:25:40', NULL, '2026-01-14 14:55:40', NULL, '2026-01-14 15:25:41', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39846, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '29306b751c264664a6ca233e349bdc32', '3a88ab5ebb514e9a826425491e184be1', 'default', NULL, '2026-01-14 15:52:07', NULL, '2026-01-14 15:22:07', NULL, '2026-01-14 15:52:38', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39847, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '77ffac724bf94c3faf1d86f75bd38ac5', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 15:55:41', NULL, '2026-01-14 15:25:41', NULL, '2026-01-14 15:57:41', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39848, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'd43717ba59ae4a628a37035e08b785ff', '3a88ab5ebb514e9a826425491e184be1', 'default', NULL, '2026-01-14 16:22:38', NULL, '2026-01-14 15:52:38', NULL, '2026-01-14 16:22:38', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39849, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '79da27b24ff641cf9f6244e3533ee9dc', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 16:27:41', NULL, '2026-01-14 15:57:41', NULL, '2026-01-14 16:29:41', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39850, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '79fc6865a8da4fad9724f7557a5c9387', '3a88ab5ebb514e9a826425491e184be1', 'default', NULL, '2026-01-14 16:52:39', NULL, '2026-01-14 16:22:39', NULL, '2026-01-14 16:52:58', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39851, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'c65d39e395ec4ec8acf37d8baa7f4732', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 16:59:41', NULL, '2026-01-14 16:29:41', NULL, '2026-01-14 17:01:41', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39852, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '0019fd4d449f47afa3c5bc65549eb6ae', '3a88ab5ebb514e9a826425491e184be1', 'default', NULL, '2026-01-14 17:22:59', NULL, '2026-01-14 16:52:59', NULL, '2026-01-14 17:23:48', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39853, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'ebea47050dda47debbc396eb1f230267', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 17:31:41', NULL, '2026-01-14 17:01:41', NULL, '2026-01-14 17:33:41', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39854, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '278d9c70a29c47ce9c5a716cea21783a', '3a88ab5ebb514e9a826425491e184be1', 'default', NULL, '2026-01-14 17:53:48', NULL, '2026-01-14 17:23:48', NULL, '2026-01-14 17:55:38', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39855, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '0392c24a1b314744be70c57f12bd8d34', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 18:03:41', NULL, '2026-01-14 17:33:41', NULL, '2026-01-14 18:05:15', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39856, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '48ce0cd78fd64acebd177dd3ef39a331', '3a88ab5ebb514e9a826425491e184be1', 'default', NULL, '2026-01-14 18:25:38', NULL, '2026-01-14 17:55:38', NULL, '2026-01-14 18:25:38', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39857, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '4f0a3297b5c84625b3a13879326b5e16', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 18:35:15', NULL, '2026-01-14 18:05:15', NULL, '2026-01-14 18:35:41', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39858, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'd41fd3c1b9344779a3e7c7383f2190cc', '3a88ab5ebb514e9a826425491e184be1', 'default', NULL, '2026-01-14 18:55:38', NULL, '2026-01-14 18:25:38', NULL, '2026-01-14 18:55:38', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39859, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '16df35c7cffa45abab6321896495589d', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 19:05:41', NULL, '2026-01-14 18:35:41', NULL, '2026-01-14 19:25:49', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39860, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '32a1f215b17e4ceb85131113d62affb6', '3a88ab5ebb514e9a826425491e184be1', 'default', NULL, '2026-01-14 19:25:38', NULL, '2026-01-14 18:55:38', NULL, '2026-01-14 19:25:38', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39861, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'f97a84ff1c7140adafae929e96ff817a', '3a88ab5ebb514e9a826425491e184be1', 'default', NULL, '2026-01-14 19:55:39', NULL, '2026-01-14 19:25:39', NULL, '2026-01-14 19:25:39', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39862, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'dde0ac8d4b66437882d06d8c4f46cb43', '23985e594cdc4becb84e24d47eb9d1b5', 'default', NULL, '2026-01-14 19:55:50', NULL, '2026-01-14 19:25:50', NULL, '2026-01-14 19:25:50', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39863, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'c7a7d1035dea4ee9adc0acffba73681c', 'f12ecca6fee04bf5a2fd4e021dc0ec61', 'default', NULL, '2026-01-14 20:11:13', NULL, '2026-01-14 19:41:13', NULL, '2026-01-14 19:41:13', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39864, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'a93b820e25af4a4b80879b76a7ad37e9', 'c44c24e1378847ed8bfa4e89aa90d42a', 'default', NULL, '2026-01-14 20:46:44', NULL, '2026-01-14 20:16:44', '1', '2026-01-14 20:24:28', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39865, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'a4862603618847c2a2e24d9b4391c57c', 'ff4b2f418bf94924aff1c1b4fcf85a3e', 'default', NULL, '2026-01-14 20:54:37', NULL, '2026-01-14 20:24:37', '1', '2026-01-14 20:25:08', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39866, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '94d5983b9c4d4ed9af96a7b83a6549d6', '50154ffffaa74c7b9fe876e53f486ba5', 'default', NULL, '2026-01-14 21:02:22', NULL, '2026-01-14 20:32:22', '1', '2026-01-14 20:33:04', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39867, 145, 2, '{\"nickname\":\"李四\",\"deptId\":\"116\"}', 'cdc00a3566ca407f8cd953eb8e505fa4', 'fdc007c9daef4dd9be62c1ea556c6eda', 'default', NULL, '2026-01-14 21:03:10', NULL, '2026-01-14 20:33:10', '145', '2026-01-14 20:36:41', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39868, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '1e83d2884b0b42e1b9506928289f4939', 'd5aaedea98cc4fa7b8f46be88c487f1f', 'default', NULL, '2026-01-14 21:06:48', NULL, '2026-01-14 20:36:48', '1', '2026-01-14 20:37:16', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39869, 145, 2, '{\"nickname\":\"李四\",\"deptId\":\"116\"}', 'e184447faa8d49bcb92f076a598b1e2d', '83d7f75b04da47a0903a9efc68eb650d', 'default', NULL, '2026-01-14 21:07:22', NULL, '2026-01-14 20:37:22', '145', '2026-01-14 20:37:49', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39870, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'e51742432a694f02bb2b97f3a082e3dd', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-14 21:07:53', NULL, '2026-01-14 20:37:53', NULL, '2026-01-14 21:09:38', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39871, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'eabc7f1635264175a9cd484e6c3f0168', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-14 21:39:38', NULL, '2026-01-14 21:09:38', NULL, '2026-01-14 21:39:42', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39872, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '315599da17334ea5b63db36be2b6c724', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-14 22:09:42', NULL, '2026-01-14 21:39:42', NULL, '2026-01-14 22:11:42', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39873, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '9cd11bea19904e468398f4ea56a2fc1f', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-14 22:41:42', NULL, '2026-01-14 22:11:42', NULL, '2026-01-14 22:43:42', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39874, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'e1c5b4567f3041c08a378efff4c41d5e', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-14 23:13:42', NULL, '2026-01-14 22:43:42', NULL, '2026-01-14 23:13:42', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39875, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '28aaba2bbe274fcc997e388b37464c93', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-14 23:43:42', NULL, '2026-01-14 23:13:42', NULL, '2026-01-14 23:43:42', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39876, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'a2226d2800854349a201eb93f7c5ec09', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 00:13:42', NULL, '2026-01-14 23:43:42', NULL, '2026-01-15 00:13:42', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39877, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '9100a362621f4c21b0d1fa8da6491251', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 00:43:42', NULL, '2026-01-15 00:13:42', NULL, '2026-01-15 00:43:42', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39878, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'e7263a4dc6a44fa68298ad96e8ff7eb5', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 01:13:42', NULL, '2026-01-15 00:43:42', NULL, '2026-01-15 01:13:42', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39879, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '8c56e54b9a514384adb3b0992bb4ce55', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 01:43:42', NULL, '2026-01-15 01:13:42', NULL, '2026-01-15 01:43:43', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39880, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '8db1adeeb85944e2ac59ced77cdb4336', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 02:13:43', NULL, '2026-01-15 01:43:43', NULL, '2026-01-15 02:15:43', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39881, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'efdc8aaffada48cf9c966fb2c589dd2b', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 02:45:43', NULL, '2026-01-15 02:15:43', NULL, '2026-01-15 02:47:43', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39882, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '0f3cad1e26334d8a8e7db39231aed857', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 03:17:43', NULL, '2026-01-15 02:47:43', NULL, '2026-01-15 03:19:43', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39883, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '7c7f539ca1d6427cb5fddc5476d8fa13', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 03:49:43', NULL, '2026-01-15 03:19:43', NULL, '2026-01-15 03:51:43', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39884, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'b1d6f78a9bf04c94bd3a47668d8e94c3', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 04:21:43', NULL, '2026-01-15 03:51:43', NULL, '2026-01-15 04:21:43', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39885, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '4b562b09ee7a485e8cb30632401f36c0', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 04:51:43', NULL, '2026-01-15 04:21:43', NULL, '2026-01-15 04:51:43', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39886, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '8027cf927c5241699668e88b3eb59afc', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 05:21:43', NULL, '2026-01-15 04:51:43', NULL, '2026-01-15 05:21:43', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39887, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '8ca1439c66c24d92a21d3c186df1b43c', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 05:51:43', NULL, '2026-01-15 05:21:43', NULL, '2026-01-15 05:51:43', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39888, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '3533624f852b43588cf2354dbf07b03b', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 06:21:43', NULL, '2026-01-15 05:51:43', NULL, '2026-01-15 06:21:43', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39889, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '2cc8331ea50d4c529ae289acc1e98dc1', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 06:51:43', NULL, '2026-01-15 06:21:43', NULL, '2026-01-15 06:51:44', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39890, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '2bcfc19f0a0b4285ad3d2962cf8f49db', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 07:21:44', NULL, '2026-01-15 06:51:44', NULL, '2026-01-15 07:23:44', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39891, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '1dac4aa64291471191c4e783830dee86', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 07:53:44', NULL, '2026-01-15 07:23:44', NULL, '2026-01-15 07:55:44', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39892, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'a68a82f243854e4cac340e438de0772c', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 08:25:44', NULL, '2026-01-15 07:55:44', NULL, '2026-01-15 08:27:44', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39893, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'de230599607e4fb4a70628e4c68adb03', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 08:57:44', NULL, '2026-01-15 08:27:44', NULL, '2026-01-15 08:59:44', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39894, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '41ee1132ee6e4d488a65fcc5fef76b19', '804a30ba8dee45ce993bdad034bf4abb', 'default', NULL, '2026-01-15 09:19:15', NULL, '2026-01-15 08:49:15', '1', '2026-01-15 09:07:24', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39895, 146, 2, '{\"nickname\":\"周伟\",\"deptId\":\"116\"}', '742b21b3a6b940a4ae94b99f7d601651', 'ed81c7359eb741f79e45986ca55e3956', 'default', NULL, '2026-01-15 09:27:35', NULL, '2026-01-15 08:57:35', '146', '2026-01-15 09:11:44', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39896, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '09c70eb05bf34a3ab63514ba34f64826', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 09:29:44', NULL, '2026-01-15 08:59:44', NULL, '2026-01-15 09:29:44', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39897, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', 'b04ae019ba7041a48ed97af6a65eef1c', '63e52787c83248f1b267fec9038f4e4a', 'default', NULL, '2026-01-15 09:37:39', NULL, '2026-01-15 09:07:39', '149', '2026-01-15 09:08:32', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39898, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '8b30071cb31b4d4099ed3b2a2a01dab7', 'e913e9bfbaba471a94edc3712f172e58', 'default', NULL, '2026-01-15 09:40:16', NULL, '2026-01-15 09:10:16', NULL, '2026-01-15 09:42:30', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39899, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', 'bddec5128284456d884d665de1ab374f', '91640f5a59f5433e9d9f441854c39143', 'default', NULL, '2026-01-15 09:42:27', NULL, '2026-01-15 09:12:27', NULL, '2026-01-15 09:57:01', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39900, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '43514494efb74c56b85a3ac236b65ddf', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 09:59:44', NULL, '2026-01-15 09:29:44', NULL, '2026-01-15 10:00:44', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39901, 147, 2, '{\"nickname\":\"邓强\",\"deptId\":\"116\"}', 'c3c5ca6c6c8646b99efa1afbcf47ad38', '61acb68ae57f428189fd93ade01d1850', 'default', NULL, '2026-01-15 10:00:41', NULL, '2026-01-15 09:30:41', NULL, '2026-01-15 10:00:50', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39902, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '174f0f08cac94dc29fc805a73c2a10ff', 'e913e9bfbaba471a94edc3712f172e58', 'default', NULL, '2026-01-15 10:12:30', NULL, '2026-01-15 09:42:30', NULL, '2026-01-15 10:23:10', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39903, 148, 2, '{\"nickname\":\"袁光华\",\"deptId\":\"116\"}', '380f36e0ec034d23962c66ffff7f6c06', '1fc0d7bcb421449d903daaa72d961f11', 'default', NULL, '2026-01-15 10:23:15', NULL, '2026-01-15 09:53:15', NULL, '2026-01-15 10:23:15', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39904, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', '53dde12cb8f64f8e8b858a810d8964ad', '91640f5a59f5433e9d9f441854c39143', 'default', NULL, '2026-01-15 10:27:01', NULL, '2026-01-15 09:57:01', '149', '2026-01-15 09:57:19', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39905, 146, 2, '{\"nickname\":\"周伟\",\"deptId\":\"116\"}', '966882a1055e4649bc91d620c55cd430', '4fb3da8efb5844f18da6293863603b81', 'default', NULL, '2026-01-15 10:27:37', NULL, '2026-01-15 09:57:37', '146', '2026-01-15 10:12:09', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39906, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', 'b51c622442be47fb888424bccd30382c', 'f7f24c2447714b0ba79578c2b387828e', 'default', NULL, '2026-01-15 10:30:44', NULL, '2026-01-15 10:00:44', '1', '2026-01-15 10:27:55', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39907, 147, 2, '{\"nickname\":\"邓强\",\"deptId\":\"116\"}', '3b9857d1c56c4520b1f7676621856718', '61acb68ae57f428189fd93ade01d1850', 'default', NULL, '2026-01-15 10:30:50', NULL, '2026-01-15 10:00:50', NULL, '2026-01-15 10:00:50', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39908, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', '11cabc422866419b8323179981fb95f2', '695d97d11c6d4bf3abb852b3f004e21d', 'default', NULL, '2026-01-15 10:42:23', NULL, '2026-01-15 10:12:23', NULL, '2026-01-15 14:16:46', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39909, 1, 2, '{\"nickname\":\"超级管理员\",\"deptId\":\"116\"}', '1bfa70e3deed463fa946ad9f1d9fff8a', 'e913e9bfbaba471a94edc3712f172e58', 'default', NULL, '2026-01-15 10:53:10', NULL, '2026-01-15 10:23:10', NULL, '2026-01-15 10:23:10', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39910, 148, 2, '{\"nickname\":\"袁光华\",\"deptId\":\"116\"}', '7cdae2457d24485d94d11a84ee932fdd', '1fc0d7bcb421449d903daaa72d961f11', 'default', NULL, '2026-01-15 10:53:15', NULL, '2026-01-15 10:23:15', NULL, '2026-01-15 10:23:15', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39911, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', '89e2dbc9aeaf4db5aa256642580f4c5c', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 10:59:03', NULL, '2026-01-15 10:29:03', NULL, '2026-01-15 10:59:44', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39912, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', 'a998fe5b735645318d23b451ca097980', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 11:29:44', NULL, '2026-01-15 10:59:44', NULL, '2026-01-15 11:29:44', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39913, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', '8cf25401bd354eb8a8eb16c1d5deac2c', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 11:59:44', NULL, '2026-01-15 11:29:44', NULL, '2026-01-15 11:59:45', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39914, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', '742b7e9a93964740920bf3065d2ad252', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 12:29:45', NULL, '2026-01-15 11:59:45', NULL, '2026-01-15 12:30:45', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39915, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', '32bcd8566ca349e3bb786a9b293b8e02', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 13:00:45', NULL, '2026-01-15 12:30:45', NULL, '2026-01-15 13:01:45', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39916, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', '5a1af21db63e401a93b19fa96b211c69', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 13:31:45', NULL, '2026-01-15 13:01:45', NULL, '2026-01-15 13:32:45', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39917, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', 'd2cb1f09b85546c4b7528f8b4e809fa5', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 14:02:45', NULL, '2026-01-15 13:32:45', NULL, '2026-01-15 14:03:45', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39918, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', '8b7192c7d5494779a3571cbe15264576', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 14:33:45', NULL, '2026-01-15 14:03:45', NULL, '2026-01-15 14:33:45', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39919, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', 'f19a99b3b12c4faba44960bc2fc7e682', '695d97d11c6d4bf3abb852b3f004e21d', 'default', NULL, '2026-01-15 14:46:46', NULL, '2026-01-15 14:16:46', NULL, '2026-01-15 14:16:46', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39920, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', '7e331b68e1ee4c4fa3212d3bf2d64288', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 15:03:45', NULL, '2026-01-15 14:33:45', NULL, '2026-01-15 15:03:45', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39921, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', 'c20f3792882c46909510f2d64550d32d', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 15:33:45', NULL, '2026-01-15 15:03:45', NULL, '2026-01-15 15:33:45', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39922, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', 'a1292fa0326b4391a97b3413eee252c4', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 16:03:45', NULL, '2026-01-15 15:33:45', NULL, '2026-01-15 16:03:45', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39923, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', 'f0a4c54ec3394e7e93cf935476d479fd', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 16:33:45', NULL, '2026-01-15 16:03:45', NULL, '2026-01-15 16:33:45', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39924, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', 'f68763bba788425bb9ba08cdc5b82368', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 17:03:45', NULL, '2026-01-15 16:33:45', NULL, '2026-01-15 17:03:46', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (39925, 149, 2, '{\"nickname\":\"敬平\",\"deptId\":\"116\"}', '44c36eb2629b409f9ee0597dcb788662', '036b39b4faf0466d83275a8af4b5cfed', 'default', NULL, '2026-01-15 17:33:46', NULL, '2026-01-15 17:03:46', NULL, '2026-01-15 17:03:46', b'0', 0);

-- ----------------------------
-- Table structure for system_oauth2_approve
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_approve`;
CREATE TABLE `system_oauth2_approve`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
  `scope` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '授权范围',
  `approved` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否接受',
  `expires_time` datetime NOT NULL COMMENT '过期时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 批准表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_oauth2_approve
-- ----------------------------

-- ----------------------------
-- Table structure for system_oauth2_client
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_client`;
CREATE TABLE `system_oauth2_client`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
  `secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端密钥',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用名',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用图标',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '应用描述',
  `status` tinyint NOT NULL COMMENT '状态',
  `access_token_validity_seconds` int NOT NULL COMMENT '访问令牌的有效期',
  `refresh_token_validity_seconds` int NOT NULL COMMENT '刷新令牌的有效期',
  `redirect_uris` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '可重定向的 URI 地址',
  `authorized_grant_types` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '授权类型',
  `scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '授权范围',
  `auto_approve_scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自动通过的授权范围',
  `authorities` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '权限',
  `resource_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资源',
  `additional_information` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '附加信息',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 客户端表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_oauth2_client
-- ----------------------------
INSERT INTO `system_oauth2_client` VALUES (1, 'default', 'admin123', '芋道源码', 'http://test.yudao.iocoder.cn/20250502/sort2_1746189740718.png', '我是描述', 0, 1800, 2592000, '[\"https://www.iocoder.cn\",\"https://doc.iocoder.cn\"]', '[\"password\",\"authorization_code\",\"implicit\",\"refresh_token\",\"client_credentials\"]', '[\"user.read\",\"user.write\"]', '[]', '[\"user.read\",\"user.write\"]', '[]', '{}', '1', '2022-05-11 21:47:12', '1', '2025-08-21 10:04:50', b'0');
INSERT INTO `system_oauth2_client` VALUES (40, 'test', 'test2', 'biubiu', 'http://test.yudao.iocoder.cn/xx/20250502/ed07110a37464b5299f8bd7c67ad65c7_1746187077009.jpg', '啦啦啦啦', 0, 1800, 43200, '[\"https://www.iocoder.cn\"]', '[\"password\",\"authorization_code\",\"implicit\"]', '[\"user_info\",\"projects\"]', '[\"user_info\"]', '[]', '[]', '{}', '1', '2022-05-12 00:28:20', '1', '2025-05-02 19:58:08', b'0');
INSERT INTO `system_oauth2_client` VALUES (41, 'yudao-sso-demo-by-code', 'test', '基于授权码模式，如何实现 SSO 单点登录？', 'http://test.yudao.iocoder.cn/it/20250502/sign_1746181948685.png', NULL, 0, 1800, 43200, '[\"http://127.0.0.1:18080\"]', '[\"authorization_code\",\"refresh_token\"]', '[\"user.read\",\"user.write\"]', '[]', '[]', '[]', NULL, '1', '2022-09-29 13:28:31', '1', '2025-05-02 18:32:30', b'0');
INSERT INTO `system_oauth2_client` VALUES (42, 'yudao-sso-demo-by-password', 'test', '基于密码模式，如何实现 SSO 单点登录？', 'http://test.yudao.iocoder.cn/20251025/images (3)_1761360515810.jpeg', NULL, 0, 1800, 43200, '[\"http://127.0.0.1:18080\"]', '[\"password\",\"refresh_token\"]', '[\"user.read\",\"user.write\"]', '[]', '[]', '[]', NULL, '1', '2022-10-04 17:40:16', '1', '2025-10-25 10:49:40', b'0');

-- ----------------------------
-- Table structure for system_oauth2_code
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_code`;
CREATE TABLE `system_oauth2_code`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '授权码',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
  `scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '授权范围',
  `expires_time` datetime NOT NULL COMMENT '过期时间',
  `redirect_uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '可重定向的 URI 地址',
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '状态',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 授权码表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_oauth2_code
-- ----------------------------

-- ----------------------------
-- Table structure for system_oauth2_refresh_token
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_refresh_token`;
CREATE TABLE `system_oauth2_refresh_token`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `refresh_token` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '刷新令牌',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
  `scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '授权范围',
  `expires_time` datetime NOT NULL COMMENT '过期时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2293 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 刷新令牌' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_oauth2_refresh_token
-- ----------------------------
INSERT INTO `system_oauth2_refresh_token` VALUES (2243, 1, '48ee41c02152434195befb5ad69e2fec', 2, 'default', NULL, '2026-02-11 13:56:16', NULL, '2026-01-12 13:56:16', NULL, '2026-01-12 06:04:09', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2244, 1, '912851bdaf0a4999a4f8a2022ac1e09c', 2, 'default', NULL, '2026-02-11 14:04:14', NULL, '2026-01-12 14:04:14', NULL, '2026-01-12 07:36:21', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2245, 1, '615a894750a24179ae55e16923e51191', 2, 'default', NULL, '2026-02-11 15:36:23', NULL, '2026-01-12 15:36:23', NULL, '2026-01-12 07:43:45', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2246, 1, '0ff8636dfa1e461bb50bb80a345b496c', 2, 'default', NULL, '2026-02-11 15:43:47', NULL, '2026-01-12 15:43:47', NULL, '2026-01-12 07:45:53', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2247, 1, '49bba04a52da4261a24e94bd33595c51', 2, 'default', NULL, '2026-02-11 15:45:54', NULL, '2026-01-12 15:45:54', NULL, '2026-01-12 10:22:07', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2248, 143, 'a2caf384d66946849ea656ed17ce820d', 2, 'default', NULL, '2026-02-11 18:22:20', NULL, '2026-01-12 18:22:20', NULL, '2026-01-13 00:37:05', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2249, 1, '8d315ab4abc2428ab73f4bfb4df25d69', 2, 'default', NULL, '2026-02-12 08:37:14', NULL, '2026-01-13 08:37:14', NULL, '2026-01-13 00:40:48', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2250, 1, '954db1fd9ab24e19b619c9f500e5a042', 2, 'default', NULL, '2026-02-12 08:41:01', NULL, '2026-01-13 08:41:01', NULL, '2026-01-13 00:56:19', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2251, 1, 'aedd849820db4d06aec9623cf7c4a741', 2, 'default', NULL, '2026-02-12 08:56:20', NULL, '2026-01-13 08:56:20', NULL, '2026-01-13 03:16:41', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2252, 143, 'da679510b8cf455083f43d1c40c35f1c', 2, 'default', NULL, '2026-02-12 11:16:52', NULL, '2026-01-13 11:16:52', NULL, '2026-01-13 05:51:14', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2253, 1, 'ca0cf700e68a4f2e8c5363228fc58def', 2, 'default', NULL, '2026-02-12 13:54:02', NULL, '2026-01-13 13:54:02', NULL, '2026-01-13 06:15:00', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2254, 144, '718fd22155f24e689a97366eb94c5280', 2, 'default', NULL, '2026-02-12 14:15:07', NULL, '2026-01-13 14:15:07', NULL, '2026-01-13 06:19:31', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2255, 1, '64c478008d1947d984fdf2a8e62990ed', 2, 'default', NULL, '2026-02-12 14:19:37', NULL, '2026-01-13 14:19:37', NULL, '2026-01-13 06:23:54', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2256, 1, 'aceaed2b3aec4c768a1ea0f21e8c9361', 2, 'default', NULL, '2026-02-12 14:23:55', NULL, '2026-01-13 14:23:55', NULL, '2026-01-13 14:23:55', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2257, 1, '883ef91adea1426d9835b87e07119622', 2, 'default', NULL, '2026-02-12 14:28:42', NULL, '2026-01-13 14:28:42', NULL, '2026-01-13 06:28:54', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2258, 143, 'bb302dd0cf0a4c18b90829a22c98fd5b', 2, 'default', NULL, '2026-02-12 14:28:59', NULL, '2026-01-13 14:28:59', NULL, '2026-01-13 06:29:07', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2259, 1, '7e38675e91564bbab0d1d55968a6ac8f', 2, 'default', NULL, '2026-02-12 14:29:17', NULL, '2026-01-13 14:29:17', NULL, '2026-01-13 06:33:53', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2260, 1, 'ba8de4af0ca74fbdacfb8446667fbcfc', 2, 'default', NULL, '2026-02-12 14:33:55', NULL, '2026-01-13 14:33:55', NULL, '2026-01-13 14:33:55', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2261, 1, '0a63733ef00e4c0e8b37e16f91043951', 2, 'default', NULL, '2026-02-12 14:39:41', NULL, '2026-01-13 14:39:41', NULL, '2026-01-13 06:41:12', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2262, 1, '4698341c6da34314875d0194d275b932', 2, 'default', NULL, '2026-02-12 14:41:13', NULL, '2026-01-13 14:41:13', NULL, '2026-01-13 06:42:20', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2263, 144, 'afcacde8dbd94da19d6883e0fbfca468', 2, 'default', NULL, '2026-02-12 14:42:25', NULL, '2026-01-13 14:42:25', NULL, '2026-01-13 06:42:36', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2264, 144, '80edb98773c3483fb3047b5a78ec6fef', 2, 'default', NULL, '2026-02-12 14:42:48', NULL, '2026-01-13 14:42:48', NULL, '2026-01-13 06:42:54', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2265, 1, '19f7f7a1670d40659710c063b3004148', 2, 'default', NULL, '2026-02-12 14:43:01', NULL, '2026-01-13 14:43:01', NULL, '2026-01-13 06:43:25', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2266, 144, '2369aba685bf42c492fc23d361b6018b', 2, 'default', NULL, '2026-02-12 14:43:27', NULL, '2026-01-13 14:43:27', NULL, '2026-01-13 06:43:45', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2267, 1, '65915561e46b423fb7d42d8109d4056e', 2, 'default', NULL, '2026-02-12 14:43:50', NULL, '2026-01-13 14:43:50', NULL, '2026-01-13 14:43:50', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2268, 1, '3b4535bd10954f83af363b99e117ccab', 2, 'default', NULL, '2026-02-12 17:00:36', NULL, '2026-01-13 17:00:36', NULL, '2026-01-13 17:00:36', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2269, 1, '677c141ab083411dadc7b173323aa0f6', 2, 'default', NULL, '2026-02-12 17:07:12', NULL, '2026-01-13 17:07:12', NULL, '2026-01-13 09:45:55', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2270, 144, '458483065d45459fa774c51a3ce9363d', 2, 'default', NULL, '2026-02-12 17:45:59', NULL, '2026-01-13 17:45:59', NULL, '2026-01-14 06:20:43', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2271, 1, '23985e594cdc4becb84e24d47eb9d1b5', 2, 'default', NULL, '2026-02-13 10:47:35', NULL, '2026-01-14 10:47:35', NULL, '2026-01-14 10:47:35', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2272, 1, 'e79670d0f70a4a81b7dfb52e324471dd', 2, 'default', NULL, '2026-02-13 10:52:04', NULL, '2026-01-14 10:52:04', NULL, '2026-01-14 10:52:04', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2273, 1, '2c45ece118674e95b7f163c58a341455', 2, 'default', NULL, '2026-02-13 11:24:40', NULL, '2026-01-14 11:24:40', NULL, '2026-01-14 11:24:40', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2274, 1, '3a88ab5ebb514e9a826425491e184be1', 2, 'default', NULL, '2026-02-13 14:20:49', NULL, '2026-01-14 14:20:49', NULL, '2026-01-14 14:20:49', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2275, 1, 'f12ecca6fee04bf5a2fd4e021dc0ec61', 2, 'default', NULL, '2026-02-13 19:41:13', NULL, '2026-01-14 19:41:13', NULL, '2026-01-14 19:41:13', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2276, 1, 'c44c24e1378847ed8bfa4e89aa90d42a', 2, 'default', NULL, '2026-02-13 20:16:44', NULL, '2026-01-14 20:16:44', NULL, '2026-01-14 20:24:27', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2277, 1, 'ff4b2f418bf94924aff1c1b4fcf85a3e', 2, 'default', NULL, '2026-02-13 20:24:37', NULL, '2026-01-14 20:24:37', NULL, '2026-01-14 20:25:08', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2278, 1, '50154ffffaa74c7b9fe876e53f486ba5', 2, 'default', NULL, '2026-02-13 20:32:22', NULL, '2026-01-14 20:32:22', NULL, '2026-01-14 20:33:03', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2279, 145, 'fdc007c9daef4dd9be62c1ea556c6eda', 2, 'default', NULL, '2026-02-13 20:33:10', NULL, '2026-01-14 20:33:10', NULL, '2026-01-14 20:36:40', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2280, 1, 'd5aaedea98cc4fa7b8f46be88c487f1f', 2, 'default', NULL, '2026-02-13 20:36:48', NULL, '2026-01-14 20:36:48', NULL, '2026-01-14 20:37:16', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2281, 145, '83d7f75b04da47a0903a9efc68eb650d', 2, 'default', NULL, '2026-02-13 20:37:22', NULL, '2026-01-14 20:37:22', NULL, '2026-01-14 20:37:48', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2282, 1, 'f7f24c2447714b0ba79578c2b387828e', 2, 'default', NULL, '2026-02-13 20:37:53', NULL, '2026-01-14 20:37:53', NULL, '2026-01-15 10:27:55', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2283, 1, '804a30ba8dee45ce993bdad034bf4abb', 2, 'default', NULL, '2026-02-14 08:49:15', NULL, '2026-01-15 08:49:15', NULL, '2026-01-15 09:07:24', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2284, 146, 'ed81c7359eb741f79e45986ca55e3956', 2, 'default', NULL, '2026-02-14 08:57:35', NULL, '2026-01-15 08:57:35', NULL, '2026-01-15 09:11:43', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2285, 149, '63e52787c83248f1b267fec9038f4e4a', 2, 'default', NULL, '2026-02-14 09:07:39', NULL, '2026-01-15 09:07:39', NULL, '2026-01-15 09:08:32', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2286, 1, 'e913e9bfbaba471a94edc3712f172e58', 2, 'default', NULL, '2026-02-14 09:10:16', NULL, '2026-01-15 09:10:16', NULL, '2026-01-15 09:10:16', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2287, 149, '91640f5a59f5433e9d9f441854c39143', 2, 'default', NULL, '2026-02-14 09:12:27', NULL, '2026-01-15 09:12:27', NULL, '2026-01-15 09:57:19', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2288, 147, '61acb68ae57f428189fd93ade01d1850', 2, 'default', NULL, '2026-02-14 09:30:41', NULL, '2026-01-15 09:30:41', NULL, '2026-01-15 09:30:41', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2289, 148, '1fc0d7bcb421449d903daaa72d961f11', 2, 'default', NULL, '2026-02-14 09:53:15', NULL, '2026-01-15 09:53:15', NULL, '2026-01-15 09:53:15', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2290, 146, '4fb3da8efb5844f18da6293863603b81', 2, 'default', NULL, '2026-02-14 09:57:37', NULL, '2026-01-15 09:57:37', NULL, '2026-01-15 10:12:08', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2291, 149, '695d97d11c6d4bf3abb852b3f004e21d', 2, 'default', NULL, '2026-02-14 10:12:23', NULL, '2026-01-15 10:12:23', NULL, '2026-01-15 10:12:23', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (2292, 149, '036b39b4faf0466d83275a8af4b5cfed', 2, 'default', NULL, '2026-02-14 10:29:03', NULL, '2026-01-15 10:29:03', NULL, '2026-01-15 10:29:03', b'0', 0);

-- ----------------------------
-- Table structure for system_operate_log
-- ----------------------------
DROP TABLE IF EXISTS `system_operate_log`;
CREATE TABLE `system_operate_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `trace_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '链路追踪编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL DEFAULT 0 COMMENT '用户类型',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作模块类型',
  `sub_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作名',
  `biz_id` bigint NOT NULL COMMENT '操作数据模块编号',
  `action` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '操作内容',
  `success` bit(1) NOT NULL DEFAULT b'1' COMMENT '操作结果',
  `extra` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '拓展字段',
  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求方法名',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求地址',
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户 IP',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '浏览器 UA',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志记录 V2 版本' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_operate_log
-- ----------------------------
INSERT INTO `system_operate_log` VALUES (1, '', 1, 2, 'SYSTEM 用户', '创建用户', 143, '创建了用户【张三】', b'1', '', 'POST', '/admin-api/system/user/create', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-12 14:13:38', '1', '2026-01-12 14:13:38', b'0', 0);
INSERT INTO `system_operate_log` VALUES (2, '', 1, 2, 'SYSTEM 用户', '创建用户', 144, '创建了用户【李四】', b'1', '', 'POST', '/admin-api/system/user/create', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-12 14:14:03', '1', '2026-01-12 14:14:03', b'0', 0);
INSERT INTO `system_operate_log` VALUES (3, '', 1, 2, 'SYSTEM 用户', '更新用户', 144, '更新了用户【李四】: 【手机号码】从【】修改为【18800000002】', b'1', '', 'PUT', '/admin-api/system/user/update', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-12 14:14:17', '1', '2026-01-12 14:14:17', b'0', 0);
INSERT INTO `system_operate_log` VALUES (4, '', 1, 2, 'SYSTEM 用户', '更新用户', 1, '更新了用户【超级管理员】: 【部门】从【空】修改为【尚泰铭成】', b'1', '', 'PUT', '/admin-api/system/user/update', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 08:49:41', '1', '2026-01-13 08:49:41', b'0', 0);
INSERT INTO `system_operate_log` VALUES (5, '', 1, 2, 'SYSTEM 用户', '更新用户', 144, '更新了用户【李四】: 【部门】从【空】修改为【业务一部】', b'1', '', 'PUT', '/admin-api/system/user/update', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 09:10:03', '1', '2026-01-13 09:10:03', b'0', 0);
INSERT INTO `system_operate_log` VALUES (6, '', 1, 2, 'SYSTEM 用户', '更新用户', 143, '更新了用户【张三】: 【部门】从【空】修改为【业务二部】', b'1', '', 'PUT', '/admin-api/system/user/update', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 09:10:08', '1', '2026-01-13 09:10:08', b'0', 0);
INSERT INTO `system_operate_log` VALUES (7, '', 1, 2, 'SYSTEM 用户', '更新用户', 143, '更新了用户【张三】: ', b'1', '', 'PUT', '/admin-api/system/user/update', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 14:14:17', '1', '2026-01-13 14:14:17', b'0', 0);
INSERT INTO `system_operate_log` VALUES (8, '', 1, 2, 'SYSTEM 用户', '更新用户', 144, '更新了用户【李四】: ', b'1', '', 'PUT', '/admin-api/system/user/update', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-13 14:14:21', '1', '2026-01-13 14:14:21', b'0', 0);
INSERT INTO `system_operate_log` VALUES (9, '', 1, 2, 'SYSTEM 用户', '删除用户', 144, '删除了用户【李四】', b'1', '', 'DELETE', '/admin-api/system/user/delete', '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-14 20:17:38', '1', '2026-01-14 20:17:38', b'0', 0);
INSERT INTO `system_operate_log` VALUES (10, '', 1, 2, 'SYSTEM 用户', '删除用户', 143, '删除了用户【张三】', b'1', '', 'DELETE', '/admin-api/system/user/delete', '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-14 20:17:41', '1', '2026-01-14 20:17:41', b'0', 0);
INSERT INTO `system_operate_log` VALUES (11, '', 1, 2, 'SYSTEM 用户', '创建用户', 145, '创建了用户【李四】', b'1', '', 'POST', '/admin-api/system/user/create', '222.209.214.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '1', '2026-01-14 20:32:58', '1', '2026-01-14 20:32:58', b'0', 0);
INSERT INTO `system_operate_log` VALUES (12, '', 1, 2, 'SYSTEM 用户', '删除用户', 145, '删除了用户【李四】', b'1', '', 'DELETE', '/admin-api/system/user/delete', '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', '1', '2026-01-15 08:52:28', '1', '2026-01-15 08:52:28', b'0', 0);
INSERT INTO `system_operate_log` VALUES (13, '', 1, 2, 'SYSTEM 用户', '创建用户', 146, '创建了用户【周伟】', b'1', '', 'POST', '/admin-api/system/user/create', '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', '1', '2026-01-15 08:54:36', '1', '2026-01-15 08:54:36', b'0', 0);
INSERT INTO `system_operate_log` VALUES (14, '', 1, 2, 'SYSTEM 用户', '更新用户', 1, '更新了用户【超级管理员】: 【手机号码】从【18818260272】修改为【13076027080】', b'1', '', 'PUT', '/admin-api/system/user/update', '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', '1', '2026-01-15 08:55:09', '1', '2026-01-15 08:55:09', b'0', 0);
INSERT INTO `system_operate_log` VALUES (15, '', 1, 2, 'SYSTEM 用户', '创建用户', 147, '创建了用户【邓强】', b'1', '', 'POST', '/admin-api/system/user/create', '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', '1', '2026-01-15 08:57:19', '1', '2026-01-15 08:57:19', b'0', 0);
INSERT INTO `system_operate_log` VALUES (16, '', 1, 2, 'SYSTEM 用户', '创建用户', 148, '创建了用户【袁光华】', b'1', '', 'POST', '/admin-api/system/user/create', '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', '1', '2026-01-15 08:58:33', '1', '2026-01-15 08:58:33', b'0', 0);
INSERT INTO `system_operate_log` VALUES (17, '', 1, 2, 'SYSTEM 用户', '重置用户密码', 1, '将用户【超级管理员】的密码从【$2a$04$KljJDa/LK7QfDm0lF5OhuePhlPfjRH3tB2Wu351Uidz.oQGJXevPi】重置为【$2a$04$1UoDysHPDw7DC8R4xsgoUepWYJljdHl4zf7qx1FYou3hF.RWUApuy】', b'1', '', 'PUT', '/admin-api/system/user/update-password', '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', '1', '2026-01-15 09:00:39', '1', '2026-01-15 09:00:39', b'0', 0);
INSERT INTO `system_operate_log` VALUES (18, '', 1, 2, 'SYSTEM 用户', '创建用户', 149, '创建了用户【敬平】', b'1', '', 'POST', '/admin-api/system/user/create', '61.157.56.88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf254151e) XWEB/17127 Flue', '1', '2026-01-15 09:01:58', '1', '2026-01-15 09:01:58', b'0', 0);

-- ----------------------------
-- Table structure for system_post
-- ----------------------------
DROP TABLE IF EXISTS `system_post`;
CREATE TABLE `system_post`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位编码',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位名称',
  `sort` int NOT NULL COMMENT '显示顺序',
  `status` tinyint NOT NULL COMMENT '状态（0正常 1停用）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_post
-- ----------------------------
INSERT INTO `system_post` VALUES (1, 'boss', '老板', 1, 0, '', 'admin', '2026-01-12 06:03:14', 'admin', '2026-01-12 06:03:14', b'0', 1);
INSERT INTO `system_post` VALUES (2, 'finance', '财务', 2, 0, '', 'admin', '2026-01-12 06:03:14', 'admin', '2026-01-12 06:03:14', b'0', 1);
INSERT INTO `system_post` VALUES (3, 'hr', '人事', 3, 0, '', 'admin', '2026-01-12 06:03:14', 'admin', '2026-01-12 06:03:14', b'0', 1);
INSERT INTO `system_post` VALUES (4, 'salesman', '业务员', 4, 0, '', 'admin', '2026-01-12 06:03:14', 'admin', '2026-01-12 06:03:14', b'0', 1);

-- ----------------------------
-- Table structure for system_role
-- ----------------------------
DROP TABLE IF EXISTS `system_role`;
CREATE TABLE `system_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` tinyint NOT NULL DEFAULT 1 COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `data_scope_dept_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据范围(指定部门数组)',
  `status` tinyint NOT NULL COMMENT '角色状态（0正常 1停用）',
  `type` tinyint NOT NULL COMMENT '角色类型',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_role
-- ----------------------------
INSERT INTO `system_role` VALUES (1, '超级管理员', 'super_admin', 1, 1, '', 0, 1, '超级管理员', 'admin', '2021-01-05 17:03:48', 'admin', '2026-01-12 06:03:14', b'0', 1);
INSERT INTO `system_role` VALUES (2, '老板', 'boss', 2, 1, '', 0, 1, '老板角色', 'admin', '2026-01-12 06:03:14', 'admin', '2026-01-12 06:03:14', b'0', 1);
INSERT INTO `system_role` VALUES (3, '业务员', 'salesman', 3, 4, '', 0, 1, '业务员角色', 'admin', '2026-01-12 06:03:14', 'admin', '2026-01-12 06:03:14', b'0', 1);

-- ----------------------------
-- Table structure for system_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `system_role_menu`;
CREATE TABLE `system_role_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7567 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_role_menu
-- ----------------------------
INSERT INTO `system_role_menu` VALUES (7394, 1, 1, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7395, 1, 100, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7396, 1, 101, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7397, 1, 104, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7398, 1, 1001, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7399, 1, 1002, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7400, 1, 1003, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7401, 1, 1004, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7402, 1, 1005, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7403, 1, 1006, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7404, 1, 1007, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7405, 1, 1013, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7406, 1, 1014, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7407, 1, 1015, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7408, 1, 1016, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7409, 1, 1017, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7410, 1, 1063, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7411, 1, 1064, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7412, 1, 1065, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7413, 1, 1066, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7414, 1, 5001, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7415, 1, 5002, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7416, 1, 5003, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7417, 1, 5004, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7418, 1, 5005, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7419, 1, 5010, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7420, 1, 5011, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7421, 1, 5012, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7422, 1, 5013, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7423, 1, 5014, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7424, 1, 5020, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7425, 1, 5021, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7426, 1, 5040, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7427, 1, 5041, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7428, 1, 5042, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7429, 1, 5043, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7430, 1, 5044, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7431, 1, 5045, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7432, 1, 5046, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7433, 1, 5047, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7434, 1, 5048, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7435, 1, 5049, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7436, 1, 5050, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7437, 1, 5051, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7438, 1, 5052, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7439, 1, 5053, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7440, 1, 5054, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7441, 1, 5055, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7442, 1, 5056, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7443, 1, 5060, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7444, 1, 5061, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7445, 1, 5062, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7457, 2, 5001, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7458, 2, 5002, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7459, 2, 5003, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7460, 2, 5004, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7461, 2, 5005, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7462, 2, 5010, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7463, 2, 5011, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7464, 2, 5012, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7465, 2, 5013, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7466, 2, 5014, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7467, 2, 5020, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7468, 2, 5021, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7469, 2, 5040, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7470, 2, 5041, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7471, 2, 5042, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7472, 2, 5043, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7473, 2, 5044, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7474, 2, 5045, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7475, 2, 5046, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7476, 2, 5047, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7477, 2, 5048, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7478, 2, 5049, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7479, 2, 5050, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7480, 2, 5051, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7481, 2, 5052, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7482, 2, 5053, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7483, 2, 5054, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7484, 2, 5055, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7485, 2, 5056, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7486, 2, 5060, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7487, 2, 5061, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7488, 2, 5062, '1', '2026-01-11 13:06:55', '1', '2026-01-11 13:06:55', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7535, 1, 5045, '1', '2026-01-12 07:34:34', '1', '2026-01-12 07:34:34', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7536, 1, 5046, '1', '2026-01-12 07:34:34', '1', '2026-01-12 07:34:34', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7537, 2, 5045, '1', '2026-01-12 07:34:34', '1', '2026-01-12 07:34:34', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7538, 2, 5046, '1', '2026-01-12 07:34:34', '1', '2026-01-12 07:34:34', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7539, 1, 5070, '1', '2026-01-13 00:40:02', '1', '2026-01-13 00:40:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7540, 1, 5071, '1', '2026-01-13 00:40:02', '1', '2026-01-13 00:40:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7541, 1, 5072, '1', '2026-01-13 00:40:02', '1', '2026-01-13 00:40:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7542, 1, 5073, '1', '2026-01-13 00:40:02', '1', '2026-01-13 00:40:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7543, 1, 5074, '1', '2026-01-13 00:40:02', '1', '2026-01-13 00:40:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7544, 2, 5070, '1', '2026-01-13 00:40:02', '1', '2026-01-13 00:40:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7545, 2, 5071, '1', '2026-01-13 00:40:02', '1', '2026-01-13 00:40:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7546, 2, 5072, '1', '2026-01-13 00:40:02', '1', '2026-01-13 00:40:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7547, 2, 5073, '1', '2026-01-13 00:40:02', '1', '2026-01-13 00:40:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7548, 2, 5074, '1', '2026-01-13 00:40:02', '1', '2026-01-13 00:40:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7549, 3, 5001, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7550, 3, 5002, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7551, 3, 5003, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7552, 3, 5004, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7553, 3, 5005, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7554, 3, 5049, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7555, 3, 5075, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7556, 3, 5020, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7557, 3, 5040, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7559, 3, 5021, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7560, 3, 5041, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7561, 3, 5042, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7562, 3, 5043, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7563, 3, 5044, '1', '2026-01-13 05:50:02', '1', '2026-01-13 05:50:02', b'0', 1);
INSERT INTO `system_role_menu` VALUES (7566, 1, 5076, '1', '2026-01-13 06:33:29', '1', '2026-01-13 06:33:29', b'0', 1);

-- ----------------------------
-- Table structure for system_sms_channel
-- ----------------------------
DROP TABLE IF EXISTS `system_sms_channel`;
CREATE TABLE `system_sms_channel`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `signature` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信签名',
  `code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '渠道编码',
  `status` tinyint NOT NULL COMMENT '开启状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `api_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信 API 的账号',
  `api_secret` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '短信 API 的秘钥',
  `callback_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '短信发送回调 URL',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '短信渠道' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_sms_channel
-- ----------------------------
INSERT INTO `system_sms_channel` VALUES (2, 'Ballcat', 'ALIYUN', 0, '你要改哦，只有我可以用！！！！', 'LTAI5tCnKso2uG3kJ5gRav88', 'fGJ5SNXL7P1NHNRmJ7DJaMJGPyE55C', NULL, '', '2021-03-31 11:53:10', '1', '2024-08-04 08:53:26', b'0');
INSERT INTO `system_sms_channel` VALUES (4, '测试渠道', 'DEBUG_DING_TALK', 0, '123', '696b5d8ead48071237e4aa5861ff08dbadb2b4ded1c688a7b7c9afc615579859', 'SEC5c4e5ff888bc8a9923ae47f59e7ccd30af1f14d93c55b4e2c9cb094e35aeed67', NULL, '1', '2021-04-13 00:23:14', '1', '2022-03-27 20:29:49', b'0');
INSERT INTO `system_sms_channel` VALUES (7, 'mock腾讯云', 'TENCENT', 0, '', '1 2', '2 3', '', '1', '2024-09-30 08:53:45', '1', '2024-09-30 08:55:01', b'0');

-- ----------------------------
-- Table structure for system_sms_code
-- ----------------------------
DROP TABLE IF EXISTS `system_sms_code`;
CREATE TABLE `system_sms_code`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号',
  `code` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '验证码',
  `create_ip` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '创建 IP',
  `scene` tinyint NOT NULL COMMENT '发送场景',
  `today_index` tinyint NOT NULL COMMENT '今日发送的第几条',
  `used` tinyint NOT NULL COMMENT '是否使用',
  `used_time` datetime NULL DEFAULT NULL COMMENT '使用时间',
  `used_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '使用 IP',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_mobile`(`mobile` ASC) USING BTREE COMMENT '手机号'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '手机验证码' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_sms_code
-- ----------------------------

-- ----------------------------
-- Table structure for system_sms_log
-- ----------------------------
DROP TABLE IF EXISTS `system_sms_log`;
CREATE TABLE `system_sms_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `channel_id` bigint NOT NULL COMMENT '短信渠道编号',
  `channel_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信渠道编码',
  `template_id` bigint NOT NULL COMMENT '模板编号',
  `template_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板编码',
  `template_type` tinyint NOT NULL COMMENT '短信类型',
  `template_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信内容',
  `template_params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信参数',
  `api_template_id` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信 API 的模板编号',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户编号',
  `user_type` tinyint NULL DEFAULT NULL COMMENT '用户类型',
  `send_status` tinyint NOT NULL DEFAULT 0 COMMENT '发送状态',
  `send_time` datetime NULL DEFAULT NULL COMMENT '发送时间',
  `api_send_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '短信 API 发送结果的编码',
  `api_send_msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '短信 API 发送失败的提示',
  `api_request_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '短信 API 发送返回的唯一请求 ID',
  `api_serial_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '短信 API 发送返回的序号',
  `receive_status` tinyint NOT NULL DEFAULT 0 COMMENT '接收状态',
  `receive_time` datetime NULL DEFAULT NULL COMMENT '接收时间',
  `api_receive_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'API 接收结果的编码',
  `api_receive_msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'API 接收结果的说明',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '短信日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_sms_log
-- ----------------------------

-- ----------------------------
-- Table structure for system_sms_template
-- ----------------------------
DROP TABLE IF EXISTS `system_sms_template`;
CREATE TABLE `system_sms_template`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `type` tinyint NOT NULL COMMENT '模板类型',
  `status` tinyint NOT NULL COMMENT '开启状态',
  `code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板编码',
  `name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板内容',
  `params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '参数数组',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `api_template_id` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信 API 的模板编号',
  `channel_id` bigint NOT NULL COMMENT '短信渠道编号',
  `channel_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信渠道编码',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '短信模板' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_sms_template
-- ----------------------------
INSERT INTO `system_sms_template` VALUES (2, 1, 0, 'test_01', '测试验证码短信', '正在进行登录操作{operation}，您的验证码是{code}', '[\"operation\",\"code\"]', '测试备注', '4383920', 4, 'DEBUG_DING_TALK', '', '2021-03-31 10:49:38', '1', '2024-08-18 11:57:18', b'0');
INSERT INTO `system_sms_template` VALUES (3, 1, 0, 'test_02', '公告通知', '您的验证码{code}，该验证码5分钟内有效，请勿泄漏于他人！', '[\"code\"]', NULL, 'SMS_207945135', 2, 'ALIYUN', '', '2021-03-31 11:56:30', '1', '2021-04-10 01:22:02', b'0');
INSERT INTO `system_sms_template` VALUES (6, 3, 0, 'test-01', '测试模板', '哈哈哈 {name}', '[\"name\"]', 'f哈哈哈', '4383920', 4, 'DEBUG_DING_TALK', '1', '2021-04-10 01:07:21', '1', '2024-08-18 11:57:07', b'0');
INSERT INTO `system_sms_template` VALUES (7, 3, 0, 'test-04', '测试下', '老鸡{name}，牛逼{code}', '[\"name\",\"code\"]', '哈哈哈哈', 'suibian', 7, 'DEBUG_DING_TALK', '1', '2021-04-13 00:29:53', '1', '2024-09-30 00:56:24', b'0');
INSERT INTO `system_sms_template` VALUES (8, 1, 0, 'user-sms-login', '前台用户短信登录', '您的验证码是{code}', '[\"code\"]', NULL, '4372216', 4, 'DEBUG_DING_TALK', '1', '2021-10-11 08:10:00', '1', '2024-08-18 11:57:06', b'0');
INSERT INTO `system_sms_template` VALUES (9, 2, 0, 'bpm_task_assigned', '【工作流】任务被分配', '您收到了一条新的待办任务：{processInstanceName}-{taskName}，申请人：{startUserNickname}，处理链接：{detailUrl}', '[\"processInstanceName\",\"taskName\",\"startUserNickname\",\"detailUrl\"]', NULL, 'suibian', 4, 'DEBUG_DING_TALK', '1', '2022-01-21 22:31:19', '1', '2022-01-22 00:03:36', b'0');
INSERT INTO `system_sms_template` VALUES (10, 2, 0, 'bpm_process_instance_reject', '【工作流】流程被不通过', '您的流程被审批不通过：{processInstanceName}，原因：{reason}，查看链接：{detailUrl}', '[\"processInstanceName\",\"reason\",\"detailUrl\"]', NULL, 'suibian', 4, 'DEBUG_DING_TALK', '1', '2022-01-22 00:03:31', '1', '2022-05-01 12:33:14', b'0');
INSERT INTO `system_sms_template` VALUES (11, 2, 0, 'bpm_process_instance_approve', '【工作流】流程被通过', '您的流程被审批通过：{processInstanceName}，查看链接：{detailUrl}', '[\"processInstanceName\",\"detailUrl\"]', NULL, 'suibian', 4, 'DEBUG_DING_TALK', '1', '2022-01-22 00:04:31', '1', '2022-03-27 20:32:21', b'0');
INSERT INTO `system_sms_template` VALUES (12, 2, 0, 'demo', '演示模板', '我就是测试一下下', '[]', NULL, 'biubiubiu', 4, 'DEBUG_DING_TALK', '1', '2022-04-10 23:22:49', '1', '2024-08-18 11:57:04', b'0');
INSERT INTO `system_sms_template` VALUES (14, 1, 0, 'user-update-mobile', '会员用户 - 修改手机', '您的验证码{code}，该验证码 5 分钟内有效，请勿泄漏于他人！', '[\"code\"]', '', 'null', 4, 'DEBUG_DING_TALK', '1', '2023-08-19 18:58:01', '1', '2023-08-19 11:34:04', b'0');
INSERT INTO `system_sms_template` VALUES (15, 1, 0, 'user-update-password', '会员用户 - 修改密码', '您的验证码{code}，该验证码 5 分钟内有效，请勿泄漏于他人！', '[\"code\"]', '', 'null', 4, 'DEBUG_DING_TALK', '1', '2023-08-19 18:58:01', '1', '2023-08-19 11:34:18', b'0');
INSERT INTO `system_sms_template` VALUES (16, 1, 0, 'user-reset-password', '会员用户 - 重置密码', '您的验证码{code}，该验证码 5 分钟内有效，请勿泄漏于他人！', '[\"code\"]', '', 'null', 4, 'DEBUG_DING_TALK', '1', '2023-08-19 18:58:01', '1', '2023-12-02 22:35:27', b'0');
INSERT INTO `system_sms_template` VALUES (17, 2, 0, 'bpm_task_timeout', '【工作流】任务审批超时', '您收到了一条超时的待办任务：{processInstanceName}-{taskName}，处理链接：{detailUrl}', '[\"processInstanceName\",\"taskName\",\"detailUrl\"]', '', 'X', 4, 'DEBUG_DING_TALK', '1', '2024-08-16 21:59:15', '1', '2024-08-16 21:59:34', b'0');
INSERT INTO `system_sms_template` VALUES (18, 1, 0, 'admin-reset-password', '后台用户 - 忘记密码', '您的验证码{code}，该验证码 5 分钟内有效，请勿泄漏于他人！', '[\"code\"]', '', 'null', 4, 'DEBUG_DING_TALK', '1', '2025-03-16 14:19:34', '1', '2025-03-16 14:19:45', b'0');
INSERT INTO `system_sms_template` VALUES (19, 1, 0, 'admin-sms-login', '后台用户短信登录', '您的验证码是{code}', '[\"code\"]', '', '4372216', 4, 'DEBUG_DING_TALK', '1', '2025-04-08 09:36:03', '1', '2025-04-08 09:36:17', b'0');

-- ----------------------------
-- Table structure for system_social_client
-- ----------------------------
DROP TABLE IF EXISTS `system_social_client`;
CREATE TABLE `system_social_client`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用名',
  `social_type` tinyint NOT NULL COMMENT '社交平台的类型',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
  `client_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端密钥',
  `agent_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '代理编号',
  `status` tinyint NOT NULL COMMENT '状态',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '社交客户端表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_social_client
-- ----------------------------
INSERT INTO `system_social_client` VALUES (1, '钉钉', 20, 2, 'dingvrnreaje3yqvzhxg', 'i8E6iZyDvZj51JIb0tYsYfVQYOks9Cq1lgryEjFRqC79P3iJcrxEwT6Qk2QvLrLI', NULL, 0, '', '2023-10-18 11:21:18', '1', '2023-12-20 21:28:26', b'1', 1);
INSERT INTO `system_social_client` VALUES (2, '钉钉（王土豆）', 20, 2, 'dingtsu9hpepjkbmthhw', 'FP_bnSq_HAHKCSncmJjw5hxhnzs6vaVDSZZn3egj6rdqTQ_hu5tQVJyLMpgCakdP', NULL, 0, '', '2023-10-18 11:21:18', '', '2023-12-20 21:28:26', b'1', 121);
INSERT INTO `system_social_client` VALUES (3, '微信公众号', 31, 1, 'wx5b23ba7a5589ecbb', '2a7b3b20c537e52e74afd395eb85f61f', NULL, 0, '', '2023-10-18 16:07:46', '1', '2023-12-20 21:28:23', b'1', 1);
INSERT INTO `system_social_client` VALUES (43, '微信小程序', 34, 1, 'wx63c280fe3248a3e7', '6f270509224a7ae1296bbf1c8cb97aed', NULL, 0, '', '2023-10-19 13:37:41', '1', '2023-12-20 21:28:25', b'1', 1);
INSERT INTO `system_social_client` VALUES (44, '1', 10, 1, '2', '3', NULL, 0, '1', '2025-04-06 20:36:28', '1', '2025-04-06 20:43:12', b'1', 1);
INSERT INTO `system_social_client` VALUES (45, '1', 10, 1, '2', '3', NULL, 1, '1', '2025-09-06 20:26:15', '1', '2025-09-06 20:27:55', b'1', 1);

-- ----------------------------
-- Table structure for system_social_user
-- ----------------------------
DROP TABLE IF EXISTS `system_social_user`;
CREATE TABLE `system_social_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键(自增策略)',
  `type` tinyint NOT NULL COMMENT '社交平台的类型',
  `openid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '社交 openid',
  `token` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '社交 token',
  `raw_token_info` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始 Token 数据，一般是 JSON 格式',
  `nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户头像',
  `raw_user_info` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始用户数据，一般是 JSON 格式',
  `code` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '最后一次的认证 code',
  `state` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最后一次的认证 state',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '社交用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_social_user
-- ----------------------------

-- ----------------------------
-- Table structure for system_social_user_bind
-- ----------------------------
DROP TABLE IF EXISTS `system_social_user_bind`;
CREATE TABLE `system_social_user_bind`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键(自增策略)',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `social_type` tinyint NOT NULL COMMENT '社交平台的类型',
  `social_user_id` bigint NOT NULL COMMENT '社交用户的编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '社交绑定表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_social_user_bind
-- ----------------------------

-- ----------------------------
-- Table structure for system_tenant
-- ----------------------------
DROP TABLE IF EXISTS `system_tenant`;
CREATE TABLE `system_tenant`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '租户编号',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '租户名',
  `contact_user_id` bigint NULL DEFAULT NULL COMMENT '联系人的用户编号',
  `contact_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系人',
  `contact_mobile` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系手机',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '租户状态',
  `websites` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '绑定域名数组',
  `package_id` bigint NOT NULL COMMENT '租户套餐编号',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `account_count` int NOT NULL COMMENT '账号数量',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 123 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '租户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_tenant
-- ----------------------------
INSERT INTO `system_tenant` VALUES (1, '尚泰铭成', 1, '管理员', '13800138000', 0, '', 0, '2099-12-31 23:59:59', 9999, 'admin', '2021-01-05 17:03:47', 'admin', '2026-01-12 06:03:14', b'0');
INSERT INTO `system_tenant` VALUES (121, '小租户', 110, '小王2', '15601691300', 0, 'zsxq.iocoder.cn,123321', 111, '2026-07-10 00:00:00', 30, '1', '2022-02-22 00:56:14', '1', '2025-08-19 21:19:29', b'0');
INSERT INTO `system_tenant` VALUES (122, '测试租户', 113, '芋道', '15601691300', 0, 'test.iocoder.cn,222,333', 111, '2022-04-29 00:00:00', 50, '1', '2022-03-07 21:37:58', '1', '2025-09-06 20:44:42', b'0');

-- ----------------------------
-- Table structure for system_tenant_package
-- ----------------------------
DROP TABLE IF EXISTS `system_tenant_package`;
CREATE TABLE `system_tenant_package`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '套餐编号',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '套餐名',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '租户状态（0正常 1停用）',
  `remark` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `menu_ids` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '关联的菜单编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 112 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '租户套餐表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_tenant_package
-- ----------------------------
INSERT INTO `system_tenant_package` VALUES (111, '普通套餐', 0, '小功能', '[1,2,5,1031,1032,1033,1034,1035,1036,1037,1038,1039,1050,1051,1052,1053,1054,1056,1057,1058,1059,1060,1063,1064,1065,1066,1067,1070,1075,1077,1078,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1117,1118,1119,1120,100,101,102,1126,103,1127,1128,1129,106,1130,107,1132,1133,110,1134,111,1135,112,1136,113,1137,2161,114,1138,1139,115,1140,116,1141,1142,1143,1150,1161,1162,1166,1173,1174,2713,2714,1178,2715,2716,2717,2718,2720,2721,1185,2722,1186,1187,2723,1188,2724,1189,2725,1190,2726,1191,2727,1192,2728,2729,1193,1194,2730,1195,2731,2732,1197,2733,1198,2734,1199,2735,1200,1201,1202,2739,2740,1207,1208,1209,2745,1210,2746,1211,2747,1212,2748,1213,1215,1216,1217,1218,1219,1220,2756,1221,2757,1222,1224,1225,1226,1227,1228,1229,1237,1238,2262,1239,1240,1241,1242,1243,2275,2276,2277,1255,1256,1257,2281,1258,2282,1259,2283,1260,2284,2285,2287,2288,2293,2294,2297,2300,2301,2302,2317,2318,2319,2320,2321,2322,2323,2324,2325,2326,2327,2328,2329,2330,2331,2332,2333,2334,2335,2363,2364,5011,5012,2472,2478,2479,2480,2481,2482,2483,2484,2485,2486,2487,2488,2489,2490,2491,2492,2493,2494,2495,2497,2525,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,2549,1014,2550,1015,2551,1016,2552,1017,2553,1018,2554,1019,2555,1020,2556,2557,2558,2559]', '1', '2022-02-22 00:54:00', '1', '2025-09-06 20:52:25', b'0');

-- ----------------------------
-- Table structure for system_user_post
-- ----------------------------
DROP TABLE IF EXISTS `system_user_post`;
CREATE TABLE `system_user_post`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '用户ID',
  `post_id` bigint NOT NULL DEFAULT 0 COMMENT '岗位ID',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 130 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户岗位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_user_post
-- ----------------------------
INSERT INTO `system_user_post` VALUES (112, 1, 1, 'admin', '2022-05-02 07:25:24', 'admin', '2022-05-02 07:25:24', b'0', 1);
INSERT INTO `system_user_post` VALUES (113, 100, 1, 'admin', '2022-05-02 07:25:24', 'admin', '2026-01-11 13:10:12', b'1', 1);
INSERT INTO `system_user_post` VALUES (115, 104, 1, '1', '2022-05-16 19:36:28', '1', '2026-01-11 13:10:08', b'1', 1);
INSERT INTO `system_user_post` VALUES (116, 117, 2, '1', '2022-07-09 17:40:26', '1', '2026-01-11 13:09:40', b'1', 1);
INSERT INTO `system_user_post` VALUES (117, 118, 1, '1', '2022-07-09 17:44:44', '1', '2026-01-11 13:09:38', b'1', 1);
INSERT INTO `system_user_post` VALUES (119, 114, 5, '1', '2024-03-24 20:45:51', '1', '2026-01-11 13:09:45', b'1', 1);
INSERT INTO `system_user_post` VALUES (123, 115, 1, '1', '2024-04-04 09:37:14', '1', '2026-01-11 13:09:42', b'1', 1);
INSERT INTO `system_user_post` VALUES (124, 115, 2, '1', '2024-04-04 09:37:14', '1', '2026-01-11 13:09:42', b'1', 1);
INSERT INTO `system_user_post` VALUES (125, 1, 2, '1', '2024-07-13 22:31:39', '1', '2026-01-11 13:12:55', b'1', 1);
INSERT INTO `system_user_post` VALUES (128, 143, 4, '1', '2026-01-12 14:13:38', '1', '2026-01-14 20:17:40', b'1', 0);
INSERT INTO `system_user_post` VALUES (129, 144, 4, '1', '2026-01-12 14:14:03', '1', '2026-01-14 20:17:38', b'1', 0);

-- ----------------------------
-- Table structure for system_user_role
-- ----------------------------
DROP TABLE IF EXISTS `system_user_role`;
CREATE TABLE `system_user_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_user_role
-- ----------------------------
INSERT INTO `system_user_role` VALUES (1, 1, 1, 'admin', '2022-01-11 13:19:45', 'admin', '2026-01-12 06:03:14', b'0', 1);
INSERT INTO `system_user_role` VALUES (51, 143, 3, '1', '2026-01-13 14:14:17', '1', '2026-01-14 20:17:40', b'1', 0);
INSERT INTO `system_user_role` VALUES (52, 144, 3, '1', '2026-01-13 14:14:21', '1', '2026-01-14 20:17:38', b'1', 0);
INSERT INTO `system_user_role` VALUES (53, 145, 3, '1', '2026-01-14 20:32:58', '1', '2026-01-15 08:52:27', b'1', 0);
INSERT INTO `system_user_role` VALUES (54, 146, 3, '1', '2026-01-15 08:54:36', '1', '2026-01-15 08:54:36', b'0', 0);
INSERT INTO `system_user_role` VALUES (55, 147, 3, '1', '2026-01-15 08:57:19', '1', '2026-01-15 08:57:19', b'0', 0);
INSERT INTO `system_user_role` VALUES (56, 148, 3, '1', '2026-01-15 08:58:33', '1', '2026-01-15 08:58:33', b'0', 0);
INSERT INTO `system_user_role` VALUES (57, 149, 2, '1', '2026-01-15 09:01:58', '1', '2026-01-15 09:01:58', b'0', 0);

-- ----------------------------
-- Table structure for system_users
-- ----------------------------
DROP TABLE IF EXISTS `system_users`;
CREATE TABLE `system_users`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户账号',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码',
  `nickname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `post_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '岗位编号数组',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` tinyint NULL DEFAULT 0 COMMENT '用户性别',
  `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '头像地址',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '帐号状态（0正常 1停用）',
  `login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 150 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_users
-- ----------------------------
INSERT INTO `system_users` VALUES (1, 'admin', '$2a$04$1UoDysHPDw7DC8R4xsgoUepWYJljdHl4zf7qx1FYou3hF.RWUApuy', '超级管理员', '管理员', 116, '[1]', '11aoteman@126.com', '13076027080', 1, 'http://8.156.76.187:48080/admin-api/infra/file/29/get/20260114/blob_1768390905397.png', 0, '61.157.56.88', '2026-01-15 09:10:16', 'admin', '2021-01-05 17:03:47', NULL, '2026-01-15 09:10:16', b'0', 1);
INSERT INTO `system_users` VALUES (143, 'zhangsan', '$2a$04$BdToMZeoQFA7yersx8Ngj.FzCfzZgfC0FVpw64mrZWZojhOw0wh06', '张三', '', 118, '[4]', '', '18200000001', 1, '', 0, '0:0:0:0:0:0:0:1', '2026-01-13 14:28:59', '1', '2026-01-12 14:13:38', '1', '2026-01-14 20:17:40', b'1', 1);
INSERT INTO `system_users` VALUES (144, 'lisi', '$2a$04$jMUXdIx7qnvRQQCT.OUJYOmpDpGC/ndWDoXnaiSi6pNQm3ZjNGGQm', '李四', '', 117, '[4]', '', '18800000002', 1, '', 0, '0:0:0:0:0:0:0:1', '2026-01-13 17:45:59', '1', '2026-01-12 14:14:03', '1', '2026-01-14 20:17:38', b'1', 1);
INSERT INTO `system_users` VALUES (145, 'lisi', '$2a$04$OdY6IDmZn6zqXCmylzVao.YDXr4h.tbeyM4vNFTk.cmoXllqFbNXm', '李四', '', 116, '[]', '', '', 1, '', 0, '222.209.214.87', '2026-01-14 20:37:22', '1', '2026-01-14 20:32:58', '1', '2026-01-15 08:52:28', b'1', 0);
INSERT INTO `system_users` VALUES (146, 'zhou123', '$2a$04$eNDA.N4CJhJbz2b8ZUYIbOVlEnBT/g3G4yaYUUoHNsUvduOsD0XQe', '周伟', '', 116, '[]', '', '15002847795', 1, '', 0, '61.157.56.88', '2026-01-15 09:57:37', '1', '2026-01-15 08:54:36', NULL, '2026-01-15 09:57:37', b'0', 0);
INSERT INTO `system_users` VALUES (147, 'deng123', '$2a$04$mpt3MkI5a/HH7LW6sh23aejBC1.SnXhaKHBvJero.75GCLiA2lnzO', '邓强', '', 116, '[]', '', '13679090196', 0, '', 0, '61.157.56.88', '2026-01-15 09:30:41', '1', '2026-01-15 08:57:19', NULL, '2026-01-15 09:30:41', b'0', 0);
INSERT INTO `system_users` VALUES (148, 'yuan123', '$2a$04$FyaVmC2OT4Vk3641zPmQPO0BKPXjwFOaIx5.s96W/q7ZTTz.8cDkO', '袁光华', '', 116, '[]', '', '18482172997', 1, '', 0, '61.157.56.88', '2026-01-15 09:53:15', '1', '2026-01-15 08:58:33', NULL, '2026-01-15 09:53:15', b'0', 0);
INSERT INTO `system_users` VALUES (149, 'jp123', '$2a$04$wvXBg4b3Q035rd2L0xMj.uFUOVieFIv0aFZwQjxt4pRUIWkqIFflG', '敬平', '', 116, '[]', '', '19827575172', 1, '', 0, '222.209.214.87', '2026-01-15 10:29:03', '1', '2026-01-15 09:01:58', NULL, '2026-01-15 10:29:03', b'0', 0);

-- ----------------------------
-- Table structure for yudao_demo01_contact
-- ----------------------------
DROP TABLE IF EXISTS `yudao_demo01_contact`;
CREATE TABLE `yudao_demo01_contact`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '名字',
  `sex` tinyint(1) NOT NULL COMMENT '性别',
  `birthday` datetime NOT NULL COMMENT '出生年',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '简介',
  `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '示例联系人表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of yudao_demo01_contact
-- ----------------------------
INSERT INTO `yudao_demo01_contact` VALUES (1, '土豆', 2, '2023-11-07 00:00:00', '<p>天蚕土豆！呀</p>', 'http://127.0.0.1:48080/admin-api/infra/file/4/get/46f8fa1a37db3f3960d8910ff2fe3962ab3b2db87cf2f8ccb4dc8145b8bdf237.jpeg', '1', '2023-11-15 23:34:30', '1', '2023-11-15 23:47:39', b'0', 1);

-- ----------------------------
-- Table structure for yudao_demo02_category
-- ----------------------------
DROP TABLE IF EXISTS `yudao_demo02_category`;
CREATE TABLE `yudao_demo02_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '名字',
  `parent_id` bigint NOT NULL COMMENT '父级编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '示例分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of yudao_demo02_category
-- ----------------------------
INSERT INTO `yudao_demo02_category` VALUES (1, '土豆', 0, '1', '2023-11-15 23:34:30', '1', '2023-11-16 20:24:23', b'0', 1);
INSERT INTO `yudao_demo02_category` VALUES (2, '番茄', 0, '1', '2023-11-16 20:24:00', '1', '2023-11-16 20:24:15', b'0', 1);
INSERT INTO `yudao_demo02_category` VALUES (3, '怪怪', 0, '1', '2023-11-16 20:24:32', '1', '2023-11-16 20:24:32', b'0', 1);
INSERT INTO `yudao_demo02_category` VALUES (4, '小番茄', 2, '1', '2023-11-16 20:24:39', '1', '2023-11-16 20:24:39', b'0', 1);
INSERT INTO `yudao_demo02_category` VALUES (5, '大番茄', 2, '1', '2023-11-16 20:24:46', '1', '2023-11-16 20:24:46', b'0', 1);
INSERT INTO `yudao_demo02_category` VALUES (6, '11', 3, '1', '2023-11-24 19:29:34', '1', '2023-11-24 19:29:34', b'0', 1);
INSERT INTO `yudao_demo02_category` VALUES (7, '1', 0, '1', '2025-10-01 09:19:20', '1', '2025-10-01 09:19:20', b'0', 1);

-- ----------------------------
-- Table structure for yudao_demo03_course
-- ----------------------------
DROP TABLE IF EXISTS `yudao_demo03_course`;
CREATE TABLE `yudao_demo03_course`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `student_id` bigint NOT NULL COMMENT '学生编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '名字',
  `score` tinyint NOT NULL COMMENT '分数',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生课程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of yudao_demo03_course
-- ----------------------------
INSERT INTO `yudao_demo03_course` VALUES (2, 2, '语文', 66, '1', '2023-11-16 23:21:49', '1', '2024-09-17 10:55:30', b'1', 1);
INSERT INTO `yudao_demo03_course` VALUES (3, 2, '数学', 22, '1', '2023-11-16 23:21:49', '1', '2024-09-17 10:55:30', b'1', 1);
INSERT INTO `yudao_demo03_course` VALUES (6, 5, '体育', 23, '1', '2023-11-16 23:22:46', '1', '2023-11-16 15:44:40', b'1', 1);
INSERT INTO `yudao_demo03_course` VALUES (7, 5, '计算机', 11, '1', '2023-11-16 23:22:46', '1', '2023-11-16 15:44:40', b'1', 1);
INSERT INTO `yudao_demo03_course` VALUES (8, 5, '体育', 23, '1', '2023-11-16 23:22:46', '1', '2023-11-16 15:47:09', b'1', 1);
INSERT INTO `yudao_demo03_course` VALUES (9, 5, '计算机', 11, '1', '2023-11-16 23:22:46', '1', '2023-11-16 15:47:09', b'1', 1);
INSERT INTO `yudao_demo03_course` VALUES (10, 5, '体育', 23, '1', '2023-11-16 23:22:46', '1', '2024-09-17 10:55:28', b'1', 1);
INSERT INTO `yudao_demo03_course` VALUES (11, 5, '计算机', 11, '1', '2023-11-16 23:22:46', '1', '2024-09-17 10:55:28', b'1', 1);
INSERT INTO `yudao_demo03_course` VALUES (12, 2, '电脑', 33, '1', '2023-11-17 00:20:42', '1', '2023-11-16 16:20:45', b'1', 1);
INSERT INTO `yudao_demo03_course` VALUES (13, 9, '滑雪', 12, '1', '2023-11-17 13:13:20', '1', '2024-09-17 10:55:26', b'1', 1);
INSERT INTO `yudao_demo03_course` VALUES (14, 9, '滑雪', 12, '1', '2023-11-17 13:13:20', '1', '2024-09-17 10:55:49', b'1', 1);
INSERT INTO `yudao_demo03_course` VALUES (15, 5, '体育', 23, '1', '2023-11-16 23:22:46', '1', '2024-09-17 18:55:29', b'0', 1);
INSERT INTO `yudao_demo03_course` VALUES (16, 5, '计算机', 11, '1', '2023-11-16 23:22:46', '1', '2024-09-17 18:55:29', b'0', 1);
INSERT INTO `yudao_demo03_course` VALUES (17, 2, '语文', 66, '1', '2023-11-16 23:21:49', '1', '2024-09-17 18:55:31', b'0', 1);
INSERT INTO `yudao_demo03_course` VALUES (18, 2, '数学', 22, '1', '2023-11-16 23:21:49', '1', '2024-09-17 18:55:31', b'0', 1);
INSERT INTO `yudao_demo03_course` VALUES (19, 9, '滑雪', 12, '1', '2023-11-17 13:13:20', '1', '2025-04-19 02:49:03', b'1', 1);
INSERT INTO `yudao_demo03_course` VALUES (20, 9, '滑雪', 12, '1', '2023-11-17 13:13:20', '1', '2025-04-19 10:49:04', b'0', 1);

-- ----------------------------
-- Table structure for yudao_demo03_grade
-- ----------------------------
DROP TABLE IF EXISTS `yudao_demo03_grade`;
CREATE TABLE `yudao_demo03_grade`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `student_id` bigint NOT NULL COMMENT '学生编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '名字',
  `teacher` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '班主任',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生班级表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of yudao_demo03_grade
-- ----------------------------
INSERT INTO `yudao_demo03_grade` VALUES (7, 2, '三年 2 班', '周杰伦', '1', '2023-11-16 23:21:49', '1', '2024-09-17 18:55:31', b'0', 1);
INSERT INTO `yudao_demo03_grade` VALUES (8, 5, '华为', '遥遥领先', '1', '2023-11-16 23:22:46', '1', '2024-09-17 18:55:29', b'0', 1);
INSERT INTO `yudao_demo03_grade` VALUES (9, 9, '小图', '小娃111', '1', '2023-11-17 13:10:23', '1', '2025-04-19 10:49:04', b'0', 1);

-- ----------------------------
-- Table structure for yudao_demo03_student
-- ----------------------------
DROP TABLE IF EXISTS `yudao_demo03_student`;
CREATE TABLE `yudao_demo03_student`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '名字',
  `sex` tinyint NOT NULL COMMENT '性别',
  `birthday` datetime NOT NULL COMMENT '出生日期',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '简介',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of yudao_demo03_student
-- ----------------------------
INSERT INTO `yudao_demo03_student` VALUES (2, '小白', 1, '2023-11-16 00:00:00', '<p>厉害</p>', '1', '2023-11-16 23:21:49', '1', '2024-09-17 18:55:31', b'0', 1);
INSERT INTO `yudao_demo03_student` VALUES (5, '大黑', 2, '2023-11-13 00:00:00', '<p>你在教我做事?</p>', '1', '2023-11-16 23:22:46', '1', '2024-09-17 18:55:29', b'0', 1);
INSERT INTO `yudao_demo03_student` VALUES (9, '小花', 1, '2023-11-07 00:00:00', '<p>哈哈哈</p>', '1', '2023-11-17 00:04:47', '1', '2025-04-19 10:49:04', b'0', 1);

SET FOREIGN_KEY_CHECKS = 1;
