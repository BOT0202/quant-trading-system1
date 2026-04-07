#!/bin/bash

# 量化系统快速启动脚本

echo "🚀 量化系统快速启动"
echo "========================================"

echo "📋 当前配置:"
echo "   用户名: BOT0202"
echo "   仓库名: quant-trading-system"
echo "   项目目录: /root/quant-auto-sync"
echo ""

echo "🔍 检查系统状态..."
echo "1. 检查目录结构:"
ls -la /root/quant-auto-sync/

echo ""
echo "2. 检查脚本权限:"
ls -la /root/quant-auto-sync/*.sh

echo ""
echo "3. 检查量化项目:"
ls -la /root/.openclaw/workspace/collaboration/shared/

echo ""
echo "📝 下一步操作:"
echo "1. 创建GitHub仓库 (如果尚未创建)"
echo "   指南: cat /root/quant-auto-sync/CREATE_GITHUB_REPO.md"
echo ""
echo "2. 设置GitHub连接"
echo "   cd /root/quant-auto-sync"
echo "   ./setup_github.sh"
echo ""
echo "3. 测试同步"
echo "   ./sync_to_github.sh"
echo ""
echo "4. 启动自动服务"
echo "   ./start_auto_sync.sh"
echo ""
echo "🌐 GitHub仓库地址:"
echo "   https://github.com/BOT0202/quant-trading-system"
