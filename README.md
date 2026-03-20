# 鸿恒盛供应链管理系统 - 后端项目

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-2.7.18-green.svg)](https://spring.io/projects/spring-boot)
[![MyBatis Plus](https://img.shields.io/badge/MyBatis%20Plus-3.5.14-blue.svg)](https://baomidou.com/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)

> 基于芋道 `ruoyi-vue-pro` 二次开发的供应链 ERP 后端，面向钢材贸易场景，围绕订单、采购、结算、费用、附件、凭证和统计分析构建业务闭环。

## 项目简介

**鸿恒盛供应链管理系统** 是一个面向供应链贸易场景的 ERP 管理平台。  
当前系统的核心不是库存生产，而是围绕以下链路运转：

`客户 / 项目 -> 主订单 -> 采购订单 -> 应收应付计划 -> 费用支出 -> 凭证 / 附件 -> 统计分析 -> 副订单 / 退换货调整`

项目保留了芋道原有的系统管理、基础设施、权限、日志、文件、定时任务等能力，并在 `stmc-module-erp` 中沉淀了当前业务的核心实现。

### 当前业务口径

- 正式业务角色以 `super_admin / honghengsheng / xihuidaxin` 为准
- `honghengsheng` 对应 A 角色，负责主订单经营闭环
- `xihuidaxin` 对应 B 角色，负责基于主订单录入副订单 / 发货单
- 代码中仍存在部分 `salesman` 字段与兼容分支，它们更多承担“录入人 / 创建人”语义，不再代表旧版项目里的正式角色体系

## 核心功能

### 1. 基础主数据

- 客户管理：客户档案、联系人、项目关联、是否需要 B 角色录单等业务属性
- 项目管理：支持项目 / 工地维度维护，是订单、统计、打印的重要归属字段
- 产品管理：产品与规格维护，支撑订单行、采购行和统计分析
- 供应商管理：供应商资料、账期配置、采购结算维度维护

### 2. 订单管理

- 主订单创建、编辑、详情查看、打印导出
- 订单状态流转：草稿、已确认、已发货、结算中、已完成、已取消
- 订单行明细维护，支持销售价、采购价、利润相关字段汇总
- 副订单录入：B 角色可基于主订单生成副订单 / 发货单
- 退货与调整流程：支持负数退货单和订单联动调整
- 数据权限隔离：A 角色看主订单，B 角色看自己录入的副订单

### 3. 采购与结算

- 从销售订单拆分采购订单
- 按供应商生成付款计划
- 付款记录、对账汇总、结算状态联动
- 成本变更后可重建相关支付计划，保持订单与结算数据一致

### 4. 费用、凭证与附件

- 费用支出管理：运费、吊装费、杂费等成本项录入
- 凭证管理：票据 / 凭证数据维护
- 订单附件管理：图片、合同、票据附件上传与归档
- 操作日志时间线：围绕订单跟踪关键操作轨迹

### 5. 首页与统计分析

- 首页经营看板
- 客户销售统计
- 供应商采购统计
- 项目利润统计
- 产品销量统计
- 应收应付统计
- 开票汇总统计

### 6. 系统与基础设施

- 用户、角色、菜单、部门、岗位、字典管理
- 登录日志、操作日志、API 日志
- 文件配置、文件上传、代码生成、定时任务、Redis 监控
- Knife4j / Swagger 接口文档

---

## 二次开发说明

### 相比上游项目的主要调整

#### 1. 聚焦供应链 ERP 主线

当前项目把重心放在真实业务闭环，ERP 相关能力集中在以下模块：

- `customer`
- `project`
- `product`
- `supplier`
- `order`
- `purchase`
- `payment`
- `paymentplan`
- `expense`
- `voucher`
- `orderattachment`
- `statistics`
- `log`

#### 2. 强化双角色业务模型

- A 角色维护主订单经营数据
- B 角色从“待录入副订单”入口补录副订单 / 发货单
- 首页、订单列表、统计口径均按角色区分主订单与副订单
- 部分历史“业务员”逻辑仍保留在字段层和兼容判断中，但不再作为 README 的主业务口径

#### 3. 新增当前版本核心能力

- 项目管理模块
- 采购订单模块
- 费用支出模块
- 凭证模块
- 订单附件模块
- 副订单录入与关联展示
- 订单操作日志时间线
- 项目利润 / 产品销量 / 应收应付 / 开票汇总等统计接口
- 成本与付款计划联动重构

---

## 技术栈

### 核心框架

| 框架 | 说明 | 版本 |
|---|---|---|
| Spring Boot | 应用开发框架 | 2.7.18 |
| MyBatis Plus | ORM 增强框架 | 3.5.14 |
| MyBatis Plus Join | 联表查询扩展 | 1.5.4 |
| Spring Security | 认证授权 | 5.7.x |
| MySQL | 关系型数据库 | 8.0+ |
| Redis | 缓存与分布式能力 | 6.0+ |
| Druid | 数据源连接池 | 1.2.27 |
| Redisson | Redis 客户端 | 3.52.0 |
| Springdoc | OpenAPI 文档 | 1.8.0 |
| Knife4j | Swagger 增强文档 | 4.5.0 |
| MapStruct | Bean 转换 | 1.6.3 |
| Lombok | Java 代码简化 | 1.18.42 |
| Hutool | Java 工具库 | 5.8.41 |
| Guava | 通用工具库 | 33.5.0-jre |

### 项目模块

| 模块 | 说明 |
|---|---|
| `stmc-dependencies` | Maven 版本与依赖统一管理 |
| `stmc-framework` | 框架扩展、公共 starter 与基础能力 |
| `stmc-module-system` | 系统管理模块 |
| `stmc-module-infra` | 基础设施模块 |
| `stmc-module-erp` | 当前项目核心业务模块 |
| `stmc-server` | 启动类与运行配置 |

---

## 快速开始

### 环境要求

- JDK 8+
- Maven 3.6+
- MySQL 8.0+
- Redis 6.0+

### 1. 克隆项目

```bash
git clone https://github.com/huangguobing/honghengsheng-boot-mini.git
cd honghengsheng-boot-mini
```

### 2. 初始化数据库

推荐两种方式二选一：

- 方式一：直接导入完整库 `sql/mysql/stmc_erp_full.sql`
- 方式二：先导入基础库 `sql/mysql/stmc_erp.sql`，再根据数据库版本补充执行增量脚本

常见增量脚本包括：

- `sql/mysql/2026-03-07-cost-payment-redesign.sql`
- `sql/mysql/2026-03-15-dual-role-sub-order.sql`
- `sql/mysql/order_attachment.sql`
- `sql/mysql/product_management.sql`
- `sql/mysql/extra_cost.sql`

### 3. 修改本地配置

本地开发默认读取：

- `stmc-server/src/main/resources/application.yaml`
- `stmc-server/src/main/resources/application-local.yaml`

至少需要确认这些配置：

- MySQL 数据源
- Redis 连接
- 文件存储配置
- 第三方服务密钥和回调地址

### 4. 编译并运行

```bash
# 编译
mvn clean package -DskipTests

# 启动
java -jar stmc-server/target/stmc-server.jar
```

也可以直接在 IDE 中运行：

```text
stmc-server/src/main/java/cn/iocoder/stmc/server/StmcServerApplication.java
```

### 5. 访问地址

- 后端服务：`http://localhost:48080`
- 接口文档：`http://localhost:48080/doc.html`
- Swagger UI：`http://localhost:48080/swagger-ui/index.html`

默认初始化账号请以实际导入的数据库数据为准。  
当前项目文档口径建议重点关注以下角色编码：

- `super_admin`
- `honghengsheng`
- `xihuidaxin`

---

## 项目结构

```text
honghengsheng-boot-mini/
├── docs/                               # 后端设计与重构文档
├── sql/
│   └── mysql/                          # MySQL 初始化与增量脚本
├── stmc-dependencies/                  # 依赖版本管理
├── stmc-framework/                     # 通用框架能力
├── stmc-module-system/                 # 系统管理
├── stmc-module-infra/                  # 基础设施
├── stmc-module-erp/                    # ERP 核心业务
│   └── src/main/java/.../controller/admin/
│       ├── customer/                   # 客户
│       ├── project/                    # 项目
│       ├── product/                    # 产品
│       ├── supplier/                   # 供应商
│       ├── order/                      # 主订单 / 副订单 / 打印
│       ├── purchase/                   # 采购订单
│       ├── payment/                    # 付款记录
│       ├── paymentplan/                # 付款计划
│       ├── expense/                    # 费用支出
│       ├── voucher/                    # 凭证
│       ├── orderattachment/            # 订单附件
│       ├── statistics/                 # 统计分析
│       └── log/                        # 业务操作日志
└── stmc-server/                        # 启动模块
```

---

## 角色说明

### 1. `super_admin`

- 平台级管理员
- 拥有系统配置、角色权限、基础设施维护能力
- 可查看全量主订单数据

### 2. `honghengsheng`

- A 角色，主业务操作主体
- 负责客户、项目、产品、供应商、主订单、采购、费用、凭证、统计等完整经营链路
- 可查看主订单视角的经营结果与利润数据

### 3. `xihuidaxin`

- B 角色，中间商 / 副订单录入主体
- 负责基于主订单补录副订单 / 发货单
- 默认只看副订单，且只看自己录入的数据

---

## 开发建议

### 文档优先阅读

如需快速理解本轮业务改造，建议先看：

- `docs/plans/2026-03-07-cost-payment-redesign.md`
- `docs/plans/2026-03-07-cost-payment-redesign-design.md`

### 联调重点

- 订单状态口径是否与前端一致
- A / B 角色的数据隔离是否符合预期
- 成本、采购、付款计划、费用、统计之间是否保持联动
- 副订单是否只在 B 角色口径下展示

---

## 更新记录

### 2026-03

- 完成成本与付款计划链路重构
- 引入项目、采购订单、费用支出、凭证、订单附件等模块
- 增加副订单双角色流程
- 扩展项目利润、产品销量、应收应付、开票汇总等统计能力
- 强化首页看板与订单口径联动

---

## 开源协议

本项目基于 [Apache License 2.0](https://opensource.org/licenses/Apache-2.0) 开源。

---

## 致谢

感谢 [芋道源码 ruoyi-vue-pro](https://gitee.com/zhijiantianya/ruoyi-vue-pro) 提供的基础框架能力。

---

## 相关项目

- 前端项目：https://github.com/huangguobing/honghengsheng-ui-admin-vue3
- 上游后端项目：https://gitee.com/zhijiantianya/ruoyi-vue-pro
