package cn.iocoder.stmc.module.erp.controller.admin.order.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Schema(description = "管理后台 - ERP 订单明细 Response VO")
@Data
public class OrderItemRespVO {

    @Schema(description = "明细ID", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long id;

    @Schema(description = "订单ID", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long orderId;

    @Schema(description = "明细类型（0商品 1费用）", example = "0")
    private Integer itemType;

    // ========== 业务员填写字段（销售信息）==========

    @Schema(description = "商品名称", example = "衬塑钢卡")
    private String productName;

    @Schema(description = "规格", example = "DN150")
    private String spec;

    @Schema(description = "销售单位", example = "个")
    private String saleUnit;

    @Schema(description = "销售数量", example = "50")
    private BigDecimal saleQuantity;

    @Schema(description = "销售单价", example = "17")
    private BigDecimal salePrice;

    @Schema(description = "销售金额", example = "850")
    private BigDecimal saleAmount;

    @Schema(description = "销售备注", example = "45度")
    private String saleRemark;

    // ========== 产品属性字段 ==========

    @Schema(description = "材质", example = "304")
    private String material;

    @Schema(description = "品牌", example = "青山")
    private String brand;

    @Schema(description = "厂家", example = "天津友发")
    private String manufacturer;

    // ========== 发货/送货信息字段 ==========

    @Schema(description = "重量（吨）", example = "2.5")
    private BigDecimal weight;

    @Schema(description = "长度（米）", example = "6")
    private BigDecimal length;

    @Schema(description = "总米数", example = "60")
    private BigDecimal totalMeters;

    @Schema(description = "车号", example = "豫A6197J")
    private String vehicleNo;

    // ========== 管理员填写字段（采购成本信息）==========

    @Schema(description = "进货单位", example = "个")
    private String purchaseUnit;

    @Schema(description = "进货数量", example = "50")
    private BigDecimal purchaseQuantity;

    @Schema(description = "采购单价", example = "16")
    private BigDecimal purchasePrice;

    @Schema(description = "采购金额", example = "800")
    private BigDecimal purchaseAmount;

    @Schema(description = "采购备注", example = "")
    private String purchaseRemark;

    @Schema(description = "供应商ID", example = "1")
    private Long supplierId;

    @Schema(description = "供应商名称", example = "武汉钢铁")
    private String supplierName;

    // ========== 利润计算字段 ==========

    @Schema(description = "毛利", example = "50")
    private BigDecimal grossProfit;

    @Schema(description = "税额", example = "2")
    private BigDecimal taxAmount;

    @Schema(description = "净利", example = "48")
    private BigDecimal netProfit;

    // ========== 付款信息字段 ==========

    @Schema(description = "付款日期", example = "2024-01-15")
    private LocalDate paymentDate;

    @Schema(description = "是否已付款", example = "false")
    private Boolean isPaid;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
