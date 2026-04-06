#!/bin/bash

# 手动检查角色活动脚本

echo "🔍 手动检查角色活动状态"
echo "========================================"

RESET_SCRIPT="/root/.openclaw/workspace/three_day_reset_system.sh"

echo "📊 当前时间: $(date)"
echo ""

# 运行检查
"$RESET_SCRIPT" check

echo ""
echo "💡 其他命令:"
echo "   记录活动: $RESET_SCRIPT record <角色> <活动描述>"
echo "   强制重置: $RESET_SCRIPT force-reset <角色>"
echo "   查看日志: $RESET_SCRIPT report"
echo "   获取帮助: $RESET_SCRIPT help"
