#!/bin/bash

# 测试GitHub连接脚本

echo "🔗 测试GitHub连接 - BOT0202"
echo "========================================"

# 1. 检查仓库是否存在
echo "1. 检查GitHub仓库..."
REPO_URL="https://github.com/BOT0202/quant-trading-system1"
if curl -s -I "$REPO_URL" | grep -q "200 OK"; then
    echo "✅ 仓库存在: $REPO_URL"
else
    echo "❌ 仓库不存在或无法访问"
    echo "   请确认仓库已创建: https://github.com/BOT0202/quant-trading-system1"
fi

echo ""

# 2. 检查本地Git配置
echo "2. 检查本地Git配置..."
cd /root/quant-auto-sync
echo "   当前目录: $(pwd)"
echo "   Git远程仓库:"
git remote -v
echo "   Git用户配置:"
git config --get user.name
git config --get user.email

echo ""

# 3. 检查文件状态
echo "3. 检查文件状态..."
echo "   文件数量: $(find . -type f | wc -l)"
echo "   Git状态:"
git status --short

echo ""

# 4. 测试推送（不实际执行）
echo "4. 推送测试..."
echo "   运行以下命令完成推送:"
echo ""
echo "   cd /root/quant-auto-sync"
echo "   git push -u origin master"
echo ""
echo "   如果需要认证，使用以下格式:"
echo "   git remote set-url origin https://BOT0202:你的token@github.com/BOT0202/quant-trading-system1.git"
echo "   git push -u origin master"

echo ""

# 5. 提供替代方案
echo "5. 替代推送方法:"
echo ""
echo "   A. 使用GitHub Desktop:"
echo "      1. 下载GitHub Desktop"
echo "      2. 添加本地仓库: /root/quant-auto-sync"
echo "      3. 点击发布仓库"
echo ""
echo "   B. 使用网页上传:"
echo "      1. 访问 https://github.com/BOT0202/quant-trading-system1"
echo "      2. 点击 'Add file' → 'Upload files'"
echo "      3. 上传 /root/quant-auto-sync 目录下的文件"
echo ""
echo "   C. 使用命令行（需要Token）:"
echo "      ./push_with_auth.sh"

echo ""

# 6. 下一步建议
echo "6. 建议操作:"
echo "   [1] 创建GitHub Token: https://github.com/settings/tokens"
echo "   [2] 使用Token推送"
echo "   [3] 启动自动化服务: ./start_auto_sync.sh"
echo "   [4] 检查状态: ./check_status.sh"

echo ""
echo "========================================"
echo "🌐 GitHub仓库: https://github.com/BOT0202/quant-trading-system1"
echo "📁 本地目录: /root/quant-auto-sync"
echo "📋 文件数量: $(find /root/quant-auto-sync -type f | wc -l)"
echo "✅ 测试完成"