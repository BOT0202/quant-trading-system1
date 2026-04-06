#!/bin/bash

# 每日对话活动检查脚本

echo "🔍 每日对话活动检查 - $(date)"
echo "========================================"

SCRIPT_DIR="/root/.openclaw/workspace"
RESET_SCRIPT="$SCRIPT_DIR/our_conversation_reset_system.sh"

# 运行检查
if [ -f "$RESET_SCRIPT" ]; then
    "$RESET_SCRIPT" check
else
    echo "❌ 对话重置系统未找到"
fi

# 记录每日检查活动
"$RESET_SCRIPT" record system "每日自动检查"

echo ""
echo "✅ 每日检查完成"
