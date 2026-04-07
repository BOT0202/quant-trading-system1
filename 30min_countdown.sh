#!/bin/bash

# 🚨 30分钟倒计时监控脚本
# 用于监控产品经理30分钟紧急任务

echo "🚨 30分钟紧急任务倒计时开始 🚨"
echo "========================================"
echo "开始时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "截止时间: $(date -d '+30 minutes' '+%H:%M:%S')"
echo "========================================"
echo ""

# 创建监控目录
MONITOR_DIR="/root/.openclaw/workspace/collaboration/30min_monitor"
mkdir -p "$MONITOR_DIR"

# 记录开始时间
START_TIME=$(date +%s)
END_TIME=$((START_TIME + 1800))  # 30分钟=1800秒

echo "⏰ 倒计时开始..." > "$MONITOR_DIR/countdown.log"
echo "开始时间戳: $START_TIME" >> "$MONITOR_DIR/countdown.log"
echo "结束时间戳: $END_TIME" >> "$MONITOR_DIR/countdown.log"

# 创建进度检查文件
cat > "$MONITOR_DIR/progress_checkpoints.json" << EOF
{
  "checkpoints": [
    {"time": 300, "name": "5分钟检查点", "target": "所有工作启动"},
    {"time": 600, "name": "10分钟检查点", "target": "访谈完成50%"},
    {"time": 900, "name": "15分钟检查点", "target": "访谈完成100%"},
    {"time": 1200, "name": "20分钟检查点", "target": "文档生成80%"},
    {"time": 1500, "name": "25分钟检查点", "target": "所有工作完成90%"},
    {"time": 1800, "name": "30分钟检查点", "target": "所有工作100%完成"}
  ],
  "tasks": [
    {"id": 1, "name": "深度访谈", "weight": 30},
    {"id": 2, "name": "需求报告", "weight": 25},
    {"id": 3, "name": "业务流程图", "weight": 20},
    {"id": 4, "name": "原型图", "weight": 15},
    {"id": 5, "name": "PRD框架", "weight": 10}
  ]
}
EOF

# 倒计时显示函数
countdown_display() {
    local remaining=$1
    local minutes=$((remaining / 60))
    local seconds=$((remaining % 60))
    
    # 进度条计算
    local total_time=1800
    local progress=$(( (total_time - remaining) * 100 / total_time ))
    local bar_length=50
    local filled=$((progress * bar_length / 100))
    local empty=$((bar_length - filled))
    
    # 颜色设置
    local RED='\033[0;31m'
    local YELLOW='\033[1;33m'
    local GREEN='\033[0;32m'
    local NC='\033[0m' # No Color
    
    # 根据剩余时间选择颜色
    if [ $remaining -le 300 ]; then
        COLOR=$RED  # 最后5分钟红色
    elif [ $remaining -le 900 ]; then
        COLOR=$YELLOW  # 5-15分钟黄色
    else
        COLOR=$GREEN  # 15分钟以上绿色
    fi
    
    clear
    echo "========================================"
    echo "🚨 产品经理30分钟紧急任务监控 🚨"
    echo "========================================"
    echo ""
    echo "⏰ 剩余时间: ${COLOR}${minutes}分${seconds}秒${NC}"
    echo ""
    echo "📊 总体进度: ${progress}%"
    echo -n "["
    for ((i=0; i<filled; i++)); do echo -n "█"; done
    for ((i=0; i<empty; i++)); do echo -n "░"; done
    echo "]"
    echo ""
    
    # 显示检查点
    echo "🔍 检查点状态:"
    local current_elapsed=$((total_time - remaining))
    for checkpoint in 300 600 900 1200 1500 1800; do
        if [ $current_elapsed -ge $checkpoint ]; then
            echo "  ✅ $(date -d "@$((START_TIME + checkpoint))" '+%H:%M:%S') - 检查点通过"
        else
            local checkpoint_remaining=$((checkpoint - current_elapsed))
            local ck_min=$((checkpoint_remaining / 60))
            local ck_sec=$((checkpoint_remaining % 60))
            echo "  ⏳ $(date -d "@$((START_TIME + checkpoint))" '+%H:%M:%S') - 剩余 ${ck_min}分${ck_sec}秒"
        fi
    done
    
    echo ""
    echo "📋 任务完成状态:"
    echo "  1. 深度访谈: [░░░░░░░░░░] 0%"
    echo "  2. 需求报告: [░░░░░░░░░░] 0%"
    echo "  3. 业务流程图: [░░░░░░░░░░] 0%"
    echo "  4. 原型图: [░░░░░░░░░░] 0%"
    echo "  5. PRD框架: [░░░░░░░░░░] 0%"
    
    echo ""
    echo "🚨 紧急提醒:"
    if [ $remaining -le 300 ]; then
        echo "  ⚠️  最后5分钟！加速完成！"
    elif [ $remaining -le 600 ]; then
        echo "  ⚠️  剩余10分钟，保持节奏！"
    elif [ $remaining -le 900 ]; then
        echo "  ℹ️  剩余15分钟，按计划执行！"
    else
        echo "  ℹ️  时间充足，但不要松懈！"
    fi
    
    echo ""
    echo "========================================"
    echo "监控时间: $(date '+%Y-%m-%d %H:%M:%S')"
}

