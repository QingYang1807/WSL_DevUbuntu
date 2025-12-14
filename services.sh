#!/bin/bash

# 开发环境服务管理脚本
# 支持的服务: redis, minio, nacos, kafka, elasticsearch

COMPOSE_FILE="$(dirname "$0")/docker-compose.yml"
SERVICES="redis minio nacos kafka elasticsearch"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}     开发环境服务管理脚本${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_usage() {
    echo -e "\n${YELLOW}用法:${NC} $0 {命令} [服务名...]"
    echo -e "\n${YELLOW}命令:${NC}"
    echo -e "  ${GREEN}start${NC}     启动服务"
    echo -e "  ${GREEN}stop${NC}      停止服务"
    echo -e "  ${GREEN}restart${NC}   重启服务"
    echo -e "  ${GREEN}status${NC}    查看服务状态"
    echo -e "  ${GREEN}logs${NC}      查看服务日志"
    echo -e "  ${GREEN}pull${NC}      拉取最新镜像"
    echo -e "  ${GREEN}clean${NC}     停止并删除容器和卷"
    echo -e "\n${YELLOW}服务:${NC} redis, minio, nacos, kafka"
    echo -e "       不指定服务则操作全部服务"
    echo -e "\n${YELLOW}示例:${NC}"
    echo -e "  $0 start              # 启动所有服务"
    echo -e "  $0 start redis kafka  # 只启动 redis 和 kafka"
    echo -e "  $0 logs nacos         # 查看 nacos 日志"
    echo -e "  $0 status             # 查看所有服务状态"
}

print_info() {
    echo -e "\n${YELLOW}服务访问信息:${NC}"
    echo -e "  ${GREEN}Redis:${NC}    localhost:6379"
    echo -e "  ${GREEN}MinIO:${NC}    http://localhost:9001 (控制台)"
    echo -e "            API: localhost:9000"
    echo -e "            用户: admin / admin123456"
    echo -e "  ${GREEN}Nacos:${NC}    http://localhost:8848/nacos"
    echo -e "  ${GREEN}Kafka:${NC}    localhost:9092"
    echo -e "  ${GREEN}Elasticsearch:${NC} http://localhost:9200"
}

do_start() {
    local services=$1
    echo -e "${GREEN}正在启动服务...${NC}"
    docker compose -f "$COMPOSE_FILE" up -d $services
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}服务启动成功!${NC}"
        print_info
    else
        echo -e "${RED}服务启动失败!${NC}"
        exit 1
    fi
}

do_stop() {
    local services=$1
    echo -e "${YELLOW}正在停止服务...${NC}"
    docker compose -f "$COMPOSE_FILE" stop $services
    echo -e "${GREEN}服务已停止${NC}"
}

do_restart() {
    local services=$1
    echo -e "${YELLOW}正在重启服务...${NC}"
    docker compose -f "$COMPOSE_FILE" restart $services
    echo -e "${GREEN}服务重启完成${NC}"
}

do_status() {
    echo -e "${BLUE}服务状态:${NC}"
    docker compose -f "$COMPOSE_FILE" ps
}

do_logs() {
    local services=$1
    docker compose -f "$COMPOSE_FILE" logs -f --tail=100 $services
}

do_pull() {
    echo -e "${YELLOW}正在拉取最新镜像...${NC}"
    docker compose -f "$COMPOSE_FILE" pull
    echo -e "${GREEN}镜像拉取完成${NC}"
}

do_clean() {
    echo -e "${RED}警告: 此操作将删除所有容器和数据卷!${NC}"
    read -p "确认继续? (y/N): " confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        docker compose -f "$COMPOSE_FILE" down -v
        echo -e "${GREEN}清理完成${NC}"
    else
        echo -e "${YELLOW}操作已取消${NC}"
    fi
}

# 检查 docker compose 是否可用
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}错误: Docker 未安装${NC}"
        exit 1
    fi
    if ! docker compose version &> /dev/null; then
        echo -e "${RED}错误: Docker Compose 不可用${NC}"
        exit 1
    fi
}

# 主逻辑
main() {
    check_docker
    
    if [ $# -lt 1 ]; then
        print_header
        print_usage
        exit 0
    fi

    command=$1
    shift
    services="$*"

    case $command in
        start)
            do_start "$services"
            ;;
        stop)
            do_stop "$services"
            ;;
        restart)
            do_restart "$services"
            ;;
        status)
            do_status
            ;;
        logs)
            do_logs "$services"
            ;;
        pull)
            do_pull
            ;;
        clean)
            do_clean
            ;;
        info)
            print_info
            ;;
        *)
            echo -e "${RED}未知命令: $command${NC}"
            print_usage
            exit 1
            ;;
    esac
}

main "$@"
