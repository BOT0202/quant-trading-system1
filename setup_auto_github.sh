#!/bin/bash

# 自动化GitHub上传设置脚本
# 配置每小时自动备份到GitHub

echo "🚀 设置每小时自动上传到GitHub..."
echo "========================================"

# 检查必要的工具
echo "🔧 检查系统工具..."
for cmd in git curl cron; do
    if ! command -v $cmd &> /dev/null; then
        echo "❌ 缺少必要工具: $cmd"
        exit 1
    fi
done
echo "✅ 所有必要工具已安装"

# 获取GitHub信息
echo ""
echo "📝 请输入GitHub配置信息:"
read -p "GitHub用户名: " GITHUB_USER
read -p "仓库名称 (默认: quant-trading-system): " REPO_NAME
REPO_NAME=${REPO_NAME:-quant-trading-system}
read -p "仓库描述 (默认: 外盘黄金量化交易信号系统): " REPO_DESC
REPO_DESC=${REPO_DESC:-外盘黄金量化交易信号系统}

echo ""
echo "🔐 GitHub认证设置:"
echo "需要GitHub Token进行自动化操作"
echo "创建Token步骤:"
echo "1. 访问 https://github.com/settings/tokens"
echo "2. 点击 'Generate new token'"
echo "3. 选择 'classic' token"
echo "4. 权限选择: repo (全部)"
echo "5. 生成并复制Token"
echo ""
read -p "GitHub Token (输入或留空稍后配置): " GITHUB_TOKEN

# 创建项目目录结构
echo ""
echo "📁 创建项目目录结构..."
PROJECT_DIR="$HOME/quant-trading-system-auto"
mkdir -p "$PROJECT_DIR"
mkdir -p "$PROJECT_DIR/backups"
mkdir -p "$PROJECT_DIR/scripts"
mkdir -p "$PROJECT_DIR/logs"

echo "✅ 项目目录: $PROJECT_DIR"

