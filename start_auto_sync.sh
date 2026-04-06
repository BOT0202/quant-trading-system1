#!/bin/bash

# 启动自动同步

echo "🚀 启动自动同步服务..."
echo "========================================"

# 检查是否已在运行
if ps aux | grep -v grep | grep -q "run_hourly.sh"; then
    echo "⚠️  服务已在运行"
    ps aux | grep -v grep | grep "run_hourly.sh"
    exit 0
fi

# 在后台启动
nohup "$HOME/quant-auto-sync/run_hourly.sh" > "$HOME/quant-auto-sync/logs/daemon.log" 2>&1 &

echo "✅ 服务已启动"
echo "PID: $!"
echo "日志: $HOME/quant-auto-sync/logs/daemon.log"

echo ""
echo "📋 查看状态:"
echo "  ps aux | grep run_hourly"
echo "  tail -f $HOME/quant-auto-sync/logs/daemon.log"
