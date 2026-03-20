package cn.iocoder.stmc.module.erp.dal.dataobject.product;

import cn.iocoder.stmc.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@TableName("erp_product_spec")
@KeySequence("erp_product_spec_seq")
@Data
@EqualsAndHashCode(callSuper = true)
public class ProductSpecDO extends BaseDO {

    @TableId
    private Long id;
    private Long productId;
    private String spec;
    private String unit;
    /** 材质（如304、20#） */
    private String material;
    /** 品牌（如青山、友发） */
    private String brand;
    /** 厂家 */
    private String manufacturer;
    /**
     * 计量方式（过磅/理计）
     */
    private String measurementType;
    private Integer status;
    private Integer sort;

}
