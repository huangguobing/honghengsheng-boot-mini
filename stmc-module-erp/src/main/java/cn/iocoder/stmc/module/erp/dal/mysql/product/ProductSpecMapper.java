package cn.iocoder.stmc.module.erp.dal.mysql.product;

import cn.iocoder.stmc.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.module.erp.dal.dataobject.product.ProductSpecDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ProductSpecMapper extends BaseMapperX<ProductSpecDO> {

    default List<ProductSpecDO> selectListByProductId(Long productId) {
        return selectList(new LambdaQueryWrapperX<ProductSpecDO>()
                .eq(ProductSpecDO::getProductId, productId)
                .orderByAsc(ProductSpecDO::getSort));
    }

    default List<ProductSpecDO> selectListByProductIdAndStatus(Long productId, Integer status) {
        return selectList(new LambdaQueryWrapperX<ProductSpecDO>()
                .eq(ProductSpecDO::getProductId, productId)
                .eq(ProductSpecDO::getStatus, status)
                .orderByAsc(ProductSpecDO::getSort));
    }

    default void deleteByProductId(Long productId) {
        delete(new LambdaQueryWrapperX<ProductSpecDO>()
                .eq(ProductSpecDO::getProductId, productId));
    }
}
