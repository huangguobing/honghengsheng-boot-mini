package cn.iocoder.stmc.module.erp.controller.admin.order.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import javax.validation.Valid;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - ERP 订单新增/修改 Request VO")
@Data
public class OrderSaveReqVO {

    @Schema(description = "订单编号", requiredMode = Schema.RequiredMode.AUTO, example = "1")
    private Long id;

    @Schema(description = "订单号", example = "SO202312250001")
    private String orderNo;

    @Schema(description = "客户编号（销售订单使用）", example = "1")
    private Long customerId;

    @Schema(description = "供应商编号（采购订单使用）", example = "1")
    private Long supplierId;

    @Schema(description = "订单类型（1销售 2采购）", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "订单类型不能为空")
    private Integer orderType;

    @Schema(description = "订单日期", example = "2023-12-25")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime orderDate;

    @Schema(description = "交货日期", example = "2023-12-30")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime deliveryDate;

    @Schema(description = "商品总数量", example = "100")
    private BigDecimal totalQuantity;

    @Schema(description = "商品总金额", example = "10000.00")
    private BigDecimal totalAmount;

    @Schema(description = "折扣金额", example = "500.00")
    private BigDecimal discountAmount;

    @Schema(description = "联系人", example = "张三")
    private String contact;

    @Schema(description = "联系电话", example = "13800138000")
    private String mobile;

    @Schema(description = "收货地址", example = "北京市朝阳区")
    private String address;

    @Schema(description = "收货单位")
    private String receivingUnit;

    @Schema(description = "备注", example = "加急订单")
    private String remark;

    @Schema(description = "提货车号", example = "豫A6197J")
    private String vehicleNo;

    @Schema(description = "发货费/运费", example = "30")
    private BigDecimal shippingFee;

    @Schema(description = "其他费用金额", example = "50")
    private BigDecimal extraCost;

    @Schema(description = "其他费用备注", example = "快递费")
    private String extraCostRemark;

    @Schema(description = "项目/工地ID", example = "1")
    private Long projectId;

    @Schema(description = "开票公司: 1=熙汇达鑫 2=鸿恒盛", example = "1")
    private Integer invoiceCompany;

    @Schema(description = "是否有采购周期: 0=否 1=是", example = "0")
    private Integer hasPurchaseCycle;

    @Schema(description = "采购周期备注", example = "预计2周到货")
    private String purchaseCycleNote;

    @Schema(description = "商品明细列表", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotEmpty(message = "商品明细不能为空")
    @Valid
    private List<OrderItemSaveReqVO> items;

}
