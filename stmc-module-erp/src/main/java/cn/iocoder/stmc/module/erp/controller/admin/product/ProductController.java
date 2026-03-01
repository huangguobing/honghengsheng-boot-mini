package cn.iocoder.stmc.module.erp.controller.admin.product;

import cn.iocoder.stmc.framework.common.pojo.CommonResult;
import cn.iocoder.stmc.framework.common.pojo.PageResult;
import cn.iocoder.stmc.framework.common.util.object.BeanUtils;
import cn.iocoder.stmc.module.erp.controller.admin.product.vo.ProductPageReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.product.vo.ProductRespVO;
import cn.iocoder.stmc.module.erp.controller.admin.product.vo.ProductSaveReqVO;
import cn.iocoder.stmc.module.erp.controller.admin.product.vo.ProductSpecRespVO;
import cn.iocoder.stmc.module.erp.dal.dataobject.product.ProductDO;
import cn.iocoder.stmc.module.erp.dal.dataobject.product.ProductSpecDO;
import cn.iocoder.stmc.module.erp.service.product.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.List;

import static cn.iocoder.stmc.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - ERP 产品")
@RestController
@RequestMapping("/erp/product")
@Validated
public class ProductController {

    @Resource
    private ProductService productService;

    @PostMapping("/create")
    @Operation(summary = "创建产品")
    @PreAuthorize("@ss.hasPermission('erp:product:create')")
    public CommonResult<Long> createProduct(@Valid @RequestBody ProductSaveReqVO createReqVO) {
        return success(productService.createProduct(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新产品")
    @PreAuthorize("@ss.hasPermission('erp:product:update')")
    public CommonResult<Boolean> updateProduct(@Valid @RequestBody ProductSaveReqVO updateReqVO) {
        productService.updateProduct(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除产品")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:product:delete')")
    public CommonResult<Boolean> deleteProduct(@RequestParam("id") Long id) {
        productService.deleteProduct(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得产品（含规格）")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('erp:product:query')")
    public CommonResult<ProductRespVO> getProduct(@RequestParam("id") Long id) {
        ProductDO product = productService.getProduct(id);
        if (product == null) {
            return success(null);
        }
        ProductRespVO respVO = BeanUtils.toBean(product, ProductRespVO.class);
        List<ProductSpecDO> specs = productService.getProductSpecList(id);
        respVO.setSpecs(BeanUtils.toBean(specs, ProductSpecRespVO.class));
        respVO.setSpecCount(specs.size());
        return success(respVO);
    }

    @GetMapping("/page")
    @Operation(summary = "获得产品分页")
    @PreAuthorize("@ss.hasPermission('erp:product:query')")
    public CommonResult<PageResult<ProductRespVO>> getProductPage(@Valid ProductPageReqVO pageVO) {
        PageResult<ProductDO> pageResult = productService.getProductPage(pageVO);
        // 转换并填充规格数量
        PageResult<ProductRespVO> result = BeanUtils.toBean(pageResult, ProductRespVO.class);
        for (ProductRespVO vo : result.getList()) {
            List<ProductSpecDO> specs = productService.getProductSpecList(vo.getId());
            vo.setSpecCount(specs.size());
            vo.setSpecs(BeanUtils.toBean(specs, ProductSpecRespVO.class));
        }
        return success(result);
    }

    @GetMapping("/simple-list")
    @Operation(summary = "搜索启用产品列表（开单用）")
    @Parameter(name = "name", description = "产品名称关键词")
    public CommonResult<List<ProductRespVO>> getProductSimpleList(
            @RequestParam(value = "name", required = false) String name) {
        List<ProductDO> list = productService.getProductSimpleList(name);
        return success(BeanUtils.toBean(list, ProductRespVO.class));
    }

    @GetMapping("/spec/list-by-product")
    @Operation(summary = "根据产品ID获取启用规格列表（开单用）")
    @Parameter(name = "productId", description = "产品编号", required = true)
    public CommonResult<List<ProductSpecRespVO>> getProductSpecListByProduct(
            @RequestParam("productId") Long productId) {
        List<ProductSpecDO> list = productService.getProductSpecListByProductIdAndStatus(productId, 0);
        return success(BeanUtils.toBean(list, ProductSpecRespVO.class));
    }
}
