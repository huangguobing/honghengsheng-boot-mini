package cn.iocoder.stmc.module.erp.controller.admin.order.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - ERP 订单 Response VO")
@Data
public class OrderRespVO {

    @Schema(description = "订单编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long id;

    @Schema(description = "订单号", requiredMode = Schema.RequiredMode.REQUIRED, example = "SO202312250001")
    private String orderNo;

    @Schema(description = "客户编号（销售订单使用）", example = "1")
    private Long customerId;

    @Schema(description = "客户名称", example = "张三")
    private String customerName;

    @Schema(description = "供应商编号（采购订单使用）", example = "1")
    private Long supplierId;

    @Schema(description = "供应商名称", example = "供应商A")
    private String supplierName;

    @Schema(description = "订单类型（1销售 2采购）", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Integer orderType;

    @Schema(description = "订单状态", requiredMode = Schema.RequiredMode.REQUIRED, example = "0")
    private Integer status;

    @Schema(description = "订单日期", example = "2023-12-25")
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private LocalDateTime orderDate;

    @Schema(description = "交货日期", example = "2023-12-30")
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private LocalDateTime deliveryDate;

    @Schema(description = "商品总数量", example = "100")
    private BigDecimal totalQuantity;

    @Schema(description = "商品总金额", example = "10000.00")
    private BigDecimal totalAmount;

    @Schema(description = "折扣金额", example = "500.00")
    private BigDecimal discountAmount;

    @Schema(description = "应付金额", example = "9500.00")
    private BigDecimal payableAmount;

    @Schema(description = "已付金额", example = "5000.00")
    private BigDecimal paidAmount;

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

    @Schema(description = "创建时间", requiredMode = Schema.RequiredMode.REQUIRED)
    private LocalDateTime createTime;

    // ========== 新增字段 ==========

    @Schema(description = "发货费/运费", example = "30")
    private BigDecimal shippingFee;

    @Schema(description = "采购总成本", example = "8000")
    private BigDecimal totalPurchaseAmount;

    @Schema(description = "总毛利", example = "2000")
    private BigDecimal totalGrossProfit;

    @Schema(description = "总税额", example = "100")
    private BigDecimal totalTaxAmount;

    @Schema(description = "总净利", example = "1900")
    private BigDecimal totalNetProfit;

    @Schema(description = "其他费用金额", example = "50")
    private BigDecimal extraCost;

    @Schema(description = "其他费用备注", example = "快递费")
    private String extraCostRemark;

    @Schema(description = "成本是否已填充", example = "false")
    private Boolean costFilled;

    @Schema(description = "成本填充人ID", example = "1")
    private Long costFilledBy;

    @Schema(description = "成本填充人姓名", example = "管理员")
    private String costFilledByName;

    @Schema(description = "成本填充时间")
    private LocalDateTime costFilledTime;

    @Schema(description = "业务员ID", example = "2")
    private Long salesmanId;

    @Schema(description = "业务员姓名", example = "张三")
    private String salesmanName;

    // ========== 鸿恒盛适配字段 ==========

    @Schema(description = "项目/工地ID", example = "1")
    private Long projectId;

    @Schema(description = "项目/工地名称", example = "XX工地")
    private String projectName;

    @Schema(description = "开票公司: 1=熙汇达鑫 2=鸿恒盛", example = "1")
    private Integer invoiceCompany;

    @Schema(description = "是否有采购周期: 0=否 1=是", example = "0")
    private Integer hasPurchaseCycle;

    @Schema(description = "采购周期备注", example = "预计2周到货")
    private String purchaseCycleNote;

    @Schema(description = "原订单ID", example = "1")
    private Long parentOrderId;

    @Schema(description = "原订单号", example = "SO202312250001")
    private String parentOrderNo;

    @Schema(description = "是否退货单: 0=否 1=是", example = "0")
    private Integer isReturn;

    @Schema(description = "副订单状态: 0=无副订单 1=已有副订单", example = "0")
    private Integer subOrderStatus;

    @Schema(description = "商品明细列表")
    private List<OrderItemRespVO> items;

}
