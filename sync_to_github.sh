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
