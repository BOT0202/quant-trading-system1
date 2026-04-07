#!/bin/bash

# 停止自动同步

echo "🛑 停止自动同步服务..."
echo "========================================"

# 查找并停止进程
PIDS=$(ps aux | grep "run_hourly.sh" | grep -v grep | awk '{print $2}')

if [ -z "$PIDS" ]; then
    echo "✅ 服务未运行"
else
    echo "找到进程: $PIDS"
    kill $PIDS 2>/dev/null
    echo "✅ 服务已停止"
fi
