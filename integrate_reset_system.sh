#!/bin/bash

# 将3天重置系统集成到现有协作系统

echo "🔗 集成3天重置系统到协作系统"
echo "========================================"

RESET_SCRIPT="/root/.openclaw/workspace/three_day_reset_system.sh"

# 1. 更新send_message.sh脚本
echo "📧 更新消息发送脚本..."
SEND_SCRIPT="/root/.openclaw/workspace/send_message.sh"
if [ -f "$SEND_SCRIPT" ]; then
    # 备份原脚本
    cp "$SEND_SCRIPT" "${SEND_SCRIPT}.backup.$(date +%Y%m%d)"
    
    # 在发送消息后添加活动记录
    sed -i '/echo "✅ 消息已发送"/a\    # 记录活动\n    '"$RESET_SCRIPT"' record "$FROM" "发送消息给$TO"' "$SEND_SCRIPT"
    
    echo "✅ send_message.sh 已集成重置系统"
else
    echo "⚠️  send_message.sh 不存在"
fi

# 2. 更新role_response.sh脚本
echo "🔄 更新角色响应脚本..."
RESPONSE_SCRIPT="/root/.openclaw/workspace/role_response.sh"
if [ -f "$RESPONSE_SCRIPT" ]; then
    cp "$RESPONSE_SCRIPT" "${RESPONSE_SCRIPT}.backup.$(date +%Y%m%d)"
    
    # 在角色响应后添加活动记录
    sed -i '/echo "📋 角色响应完成"/a\    # 记录活动\n    '"$RESET_SCRIPT"' record "$ROLE" "更新状态响应"' "$RESPONSE_SCRIPT"
    
    echo "✅ role_response.sh 已集成重置系统"
else
    echo "⚠️  role_response.sh 不存在"
fi

# 3. 更新start_collaboration.sh脚本
echo "🚀 更新协作启动脚本..."
START_SCRIPT="/root/.openclaw/workspace/start_collaboration.sh"
if [ -f "$START_SCRIPT" ]; then
    cp "$START_SCRIPT" "${START_SCRIPT}.backup.$(date +%Y%m%d)"
    
    # 在协作启动后添加活动记录
    sed -i '/echo "✅ 协作系统启动完成"/a\\n# 初始化重置系统活动记录\necho "📝 初始化重置系统活动记录..."\n'"$RESET_SCRIPT"' record system "协作系统启动"\n'"$RESET_SCRIPT"' record product "系统启动 - 开始工作"\n'"$RESET_SCRIPT"' record tech "系统启动 - 开始工作"\n'"$RESET_SCRIPT"' record ops "系统启动 - 开始工作"\n'"$RESET_SCRIPT"' record test "系统启动 - 开始工作"' "$START_SCRIPT"
    
    echo "✅ start_collaboration.sh 已集成重置系统"
else
    echo "⚠️  start_collaboration.sh 不存在"
fi

# 4. 创建每日工作开始脚本
echo "📅 创建每日工作开始脚本..."
cat > /root/.openclaw/workspace/start_daily_work.sh << 'EOF'
#!/bin/bash

# 每日工作开始脚本
# 记录各角色开始工作，避免被重置

echo "🌅 每日工作开始记录"
echo "========================================"

RESET_SCRIPT="/root/.openclaw/workspace/three_day_reset_system.sh"

# 记录系统每日检查
"$RESET_SCRIPT" record system "每日工作检查"

# 记录各角色开始工作
echo "👥 记录各角色工作开始..."
"$RESET_SCRIPT" record product "开始今日工作"
"$RESET_SCRIPT" record tech "开始今日工作"
"$RESET_SCRIPT" record ops "开始今日工作"
"$RESET_SCRIPT" record test "开始今日工作"

echo ""
echo "📊 今日日期: $(date)"
echo "📋 项目阶段: 需求分析与设计"
echo "⏰ 下次会议: 2026-04-10 14:00"
echo ""
echo "💡 建议今日工作:"
echo "   产品经理: 继续交易员访谈"
echo "   技术负责人: 开始架构设计"
echo "   运营专家: 开始策略收集"
echo "   测试专家: 完善测试计划"
echo ""
echo "✅ 每日工作记录完成"
EOF

chmod +x /root/.openclaw/workspace/start_daily_work.sh

# 5. 创建每周活动报告脚本
echo "📈 创建每周活动报告脚本..."
cat > /root/.openclaw/workspace/weekly_activity_report.sh << 'EOF'
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
EOF

chmod +x /root/.openclaw/workspace/weekly_activity_report.sh

# 6. 更新项目文档
echo "📚 更新项目文档..."
cat >> /root/.openclaw/workspace/README.md << 'EOF'

## 🔄 3天不说话重置系统

### 系统概述
自动监控各角色活动状态，3天无活动则自动重置角色状态。

### 主要功能
1. **活动监控** - 记录各角色的工作活动
2. **自动重置** - 3天无活动自动重置状态
3. **通知提醒** - 发送重置通知和重新激活要求
4. **进度保护** - 避免项目因角色不活跃而停滞

### 使用方法
```bash
# 手动检查活动状态
./check_role_activity.sh

# 记录角色活动
./three_day_reset_system.sh record product "完成需求调研"

# 每日工作开始记录
./start_daily_work.sh

# 每周活动报告
./weekly_activity_report.sh
```

### 自动化设置
- **每天9:00**自动检查活动状态
- **3天无活动**自动触发重置
- **集成到协作系统**中自动记录活动

### 文件位置
- 核心脚本: `three_day_reset_system.sh`
- 活动日志: `collaboration/logs/role_activity.log`
- 重置日志: `collaboration/logs/reset_system.log`
- 使用指南: `RESET_SYSTEM_GUIDE.md`
EOF

echo ""
echo "✅ 3天重置系统集成完成！"
echo "========================================"
echo "📋 已完成的集成:"
echo "   1. ✅ send_message.sh - 发送消息时记录活动"
echo "   2. ✅ role_response.sh - 角色响应时记录活动"
echo "   3. ✅ start_collaboration.sh - 系统启动时初始化"
echo "   4. ✅ start_daily_work.sh - 每日工作开始脚本"
echo "   5. ✅ weekly_activity_report.sh - 每周活动报告"
echo "   6. ✅ README.md - 更新项目文档"
echo ""
echo "🚀 立即测试:"
echo "   ./check_role_activity.sh"
echo "   ./start_daily_work.sh"
echo "   ./three_day_reset_system.sh help"
echo ""
echo "📚 详细指南: cat RESET_SYSTEM_GUIDE.md"