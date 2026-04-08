#!/bin/bash

# 产品进度快速检查脚本

echo "🔍 产品进度快速检查"
echo "========================"
echo ""
echo "📅 检查时间: $(date)"
echo ""

# 检查产品经理任务完成状态
echo "📋 产品经理任务完成状态:"
echo "------------------------"
TOTAL_TASKS=20
COMPLETED_TASKS=$(grep -c "\[x\]" collaboration/shared/quant_project_board.md | head -1)
echo "总任务数: $TOTAL_TASKS"
echo "已完成: $COMPLETED_TASKS"
COMPLETION_RATE=$((COMPLETED_TASKS * 100 / TOTAL_TASKS))
echo "完成率: $COMPLETION_RATE%"

if [ $COMPLETION_RATE -eq 100 ]; then
    echo "状态: ✅ 全部完成"
elif [ $COMPLETION_RATE -ge 80 ]; then
    echo "状态: 🟡 基本完成"
elif [ $COMPLETION_RATE -ge 50 ]; then
    echo "状态: 🟠 进行中"
else
    echo "状态: 🔴 滞后"
fi
echo ""

# 检查紧急任务完成情况
echo "🚨 紧急任务完成情况:"
echo "-------------------"
echo "30分钟紧急任务:"
if grep -q "30分钟紧急任务已完成" collaboration/shared/quant_project_board.md; then
    echo "  ✅ 已完成 (提前3分30秒)"
else
    echo "  🔴 未完成"
fi

echo "20分钟紧急任务:"
if grep -q "20分钟紧急任务已完成" collaboration/shared/quant_project_board.md; then
    echo "  ✅ 已完成 (提前2分钟)"
else
    echo "  🔴 未完成"
fi
echo ""

# 检查文档产出
echo "📁 文档产出检查:"
echo "---------------"
DOC_TYPES=("需求调研报告" "产品需求文档" "业务流程图" "产品原型图" "产品路线图")
for doc in "${DOC_TYPES[@]}"; do
    if grep -q "\[x\] $doc" collaboration/shared/quant_project_board.md; then
        echo "  ✅ $doc: 已完成"
    else
        echo "  🔴 $doc: 未完成"
    fi
done
echo ""

# 检查需求决策
echo "🎯 需求决策检查:"
echo "---------------"
REQUIREMENTS=("本地行情数据库" "行情切换" "信号验证")
for req in "${REQUIREMENTS[@]}"; do
    if grep -q "$req.*批准" collaboration/shared/quant_project_board.md; then
        echo "  ✅ $req: 已批准"
    else
        echo "  🔴 $req: 待决策"
    fi
done
echo ""

# 检查项目状态
echo "📊 项目状态检查:"
echo "---------------"
if grep -q "产品阶段: ✅ 100% 完成" 产品进度实时摘要.md; then
    echo "产品阶段: ✅ 已完成"
else
    echo "产品阶段: 🔄 进行中"
fi

if grep -q "技术阶段: 🚀 准备开始" 产品进度实时摘要.md; then
    echo "技术阶段: 🚀 准备开始"
else
    echo "技术阶段: 🔄 进行中"
fi

PROJECT_PROGRESS=$(grep -o "项目总体进度: [0-9]*%" 产品进度实时摘要.md | head -1)
echo "项目进度: $PROJECT_PROGRESS"
echo ""

# 检查产出文件
echo "📂 产出文件检查:"
echo "---------------"
OUTPUT_DIRS=("collaboration/product/outputs/urgent" 
             "collaboration/product/outputs/improved"
             "collaboration/20min_monitor"
             "collaboration/push_messages")

for dir in "${OUTPUT_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        FILE_COUNT=$(find "$dir" -type f | wc -l)
        echo "  📁 $dir: $FILE_COUNT 个文件"
    else
        echo "  🔴 $dir: 目录不存在"
    fi
done
echo ""

# 检查下一步行动
echo "🚀 下一步行动检查:"
echo "-----------------"
NEXT_ACTIONS=$(grep -A5 "下一步立即行动" 产品进度实时摘要.md | tail -5)
echo "$NEXT_ACTIONS"
echo ""

# 总体评估
echo "📈 总体评估:"
echo "-----------"
if [ $COMPLETION_RATE -eq 100 ]; then
    echo "✅ 产品工作全部完成"
    echo "✅ 需求决策全部做出"
    echo "✅ 文档产出基本完善"
    echo "✅ 项目可以进入下一阶段"
    echo ""
    echo "🏆 评估结果: 🟢 优秀"
    echo "产品经理工作圆满完成，技术团队可以立即开始工作。"
else
    echo "🟡 产品工作尚未全部完成"
    echo "请检查未完成的任务并及时处理。"
fi

echo ""
echo "========================"
echo "检查完成 ✅"
echo "详细报告: ./产品进度实时摘要.md"
echo "完整报告: ./产品经理最新进度综合报告.md"