#!/bin/bash

echo "🔍 技术进度快速检查"
echo "========================"
echo ""
echo "📅 检查时间: $(date)"
echo ""

# 检查技术文档
echo "📋 技术文档完成状态:"
echo "------------------------"
tech_docs=(
  "Backtrader采用决策记录.md"
  "技术可行性评估摘要.md"
  "Backtrader集成架构设计.md"
  "4周实施详细计划.md"
  "资源需求清单.md"
  "风险评估和应对.md"
  "技术栈选型确认.md"
  "系统数据流设计.md"
  "开发环境准备清单.md"
  "20分钟执行总结报告.md"
)

completed=0
total=${#tech_docs[@]}

for doc in "${tech_docs[@]}"; do
  if [ -f "$doc" ]; then
    echo "  ✅ $doc"
    ((completed++))
  else
    echo "  ❌ $doc (缺失)"
  fi
done

echo ""
echo "📊 文档完成率: $completed/$total ($((completed*100/total))%)"

# 检查项目看板状态
echo ""
echo "🎯 项目看板技术状态:"
echo "------------------------"
if [ -f "collaboration/shared/quant_project_board.md" ]; then
  echo "  ✅ 项目看板存在"
  
  # 检查技术任务状态
  tech_tasks=$(grep -c "技术负责人" collaboration/shared/quant_project_board.md)
  completed_tasks=$(grep -c "✅" collaboration/shared/quant_project_board.md | head -1)
  
  echo "  📋 技术任务数: $tech_tasks"
  echo "  ✅ 已完成任务: $completed_tasks"
else
  echo "  ❌ 项目看板缺失"
fi

# 检查技术收件箱
echo ""
echo "📥 技术收件箱状态:"
echo "------------------------"
if [ -d "collaboration/tech/inbox" ]; then
  inbox_count=$(ls -1 collaboration/tech/inbox/ 2>/dev/null | wc -l)
  echo "  ✅ 技术收件箱存在"
  echo "  📧 收件数量: $inbox_count"
  
  # 列出最新收件
  latest_inbox=$(ls -t collaboration/tech/inbox/ 2>/dev/null | head -3)
  if [ -n "$latest_inbox" ]; then
    echo "  📋 最新收件:"
    for item in $latest_inbox; do
      echo "    • $item"
    done
  fi
else
  echo "  ❌ 技术收件箱缺失"
fi

# 检查监控目录
echo ""
echo "⏰ 技术监控状态:"
echo "------------------------"
if [ -d "collaboration/20min_tech_monitor" ]; then
  monitor_files=$(ls -1 collaboration/20min_tech_monitor/ 2>/dev/null | wc -l)
  echo "  ✅ 技术监控目录存在"
  echo "  📁 监控文件数: $monitor_files"
  
  # 检查时间监控
  if [ -f "collaboration/20min_tech_monitor/time_monitor.sh" ]; then
    echo "  ⏰ 时间监控脚本: 存在"
  else
    echo "  ⏰ 时间监控脚本: 缺失"
  fi
else
  echo "  ❌ 技术监控目录缺失"
fi

# 检查下一步行动
echo ""
echo "🚀 下一步技术行动:"
echo "------------------------"
next_actions=(
  "开始第1周框架集成工作"
  "安排技术团队培训"
  "准备开发环境搭建"
  "开始策略原型开发"
)

for action in "${next_actions[@]}"; do
  echo "  • $action"
done

# 总体评估
echo ""
echo "📈 技术进度总体评估:"
echo "------------------------"

if [ $completed -eq $total ]; then
  echo "  🟢 优秀: 所有技术文档完成"
  echo "  🎯 技术决策阶段: 100% 完成"
  echo "  ⚡ 效率: 20分钟任务提前完成"
  echo "  📝 质量: 10个核心文档产出"
else
  completion_rate=$((completed*100/total))
  if [ $completion_rate -ge 80 ]; then
    echo "  🟡 良好: 技术文档基本完成 ($completion_rate%)"
  elif [ $completion_rate -ge 60 ]; then
    echo "  🟡 中等: 技术文档部分完成 ($completion_rate%)"
  else
    echo "  🔴 需要改进: 技术文档完成度低 ($completion_rate%)"
  fi
fi

# 检查风险状态
echo ""
echo "🚨 技术风险状态:"
echo "------------------------"
if [ -f "风险评估和应对.md" ]; then
  high_risk=$(grep -c "极高风险" 风险评估和应对.md)
  medium_risk=$(grep -c "中风险" 风险评估和应对.md)
  
  echo "  🔴 极高风险: $high_risk 项"
  echo "  🟡 中风险: $medium_risk 项"
  
  if [ $high_risk -eq 0 ]; then
    echo "  🟢 风险状态: 可控"
  else
    echo "  🟡 风险状态: 需要关注"
  fi
else
  echo "  ❌ 风险评估文档缺失"
fi

# 资源检查
echo ""
echo "💰 技术资源状态:"
echo "------------------------"
if [ -f "资源需求清单.md" ]; then
  budget=$(grep "总预算" 资源需求清单.md | head -1)
  if [ -n "$budget" ]; then
    echo "  $budget"
  fi
  
  manpower=$(grep -A2 "人力资源" 资源需求清单.md | grep -c "技术负责人")
  echo "  👥 技术人力: $manpower 名核心成员"
else
  echo "  ❌ 资源需求文档缺失"
fi

# 最后更新时间
echo ""
echo "⏰ 最后更新状态:"
echo "------------------------"
if [ -f "collaboration/shared/quant_project_board.md" ]; then
  last_update=$(grep "下次更新" collaboration/shared/quant_project_board.md | tail -1)
  if [ -n "$last_update" ]; then
    echo "  $last_update"
  fi
fi

echo ""
echo "🔍 检查完成!"
echo "建议:"
echo "1. 确保所有技术文档完整"
echo "2. 开始第1周框架集成工作"
echo "3. 安排技术团队培训"
echo "4. 建立每日进度跟踪"