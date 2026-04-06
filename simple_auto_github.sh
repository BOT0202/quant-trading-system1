#!/bin/bash

# 最简单的自动化GitHub上传设置

echo "🚀 设置每小时自动上传到GitHub..."
echo "========================================"

# 获取GitHub信息
echo ""
read -p "GitHub用户名: " GITHUB_USER
read -p "仓库名称 (默认: quant-trading-system): " REPO_NAME
REPO_NAME=${REPO_NAME:-quant-trading-system}

# 创建项目目录
PROJECT_DIR="$HOME/quant-auto-sync"
echo ""
echo "📁 创建项目目录: $PROJECT_DIR"
mkdir -p "$PROJECT_DIR"
mkdir -p "$PROJECT_DIR/backups"
mkdir -p "$PROJECT_DIR/logs"

# 创建核心同步脚本
cat > "$PROJECT_DIR/sync_to_github.sh" << 'EOF'
#!/bin/bash

# 核心同步脚本

PROJECT_DIR="$HOME/quant-auto-sync"
LOG_FILE="$PROJECT_DIR/logs/sync_$(date +%Y%m%d).log"
BACKUP_TIME=$(date '+%Y-%m-%d %H:%M:%S')

echo "========================================" >> "$LOG_FILE"
echo "🔄 开始同步 - $BACKUP_TIME" >> "$LOG_FILE"

