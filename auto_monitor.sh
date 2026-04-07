#!/bin/bash

# 🔄 自动监控脚本
# 用于定时检查进度并自动推动

MONITOR_LOG="/root/.openclaw/workspace/collaboration/monitor.log"
BOARD_FILE="/root/.openclaw/workspace/collaboration/shared/quant_project_board.md"

echo "🔄 启动自动监控系统 - $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$MONITOR_LOG"
echo "==========================================" | tee -a "$MONITOR_LOG"

# 检查监控目录
MONITOR_DIR="/root/.openclaw/workspace/collaboration/monitor"
mkdir -p "$MONITOR_DIR"

# 记录启动时间
echo "监控启动时间: $(date '+%Y-%m-%d %H:%M:%S')" > "$MONITOR_DIR/start_time.txt"

# 创建监控配置文件
cat > "$MONITOR_DIR/config.json" << EOF
{
  "monitor": {
    "interval_minutes": 60,
    "checkpoints": [
      "18:00",
      "21:00",
      "09:00",
      "12:00",
      "15:00",
      "18:00"
    ],
    "roles": [
      "product_manager",
      "tech_lead",
      "operations_expert",
      "test_expert"
    ],
    "alert_thresholds": {
      "no_progress_hours": 2,
      "low_progress_percentage": 20,
      "critical_tasks_pending": 3
    }
  }
}
EOF

echo "✅ 监控配置已创建" | tee -a "$MONITOR_LOG"

# 创建监控循环脚本
cat > "$MONITOR_DIR/monitor_loop.sh" << 'EOF'
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
EOF

chmod +x "$MONITOR_DIR/monitor_loop.sh"

echo "✅ 监控循环脚本已创建" | tee -a "$MONITOR_LOG"

# 创建每日报告脚本
cat > "$MONITOR_DIR/daily_report.sh" << 'EOF'
#!/bin/bash

REPORT_DATE=$(date '+%Y-%m-%d')
REPORT_FILE="/root/.openclaw/workspace/collaboration/reports/daily_${REPORT_DATE}.md"
mkdir -p "/root/.openclaw/workspace/collaboration/reports"

BOARD_FILE="/root/.openclaw/workspace/collaboration/shared/quant_project_board.md"
LOG_FILE="/root/.openclaw/workspace/collaboration/monitor.log"

echo "# 📊 每日项目进度报告 - $REPORT_DATE" > "$REPORT_FILE"
echo "## 生成时间: $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "## 🎯 项目概况" >> "$REPORT_FILE"
PHASE=$(grep -A 1 "当前阶段" "$BOARD_FILE" | tail -1 | sed 's/\*\*//g')
echo "- 阶段: $(echo "$PHASE" | cut -d: -f1)" >> "$REPORT_FILE"
echo "- 进度: $(echo "$PHASE" | grep -o "进度: [0-9]*%" | cut -d: -f2)" >> "$REPORT_FILE"
echo "- 紧急状态: $(grep -o "紧急状态:.*" "$BOARD_FILE" | cut -d: -f2)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "## 👥 各角色进度" >> "$REPORT_FILE"
echo "| 角色 | 状态 | 进度 | 今日完成 |" >> "$REPORT_FILE"
echo "|------|------|------|----------|" >> "$REPORT_FILE"

ROLES=("产品经理" "技术负责人" "运营专家" "测试专家")
for ROLE in "${ROLES[@]}"; do
    STATUS=$(grep -A 5 "各角色进度" "$BOARD_FILE" | grep "$ROLE" | awk -F'|' '{print $5}' | sed 's/^ *//;s/ *$//')
    PROGRESS=$(grep -A 5 "各角色进度" "$BOARD_FILE" | grep "$ROLE" | awk -F'|' '{print $4}' | sed 's/^ *//;s/ *$//')
    TASKS=$(grep -A 20 "${ROLE}任务:" "$BOARD_FILE" | grep -E "\[x\]" | wc -l)
    echo "| $ROLE | $STATUS | $PROGRESS | $TASKS项 |" >> "$REPORT_FILE"
done

echo "" >> "$REPORT_FILE"

echo "## 📈 进度趋势" >> "$REPORT_FILE"
echo "- 总体进度变化: [待计算]" >> "$REPORT_FILE"
echo "- 各角色进度变化: [待计算]" >> "$REPORT_FILE"
echo "- 任务完成速度: [待计算]" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "## 🚨 风险与问题" >> "$REPORT_FILE"
grep -A 10 "风险与问题" "$BOARD_FILE" | grep -E "风险|问题" | head -5 | while read line; do
    echo "- $line" >> "$REPORT_FILE"
done
echo "" >> "$REPORT_FILE"

echo "## 💡 建议与行动" >> "$REPORT_FILE"
echo "1. 继续推进紧急任务" >> "$REPORT_FILE"
echo "2. 准备明天的需求评审会" >> "$REPORT_FILE"
echo "3. 协调解决识别出的风险" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "## 📅 明日计划" >> "$REPORT_FILE"
echo "- 9:00 紧急站会" >> "$REPORT_FILE"
echo "- 14:00 需求评审会准备" >> "$REPORT_FILE"
echo "- 18:00 进度检查" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "---" >> "$REPORT_FILE"
echo "报告生成: 自动监控系统" >> "$REPORT_FILE"
echo "数据来源: 项目协作看板" >> "$REPORT_FILE"

echo "✅ 每日报告已生成: $REPORT_FILE"
EOF

chmod +x "$MONITOR_DIR/daily_report.sh"

echo "✅ 每日报告脚本已创建" | tee -a "$MONITOR_LOG"

# 创建推动触发器
cat > "$MONITOR_DIR/push_trigger.sh" << 'EOF'
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
EOF

chmod +x "$MONITOR_DIR/push_trigger.sh"

echo "✅ 推动触发器已创建" | tee -a "$MONITOR_LOG"

echo "" | tee -a "$MONITOR_LOG"
echo "==========================================" | tee -a "$MONITOR_LOG"
echo "🎯 自动监控系统部署完成" | tee -a "$MONITOR_LOG"
echo "" | tee -a "$MONITOR_LOG"
echo "📁 监控文件位置: $MONITOR_DIR" | tee -a "$MONITOR_LOG"
echo "📝 监控日志: $MONITOR_LOG" | tee -a "$MONITOR_LOG"
echo "" | tee -a "$MONITOR_LOG"
echo "🔄 可用命令:" | tee -a "$MONITOR_LOG"
echo "1. 启动监控: $MONITOR_DIR/monitor_loop.sh &" | tee -a "$MONITOR_LOG"
echo "2. 生成日报: $MONITOR_DIR/daily_report.sh" | tee -a "$MONITOR_LOG"
echo "3. 触发推动: $MONITOR_DIR/push_trigger.sh" | tee -a "$MONITOR_LOG"
echo "" | tee -a "$MONITOR_LOG"
echo "⏰ 监控将每小时自动检查进度" | tee -a "$MONITOR_LOG"
echo "🚨 发现异常将自动发送推动指令" | tee -a "$MONITOR_LOG"

# 启动监控后台进程
nohup "$MONITOR_DIR/monitor_loop.sh" > /dev/null 2>&1 &
MONITOR_PID=$!
echo "$MONITOR_PID" > "$MONITOR_DIR/monitor.pid"

echo "" | tee -a "$MONITOR_LOG"
echo "✅ 监控进程已启动 (PID: $MONITOR_PID)" | tee -a "$MONITOR_LOG"
echo "📊 监控系统已全面部署完成！" | tee -a "$MONITOR_LOG"