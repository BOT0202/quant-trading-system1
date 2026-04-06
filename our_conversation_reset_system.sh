#!/bin/bash

# 我们对话的3天不说话重置系统
# 监控我们之间的协作活动，3天无活动则提醒

echo "💬 我们对话的3天不说话重置系统"
echo "========================================"

# 配置文件
CONFIG_DIR="/root/.openclaw/workspace/our_conversation"
LOG_DIR="$CONFIG_DIR/logs"
ACTIVITY_LOG="$LOG_DIR/conversation_activity.log"
RESET_THRESHOLD_DAYS=3
LAST_CHECK_FILE="$CONFIG_DIR/last_check.txt"

# 创建必要的目录和文件
mkdir -p "$LOG_DIR"
touch "$ACTIVITY_LOG"
touch "$LAST_CHECK_FILE"

# 记录对话活动
record_conversation_activity() {
    local PARTICIPANT=$1
    local ACTION=$2
    local CONTEXT=$3
    local TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    
    echo "$TIMESTAMP | $PARTICIPANT | $ACTION | $CONTEXT" >> "$ACTIVITY_LOG"
    echo "💬 记录对话活动: $PARTICIPANT - $ACTION"
    
    # 更新最后检查时间
    echo "$TIMESTAMP" > "$LAST_CHECK_FILE"
}

# 检查重置状态
check_conversation_reset() {
    local CURRENT_TIME=$(date +%s)
    local RESET_THRESHOLD_SECONDS=$((RESET_THRESHOLD_DAYS * 24 * 60 * 60))
    
    # 查找最后活动时间
    local LAST_ACTIVITY=$(tail -1 "$ACTIVITY_LOG" 2>/dev/null)
    
    if [ -z "$LAST_ACTIVITY" ]; then
        echo "⚠️  无对话活动记录"
        return 1
    fi
    
    # 提取时间戳
    local LAST_TIMESTAMP=$(echo "$LAST_ACTIVITY" | cut -d'|' -f1 | xargs)
    local LAST_TIME=$(date -d "$LAST_TIMESTAMP" +%s 2>/dev/null || echo "0")
    
    if [ "$LAST_TIME" = "0" ]; then
        echo "❌ 无法解析时间戳"
        return 1
    fi
    
    # 计算时间差
    local TIME_DIFF=$((CURRENT_TIME - LAST_TIME))
    
    if [ $TIME_DIFF -ge $RESET_THRESHOLD_SECONDS ]; then
        echo "🚨 对话已 $RESET_THRESHOLD_DAYS 天无活动，需要重置！"
        show_reset_warning
        return 0
    else
        local DAYS_LEFT=$(echo "scale=1; ($RESET_THRESHOLD_SECONDS - $TIME_DIFF) / 86400" | bc)
        echo "✅ 对话活动正常，距离重置还有 $DAYS_LEFT 天"
        show_recent_activities
        return 1
    fi
}

# 显示重置警告
show_reset_warning() {
    echo ""
    echo "========================================"
    echo "🚨 3天不说话重置警告 🚨"
    echo "========================================"
    echo ""
    echo "检测到我们的对话已连续 $RESET_THRESHOLD_DAYS 天无活动。"
    echo ""
    echo "⚠️  即将执行的操作："
    echo "   1. 对话上下文可能丢失"
    echo "   2. 项目进度需要重新同步"
    echo "   3. 需要重新建立工作节奏"
    echo ""
    echo "💡 建议立即行动："
    echo "   1. 继续当前量化系统项目工作"
    echo "   2. 更新项目进度状态"
    echo "   3. 制定下一步工作计划"
    echo ""
    echo "📋 最后活动记录："
    tail -5 "$ACTIVITY_LOG" | while read line; do
        echo "   $line"
    done
    echo ""
    echo "✅ 立即记录活动避免重置："
    echo "   ./our_conversation_reset_system.sh record <参与者> <活动> <上下文>"
}

