#!/bin/bash

# 每小时运行脚本

echo "⏰ 每小时自动运行开始..."
echo "运行时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================"

# 运行同步
"$HOME/quant-auto-sync/sync_to_github.sh"

# 显示日志
echo ""
echo "📋 最近日志:"
tail -5 "$HOME/quant-auto-sync/logs/sync_$(date +%Y%m%d).log" 2>/dev/null || echo "暂无日志"

echo ""
echo "😴 等待1小时..."
sleep 3600

# 递归调用（保持运行）
exec "$0"
