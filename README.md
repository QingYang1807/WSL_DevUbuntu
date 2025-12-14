# Development Environment Docker Services

[中文](./README_zh-CN.md)

This project provides a one-click development environment setup, including the following basic services:

- **Redis** - High-performance key-value store
- **MinIO** - Object storage service (S3 compatible)
- **Nacos** - Service discovery and configuration center
- **Kafka** - Distributed message queue
- **Elasticsearch** - Distributed search engine

## Quick Start

```bash
# Start all services
./services.sh start

# Check service status
./services.sh status
```

## Service Information

| Service | Image Version | Ports | Description |
|---------|---------------|-------|-------------|
| Redis | redis:7-alpine | 6379 | Persistence enabled |
| MinIO | minio/minio:latest | 9000, 9001 | 9000=API, 9001=Console |
| Nacos | nacos/nacos-server:v2.3.0 | 8848, 9848, 9849 | Standalone mode |
| Kafka | apache/kafka:latest | 9092 | KRaft mode (No Zookeeper) |
| Elasticsearch | elasticsearch:8.11.0 | 9200, 9300 | Single-node mode |

## Access Addresses

### Redis
```
Address: localhost:6379
```

Connection example:
```bash
redis-cli -h localhost -p 6379
```

### MinIO
```
Console:  http://localhost:9001
API:      http://localhost:9000
Username: admin
Password: admin123456
```

### Nacos
```
Console: http://localhost:8848/nacos
```

### Kafka
```
Address: localhost:9092
```

Connection example (external app):
```properties
bootstrap.servers=localhost:9092
```

### Elasticsearch
```
API: http://localhost:9200
```

Test connection:
```bash
curl http://localhost:9200
```

## Management Script Usage

### Basic Commands

```bash
./services.sh start              # Start all services
./services.sh stop               # Stop all services
./services.sh restart            # Restart all services
./services.sh status             # View service status
./services.sh logs               # View all service logs
./services.sh pull               # Pull latest images
./services.sh clean              # Stop and remove containers and volumes
./services.sh info               # Show service access info
```

### Operation on Single Service

```bash
./services.sh start redis        # Start only Redis
./services.sh stop kafka         # Stop only Kafka
./services.sh restart nacos      # Restart Nacos
./services.sh logs minio         # View MinIO logs
```

### Operation on Multiple Services

```bash
./services.sh start redis kafka  # Start Redis and Kafka
./services.sh stop redis minio nacos kafka elasticsearch  # Stop multiple services
```

## Data Persistence

All service data is persisted via Docker Volumes:

| Volume | Service | Description |
|--------|---------|-------------|
| redis_data | Redis | RDB/AOF persistence data |
| minio_data | MinIO | Stored object data |
| nacos_data | Nacos | Configuration and registry data |
| kafka_data | Kafka | Message log data |
| elasticsearch_data | Elasticsearch | Index data |

View Volumes:
```bash
docker volume ls | grep dev
```

## FAQ

### Port Occupied

If startup fails due to port occupation, check if other local services are using the ports:
```bash
lsof -i :6379   # Redis
lsof -i :9000   # MinIO
lsof -i :8848   # Nacos
lsof -i :9092   # Kafka
```

### Troubleshooting with Logs

```bash
./services.sh logs kafka    # View Kafka logs
docker logs dev-nacos       # View container logs directly
```

### Reset All Data

```bash
./services.sh clean         # Will ask for confirmation, deletes all containers and data
./services.sh start         # Restart
```

### MinIO Initialization

After first startup, create Buckets via the console `http://localhost:9001`.

## Network

All services are in the same Docker network `dev-network`. Containers can access each other via service names:

```
redis:6379
minio:9000
nacos:8848
kafka:9092
elasticsearch:9200
```

## System Requirements

- Docker 20.10+
- Docker Compose v2+
- Recommended RAM 4GB+