# 显示最近活动
show_recent_activities() {
    echo ""
    echo "📋 最近对话活动："
    echo "----------------------------------------"
    local RECENT_COUNT=5
    tail -$RECENT_COUNT "$ACTIVITY_LOG" | while read line; do
        local TS=$(echo "$line" | cut -d'|' -f1 | xargs)
        local WHO=$(echo "$line" | cut -d'|' -f2 | xargs)
        local ACTION=$(echo "$line" | cut -d'|' -f3 | xargs)
        local CONTEXT=$(echo "$line" | cut -d'|' -f4 | xargs)
        
        # 美化显示
        case $WHO in
            "YangCheng") EMOJI="👤" ;;
            "Assistant") EMOJI="🤖" ;;
            "system") EMOJI="⚙️ " ;;
            *) EMOJI="👥" ;;
        esac
        
        printf "   %s %-10s %-20s\n" "$EMOJI" "$TS" "$ACTION"
        if [ -n "$CONTEXT" ] && [ "$CONTEXT" != " " ]; then
            printf "        📝 %s\n" "$CONTEXT"
        fi
    done
}

# 生成对话报告
generate_conversation_report() {
    local DAYS=${1:-7}
    local REPORT_FILE="$LOG_DIR/conversation_report_$(date +%Y%m%d).md"
    
    echo "# 我们对话活动报告" > "$REPORT_FILE"
    echo "## 生成时间: $(date)" >> "$REPORT_FILE"
    echo "## 报告周期: 最近${DAYS}天" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    # 统计活动数量
    local START_DATE=$(date -d "$DAYS days ago" "+%Y-%m-%d")
    local TOTAL_ACTIVITIES=$(grep "^$START_DATE\|^$(date -d "$((DAYS-1)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-2)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-3)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-4)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-5)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-6)) days ago" "+%Y-%m-%d")\|^$(date "+%Y-%m-%d")" "$ACTIVITY_LOG" | wc -l)
    
    echo "## 📊 活动统计" >> "$REPORT_FILE"
    echo "- 总活动数: $TOTAL_ACTIVITIES" >> "$REPORT_FILE"
    echo "- 平均每天: $((TOTAL_ACTIVITIES / DAYS)) 次活动" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    # 按参与者统计
    echo "## 👥 参与者统计" >> "$REPORT_FILE"
    for PARTICIPANT in "YangCheng" "Assistant" "system"; do
        local COUNT=$(grep "| $PARTICIPANT |" "$ACTIVITY_LOG" | grep -c "$START_DATE\|^$(date -d "$((DAYS-1)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-2)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-3)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-4)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-5)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-6)) days ago" "+%Y-%m-%d")\|^$(date "+%Y-%m-%d")")
        echo "- $PARTICIPANT: $COUNT 次活动" >> "$REPORT_FILE"
    done
    echo "" >> "$REPORT_FILE"
    
    # 按项目统计
    echo "## 🎯 项目活动统计" >> "$REPORT_FILE"
    echo "### 量化交易信号系统项目" >> "$REPORT_FILE"
    local QUANT_COUNT=$(grep -i "量化\|交易\|信号\|策略\|黄金\|GitHub" "$ACTIVITY_LOG" | grep -c "$START_DATE\|^$(date -d "$((DAYS-1)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-2)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-3)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-4)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-5)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-6)) days ago" "+%Y-%m-%d")\|^$(date "+%Y-%m-%d")")
    echo "- 相关活动: $QUANT_COUNT 次" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    # 详细活动记录
    echo "## 📝 详细活动记录" >> "$REPORT_FILE"
    grep "$START_DATE\|^$(date -d "$((DAYS-1)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-2)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-3)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-4)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-5)) days ago" "+%Y-%m-%d")\|^$(date -d "$((DAYS-6)) days ago" "+%Y-%m-%d")\|^$(date "+%Y-%m-%d")" "$ACTIVITY_LOG" | tail -20 >> "$REPORT_FILE"
    
    echo "" >> "$REPORT_FILE"
    echo "---" >> "$REPORT_FILE"
    echo "*报告生成时间: $(date)*" >> "$REPORT_FILE"
    
    echo "📊 对话报告已生成: $REPORT_FILE"
    cat "$REPORT_FILE"
}