# 创建自动检查脚本
cat > "$MONITOR_DIR/auto_check.sh" << 'EOF'
#!/bin/bash

# 自动检查产品经理进度

MONITOR_DIR="/root/.openclaw/workspace/collaboration/30min_monitor"
PRODUCT_DIR="/root/.openclaw/workspace/collaboration/product/work"
OUTPUT_DIR="/root/.openclaw/workspace/collaboration/product/outputs/urgent"

check_progress() {
    local task=$1
    local progress=0
    
    case $task in
        "interview")
            # 检查访谈完成情况
            if [ -f "$PRODUCT_DIR/interview_complete.md" ]; then
                progress=100
            elif [ -f "$PRODUCT_DIR/interview_in_progress.md" ]; then
                progress=50
            else
                progress=0
            fi
            ;;
        "report")
            # 检查需求报告
            if [ -f "$OUTPUT_DIR/需求调研报告.pdf" ]; then
                progress=100
            elif [ -f "$PRODUCT_DIR/requirements_report_draft.md" ]; then
                progress=60
            else
                progress=0
            fi
            ;;
        "flowchart")
            # 检查业务流程图
            if [ -f "$OUTPUT_DIR/核心业务流程图.png" ]; then
                progress=100
            elif [ -f "$PRODUCT_DIR/business_flowchart.dio" ]; then
                progress=50
            else
                progress=0
            fi
            ;;
        "prototype")
            # 检查原型图
            if [ -f "$OUTPUT_DIR/信号看板原型图.fig" ]; then
                progress=100
            elif [ -f "$PRODUCT_DIR/prototype_design.fig" ]; then
                progress=50
            else
                progress=0
            fi
            ;;
        "prd")
            # 检查PRD框架
            if [ -f "$OUTPUT_DIR/PRD框架.md" ]; then
                progress=100
            elif [ -f "$PRODUCT_DIR/prd_framework.md" ]; then
                progress=60
            else
                progress=0
            fi
            ;;
    esac
    
    echo $progress
}

# 检查所有任务
INTERVIEW_PROGRESS=$(check_progress "interview")
REPORT_PROGRESS=$(check_progress "report")
FLOWCHART_PROGRESS=$(check_progress "flowchart")
PROTOTYPE_PROGRESS=$(check_progress "prototype")
PRD_PROGRESS=$(check_progress "prd")

# 计算总体进度
TOTAL_PROGRESS=$(( (INTERVIEW_PROGRESS*30 + REPORT_PROGRESS*25 + FLOWCHART_PROGRESS*20 + PROTOTYPE_PROGRESS*15 + PRD_PROGRESS*10) / 100 ))

# 记录进度
echo "$(date '+%Y-%m-%d %H:%M:%S'),$INTERVIEW_PROGRESS,$REPORT_PROGRESS,$FLOWCHART_PROGRESS,$PROTOTYPE_PROGRESS,$PRD_PROGRESS,$TOTAL_PROGRESS" >> "$MONITOR_DIR/progress_log.csv"

# 输出进度
echo "进度更新:"
echo "  深度访谈: $INTERVIEW_PROGRESS%"
echo "  需求报告: $REPORT_PROGRESS%"
echo "  业务流程图: $FLOWCHART_PROGRESS%"
echo "  原型图: $PROTOTYPE_PROGRESS%"
echo "  PRD框架: $PRD_PROGRESS%"
echo "  总体进度: $TOTAL_PROGRESS%"
EOF

chmod +x "$MONITOR_DIR/auto_check.sh"

# 创建进度日志文件
echo "timestamp,interview,report,flowchart,prototype,prd,total" > "$MONITOR_DIR/progress_log.csv"

echo "✅ 监控系统已启动"
echo "🔄 开始30分钟倒计时..."

