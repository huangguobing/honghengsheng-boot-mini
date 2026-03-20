package cn.iocoder.stmc.module.erp.controller.admin.order.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.List;

@Schema(description = "管理后台 - ERP 副订单保存 Request VO")
@Data
public class SubOrderSaveReqVO {

    @Schema(description = "主订单ID", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "主订单ID不能为空")
    private Long parentOrderId;

    @Schema(description = "客户ID")
    private Long customerId;

    @Schema(description = "项目ID（熙汇达鑫维度二级项目）")
    private Long projectId;

    @Schema(description = "联系人")
    private String contact;

    @Schema(description = "手机号")
    private String mobile;

    @Schema(description = "收货地址")
    private String address;

    @Schema(description = "收货单位")
    private String receivingUnit;

    @Schema(description = "提货车号")
    private String vehicleNo;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "商品明细列表")
    @NotNull(message = "商品明细不能为空")
    private List<SubOrderItemVO> items;

    @Data
    public static class SubOrderItemVO {
        @Schema(description = "关联主订单商品行ID")
        private Long parentItemId;

        @Schema(description = "明细类型（0商品 1费用）")
        private Integer itemType;

        @Schema(description = "商品名称")
        private String productName;

        @Schema(description = "规格")
        private String spec;

        @Schema(description = "材质")
        private String material;

        @Schema(description = "销售单位")
        private String saleUnit;

        @Schema(description = "数量")
        private BigDecimal saleQuantity;

        @Schema(description = "单价")
        private BigDecimal salePrice;

        @Schema(description = "金额")
        private BigDecimal saleAmount;

        @Schema(description = "备注")
        private String saleRemark;

        @Schema(description = "品牌")
        private String brand;

        @Schema(description = "厂家")
        private String manufacturer;

        @Schema(description = "重量（吨）")
        private BigDecimal weight;

        @Schema(description = "长度（米）")
        private BigDecimal length;

        @Schema(description = "总米数")
        private BigDecimal totalMeters;

        @Schema(description = "车号")
        private String vehicleNo;
    }
}
