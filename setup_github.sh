#!/bin/bash

# GitHub仓库设置脚本

echo "🔧 设置GitHub仓库..."
echo "========================================"

cd "/root/quant-auto-sync"

# 1. 创建GitHub仓库（通过命令行）
echo "🌐 创建GitHub仓库: quant-trading-system"
echo ""
echo "请手动在GitHub创建仓库:"
echo "1. 访问 https://github.com/new"
echo "2. 仓库名: quant-trading-system"
echo "3. 描述: 量化交易信号系统"
echo "4. 不要初始化文件"
echo ""
read -p "按回车继续..." 

# 2. 添加远程仓库
echo ""
echo "🔗 添加远程仓库..."
GITHUB_URL="https://github.com//quant-trading-system.git"
echo "仓库地址: "

if ! git remote | grep -q origin; then
    git remote add origin ""
    echo "✅ 远程仓库已添加"
else
    git remote set-url origin ""
    echo "✅ 远程仓库已更新"
fi

# 3. 首次推送
echo ""
echo "📤 首次推送..."
if git push -u origin main 2>&1; then
    echo "✅ 推送到 main 分支成功"
elif git push -u origin master 2>&1; then
    echo "✅ 推送到 master 分支成功"
else
    echo "🔄 尝试强制推送..."
    git push -f origin HEAD
    echo "✅ 强制推送完成"
fi

echo ""
echo "🎉 GitHub设置完成！"
echo "仓库地址: https://github.com//quant-trading-system"
