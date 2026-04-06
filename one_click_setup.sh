#!/bin/bash

# 一键完成设置脚本

echo "🎯 一键完成GitHub自动化设置"
echo "========================================"

echo "📋 配置信息:"
echo "   GitHub用户: BOT0202"
echo "   仓库名称: quant-trading-system"
echo "   项目目录: /root/quant-auto-sync"
echo ""

echo "🔍 检查前置条件..."
# 检查是否已创建GitHub仓库
echo "请确认是否已在GitHub创建仓库:"
echo "   地址: https://github.com/BOT0202/quant-trading-system"
echo ""
read -p "是否已创建GitHub仓库? (y/n): " REPO_CREATED

if [[ "$REPO_CREATED" != "y" && "$REPO_CREATED" != "Y" ]]; then
    echo ""
    echo "📝 请先创建GitHub仓库:"
    echo "1. 访问 https://github.com/new"
    echo "2. 仓库名: quant-trading-system"
    echo "3. 不要初始化任何文件"
    echo "4. 创建后返回继续"
    echo ""
    read -p "按回车继续查看详细指南..." 
    cat /root/quant-auto-sync/CREATE_GITHUB_REPO.md
    exit 0
fi

echo ""
echo "🚀 开始自动化设置..."
echo ""

# 步骤1: 设置GitHub连接
echo "1. 设置GitHub连接..."
cd /root/quant-auto-sync
./setup_github.sh

echo ""
echo "2. 测试同步..."
./sync_to_github.sh

echo ""
echo "3. 启动自动服务..."
./start_auto_sync.sh

echo ""
echo "4. 检查状态..."
./check_status.sh

echo ""
echo "🎉 设置完成！"
echo "========================================"
echo "✅ 自动化系统已就绪"
echo "⏰ 每小时自动备份到GitHub"
echo "📁 本地备份保留7天"
echo "📝 所有操作都有日志记录"
echo ""
echo "🌐 GitHub仓库: https://github.com/BOT0202/quant-trading-system"
echo "📊 监控状态: ./check_status.sh"
echo "🔄 手动同步: ./sync_to_github.sh"
echo "🛑 停止服务: ./stop_auto_sync.sh"
