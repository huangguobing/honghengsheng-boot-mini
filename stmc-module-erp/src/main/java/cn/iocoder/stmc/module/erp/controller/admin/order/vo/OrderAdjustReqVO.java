package cn.iocoder.stmc.module.erp.controller.admin.order.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Schema(description = "管理后台 - ERP 订单调整 Request VO")
@Data
public class OrderAdjustReqVO {

    @Schema(description = "订单 ID", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "订单 ID 不能为空")
    private Long orderId;

    @Schema(description = "运费", example = "100")
    private BigDecimal shippingFee;

    @Schema(description = "折扣金额", example = "50")
    private BigDecimal discountAmount;

    @Schema(description = "调整后的订单商品列表", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotEmpty(message = "订单商品不能为空")
    @Valid
    private List<Item> items;

    @Schema(description = "调整后的采购单列表（保留原采购单头，仅替换明细）")
    @Valid
    private List<PurchaseOrder> purchaseOrders;

    @Schema(description = "调整后的应付计划列表")
    @Valid
    private List<Plan> payablePlans;

    @Schema(description = "调整后的应收计划列表")
    @Valid
    private List<Plan> receivablePlans;

    @Schema(description = "费用列表")
    @Valid
    private List<Expense> expenses;

    @Data
    public static class Item {

        @Schema(description = "前端稳定键，用于关联采购分配", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotBlank(message = "商品键不能为空")
        private String clientKey;

        @Schema(description = "订单明细 ID，已有明细时传")
        private Long id;

        @Schema(description = "明细类型 0=商品 1=费用", example = "0")
        private Integer itemType;

        @Schema(description = "商品名称", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotBlank(message = "商品名称不能为空")
        private String productName;

        @Schema(description = "规格")
        private String spec;

        @Schema(description = "销售单位")
        private String saleUnit;

        @Schema(description = "销售数量", example = "10")
        @NotNull(message = "销售数量不能为空")
        private BigDecimal saleQuantity;

        @Schema(description = "销售单价", example = "100")
        @NotNull(message = "销售单价不能为空")
        private BigDecimal salePrice;

        @Schema(description = "销售金额", example = "1000")
        private BigDecimal saleAmount;

        @Schema(description = "销售备注")
        private String saleRemark;

        @Schema(description = "材质")
        private String material;

        @Schema(description = "品牌")
        private String brand;

        @Schema(description = "厂家")
        private String manufacturer;

        @Schema(description = "重量", example = "1.23")
        private BigDecimal weight;

        @Schema(description = "长度", example = "6")
        private BigDecimal length;

        @Schema(description = "总米数", example = "60")
        private BigDecimal totalMeters;

        @Schema(description = "税额", example = "20")
        private BigDecimal taxAmount;
    }

    @Data
    public static class PurchaseOrder {

        @Schema(description = "采购单 ID", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
        @NotNull(message = "采购单 ID 不能为空")
        private Long id;

        @Schema(description = "供应商 ID", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
        @NotNull(message = "供应商 ID 不能为空")
        private Long supplierId;

        @Schema(description = "采购单明细列表")
        @Valid
        private List<PurchaseItem> items;
    }

    @Data
    public static class PurchaseItem {

        @Schema(description = "关联订单商品前端稳定键", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotBlank(message = "关联商品键不能为空")
        private String orderItemClientKey;

        @Schema(description = "商品名称", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotBlank(message = "商品名称不能为空")
        private String productName;

        @Schema(description = "规格")
        private String spec;

        @Schema(description = "单位")
        private String unit;

        @Schema(description = "数量", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotNull(message = "数量不能为空")
        private BigDecimal quantity;

        @Schema(description = "重量", example = "1.23")
        private BigDecimal weight;

        @Schema(description = "采购单价", example = "80")
        @NotNull(message = "采购单价不能为空")
        private BigDecimal purchasePrice;

        @Schema(description = "采购金额", example = "800")
        @NotNull(message = "采购金额不能为空")
        private BigDecimal purchaseAmount;
    }

    @Data
    public static class Plan {

        @Schema(description = "计划 ID，已有计划时传")
        private Long id;

        @Schema(description = "关联采购单 ID，应付时传")
        private Long purchaseOrderId;

        @Schema(description = "计划金额", requiredMode = Schema.RequiredMode.REQUIRED, example = "5000")
        @NotNull(message = "计划金额不能为空")
        private BigDecimal planAmount;

        @Schema(description = "收付方式")
        private Integer paymentMethod;

        @Schema(description = "备注")
        private String remark;

        @Schema(description = "计划日期")
        private LocalDate planDate;

        @Schema(description = "是否删除")
        private Boolean deleted;
    }

    @Data
    public static class Expense {

        @Schema(description = "费用 ID")
        private Long id;

        @Schema(description = "费用日期", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotNull(message = "费用日期不能为空")
        private LocalDate expenseDate;

        @Schema(description = "运费", example = "100")
        private BigDecimal freight;

        @Schema(description = "吊装费", example = "100")
        private BigDecimal craneFee;

        @Schema(description = "复印费", example = "10")
        private BigDecimal copyFee;

        @Schema(description = "其他费用", example = "20")
        private BigDecimal otherFee;

        @Schema(description = "车牌号")
        private String vehicleNo;

        @Schema(description = "备注")
        private String remark;

        @Schema(description = "是否删除")
        private Boolean deleted;
    }
}
