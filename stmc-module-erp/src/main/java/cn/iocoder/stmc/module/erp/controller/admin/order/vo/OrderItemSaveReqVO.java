package cn.iocoder.stmc.module.erp.controller.admin.order.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;

@Schema(description = "管理后台 - ERP 订单明细新增/修改 Request VO")
@Data
public class OrderItemSaveReqVO {

    @Schema(description = "明细ID（修改时传）", example = "1")
    private Long id;

    @Schema(description = "明细类型（0商品 1费用）", example = "0")
    private Integer itemType;

    // ========== 业务员填写字段（销售信息）==========

    @Schema(description = "商品名称", example = "衬塑钢卡")
    private String productName;

    @Schema(description = "规格（如DN150、DN100）", example = "DN150")
    private String spec;

    @Schema(description = "销售单位（个、吨等）", example = "个")
    private String saleUnit;

    @Schema(description = "销售数量", example = "50")
    private BigDecimal saleQuantity;

    @Schema(description = "销售单价", example = "17")
    private BigDecimal salePrice;

    @Schema(description = "销售金额（数量*单价，前端计算）", example = "850")
    private BigDecimal saleAmount;

    @Schema(description = "销售备注（如45度、90度）", example = "45度")
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

    @Schema(description = "进货单位")
    private String purchaseUnit;

    @Schema(description = "进货数量")
    private BigDecimal purchaseQuantity;

    @Schema(description = "采购单价")
    private BigDecimal purchasePrice;

    @Schema(description = "采购金额")
    private BigDecimal purchaseAmount;

    @Schema(description = "采购备注")
    private String purchaseRemark;

    @Schema(description = "供应商ID")
    private Long supplierId;

    @Schema(description = "税额")
    private BigDecimal taxAmount;

    @Schema(description = "付款日期")
    private LocalDate paymentDate;

    @Schema(description = "是否已付款")
    private Boolean isPaid;

}
