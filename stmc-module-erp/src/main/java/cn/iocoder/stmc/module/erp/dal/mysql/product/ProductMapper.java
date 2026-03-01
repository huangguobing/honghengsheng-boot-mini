package cn.iocoder.stmc.module.erp.dal.mysql.product;

import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.stmc.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.stmc.module.erp.controller.admin.product.vo.ProductPageReqVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.product.ProductDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ProductMapper extends BaseMapperX<ProductDO> {

    default PageResult<ProductDO> selectPage(ProductPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<ProductDO>()
                .likeIfPresent(ProductDO::getName, reqVO.getName())
                .eqIfPresent(ProductDO::getStatus, reqVO.getStatus())
                .orderByAsc(ProductDO::getSort)
                .orderByDesc(ProductDO::getCreateTime));
    }

    default ProductDO selectByName(String name) {
        return selectOne(ProductDO::getName, name);
    }

    default List<ProductDO> selectListByStatus(Integer status) {
        return selectList(new LambdaQueryWrapperX<ProductDO>()
                .eqIfPresent(ProductDO::getStatus, status)
                .orderByAsc(ProductDO::getSort));
    }

    default List<ProductDO> selectListByNameLike(String name) {
        return selectList(new LambdaQueryWrapperX<ProductDO>()
                .likeIfPresent(ProductDO::getName, name)
                .eq(ProductDO::getStatus, 0)
                .orderByAsc(ProductDO::getSort));
    }
}
