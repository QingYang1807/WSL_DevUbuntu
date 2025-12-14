# V0.1 版本日志

## 更新日期
2025-12-15

## 更新内容

### 1. 基础服务搭建
完成以下服务的 Docker 容器化部署：
- **Redis 7**
- **MinIO** (对象存储)
- **Nacos 2.3.0** (注册中心/配置中心)
- **Kafka** (KRaft 模式)
- **Elasticsearch 8.11.0**

### 2. 工具脚本
- 新增 `services.sh` 批量管理脚本
  - 支持 `start`, `stop`, `restart`, `status`, `logs` 等命令
  - 支持批量或单独控制服务

### 3. 文档
- 新增项目 `README.md`，包含详细的服务信息和使用说明
