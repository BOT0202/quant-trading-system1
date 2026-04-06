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
