#!/bin/bash

# 系统状态检查脚本

echo "🔍 系统状态检查 - BOT0202"
echo "========================================"

echo "📊 1. 自动化系统状态:"
echo "   目录: /root/quant-auto-sync"
echo "   文件数: $(find /root/quant-auto-sync -type f | wc -l)"
echo "   脚本数: $(find /root/quant-auto-sync -name "*.sh" | wc -l)"
echo "   备份数: $(find /root/quant-auto-sync/backups -type d 2>/dev/null | wc -l)"
echo "   日志数: $(find /root/quant-auto-sync/logs -type f 2>/dev/null | wc -l)"

echo ""
echo "📈 2. 量化项目状态:"
echo "   项目目录: /root/.openclaw/workspace"
echo "   协作文件: $(find /root/.openclaw/workspace/collaboration -type f 2>/dev/null | wc -l)"
echo "   脚本文件: $(find /root/.openclaw/workspace -name "*.sh" | wc -l)"
echo "   文档文件: $(find /root/.openclaw/workspace -name "*.md" | wc -l)"

echo ""
echo "⚙️  3. 服务运行状态:"
if ps aux | grep -v grep | grep -q "run_hourly.sh"; then
    echo "   ✅ 自动服务正在运行"
    ps aux | grep -v grep | grep "run_hourly.sh" | awk '{print "   PID: "$2" | 启动时间: "$9}'
else
    echo "   ⚠️  自动服务未运行"
    echo "   启动命令: cd /root/quant-auto-sync && ./start_auto_sync.sh"
fi

echo ""
echo "🌐 4. GitHub配置:"
echo "   用户名: BOT0202"
echo "   仓库名: quant-trading-system"
echo "   仓库地址: https://github.com/BOT0202/quant-trading-system"

echo ""
echo "📋 5. 最近日志:"
if [ -f "/root/quant-auto-sync/logs/sync_$(date +%Y%m%d).log" ]; then
    echo "   今日同步日志:"
    tail -3 "/root/quant-auto-sync/logs/sync_$(date +%Y%m%d).log"
else
    echo "   暂无今日日志"
fi

echo ""
echo "🎯 6. 建议操作:"
if [ ! -d "/root/quant-auto-sync/.git" ]; then
    echo "   ⚠️  Git未初始化，需要运行: ./setup_github.sh"
else
    echo "   ✅ Git已初始化"
fi

if ! ps aux | grep -v grep | grep -q "run_hourly.sh"; then
    echo "   ⚠️  自动服务未运行，需要启动: ./start_auto_sync.sh"
else
    echo "   ✅ 自动服务正在运行"
fi

echo ""
echo "========================================"
echo "✅ 状态检查完成"
echo "💡 详细指南: cat /root/quant-auto-sync/README.md"
