#!/bin/bash

# 项目进度查看脚本

echo "📊 量化系统项目进度查看"
echo "========================================"

# 1. 查看项目基本信息
echo "🎯 项目基本信息:"
echo "----------------------------------------"
grep -A 2 "项目名称" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md
grep -A 2 "当前阶段" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md
echo ""

# 2. 查看各角色进度
echo "👥 各角色进度状态:"
echo "----------------------------------------"
grep -A 6 "各角色进度" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md
echo ""

# 3. 查看任务清单状态
echo "📋 任务完成情况:"
echo "----------------------------------------"
echo "产品经理任务:"
grep -A 10 "产品经理 (Alex)" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md | grep -E "\[ \]|\[x\]" | head -5
echo ""
echo "技术负责人任务:"
grep -A 10 "技术负责人 (Brian)" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md | grep -E "\[ \]|\[x\]" | head -5
echo ""
echo "运营专家任务:"
grep -A 10 "运营专家 (Cathy)" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md | grep -E "\[ \]|\[x\]" | head -5
echo ""
echo "测试专家任务:"
grep -A 10 "测试专家 (Taylor)" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md | grep -E "\[ \]|\[x\]" | head -5
echo ""

# 4. 查看时间节点
echo "📅 重要时间节点:"
echo "----------------------------------------"
grep -A 10 "重要时间节点" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md | grep -E "[0-9]+\.[0-9]+:|第一阶段|第二阶段|第三阶段"
echo ""

# 5. 查看风险状态
echo "🚨 项目风险状态:"
echo "----------------------------------------"
grep -A 5 "已识别风险" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md | grep -E "风险等级:|数据源|策略有效性|技术实现|用户接受度"
echo ""

# 6. 查看催促状态
echo "⚠️  催促状态:"
echo "----------------------------------------"
if [ -f "/root/.openclaw/workspace/collaboration/shared/task_reminder_log.md" ]; then
    echo "最近催促: $(grep -m1 "时间:" /root/.openclaw/workspace/collaboration/shared/task_reminder_log.md | cut -d: -f2-)"
    echo "目标角色: $(grep -m1 "目标角色:" /root/.openclaw/workspace/collaboration/shared/task_reminder_log.md | cut -d: -f2-)"
else
    echo "暂无催促记录"
fi

echo ""
echo "========================================"
echo "💡 快捷命令:"
echo "   查看完整看板: cat /root/.openclaw/workspace/collaboration/shared/quant_project_board.md"
echo "   只看进度: cat ... | grep -A 10 '各角色进度'"
echo "   查看催促: cat /root/.openclaw/workspace/collaboration/shared/task_reminder_log.md"
echo ""
echo "🔄 看板最后更新: $(grep "看板最后更新" /root/.openclaw/workspace/collaboration/shared/quant_project_board.md | cut -d: -f2-)"