# 开发环境 Docker 服务

[English](./README.md)

本项目提供一键式开发环境搭建，包含以下基础服务：

- **Redis** - 高性能键值存储
- **MinIO** - 对象存储服务（兼容 S3）
- **Nacos** - 服务发现与配置中心
- **Kafka** - 分布式消息队列
- **Elasticsearch** - 分布式搜索引擎

## 快速开始

```bash
# 启动所有服务
./services.sh start

# 查看服务状态
./services.sh status
```

## 服务信息

| 服务 | 镜像版本 | 端口 | 说明 |
|------|---------|------|------|
| Redis | redis:7-alpine | 6379 | 数据持久化已开启 |
| MinIO | minio/minio:latest | 9000, 9001 | 9000=API, 9001=控制台 |
| Nacos | nacos/nacos-server:v2.3.0 | 8848, 9848, 9849 | 单机模式 |
| Kafka | apache/kafka:latest | 9092 | KRaft 模式（无需 Zookeeper） |
| Elasticsearch | elasticsearch:8.11.0 | 9200, 9300 | 单节点模式 |

## 访问地址

### Redis
```
地址: localhost:6379
```

连接示例：
```bash
redis-cli -h localhost -p 6379
```

### MinIO
```
控制台: http://localhost:9001
API:    http://localhost:9000
用户名: admin
密码:   admin123456
```

### Nacos
```
控制台: http://localhost:8848/nacos
```

### Kafka
```
地址: localhost:9092
```

连接示例（外部应用）：
```properties
bootstrap.servers=localhost:9092
```

### Elasticsearch
```
API: http://localhost:9200
```

测试连接：
```bash
curl http://localhost:9200
```

## 管理脚本使用

### 基本命令

```bash
./services.sh start              # 启动所有服务
./services.sh stop               # 停止所有服务
./services.sh restart            # 重启所有服务
./services.sh status             # 查看服务状态
./services.sh logs               # 查看所有服务日志
./services.sh pull               # 拉取最新镜像
./services.sh clean              # 停止并删除容器和数据卷
./services.sh info               # 显示服务访问信息
```

### 操作单个服务

```bash
./services.sh start redis        # 只启动 Redis
./services.sh stop kafka         # 只停止 Kafka
./services.sh restart nacos      # 重启 Nacos
./services.sh logs minio         # 查看 MinIO 日志
```

### 操作多个服务

```bash
./services.sh start redis kafka  # 启动 Redis 和 Kafka
./services.sh stop redis minio nacos kafka elasticsearch  # 停止 Redis 和 MinIO
```

## 数据持久化

所有服务数据均通过 Docker Volume 持久化：

| Volume | 服务 | 说明 |
|--------|------|------|
| redis_data | Redis | RDB/AOF 持久化数据 |
| minio_data | MinIO | 存储的对象数据 |
| nacos_data | Nacos | 配置和服务注册数据 |
| kafka_data | Kafka | 消息日志数据 |
| elasticsearch_data | Elasticsearch | 索引数据 |

查看 Volume：
```bash
docker volume ls | grep dev
```

## 常见问题

### 端口被占用

如果启动失败提示端口被占用，请检查本地是否有其他服务占用了相关端口：
```bash
lsof -i :6379   # Redis
lsof -i :9000   # MinIO
lsof -i :8848   # Nacos
lsof -i :9092   # Kafka
```

### 查看服务日志排查问题

```bash
./services.sh logs kafka    # 查看 Kafka 日志
docker logs dev-nacos       # 直接查看容器日志
```

### 重置所有数据

```bash
./services.sh clean         # 会提示确认，删除所有容器和数据
./services.sh start         # 重新启动
```

### MinIO 初始化

首次启动后，可通过控制台 `http://localhost:9001` 创建 Bucket。

## 网络

所有服务位于同一 Docker 网络 `dev-network` 中，容器间可通过服务名互相访问：

```
redis:6379
minio:9000
nacos:8848
kafka:9092
elasticsearch:9200
```

## 系统要求

- Docker 20.10+
- Docker Compose v2+
- 建议内存 4GB+
