-- -----------------------------------------------------------
-- 订单附件表
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `erp_order_attachment` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '附件编号',
  `order_id`    BIGINT       NOT NULL                COMMENT '关联订单ID',
  `category`    VARCHAR(32)  NOT NULL DEFAULT ''      COMMENT '附件分类: invoice-发票照片, receipt-回执照片, delivery-送货单, contract-合同, other-其他',
  `file_name`   VARCHAR(255) NOT NULL DEFAULT ''      COMMENT '原始文件名',
  `file_url`    VARCHAR(512) NOT NULL DEFAULT ''      COMMENT '文件访问URL',
  `file_size`   BIGINT       NULL     DEFAULT 0       COMMENT '文件大小(字节)',
  `remark`      VARCHAR(255) NULL     DEFAULT ''      COMMENT '备注说明',
  `creator`     VARCHAR(64)  NULL     DEFAULT ''      COMMENT '创建者',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater`     VARCHAR(64)  NULL     DEFAULT ''      COMMENT '更新者',
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted`     BIT(1)       NOT NULL DEFAULT b'0'    COMMENT '是否删除',
  `tenant_id`   BIGINT       NOT NULL DEFAULT 0       COMMENT '租户编号',
  PRIMARY KEY (`id`),
  INDEX `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 订单附件表';

-- 菜单权限 (挂在订单管理下，不需要独立菜单)
-- 权限标识: erp:order-attachment:query / create / delete
