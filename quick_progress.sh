#!/bin/bash

# 快速进度查看

echo "🚀 项目进度速览"
echo "================"

# 项目阶段和进度
PHASE=$(grep -A 1 "当前阶段" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md | tail -1 | sed 's/\*\*//g')
PROGRESS=$(echo "$PHASE" | grep -o "进度: [0-9]*%" | cut -d: -f2)
DEADLINE=$(echo "$PHASE" | grep -o "截止时间: [0-9\-]*" | cut -d: -f2)

echo "📅 阶段: $(echo "$PHASE" | cut -d: -f1)"
echo "📊 进度: $PROGRESS"
echo "⏰ 截止: $DEADLINE"
echo ""

# 各角色进度表格
echo "👥 角色进度表"
echo "------------"
echo "角色          任务                进度   状态"
echo "--------------------------------------------"

grep -A 4 "各角色进度" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md | tail -4 | while read line; do
    if [[ "$line" == *"|"* ]]; then
        # 提取表格数据
        ROLE=$(echo "$line" | awk -F'|' '{print $2}' | sed 's/^ *//;s/ *$//')
        TASK=$(echo "$line" | awk -F'|' '{print $3}' | sed 's/^ *//;s/ *$//')
        PROG=$(echo "$line" | awk -F'|' '{print $4}' | sed 's/^ *//;s/ *$//')
        STATUS=$(echo "$line" | awk -F'|' '{print $5}' | sed 's/^ *//;s/ *$//')
        
        # 格式化输出
        printf "%-12s %-20s %-6s %s\n" "$ROLE" "$TASK" "$PROG" "$STATUS"
    fi
done

echo ""
echo "📋 任务完成统计"
echo "--------------"

# 统计各角色任务完成情况
for role in "产品经理" "技术负责人" "运营专家" "测试专家"; do
    TASKS=$(grep -A 15 "$role (" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md | grep -E "\[ \]|\[x\]" | wc -l)
    DONE=$(grep -A 15 "$role (" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md | grep "\[x\]" | wc -l)
    if [ $TASKS -gt 0 ]; then
        PERCENT=$((DONE * 100 / TASKS))
        echo "$role: $DONE/$TASKS 完成 ($PERCENT%)"
    fi
done

echo ""
echo "⏰ 下次重要会议"
NEXT_MEETING=$(grep -A 5 "计划中的会议" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md | grep -E "4\.[0-9]+" | head -1)
if [ -n "$NEXT_MEETING" ]; then
    echo "$NEXT_MEETING"
else
    echo "暂无会议安排"
fi

echo ""
echo "🚨 最高风险"
RISK=$(grep -A 3 "风险等级: 高" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md | head -1 | sed 's/^[0-9]*\. //')
if [ -n "$RISK" ]; then
    echo "$RISK"
else
    echo "暂无高风险"
fi

echo ""
echo "💡 命令: ./view_progress.sh (查看详细进度)"