# 主倒计时循环
while true; do
    CURRENT_TIME=$(date +%s)
    REMAINING=$((END_TIME - CURRENT_TIME))
    
    if [ $REMAINING -le 0 ]; then
        break
    fi
    
    # 显示倒计时
    countdown_display $REMAINING
    
    # 每30秒自动检查一次进度
    if [ $((CURRENT_TIME % 30)) -eq 0 ]; then
        echo "🔍 自动检查进度..." >> "$MONITOR_DIR/countdown.log"
        "$MONITOR_DIR/auto_check.sh" >> "$MONITOR_DIR/countdown.log" 2>&1
    fi
    
    # 每5分钟提醒一次
    if [ $((REMAINING % 300)) -eq 0 ] && [ $REMAINING -ne 1800 ]; then
        MINUTES_REMAINING=$((REMAINING / 60))
        echo "⏰ ${MINUTES_REMAINING}分钟剩余提醒" >> "$MONITOR_DIR/countdown.log"
        
        # 发送提醒消息
        REMINDER_MSG="$MONITOR_DIR/reminder_${MINUTES_REMAINING}min.txt"
        echo "⏰ 时间提醒: 剩余${MINUTES_REMAINING}分钟" > "$REMINDER_MSG"
        echo "请加快进度！" >> "$REMINDER_MSG"
    fi
    
    sleep 1
done

# 倒计时结束
clear
echo "========================================"
echo "🚨 30分钟倒计时结束！ 🚨"
echo "========================================"
echo "结束时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 检查最终完成情况
echo "🔍 检查最终完成情况..."
FINAL_CHECK="$MONITOR_DIR/final_check.txt"
"$MONITOR_DIR/auto_check.sh" > "$FINAL_CHECK"

# 读取最终进度
FINAL_TOTAL=$(tail -1 "$MONITOR_DIR/progress_log.csv" | cut -d',' -f7)

echo ""
echo "📊 最终完成情况:"
cat "$FINAL_CHECK"

echo ""
if [ "$FINAL_TOTAL" -eq 100 ]; then
    echo "🎉 恭喜！所有任务100%完成！"
    echo "✅ 产品经理成功在30分钟内完成所有工作"
    
    # 发送成功通知
    SUCCESS_MSG="/root/.openclaw/workspace/collaboration/push_messages/30min_success.txt"
    echo "🎉 30分钟紧急任务成功完成！" > "$SUCCESS_MSG"
    echo "完成时间: $(date '+%Y-%m-%d %H:%M:%S')" >> "$SUCCESS_MSG"
    echo "总体进度: 100%" >> "$SUCCESS_MSG"
    echo "所有产出已提交到指定目录" >> "$SUCCESS_MSG"
    
elif [ "$FINAL_TOTAL" -ge 80 ]; then
    echo "👍 良好！完成${FINAL_TOTAL}%，基本达到要求"
    echo "⚠️  部分细节可能需要后续补充"
    
    # 发送部分完成通知
    PARTIAL_MSG="/root/.openclaw/workspace/collaboration/push_messages/30min_partial.txt"
    echo "⚠️ 30分钟紧急任务部分完成" > "$PARTIAL_MSG"
    echo "完成时间: $(date '+%Y-%m-%d %H:%M:%S')" >> "$PARTIAL_MSG"
    echo "总体进度: ${FINAL_TOTAL}%" >> "$PARTIAL_MSG"
    echo "需要后续补充完善" >> "$PARTIAL_MSG"
    
else
    echo "❌ 未完成！只完成${FINAL_TOTAL}%"
    echo "🚨 需要立即分析原因并采取补救措施"
    
    # 发送未完成通知
    FAIL_MSG="/root/.openclaw/workspace/collaboration/push_messages/30min_fail.txt"
    echo "❌ 30分钟紧急任务未完成" > "$FAIL_MSG"
    echo "结束时间: $(date '+%Y-%m-%d %H:%M:%S')" >> "$FAIL_MSG"
    echo "总体进度: ${FINAL_TOTAL}%" >> "$FAIL_MSG"
    echo "需要立即分析原因并补救" >> "$FAIL_MSG"
fi

echo ""
echo "📁 监控日志: $MONITOR_DIR/countdown.log"
echo "📊 进度记录: $MONITOR_DIR/progress_log.csv"
echo "🔍 详细检查: $FINAL_CHECK"

echo ""
echo "========================================"
echo "监控结束时间: $(date '+%Y-%m-%d %H:%M:%S')"