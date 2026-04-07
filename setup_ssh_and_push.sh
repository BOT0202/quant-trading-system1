#!/bin/bash

# SSH配置和推送脚本

echo "🚀 SSH配置和GitHub推送"
echo "========================================"

echo "🔑 你的SSH公钥："
echo "========================================"
cat ~/.ssh/id_ed25519.pub
echo "========================================"

echo ""
echo "📋 请先完成以下步骤："
echo "1. 登录GitHub账号 BOT0202"
echo "2. 访问 https://github.com/settings/keys"
echo "3. 点击 'New SSH key'"
echo "4. 粘贴上面的公钥"
echo "5. 标题: quant-trading-system"
echo "6. 点击 'Add SSH key'"
echo ""
read -p "完成后按回车继续..." 

echo ""
echo "🔧 配置Git使用SSH..."
cd /root/quant-auto-sync
git remote set-url origin git@github.com:BOT0202/quant-trading-system1.git
echo "✅ 远程仓库地址已更新"

echo ""
echo "🔗 测试SSH连接..."
ssh -T git@github.com

echo ""
echo "📤 推送到GitHub..."
if git push -u origin master; then
    echo "✅ 推送成功！"
    echo ""
    echo "🎉 恭喜！量化系统项目已上传到GitHub"
    echo "🌐 仓库地址: https://github.com/BOT0202/quant-trading-system1"
    echo ""
    echo "🚀 现在可以启动自动化服务："
    echo "   cd /root/quant-auto-sync"
    echo "   ./start_auto_sync.sh"
else
    echo "❌ 推送失败"
    echo ""
    echo "🔍 可能的原因："
    echo "   1. SSH密钥未正确添加到GitHub"
    echo "   2. 仓库权限问题"
    echo "   3. 网络连接问题"
    echo ""
    echo "💡 尝试手动推送："
    echo "   git push -u origin master"
fi

echo ""
echo "========================================"
echo "📊 当前状态："
echo "   远程仓库: $(git remote -v | grep origin)"
echo "   本地提交: $(git log --oneline -1)"
echo "   SSH密钥: $(ssh-keygen -l -f ~/.ssh/id_ed25519 | awk '{print $3}')"
echo ""
echo "📞 如果需要帮助，请提供错误信息"