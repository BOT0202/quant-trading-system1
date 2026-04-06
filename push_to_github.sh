#!/bin/bash

# GitHub推送脚本
# 将量化系统项目推送到GitHub仓库

echo "🚀 准备推送到GitHub..."
echo "========================================"

# 检查是否在备份目录中
if [ ! -f "setup_git.sh" ]; then
    echo "❌ 请在备份目录中运行此脚本"
    echo "   运行: cd /tmp/quant_system_backup_* && ../push_to_github.sh"
    exit 1
fi

# 询问GitHub仓库信息
echo "📝 请输入GitHub仓库信息:"
read -p "GitHub用户名: " GITHUB_USER
read -p "仓库名称 (默认: quant-trading-system): " REPO_NAME
REPO_NAME=${REPO_NAME:-quant-trading-system}
read -p "仓库描述 (默认: 外盘黄金量化交易信号系统): " REPO_DESC
REPO_DESC=${REPO_DESC:-外盘黄金量化交易信号系统}

echo ""
echo "🔍 验证信息:"
echo "   用户名: $GITHUB_USER"
echo "   仓库名: $REPO_NAME"
echo "   描述: $REPO_DESC"
echo ""
read -p "是否继续? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "❌ 操作取消"
    exit 0
fi

# 1. 初始化Git仓库
echo ""
echo "🔧 初始化Git仓库..."
if [ ! -d ".git" ]; then
    ./setup_git.sh
else
    echo "✅ Git仓库已存在，跳过初始化"
fi

# 2. 检查Git配置
echo ""
echo "⚙️  检查Git配置..."
if ! git config --get user.name > /dev/null 2>&1; then
    read -p "请输入Git用户名: " GIT_USER
    git config user.name "$GIT_USER"
fi

if ! git config --get user.email > /dev/null 2>&1; then
    read -p "请输入Git邮箱: " GIT_EMAIL
    git config user.email "$GIT_EMAIL"
fi

# 3. 创建GitHub仓库（通过API）
echo ""
echo "🌐 创建GitHub仓库..."
cat > /tmp/create_repo.json << EOF
{
  "name": "$REPO_NAME",
  "description": "$REPO_DESC",
  "private": false,
  "has_issues": true,
  "has_projects": true,
  "has_wiki": true,
  "auto_init": false
}
EOF

echo "📋 仓库创建命令（需要GitHub Token）:"
echo "curl -X POST \\"
echo "  -H \"Authorization: token YOUR_GITHUB_TOKEN\" \\"
echo "  -H \"Accept: application/vnd.github.v3+json\" \\"
echo "  https://api.github.com/user/repos \\"
echo "  -d @/tmp/create_repo.json"
echo ""

# 4. 添加远程仓库
echo "🔗 添加远程仓库..."
GIT_REMOTE="https://github.com/$GITHUB_USER/$REPO_NAME.git"
echo "远程仓库地址: $GIT_REMOTE"

# 检查是否已存在远程仓库
if git remote | grep -q origin; then
    echo "🔄 更新远程仓库地址..."
    git remote set-url origin "$GIT_REMOTE"
else
    echo "➕ 添加远程仓库..."
    git remote add origin "$GIT_REMOTE"
fi

# 5. 推送代码
echo ""
echo "📤 推送代码到GitHub..."
echo "请确保:"
echo "1. 已在GitHub创建仓库: https://github.com/$GITHUB_USER/$REPO_NAME"
echo "2. 有推送权限"
echo ""
read -p "是否开始推送? (y/n): " PUSH_CONFIRM

if [[ "$PUSH_CONFIRM" == "y" || "$PUSH_CONFIRM" == "Y" ]]; then
    echo "🔄 推送中..."
    
    # 拉取可能的变化
    git pull origin main --allow-unrelated-histories 2>/dev/null || true
    git pull origin master --allow-unrelated-histories 2>/dev/null || true
    
    # 推送到GitHub
    if git push -u origin main 2>/dev/null; then
        echo "✅ 推送到 main 分支成功"
    elif git push -u origin master 2>/dev/null; then
        echo "✅ 推送到 master 分支成功"
    else
        echo "⚠️  推送失败，可能需要手动设置默认分支"
        echo "手动推送命令:"
        echo "  git push -u origin HEAD"
    fi
else
    echo "⏸️  跳过推送"
fi

# 6. 显示GitHub仓库信息
echo ""
echo "🎉 GitHub仓库设置完成！"
echo "========================================"
echo "📊 仓库信息:"
echo "   名称: $REPO_NAME"
echo "   地址: https://github.com/$GITHUB_USER/$REPO_NAME"
echo "   描述: $REPO_DESC"
echo ""
echo "📁 本地Git状态:"
git status --short
echo ""
echo "📈 提交历史:"
git log --oneline -5
echo ""
echo "🚀 后续操作:"
echo "1. 查看GitHub仓库: https://github.com/$GITHUB_USER/$REPO_NAME"
echo "2. 更新代码: git add . && git commit -m '更新说明' && git push"
echo "3. 拉取更新: git pull"
echo "4. 查看分支: git branch -a"
echo ""
echo "💡 提示:"
echo "- 定期提交项目进展"
echo "- 使用有意义的提交信息"
echo "- 保护敏感信息，不要提交密码和密钥"
echo "- 使用.gitignore过滤不需要的文件"

# 7. 创建更新脚本
cat > update_github.sh << EOF
#!/bin/bash

# 更新GitHub仓库脚本

echo "🔄 更新GitHub仓库..."
echo "========================================"

# 检查更改
echo "📋 检查更改..."
git status

# 添加所有更改
read -p "是否添加所有更改? (y/n): " ADD_ALL
if [[ "\$ADD_ALL" == "y" || "\$ADD_ALL" == "Y" ]]; then
    git add .
else
    echo "请手动添加文件: git add <文件>"
    exit 0
fi

# 输入提交信息
read -p "提交信息: " COMMIT_MSG
if [ -z "\$COMMIT_MSG" ]; then
    COMMIT_MSG="更新项目文件 $(date '+%Y-%m-%d %H:%M:%S')"
fi

# 提交
git commit -m "\$COMMIT_MSG"

# 推送
echo "📤 推送到GitHub..."
git push

echo "✅ 更新完成！"
echo "仓库地址: https://github.com/$GITHUB_USER/$REPO_NAME"
EOF

chmod +x update_github.sh

echo ""
echo "📜 已创建更新脚本: ./update_github.sh"
echo "   使用: ./update_github.sh 快速更新GitHub仓库"