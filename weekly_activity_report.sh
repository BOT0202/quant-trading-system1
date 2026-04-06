#!/bin/bash

# 每周活动报告脚本

echo "📊 每周角色活动报告"
echo "========================================"

ACTIVITY_LOG="/root/.openclaw/workspace/collaboration/logs/role_activity.log"
RESET_LOG="/root/.openclaw/workspace/collaboration/logs/reset_system.log"
WEEK_START=$(date -d "7 days ago" "+%Y-%m-%d")
TODAY=$(date "+%Y-%m-%d")

echo "📅 报告周期: $WEEK_START 至 $TODAY"
echo ""

# 各角色活动统计
echo "👥 各角色活动统计:"
echo "----------------------------------------"
for ROLE in "product" "tech" "ops" "test"; do
    COUNT=$(grep "| $ROLE |" "$ACTIVITY_LOG" | grep -c "$WEEK_START\|$(date -d "6 days ago" "+%Y-%m-%d")\|$(date -d "5 days ago" "+%Y-%m-%d")\|$(date -d "4 days ago" "+%Y-%m-%d")\|$(date -d "3 days ago" "+%Y-%m-%d")\|$(date -d "2 days ago" "+%Y-%m-%d")\|$(date -d "1 day ago" "+%Y-%m-%d")\|$TODAY")
    case $ROLE in
        "product") ROLE_NAME="产品经理" ;;
        "tech") ROLE_NAME="技术负责人" ;;
        "ops") ROLE_NAME="运营专家" ;;
        "test") ROLE_NAME="测试专家" ;;
    esac
    echo "  $ROLE_NAME: $COUNT 次活动"
done

echo ""
echo "🔄 本周重置统计:"
echo "----------------------------------------"
RESET_COUNT=$(grep "重置时间" "$RESET_LOG" | grep -c "$WEEK_START\|$(date -d "6 days ago" "+%Y-%m-%d")\|$(date -d "5 days ago" "+%Y-%m-%d")\|$(date -d "4 days ago" "+%Y-%m-%d")\|$(date -d "3 days ago" "+%Y-%m-%d")\|$(date -d "2 days ago" "+%Y-%m-%d")\|$(date -d "1 day ago" "+%Y-%m-%d")\|$TODAY")
if [ "$RESET_COUNT" -eq 0 ]; then
    echo "  ✅ 本周无重置记录"
else
    echo "  ⚠️  本周有 $RESET_COUNT 次重置"
    grep "重置角色" "$RESET_LOG" | grep "$WEEK_START\|$(date -d "6 days ago" "+%Y-%m-%d")\|$(date -d "5 days ago" "+%Y-%m-%d")\|$(date -d "4 days ago" "+%Y-%m-%d")\|$(date -d "3 days ago" "+%Y-%m-%d")\|$(date -d "2 days ago" "+%Y-%m-%d")\|$(date -d "1 day ago" "+%Y-%m-%d")\|$TODAY" | sort | uniq -c
fi

echo ""
echo "📋 最近活动记录:"
echo "----------------------------------------"
tail -10 "$ACTIVITY_LOG" | while read line; do
    echo "  $line"
done

echo ""
echo "💡 活动健康度分析:"
echo "----------------------------------------"
TOTAL_ACTIVITIES=$(grep "$WEEK_START\|$(date -d "6 days ago" "+%Y-%m-%d")\|$(date -d "5 days ago" "+%Y-%m-%d")\|$(date -d "4 days ago" "+%Y-%m-%d")\|$(date -d "3 days ago" "+%Y-%m-%d")\|$(date -d "2 days ago" "+%Y-%m-%d")\|$(date -d "1 day ago" "+%Y-%m-%d")\|$TODAY" "$ACTIVITY_LOG" | wc -l)
DAYS_COVERED=7
AVG_DAILY=$((TOTAL_ACTIVITIES / DAYS_COVERED))

if [ "$AVG_DAILY" -ge 4 ]; then
    echo "  🟢 优秀: 平均每天 $AVG_DAILY 次活动"
elif [ "$AVG_DAILY" -ge 2 ]; then
    echo "  🟡 良好: 平均每天 $AVG_DAILY 次活动"
else
    echo "  🔴 需改进: 平均每天 $AVG_DAILY 次活动"
fi

echo ""
echo "✅ 每周报告生成完成"
echo "📁 详细日志: $ACTIVITY_LOG"
