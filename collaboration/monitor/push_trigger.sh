#!/bin/bash

# 推动触发器 - 根据条件自动发送推动指令

BOARD_FILE="/root/.openclaw/workspace/collaboration/shared/quant_project_board.md"
PUSH_DIR="/root/.openclaw/workspace/collaboration/push_messages"
LOG_FILE="/root/.openclaw/workspace/collaboration/monitor.log"

# 检查条件1: 是否有角色进度低于20%
check_low_progress() {
    ROLES=("产品经理" "技术负责人" "运营专家" "测试专家")
    for ROLE in "${ROLES[@]}"; do
        PROGRESS=$(grep -A 5 "各角色进度" "$BOARD_FILE" | grep "$ROLE" | awk -F'|' '{print $4}' | sed 's/^ *//;s/ *$//' | grep -o '[0-9]*')
        if [ -n "$PROGRESS" ] && [ "$PROGRESS" -lt 20 ]; then
            echo "🚨 $ROLE 进度低于20% ($PROGRESS%)" >> "$LOG_FILE"
            # 发送推动消息
            MSG_FILE="$PUSH_DIR/auto_push_${ROLE}_$(date +%s).txt"
            echo "⏰ 自动推动提醒 - $ROLE" > "$MSG_FILE"
            echo "时间: $(date '+%Y-%m-%d %H:%M:%S')" >> "$MSG_FILE"
            echo "原因: 进度低于20%，当前进度: $PROGRESS%" >> "$MSG_FILE"
            echo "要求: 请加快工作进度，2小时内汇报进展" >> "$MSG_FILE"
        fi
    done
}

# 检查条件2: 是否有任务超过24小时未更新
check_stale_tasks() {
    # 这里可以添加检查逻辑
    echo "检查过期任务..." >> "$LOG_FILE"
}

# 检查条件3: 是否接近截止时间
check_deadline() {
    DEADLINE=$(grep -o "截止时间: [0-9\-]*" "$BOARD_FILE" | cut -d: -f2 | tr -d ' ')
    if [ -n "$DEADLINE" ]; then
        DAYS_LEFT=$(( ($(date -d "$DEADLINE" +%s) - $(date +%s)) / 86400 ))
        if [ "$DAYS_LEFT" -lt 3 ]; then
            echo "⚠️  距离截止时间仅剩 $DAYS_LEFT 天" >> "$LOG_FILE"
            # 发送紧急提醒
            MSG_FILE="$PUSH_DIR/deadline_alert_$(date +%s).txt"
            echo "⏳ 截止时间提醒" > "$MSG_FILE"
            echo "距离阶段截止仅剩 $DAYS_LEFT 天" >> "$MSG_FILE"
            echo "请加快工作进度！" >> "$MSG_FILE"
        fi
    fi
}

# 执行检查
echo "🔍 执行自动推动检查 - $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
check_low_progress
check_stale_tasks
check_deadline
echo "✅ 自动推动检查完成" >> "$LOG_FILE"
