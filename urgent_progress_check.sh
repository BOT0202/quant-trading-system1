#!/bin/bash

# 🚨 紧急进度检查脚本
# 用于每小时检查各角色进度

echo "🚨 紧急进度检查 - $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

# 读取项目看板
BOARD_FILE="/root/.openclaw/workspace/collaboration/shared/quant_project_board.md"
LOG_FILE="/root/.openclaw/workspace/collaboration/shared/task_reminder_log.md"

echo ""
echo "📊 当前项目状态"
echo "--------------"

# 提取项目阶段和进度
PHASE=$(grep -A 1 "当前阶段" "$BOARD_FILE" | tail -1 | sed 's/\*\*//g')
echo "阶段: $(echo "$PHASE" | cut -d: -f1)"
echo "进度: $(echo "$PHASE" | grep -o "进度: [0-9]*%" | cut -d: -f2)"
echo "紧急状态: $(grep -o "紧急状态:.*" "$BOARD_FILE" | cut -d: -f2)"

echo ""
echo "👥 各角色当前状态"
echo "----------------"

# 提取各角色状态
echo "角色          状态          最后更新"
echo "------------------------------------"
grep -A 5 "各角色进度" "$BOARD_FILE" | grep "|" | while read line; do
    if [[ "$line" == *"|"* ]]; then
        ROLE=$(echo "$line" | awk -F'|' '{print $2}' | sed 's/^ *//;s/ *$//')
        STATUS=$(echo "$line" | awk -F'|' '{print $5}' | sed 's/^ *//;s/ *$//')
        printf "%-12s %-15s %s\n" "$ROLE" "$STATUS" "$(date '+%H:%M')"
    fi
done

echo ""
echo "📋 紧急任务完成情况"
echo "------------------"

# 检查产品经理任务
echo "🎯 产品经理:"
PM_TASKS=$(grep -A 20 "产品经理任务:" "$BOARD_FILE" | grep -E "\[x\]|\[\s\]" | wc -l)
PM_DONE=$(grep -A 20 "产品经理任务:" "$BOARD_FILE" | grep "\[x\]" | wc -l)
echo "  已完成: $PM_DONE/$PM_TASKS"

# 检查技术负责人任务
echo "⚙️ 技术负责人:"
TECH_TASKS=$(grep -A 20 "技术负责人任务:" "$BOARD_FILE" | grep -E "\[x\]|\[\s\]" | wc -l)
TECH_DONE=$(grep -A 20 "技术负责人任务:" "$BOARD_FILE" | grep "\[x\]" | wc -l)
echo "  已完成: $TECH_DONE/$TECH_TASKS"

# 检查运营专家任务
echo "📈 运营专家:"
OPS_TASKS=$(grep -A 20 "运营专家任务:" "$BOARD_FILE" | grep -E "\[x\]|\[\s\]" | wc -l)
OPS_DONE=$(grep -A 20 "运营专家任务:" "$BOARD_FILE" | grep "\[x\]" | wc -l)
echo "  已完成: $OPS_DONE/$OPS_TASKS"

# 检查测试专家任务
echo "🧪 测试专家:"
TEST_TASKS=$(grep -A 20 "测试专家任务:" "$BOARD_FILE" | grep -E "\[x\]|\[\s\]" | wc -l)
TEST_DONE=$(grep -A 20 "测试专家任务:" "$BOARD_FILE" | grep "\[x\]" | wc -l)
echo "  已完成: $TEST_DONE/$TEST_TASKS"

echo ""
echo "⏰ 下次检查点"
echo "-----------"

# 提取下次检查点
NEXT_CHECK=$(grep -A 5 "紧急时间表" "$BOARD_FILE" | grep -E "今天|明天|后天" | head -1)
if [ -n "$NEXT_CHECK" ]; then
    echo "$NEXT_CHECK"
else
    echo "今天18:00 - 第一次进度检查"
fi

echo ""
echo "🚨 需要立即关注的问题"
echo "-------------------"

# 检查是否有未完成任务超过24小时
URGENT_TASKS=$(grep -B 5 -A 5 "最近催促" "$LOG_FILE" | grep -c "催促内容")
if [ "$URGENT_TASKS" -gt 0 ]; then
    echo "有 $URGENT_TASKS 个任务需要立即关注"
    grep -B 5 -A 5 "最近催促" "$LOG_FILE" | grep -E "催促内容|响应要求" | head -4
else
    echo "暂无紧急问题"
fi

echo ""
echo "💡 建议行动"
echo "---------"

# 根据进度给出建议
if [ "$PM_DONE" -lt 10 ]; then
    echo "1. 产品经理需要加快访谈进度"
fi

if [ "$TECH_DONE" -eq 0 ]; then
    echo "2. 技术负责人需要立即开始技术选型"
fi

if [ "$OPS_DONE" -eq 0 ]; then
    echo "3. 运营专家需要立即开始策略收集"
fi

if [ "$TEST_DONE" -eq 0 ]; then
    echo "4. 测试专家需要立即开始场景分析"
fi

echo ""
echo "=========================================="
echo "📝 记录时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "🔄 下次检查: 1小时后"

# 更新催促日志
echo -e "\n---\n**进度检查**: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
echo "检查结果: 各角色进度如上所示" >> "$LOG_FILE"

echo ""
echo "✅ 进度检查完成，结果已记录到催促日志"