# 1. 备份当前状态
BACKUP_DIR="$PROJECT_DIR/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "📋 备份文件..." >> "$LOG_FILE"
cp -r /root/.openclaw/workspace/collaboration "$BACKUP_DIR/" 2>/dev/null
cp /root/.openclaw/workspace/*.sh "$BACKUP_DIR/" 2>/dev/null
cp /root/.openclaw/workspace/*.md "$BACKUP_DIR/" 2>/dev/null

echo "✅ 备份完成: $(find "$BACKUP_DIR" -type f | wc -l) 个文件" >> "$LOG_FILE"

# 2. 更新主目录（用于Git）
echo "🔄 更新Git目录..." >> "$LOG_FILE"
cd "$PROJECT_DIR"
cp -r /root/.openclaw/workspace/collaboration . 2>/dev/null
cp /root/.openclaw/workspace/*.sh . 2>/dev/null
cp /root/.openclaw/workspace/*.md . 2>/dev/null

# 3. Git操作
if [ ! -d ".git" ]; then
    echo "🔧 初始化Git..." >> "$LOG_FILE"
    git init
    git config user.name "Auto Sync Bot"
    git config user.email "sync@quant-system.com"
    git add .
    git commit -m "初始提交"
fi

# 检查更改
if ! git diff --quiet || ! git diff --cached --quiet; then
    git add .
    git commit -m "自动更新: $BACKUP_TIME"
    echo "💾 提交更改" >> "$LOG_FILE"
    
    # 推送到GitHub
    echo "📤 推送到GitHub..." >> "$LOG_FILE"
    git push -u origin main 2>&1 | tee -a "$LOG_FILE" || \
    git push -u origin master 2>&1 | tee -a "$LOG_FILE" || \
    echo "⚠️  推送失败" >> "$LOG_FILE"
else
    echo "📭 没有更改" >> "$LOG_FILE"
fi

# 4. 清理
find "$PROJECT_DIR/backups" -type d -mtime +7 -exec rm -rf {} \; 2>/dev/null
echo "🧹 清理7天前备份" >> "$LOG_FILE"

echo "✅ 同步完成" >> "$LOG_FILE"
echo "========================================" >> "$LOG_FILE"
EOF

chmod +x "$PROJECT_DIR/sync_to_github.sh"

# 创建设置脚本
cat > "$PROJECT_DIR/setup_github.sh" << EOF
#!/bin/bash

# GitHub仓库设置脚本

echo "🔧 设置GitHub仓库..."
echo "========================================"

cd "$PROJECT_DIR"

# 1. 创建GitHub仓库（通过命令行）
echo "🌐 创建GitHub仓库: $REPO_NAME"
echo ""
echo "请手动在GitHub创建仓库:"
echo "1. 访问 https://github.com/new"
echo "2. 仓库名: $REPO_NAME"
echo "3. 描述: 量化交易信号系统"
echo "4. 不要初始化文件"
echo ""
read -p "按回车继续..." 

# 2. 添加远程仓库
echo ""
echo "🔗 添加远程仓库..."
GITHUB_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"
echo "仓库地址: $GITHUB_URL"

if ! git remote | grep -q origin; then
    git remote add origin "$GITHUB_URL"
    echo "✅ 远程仓库已添加"
else
    git remote set-url origin "$GITHUB_URL"
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
echo "仓库地址: https://github.com/$GITHUB_USER/$REPO_NAME"
EOF

chmod +x "$PROJECT_DIR/setup_github.sh"

# 创建定时运行脚本
cat > "$PROJECT_DIR/run_hourly.sh" << 'EOF'
#!/bin/bash

# 每小时运行脚本

echo "⏰ 每小时自动运行开始..."
echo "运行时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================"

# 运行同步
"$HOME/quant-auto-sync/sync_to_github.sh"

# 显示日志
echo ""
echo "📋 最近日志:"
tail -5 "$HOME/quant-auto-sync/logs/sync_$(date +%Y%m%d).log" 2>/dev/null || echo "暂无日志"

echo ""
echo "😴 等待1小时..."
sleep 3600

# 递归调用（保持运行）
exec "$0"
EOF

chmod +x "$PROJECT_DIR/run_hourly.sh"

# 创建启动脚本
cat > "$PROJECT_DIR/start_auto_sync.sh" << 'EOF'
#!/bin/bash

# 启动自动同步

echo "🚀 启动自动同步服务..."
echo "========================================"

# 检查是否已在运行
if ps aux | grep -v grep | grep -q "run_hourly.sh"; then
    echo "⚠️  服务已在运行"
    ps aux | grep -v grep | grep "run_hourly.sh"
    exit 0
fi

# 在后台启动
nohup "$HOME/quant-auto-sync/run_hourly.sh" > "$HOME/quant-auto-sync/logs/daemon.log" 2>&1 &

echo "✅ 服务已启动"
echo "PID: $!"
echo "日志: $HOME/quant-auto-sync/logs/daemon.log"

echo ""
echo "📋 查看状态:"
echo "  ps aux | grep run_hourly"
echo "  tail -f $HOME/quant-auto-sync/logs/daemon.log"
EOF

chmod +x "$PROJECT_DIR/start_auto_sync.sh"

# 创建停止脚本
cat > "$PROJECT_DIR/stop_auto_sync.sh" << 'EOF'
#!/bin/bash

# 停止自动同步

echo "🛑 停止自动同步服务..."
echo "========================================"

# 查找并停止进程
PIDS=$(ps aux | grep "run_hourly.sh" | grep -v grep | awk '{print $2}')

if [ -z "$PIDS" ]; then
    echo "✅ 服务未运行"
else
    echo "找到进程: $PIDS"
    kill $PIDS 2>/dev/null
    echo "✅ 服务已停止"
fi
EOF

chmod +x "$PROJECT_DIR/stop_auto_sync.sh"

# 创建使用指南
cat > "$PROJECT_DIR/README.md" << EOF
# 🔄 每小时自动GitHub同步系统

## 快速开始

### 1. 设置GitHub仓库
\`\`\`bash
cd $PROJECT_DIR
./setup_github.sh
\`\`\`

### 2. 手动运行一次同步
\`\`\`bash
./sync_to_github.sh
\`\`\`

### 3. 启动自动服务（每小时运行）
\`\`\`bash
./start_auto_sync.sh
\`\`\`

## 文件说明
- \`sync_to_github.sh\` - 核心同步脚本
- \`setup_github.sh\` - GitHub仓库设置
- \`run_hourly.sh\` - 每小时运行脚本
- \`start_auto_sync.sh\` - 启动服务
- \`stop_auto_sync.sh\` - 停止服务
- \`backups/\` - 本地备份
- \`logs/\` - 运行日志

## 手动操作

### 立即同步
\`\`\`bash
./sync_to_github.sh
\`\`\`

### 查看日志
\`\`\`bash
# 查看同步日志
tail -f logs/sync_$(date +%Y%m%d).log

# 查看服务日志
tail -f logs/daemon.log
\`\`\`

### 查看备份
\`\`\`bash
ls -la backups/
\`\`\`

## GitHub仓库
\`\`\`
https://github.com/$GITHUB_USER/$REPO_NAME
\`\`\`

## 监控状态

### 检查服务状态
\`\`\`bash
ps aux | grep run_hourly
\`\`\`

### 检查Git状态
\`\`\`bash
cd $PROJECT_DIR
git status
git log --oneline -5
\`\`\`

## 停止服务
\`\`\`bash
./stop_auto_sync.sh
\`\`\`

## 配置说明

### 修改同步频率
编辑 \`run_hourly.sh\`，修改 \`sleep 3600\`（3600秒=1小时）

### 修改备份保留时间
编辑 \`sync_to_github.sh\`，修改 \`-mtime +7\`（7天）

### 添加GitHub Token
如果需要Token认证，修改Git远程地址：
\`\`\`bash
git remote set-url origin https://token@github.com/用户名/仓库.git
\`\`\`

## 故障排除

### 同步失败
1. 检查网络连接
2. 检查GitHub仓库权限
3. 查看日志文件

### 服务不运行
1. 检查脚本权限：\`chmod +x *.sh\`
2. 手动运行测试：\`./sync_to_github.sh\`
3. 查看错误日志

### 磁盘空间不足
1. 清理旧备份：\`find backups -type d -mtime +7 -exec rm -rf {} \;\`
2. 清理旧日志：\`find logs -type f -mtime +30 -delete\`

---
*设置时间: $(date)*
*项目目录: $PROJECT_DIR*
EOF

echo ""
echo "🎉 自动化GitHub同步系统设置完成！"
echo "========================================"
echo "📁 项目目录: $PROJECT_DIR"
echo "🌐 GitHub仓库: https://github.com/$GITHUB_USER/$REPO_NAME"
echo "⏰ 自动化: 每小时自动同步"
echo ""
echo "🚀 立即操作:"
echo "1. 设置GitHub: cd $PROJECT_DIR && ./setup_github.sh"
echo "2. 测试同步: cd $PROJECT_DIR && ./sync_to_github.sh"
echo "3. 启动服务: cd $PROJECT_DIR && ./start_auto_sync.sh"
echo "4. 查看指南: cat $PROJECT_DIR/README.md"
echo ""
echo "💡 提示:"
echo "- 首先需要在GitHub创建仓库"
echo "- 系统会自动每小时备份并上传"
echo "- 所有操作都有日志记录"
echo "- 可以随时手动运行同步"
echo ""
echo "✅ 系统已就绪！"