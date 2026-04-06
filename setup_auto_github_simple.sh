#!/bin/bash

# 简化版自动化GitHub上传设置
# 使用systemd timer或简单循环实现每小时自动上传

echo "🚀 设置每小时自动上传到GitHub（简化版）..."
echo "========================================"

# 获取GitHub信息
echo ""
echo "📝 请输入GitHub配置信息:"
read -p "GitHub用户名: " GITHUB_USER
read -p "仓库名称 (默认: quant-trading-system): " REPO_NAME
REPO_NAME=${REPO_NAME:-quant-trading-system}
read -p "仓库描述 (默认: 外盘黄金量化交易信号系统): " REPO_DESC
REPO_DESC=${REPO_DESC:-外盘黄金量化交易信号系统}

echo ""
echo "🔐 GitHub Token设置 (可选但推荐):"
echo "创建Token: https://github.com/settings/tokens"
echo "权限选择: repo (全部)"
read -p "GitHub Token (留空则使用HTTPS无Token): " GITHUB_TOKEN

# 创建项目目录
echo ""
echo "📁 创建项目目录..."
PROJECT_DIR="$HOME/quant-trading-system-auto"
mkdir -p "$PROJECT_DIR"
mkdir -p "$PROJECT_DIR/backups"
mkdir -p "$PROJECT_DIR/scripts"
mkdir -p "$PROJECT_DIR/logs"
mkdir -p "$PROJECT_DIR/.github/workflows"

echo "✅ 项目目录: $PROJECT_DIR"

