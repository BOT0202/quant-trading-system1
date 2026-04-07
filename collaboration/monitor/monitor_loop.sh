#!/bin/bash

MONITOR_DIR="/root/.openclaw/workspace/collaboration/monitor"
BOARD_FILE="/root/.openclaw/workspace/collaboration/shared/quant_project_board.md"
LOG_FILE="/root/.openclaw/workspace/collaboration/monitor.log"
PUSH_DIR="/root/.openclaw/workspace/collaboration/push_messages"

# 加载配置
CONFIG="$MONITOR_DIR/config.json"
INTERVAL=$(grep -o '"interval_minutes":[0-9]*' "$CONFIG" | cut -d: -f2)

echo "🔄 监控循环启动 - 间隔: ${INTERVAL}分钟" >> "$LOG_FILE"

while true; do
    CURRENT_TIME=$(date '+%Y-%m-%d %H:%M:%S')
    echo "=== 监控检查: $CURRENT_TIME ===" >> "$LOG_FILE"
    
    # 检查项目看板最后更新时间
    LAST_UPDATE=$(grep "看板最后更新" "$BOARD_FILE" | tail -1 | grep -o '[0-9]*-[0-9]*-[0-9]*')
    TODAY=$(date '+%Y-%m-%d')
    
    if [ "$LAST_UPDATE" != "$TODAY" ]; then
        echo "⚠️  警告: 项目看板今天未更新" >> "$LOG_FILE"
        # 发送更新提醒
        REMINDER_MSG="$PUSH_DIR/update_reminder_$(date +%s).txt"
        echo "🔄 更新提醒: 请及时更新项目看板状态" > "$REMINDER_MSG"
        echo "时间: $CURRENT_TIME" >> "$REMINDER_MSG"
    fi
    
    # 检查各角色进度
    ROLES=("产品经理" "技术负责人" "运营专家" "测试专家")
    for ROLE in "${ROLES[@]}"; do
        ROLE_STATUS=$(grep -A 5 "各角色进度" "$BOARD_FILE" | grep "$ROLE" | awk -F'|' '{print $5}' | sed 's/^ *//;s/ *$//')
        ROLE_PROGRESS=$(grep -A 5 "各角色进度" "$BOARD_FILE" | grep "$ROLE" | awk -F'|' '{print $4}' | sed 's/^ *//;s/ *$//')
        
        echo "  $ROLE: 状态=$ROLE_STATUS, 进度=$ROLE_PROGRESS" >> "$LOG_FILE"
        
        # 检查是否需要推动
        if [[ "$ROLE_STATUS" == *"进行中"* ]] || [[ "$ROLE_STATUS" == *"启动中"* ]]; then
            HOURS_SINCE_PUSH=$(find "$PUSH_DIR" -name "*$(echo "$ROLE" | tr -d ' ')*" -mmin +120 2>/dev/null | wc -l)
            if [ "$HOURS_SINCE_PUSH" -gt 0 ]; then
                echo "  ⚠️  $ROLE 已2小时无更新，可能需要推动" >> "$LOG_FILE"
            fi
        fi
    done
    
    # 检查任务完成情况
    echo "📊 任务完成统计:" >> "$LOG_FILE"
    for ROLE in "${ROLES[@]}"; do
        TASKS=$(grep -A 20 "${ROLE}任务:" "$BOARD_FILE" | grep -E "\[x\]|\[\s\]" | wc -l)
        DONE=$(grep -A 20 "${ROLE}任务:" "$BOARD_FILE" | grep "\[x\]" | wc -l)
        if [ "$TASKS" -gt 0 ]; then
            PERCENT=$((DONE * 100 / TASKS))
            echo "  $ROLE: $DONE/$TASKS ($PERCENT%)" >> "$LOG_FILE"
            
            # 低进度警报
            if [ "$PERCENT" -lt 20 ] && [ "$TASKS" -gt 3 ]; then
                echo "  🚨 $ROLE 进度低于20%，需要关注" >> "$LOG_FILE"
            fi
        fi
    done
    
    echo "✅ 监控检查完成" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
    
    # 等待下一个检查周期
    sleep $((INTERVAL * 60))
done