# 初始化历史活动记录
initialize_history() {
    echo "🔄 初始化我们的对话历史记录..."
    
    # 记录今天的活动
    local TODAY=$(date "+%Y-%m-%d")
    
    # 量化系统项目相关活动
    record_conversation_activity "YangCheng" "启动量化系统项目" "外盘黄金交易信号系统"
    record_conversation_activity "Assistant" "创建协作框架" "四角色系统：产品、技术、运营、测试"
    record_conversation_activity "YangCheng" "设置GitHub备份" "每小时自动同步到GitHub"
    record_conversation_activity "Assistant" "配置SSH密钥" "为BOT0202用户配置GitHub SSH"
    record_conversation_activity "YangCheng" "查看项目进度" "检查各角色工作状态"
    record_conversation_activity "Assistant" "推动产品经理工作" "发送立即执行指令"
    record_conversation_activity "YangCheng" "修改reset机制" "将daily reset改为3天不说话重置"
    record_conversation_activity "Assistant" "创建3天重置系统" "完整的活动监控和重置系统"
    
    echo "✅ 历史活动记录初始化完成"
}

# 设置每日自动检查
setup_daily_check() {
    echo "⏰ 设置每日自动检查..."
    
    # 创建每日检查脚本
    cat > "/root/.openclaw/workspace/daily_conversation_check.sh" << 'EOF'
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
EOF
    
    chmod +x "/root/.openclaw/workspace/daily_conversation_check.sh"
    
    # 设置cron任务（如果可用）
    if command -v crontab &> /dev/null; then
        CRON_JOB="0 10 * * * /root/.openclaw/workspace/daily_conversation_check.sh >> /root/.openclaw/workspace/our_conversation/logs/daily_check.log 2>&1"
        
        if ! crontab -l 2>/dev/null | grep -q "daily_conversation_check"; then
            (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
            echo "✅ cron任务已添加: 每天10:00自动检查"
        else
            echo "⚠️  cron任务已存在"
        fi
    else
        echo "⚠️  crontab不可用，请手动运行检查"
    fi
}

# 主函数
main() {
    local ACTION=${1:-"check"}
    
    case $ACTION in
        "check")
            echo "🔍 检查我们的对话活动状态..."
            check_conversation_reset
            ;;
        "record")
            if [ $# -lt 3 ]; then
                echo "❌ 用法: $0 record <参与者> <活动> [上下文]"
                echo "   参与者: YangCheng, Assistant, system"
                echo "   示例: $0 record YangCheng '查看项目进度' '量化系统项目'"
                exit 1
            fi
            record_conversation_activity "$2" "$3" "${4:-}"
            ;;
        "report")
            local DAYS=${2:-7}
            generate_conversation_report "$DAYS"
            ;;
        "init")
            initialize_history
            ;;
        "setup")
            setup_daily_check
            ;;
        "history")
            echo "📜 我们的对话活动历史："
            echo "========================================"
            if [ -f "$ACTIVITY_LOG" ]; then
                cat "$ACTIVITY_LOG"
            else
                echo "暂无活动记录"
            fi
            ;;
        "help")
            echo "💬 我们对话的3天重置系统 - 使用说明"
            echo "========================================"
            echo "命令:"
            echo "  $0 check              - 检查对话活动状态"
            echo "  $0 record <谁> <活动> [上下文] - 记录对话活动"
            echo "  $0 report [天数]      - 生成对话报告（默认7天）"
            echo "  $0 init               - 初始化历史记录"
            echo "  $0 setup              - 设置每日自动检查"
            echo "  $0 history            - 查看完整活动历史"
            echo "  $0 help               - 显示帮助"
            echo ""
            echo "参与者: YangCheng(你), Assistant(我), system(系统)"
            echo ""
            echo "示例:"
            echo "  $0 record YangCheng '推动项目进展' '量化系统'"
            echo "  $0 record Assistant '提供技术支持' 'GitHub配置'"
            echo "  $0 check"
            echo "  $0 report 30"
            ;;
        *)
            echo "❌ 未知命令: $ACTION"
            echo "使用: $0 help 查看帮助"
            ;;
    esac
}

# 运行主函数
main "$@"