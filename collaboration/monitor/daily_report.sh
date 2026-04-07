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
