#!/bin/bash

# 使用HTTPS和认证信息推送

echo "🔐 使用HTTPS方式推送到GitHub..."
echo "========================================"

cd /root/quant-auto-sync

# 切换回HTTPS
git remote set-url origin https://github.com/BOT0202/quant-trading-system1.git

echo "📤 推送中..."
echo ""
echo "💡 提示: 如果提示输入用户名和密码:"
echo "   用户名: BOT0202"
echo "   密码: 使用GitHub Token (不是登录密码)"
echo ""
echo "创建Token: https://github.com/settings/tokens"
echo "选择 repo 权限"
echo ""

# 尝试推送
git push -u origin master

echo ""
echo "✅ 如果推送成功，项目已上传到GitHub"
echo "🌐 仓库地址: https://github.com/BOT0202/quant-trading-system1"