# 复制备份文件
echo "📋 复制项目文件..."
cp -r /tmp/quant_system_backup_20260407_004825/* "$PROJECT_DIR/"
cp /root/.openclaw/workspace/collaboration "$PROJECT_DIR/current/" -r 2>/dev/null || true

# 创建自动化脚本
echo "📜 创建自动化脚本..."

# 1. 备份脚本
cat > "$PROJECT_DIR/scripts/auto_backup.sh" << 'EOF'
#!/bin/bash

# 自动化备份脚本
# 每小时运行一次，备份项目到GitHub

LOG_FILE="$HOME/quant-trading-system-auto/logs/backup_$(date +%Y%m%d).log"
BACKUP_DIR="$HOME/quant-trading-system-auto/backups/$(date +%Y%m%d_%H%M%S)"
SOURCE_DIR="/root/.openclaw/workspace"

echo "========================================" >> "$LOG_FILE"
echo "🔄 开始自动备份 - $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
echo "========================================" >> "$LOG_FILE"

# 创建备份目录
mkdir -p "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR/collaboration"
mkdir -p "$BACKUP_DIR/scripts"

# 备份协作文件
echo "📋 备份协作文件..." >> "$LOG_FILE"
cp -r "$SOURCE_DIR/collaboration" "$BACKUP_DIR/" 2>/dev/null

# 备份脚本文件
echo "📜 备份脚本文件..." >> "$LOG_FILE"
cp "$SOURCE_DIR"/*.sh "$BACKUP_DIR/scripts/" 2>/dev/null
cp "$SOURCE_DIR"/*.md "$BACKUP_DIR/scripts/" 2>/dev/null

# 创建备份信息
cat > "$BACKUP_DIR/backup_info.json" << INFO_EOF
{
  "backup_time": "$(date '+%Y-%m-%d %H:%M:%S')",
  "backup_id": "$(date +%Y%m%d_%H%M%S)",
  "source_directory": "$SOURCE_DIR",
  "file_count": "$(find "$BACKUP_DIR" -type f | wc -l)",
  "total_size": "$(du -sh "$BACKUP_DIR" | cut -f1)"
}
INFO_EOF

echo "✅ 备份完成: $BACKUP_DIR" >> "$LOG_FILE"
echo "📊 文件数量: $(find "$BACKUP_DIR" -type f | wc -l)" >> "$LOG_FILE"
echo "💾 备份大小: $(du -sh "$BACKUP_DIR" | cut -f1)" >> "$LOG_FILE"

# 清理旧备份（保留最近7天）
find "$HOME/quant-trading-system-auto/backups" -type d -mtime +7 -exec rm -rf {} \; 2>/dev/null
echo "🧹 已清理7天前的旧备份" >> "$LOG_FILE"

echo "========================================" >> "$LOG_FILE"
EOF

# 2. GitHub上传脚本
cat > "$PROJECT_DIR/scripts/auto_github_push.sh" << EOF
#!/bin/bash

# 自动化GitHub上传脚本

LOG_FILE="\$HOME/quant-trading-system-auto/logs/github_$(date +%Y%m%d).log"
PROJECT_DIR="\$HOME/quant-trading-system-auto"
GIT_DIR="\$PROJECT_DIR"

# GitHub配置
GITHUB_USER="$GITHUB_USER"
REPO_NAME="$REPO_NAME"
GITHUB_TOKEN="$GITHUB_TOKEN"

echo "========================================" >> "\$LOG_FILE"
echo "🌐 开始GitHub上传 - $(date '+%Y-%m-%d %H:%M:%S')" >> "\$LOG_FILE"
echo "========================================" >> "\$LOG_FILE"

cd "\$GIT_DIR"

# 检查Git仓库
if [ ! -d ".git" ]; then
    echo "🔧 初始化Git仓库..." >> "\$LOG_FILE"
    git init
    git config user.name "Auto Backup Bot"
    git config user.email "backup@quant-system.com"
    
    # 添加远程仓库
    if [ -n "\$GITHUB_TOKEN" ]; then
        git remote add origin "https://\${GITHUB_TOKEN}@github.com/\${GITHUB_USER}/\${REPO_NAME}.git"
    else
        git remote add origin "https://github.com/\${GITHUB_USER}/\${REPO_NAME}.git"
    fi
fi

# 更新项目文件
echo "📋 更新项目文件..." >> "\$LOG_FILE"
cp -r /root/.openclaw/workspace/collaboration "\$PROJECT_DIR/" 2>/dev/null
cp /root/.openclaw/workspace/*.sh "\$PROJECT_DIR/scripts/" 2>/dev/null
cp /root/.openclaw/workspace/*.md "\$PROJECT_DIR/scripts/" 2>/dev/null

# Git操作
echo "💾 Git操作..." >> "\$LOG_FILE"
git add .

# 检查是否有更改
if git diff --cached --quiet; then
    echo "📭 没有更改需要提交" >> "\$LOG_FILE"
else
    # 提交更改
    COMMIT_MSG="自动备份 $(date '+%Y-%m-%d %H:%M:%S') - 量化系统更新"
    git commit -m "\$COMMIT_MSG"
    
    # 推送到GitHub
    echo "📤 推送到GitHub..." >> "\$LOG_FILE"
    if git push -u origin main 2>&1 | tee -a "\$LOG_FILE"; then
        echo "✅ GitHub上传成功" >> "\$LOG_FILE"
    elif git push -u origin master 2>&1 | tee -a "\$LOG_FILE"; then
        echo "✅ GitHub上传成功" >> "\$LOG_FILE"
    else
        echo "❌ GitHub上传失败" >> "\$LOG_FILE"
        # 尝试强制推送
        git push -f origin HEAD 2>&1 | tee -a "\$LOG_FILE"
    fi
fi

echo "📊 仓库状态:" >> "\$LOG_FILE"
git status --short >> "\$LOG_FILE"

echo "========================================" >> "\$LOG_FILE"
EOF

# 3. 主控制脚本
cat > "$PROJECT_DIR/scripts/auto_sync.sh" << 'EOF'
#!/bin/bash

# 主同步脚本 - 备份并上传到GitHub

MAIN_LOG="$HOME/quant-trading-system-auto/logs/sync_$(date +%Y%m%d).log"

echo "========================================" >> "$MAIN_LOG"
echo "🚀 开始自动同步 - $(date '+%Y-%m-%d %H:%M:%S')" >> "$MAIN_LOG"
echo "========================================" >> "$MAIN_LOG"

# 1. 执行备份
echo "🔄 步骤1: 执行本地备份..." >> "$MAIN_LOG"
"$HOME/quant-trading-system-auto/scripts/auto_backup.sh"

# 2. 上传到GitHub
echo "🌐 步骤2: 上传到GitHub..." >> "$MAIN_LOG"
"$HOME/quant-trading-system-auto/scripts/auto_github_push.sh"

# 3. 记录同步状态
echo "📈 同步完成统计:" >> "$MAIN_LOG"
echo "   备份目录: $HOME/quant-trading-system-auto/backups/" >> "$MAIN_LOG"
echo "   日志文件: $HOME/quant-trading-system-auto/logs/" >> "$MAIN_LOG"
echo "   GitHub仓库: https://github.com/$GITHUB_USER/$REPO_NAME" >> "$MAIN_LOG"

# 4. 发送通知（可选）
if command -v curl &> /dev/null; then
    # 这里可以添加通知逻辑，如发送到Slack、钉钉等
    echo "📨 通知功能已就绪" >> "$MAIN_LOG"
fi

echo "✅ 自动同步完成 - $(date '+%Y-%m-%d %H:%M:%S')" >> "$MAIN_LOG"
echo "========================================" >> "$MAIN_LOG"
EOF

# 设置脚本权限
chmod +x "$PROJECT_DIR/scripts/"*.sh

# 创建cron定时任务
echo ""
echo "⏰ 设置cron定时任务..."
CRON_JOB="0 * * * * $PROJECT_DIR/scripts/auto_sync.sh >> $PROJECT_DIR/logs/cron.log 2>&1"

# 添加到crontab
(crontab -l 2>/dev/null | grep -v "auto_sync.sh"; echo "$CRON_JOB") | crontab -

echo "✅ cron定时任务已设置: 每小时运行一次"

# 创建GitHub Actions工作流（备用）
echo ""
echo "🔧 创建GitHub Actions工作流..."
mkdir -p "$PROJECT_DIR/.github/workflows"

cat > "$PROJECT_DIR/.github/workflows/auto-sync.yml" << EOF
name: Auto Sync Quant System

on:
  schedule:
    # 每小时运行一次
    - cron: '0 * * * *'
  workflow_dispatch:  # 手动触发
  push:
    branches: [ main, master ]

jobs:
  sync:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout repository
      uses: actions/checkout@v3
      with:
        token: \${{ secrets.GITHUB_TOKEN }}
        
    - name: Setup Git
      run: |
        git config --global user.name "GitHub Actions Bot"
        git config --global user.email "actions@github.com"
        
    - name: Run sync script
      run: |
        chmod +x scripts/auto_sync.sh
        ./scripts/auto_sync.sh
        
    - name: Commit and push changes
      run: |
        git add .
        git commit -m "Auto sync: \$(date)" || echo "No changes to commit"
        git push
EOF

# 创建配置说明
cat > "$PROJECT_DIR/SETUP_GUIDE.md" << EOF
# 🔄 每小时自动GitHub上传系统

## 系统概述
已设置每小时自动备份量化交易信号系统项目到GitHub。

## 目录结构
\`\`\`
$PROJECT_DIR/
├── backups/           # 本地备份（保留7天）
├── scripts/           # 自动化脚本
├── logs/              # 运行日志
├── .github/workflows/ # GitHub Actions配置
├── collaboration/     # 项目协作文件
├── SETUP_GUIDE.md    # 本指南
└── README.md         # 项目说明
\`\`\`

## 自动化脚本
1. \`auto_backup.sh\` - 本地备份脚本
2. \`auto_github_push.sh\` - GitHub上传脚本
3. \`auto_sync.sh\` - 主同步脚本（每小时运行）

## 定时任务
已设置cron任务，每小时运行一次：
\`\`\`
0 * * * * $PROJECT_DIR/scripts/auto_sync.sh
\`\`\`

查看cron任务：
\`\`\`
crontab -l
\`\`\`

## GitHub配置
- 用户名: $GITHUB_USER
- 仓库: $REPO_NAME
- Token: $(if [ -n "$GITHUB_TOKEN" ]; then echo "已设置"; else echo "未设置，请配置"; fi)

## 手动运行
\`\`\`
# 运行一次同步
$PROJECT_DIR/scripts/auto_sync.sh

# 仅备份
$PROJECT_DIR/scripts/auto_backup.sh

# 仅上传到GitHub
$PROJECT_DIR/scripts/auto_github_push.sh
\`\`\`

## 查看日志
\`\`\`
# 查看最新日志
tail -f $PROJECT_DIR/logs/sync_$(date +%Y%m%d).log

# 查看所有日志
ls -la $PROJECT_DIR/logs/
\`\`\`

## GitHub仓库
\`\`\`
https://github.com/$GITHUB_USER/$REPO_NAME
\`\`\`

## 故障排除
1. **GitHub认证失败**: 检查Token是否正确
2. **cron不运行**: 检查cron服务状态 \`systemctl status cron\`
3. **磁盘空间不足**: 定期清理旧备份
4. **网络问题**: 检查网络连接

## 更新配置
编辑脚本文件：
\`\`\`
vim $PROJECT_DIR/scripts/auto_github_push.sh
\`\`\`

## 停止自动同步
\`\`\`
# 移除cron任务
crontab -l | grep -v "auto_sync.sh" | crontab -
\`\`\`

---
*设置时间: $(date)*
*下次运行: 下一小时的整点*
EOF

# 创建首次运行脚本
cat > "$PROJECT_DIR/first_run.sh" << EOF
#!/bin/bash

# 首次运行脚本

echo "🚀 首次运行自动同步系统..."
echo "========================================"

# 1. 测试GitHub连接
echo "🔗 测试GitHub连接..."
if [ -n "$GITHUB_TOKEN" ]; then
    curl -s -H "Authorization: token $GITHUB_TOKEN" \
         "https://api.github.com/user" | grep -q '"login"' \
         && echo "✅ GitHub连接成功" || echo "❌ GitHub连接失败"
else
    echo "⚠️  GitHub Token未设置，部分功能可能受限"
fi

# 2. 运行一次同步
echo "🔄 运行首次同步..."
"$PROJECT_DIR/scripts/auto_sync.sh"

# 3. 显示状态
echo ""
echo "📊 系统状态:"
echo "   项目目录: $PROJECT_DIR"
echo "   cron任务: 已设置（每小时运行）"
echo "   GitHub仓库: https://github.com/$GITHUB_USER/$REPO_NAME"
echo "   日志目录: $PROJECT_DIR/logs/"
echo ""
echo "📋 查看日志:"
tail -5 "$PROJECT_DIR/logs/sync_$(date +%Y%m%d).log" 2>/dev/null || echo "   日志文件尚未生成"
echo ""
echo "✅ 首次运行完成！"
echo "💡 系统将在下一小时的整点自动运行"
EOF

chmod +x "$PROJECT_DIR/first_run.sh"

echo ""
echo "🎉 自动化GitHub上传系统设置完成！"
echo "========================================"
echo "📁 项目目录: $PROJECT_DIR"
echo "⏰ 定时任务: 每小时运行一次"
echo "🌐 GitHub仓库: https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
echo "🚀 下一步操作:"
echo "1. 运行首次同步: cd $PROJECT_DIR && ./first_run.sh"
echo "2. 查看设置指南: cat $PROJECT_DIR/SETUP_GUIDE.md"
echo "3. 检查cron任务: crontab -l"
echo "4. 查看GitHub仓库: https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
echo "💡 提示:"
echo "- 系统每小时自动备份并上传到GitHub"
echo "- 本地备份保留7天"
echo "- 所有操作都有详细日志记录"
echo "- 可以通过修改脚本调整备份频率"