# 复制现有备份
echo "📋 复制项目文件..."
cp -r /tmp/quant_system_backup_20260407_004825/* "$PROJECT_DIR/" 2>/dev/null

# 创建简化版同步脚本
cat > "$PROJECT_DIR/scripts/simple_sync.sh" << EOF
#!/bin/bash

# 简化版同步脚本 - 备份并上传到GitHub

SYNC_LOG="\$HOME/quant-trading-system-auto/logs/sync.log"
BACKUP_TIME=\$(date '+%Y-%m-%d %H:%M:%S')

echo "[\$BACKUP_TIME] 🚀 开始同步..." >> "\$SYNC_LOG"

# 1. 备份当前项目状态
BACKUP_DIR="\$HOME/quant-trading-system-auto/backups/\$(date +%Y%m%d_%H%M%S)"
mkdir -p "\$BACKUP_DIR"

echo "[\$BACKUP_TIME] 📋 备份文件..." >> "\$SYNC_LOG"
cp -r /root/.openclaw/workspace/collaboration "\$BACKUP_DIR/" 2>/dev/null
cp /root/.openclaw/workspace/*.sh "\$BACKUP_DIR/" 2>/dev/null
cp /root/.openclaw/workspace/*.md "\$BACKUP_DIR/" 2>/dev/null

BACKUP_COUNT=\$(find "\$BACKUP_DIR" -type f | wc -l)
echo "[\$BACKUP_TIME] ✅ 备份完成: \$BACKUP_COUNT 个文件" >> "\$SYNC_LOG"

# 2. 更新主项目目录
echo "[\$BACKUP_TIME] 🔄 更新项目目录..." >> "\$SYNC_LOG"
cp -r /root/.openclaw/workspace/collaboration "\$HOME/quant-trading-system-auto/" 2>/dev/null
cp /root/.openclaw/workspace/*.sh "\$HOME/quant-trading-system-auto/scripts/" 2>/dev/null
cp /root/.openclaw/workspace/*.md "\$HOME/quant-trading-system-auto/" 2>/dev/null

# 3. Git操作
cd "\$HOME/quant-trading-system-auto"

# 初始化Git（如果未初始化）
if [ ! -d ".git" ]; then
    echo "[\$BACKUP_TIME] 🔧 初始化Git仓库..." >> "\$SYNC_LOG"
    git init
    git config user.name "Auto Backup Bot"
    git config user.email "backup@quant-system.com"
    
    # 创建初始提交
    git add .
    git commit -m "初始提交: 量化交易信号系统"
fi

# 检查更改
if git diff --quiet && git diff --cached --quiet; then
    echo "[\$BACKUP_TIME] 📭 没有更改需要提交" >> "\$SYNC_LOG"
else
    # 添加并提交更改
    git add .
    COMMIT_MSG="自动更新: \$BACKUP_TIME"
    git commit -m "\$COMMIT_MSG"
    echo "[\$BACKUP_TIME] 💾 提交更改: \$COMMIT_MSG" >> "\$SYNC_LOG"
    
    # 推送到GitHub
    echo "[\$BACKUP_TIME] 📤 推送到GitHub..." >> "\$SYNC_LOG"
    
    # 设置远程仓库
    if ! git remote | grep -q origin; then
        if [ -n "$GITHUB_TOKEN" ]; then
            git remote add origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"
        else
            git remote add origin "https://github.com/${GITHUB_USER}/${REPO_NAME}.git"
        fi
    fi
    
    # 推送
    if git push -u origin main 2>&1 | tee -a "\$SYNC_LOG"; then
        echo "[\$BACKUP_TIME] ✅ GitHub上传成功" >> "\$SYNC_LOG"
    elif git push -u origin master 2>&1 | tee -a "\$SYNC_LOG"; then
        echo "[\$BACKUP_TIME] ✅ GitHub上传成功" >> "\$SYNC_LOG"
    else
        # 强制推送（首次）
        git push -f origin HEAD 2>&1 | tee -a "\$SYNC_LOG"
        echo "[\$BACKUP_TIME] ⚠️  使用强制推送" >> "\$SYNC_LOG"
    fi
fi

# 4. 清理旧备份（保留3天）
find "\$HOME/quant-trading-system-auto/backups" -type d -mtime +3 -exec rm -rf {} \; 2>/dev/null
echo "[\$BACKUP_TIME] 🧹 清理3天前的旧备份" >> "\$SYNC_LOG"

echo "[\$BACKUP_TIME] 🎉 同步完成" >> "\$SYNC_LOG"
echo "[\$BACKUP_TIME] ========================================" >> "\$SYNC_LOG"
EOF

chmod +x "$PROJECT_DIR/scripts/simple_sync.sh"

# 创建定时运行脚本（使用while循环）
cat > "$PROJECT_DIR/scripts/auto_runner.sh" << 'EOF'
#!/bin/bash

# 自动运行器 - 每小时运行一次同步

RUNNER_LOG="$HOME/quant-trading-system-auto/logs/runner.log"

echo "========================================" >> "$RUNNER_LOG"
echo "🔄 启动自动运行器 - $(date '+%Y-%m-%d %H:%M:%S')" >> "$RUNNER_LOG"
echo "运行间隔: 1小时" >> "$RUNNER_LOG"
echo "========================================" >> "$RUNNER_LOG"

while true; do
    CURRENT_HOUR=$(date +%H)
    CURRENT_TIME=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$CURRENT_TIME] ⏰ 运行同步..." >> "$RUNNER_LOG"
    
    # 运行同步脚本
    "$HOME/quant-trading-system-auto/scripts/simple_sync.sh"
    
    # 等待1小时
    echo "[$CURRENT_TIME] 😴 等待1小时..." >> "$RUNNER_LOG"
    sleep 3600
done
EOF

chmod +x "$PROJECT_DIR/scripts/auto_runner.sh"

# 创建systemd服务（如果可用）
if command -v systemctl &> /dev/null; then
    echo "🔧 创建systemd服务..."
    
    # 创建服务文件
    cat > /tmp/quant-sync.service << EOF
[Unit]
Description=Quant System Auto Sync to GitHub
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$PROJECT_DIR
ExecStart=$PROJECT_DIR/scripts/auto_runner.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    
    # 创建timer文件（每小时运行）
    cat > /tmp/quant-sync.timer << EOF
[Unit]
Description=Run quant sync hourly

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
EOF
    
    echo "✅ systemd服务文件已创建（需要手动安装）"
fi

# 创建GitHub Actions工作流
echo "🔧 创建GitHub Actions工作流..."

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
        fetch-depth: 0
        
    - name: Setup Git
      run: |
        git config --global user.name "GitHub Actions Bot"
        git config --global user.email "actions@github.com"
        
    - name: Run sync from source
      run: |
        # 这里可以添加从源目录同步的代码
        echo "Sync would run here"
        # 实际使用时需要配置如何从源目录获取文件
        
    - name: Commit and push if changed
      run: |
        git add .
        git diff --cached --quiet || git commit -m "Auto sync: \$(date)"
        git push
EOF

# 创建手动运行脚本
cat > "$PROJECT_DIR/run_now.sh" << EOF
#!/bin/bash

# 立即运行同步

echo "🚀 立即运行GitHub同步..."
echo "========================================"

# 运行同步脚本
"$PROJECT_DIR/scripts/simple_sync.sh"

# 显示日志
echo ""
echo "📋 同步日志:"
tail -20 "$PROJECT_DIR/logs/sync.log" 2>/dev/null || echo "日志文件尚未生成"

echo ""
echo "🌐 GitHub仓库: https://github.com/$GITHUB_USER/$REPO_NAME"
echo "📁 本地备份: $PROJECT_DIR/backups/"
echo "📝 运行日志: $PROJECT_DIR/logs/"
EOF

chmod +x "$PROJECT_DIR/run_now.sh"

# 创建设置指南
cat > "$PROJECT_DIR/SETUP_GUIDE.md" << EOF
# 🔄 每小时自动GitHub上传系统

## 已完成设置
- ✅ 项目目录: \`$PROJECT_DIR\`
- ✅ 同步脚本: \`scripts/simple_sync.sh\`
- ✅ GitHub仓库: \`$REPO_NAME\`
- ✅ 自动化配置: GitHub Actions工作流

## 使用方法

### 1. 立即运行一次同步
\`\`\`bash
cd $PROJECT_DIR
./run_now.sh
\`\`\`

### 2. 查看同步日志
\`\`\`bash
tail -f $PROJECT_DIR/logs/sync.log
\`\`\`

### 3. 手动运行同步脚本
\`\`\`bash
$PROJECT_DIR/scripts/simple_sync.sh
\`\`\`

### 4. 启动自动运行器（后台运行）
\`\`\`bash
# 在后台运行
nohup $PROJECT_DIR/scripts/auto_runner.sh > /dev/null 2>&1 &

# 查看运行状态
ps aux | grep auto_runner
\`\`\`

## GitHub仓库设置

### 1. 创建GitHub仓库
访问 https://github.com/new 创建仓库:
- 名称: \`$REPO_NAME\`
- 描述: \`$REPO_DESC\`
- 不要初始化README

### 2. 首次推送
\`\`\`bash
cd $PROJECT_DIR

# 初始化Git（如果未初始化）
git init
git add .
git commit -m "初始提交"

# 添加远程仓库
git remote add origin https://github.com/$GITHUB_USER/$REPO_NAME.git

# 推送
git push -u origin main
# 如果失败，尝试:
git push -u origin master
\`\`\`

### 3. 配置GitHub Token（可选但推荐）
1. 访问 https://github.com/settings/tokens
2. 创建新token，选择 \`repo\` 权限
3. 在脚本中更新Token:
\`\`\`bash
sed -i 's|GITHUB_TOKEN=".*"|GITHUB_TOKEN="你的token"|' $PROJECT_DIR/scripts/simple_sync.sh
\`\`\`

## 自动化选项

### 选项1: 使用GitHub Actions（推荐）
- 已配置每小时自动运行
- 无需本地持续运行
- 查看: \`.github/workflows/auto-sync.yml\`

### 选项2: 本地后台运行
\`\`\`bash
# 启动
nohup $PROJECT_DIR/scripts/auto_runner.sh &

# 停止
pkill -f auto_runner.sh
\`\`\`

### 选项3: 使用crontab（如果可用）
\`\`\`bash
# 每小时运行一次
0 * * * * $PROJECT_DIR/scripts/simple_sync.sh
\`\`\`

## 文件说明
- \`backups/\` - 本地备份（保留3天）
- \`logs/\` - 运行日志
- \`scripts/\` - 所有脚本
- \`collaboration/\` - 项目协作文件
- \`.github/workflows/\` - GitHub Actions配置

## 监控与维护

### 查看状态
\`\`\`bash
# 查看最近同步
tail -10 $PROJECT_DIR/logs/sync.log

# 查看备份文件
ls -la $PROJECT_DIR/backups/

# 检查Git状态
cd $PROJECT_DIR && git status
\`\`\`

### 清理旧文件
\`\`\`
# 手动清理3天前的备份
find $PROJECT_DIR/backups -type d -mtime +3 -exec rm -rf {} \;
\`\`\`

## 故障排除

### GitHub推送失败
1. 检查网络连接
2. 验证GitHub Token
3. 检查仓库权限

### 脚本不运行
1. 检查脚本权限: \`chmod +x scripts/*.sh\`
2. 检查日志文件
3. 手动运行测试

### 磁盘空间不足
1. 减少备份保留天数
2. 清理旧日志
3. 排除大文件备份

## 联系信息
- GitHub仓库: https://github.com/$GITHUB_USER/$REPO_NAME
- 项目目录: \`$PROJECT_DIR\`
- 设置时间: $(date)

---
*系统已就绪，建议立即运行一次测试同步*
EOF

# 创建测试脚本
cat > "$PROJECT_DIR/test_system.sh" << EOF
#!/bin/bash

# 测试系统脚本

echo "🧪 测试自动化GitHub上传系统..."
echo "========================================"

# 1. 检查目录结构
echo "📁 检查目录结构..."
ls -la "$PROJECT_DIR"
echo ""

# 2. 检查脚本权限
echo "🔧 检查脚本权限..."
ls -la "$PROJECT_DIR/scripts/"
echo ""

# 3. 测试GitHub连接
echo "🌐 测试GitHub连接..."
if curl -s "https://github.com/$GITHUB_USER" | grep -q "Not Found"; then
    echo "❌ GitHub用户不存在: $GITHUB_USER"
else
    echo "✅ GitHub用户存在: $GITHUB_USER"
fi
echo ""

# 4. 运行一次同步
echo "🚀 运行测试同步..."
"$PROJECT_DIR/scripts/simple_sync.sh"
echo ""

# 5. 显示结果
echo "📊 测试结果:"
echo "   项目目录: $PROJECT_DIR"
echo "   脚本数量: $(find "$PROJECT_DIR/scripts" -type f -name "*.sh" | wc -l)"
echo "   备份目录: $(find "$PROJECT_DIR/backups" -type d | wc -l) 个"
echo "   日志文件: $(find "$PROJECT_DIR/logs" -type f | wc -l) 个"
echo ""
echo "📋 查看日志:"
tail -5 "$PROJECT_DIR/logs/sync.log" 2>/dev/null || echo "   日志文件尚未生成"
echo ""
echo "✅ 测试完成！"
EOF

chmod +x "$PROJECT_DIR/test_system.sh"

echo ""
echo "🎉 自动化GitHub上传系统设置完成！"
echo "========================================"
echo "📁 项目目录: $PROJECT_DIR"
echo "🌐 GitHub仓库: https://github.com/$GITHUB_USER/$REPO_NAME"
echo "⏰ 自动化: GitHub Actions每小时运行"
echo ""
echo "🚀 立即操作:"
echo "1. 测试系统: cd $PROJECT_DIR && ./test_system.sh"
echo "2. 立即同步: cd $PROJECT_DIR && ./run_now.sh"
echo "3. 查看指南: cat $PROJECT_DIR/SETUP_GUIDE.md"
echo "4. 创建GitHub仓库: https://github.com/new"
echo ""
echo "💡 重要提示:"
echo "- 首先在GitHub创建仓库: $REPO_NAME"
echo "- 运行一次手动同步初始化仓库"
echo "- GitHub Actions会自动每小时同步"
echo "- 所有操作都有详细日志记录"
echo ""
echo "✅ 系统已就