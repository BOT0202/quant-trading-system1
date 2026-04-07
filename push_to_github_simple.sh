#!/bin/bash
echo "🚀 GitHub推送工具"
echo "=================="
if git remote | grep -q origin; then
    echo "✅ 远程仓库已配置"
    git remote -v
    echo ""
    echo "⬆️  正在推送到GitHub..."
    if git push origin master; then
        echo ""
        echo "✅ 推送成功！"
        echo ""
        echo "📊 推送详情："
        echo "最后提交: $(git log --oneline -1)"
    else
        echo ""
        echo "❌ 推送失败"
    fi
else
    echo "❌ 未配置远程仓库"
    echo ""
    echo "📝 请先在GitHub创建仓库，然后运行："
    echo "  git remote add origin git@github.com:BOT0202/你的仓库名.git"
    echo "  git push -u origin master"
fi
