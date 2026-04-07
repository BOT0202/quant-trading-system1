#!/bin/bash

# 自动检查产品经理进度

MONITOR_DIR="/root/.openclaw/workspace/collaboration/30min_monitor"
PRODUCT_DIR="/root/.openclaw/workspace/collaboration/product/work"
OUTPUT_DIR="/root/.openclaw/workspace/collaboration/product/outputs/urgent"

check_progress() {
    local task=$1
    local progress=0
    
    case $task in
        "interview")
            # 检查访谈完成情况
            if [ -f "$PRODUCT_DIR/interview_complete.md" ]; then
                progress=100
            elif [ -f "$PRODUCT_DIR/interview_in_progress.md" ]; then
                progress=50
            else
                progress=0
            fi
            ;;
        "report")
            # 检查需求报告
            if [ -f "$OUTPUT_DIR/需求调研报告.pdf" ]; then
                progress=100
            elif [ -f "$PRODUCT_DIR/requirements_report_draft.md" ]; then
                progress=60
            else
                progress=0
            fi
            ;;
        "flowchart")
            # 检查业务流程图
            if [ -f "$OUTPUT_DIR/核心业务流程图.png" ]; then
                progress=100
            elif [ -f "$PRODUCT_DIR/business_flowchart.dio" ]; then
                progress=50
            else
                progress=0
            fi
            ;;
        "prototype")
            # 检查原型图
            if [ -f "$OUTPUT_DIR/信号看板原型图.fig" ]; then
                progress=100
            elif [ -f "$PRODUCT_DIR/prototype_design.fig" ]; then
                progress=50
            else
                progress=0
            fi
            ;;
        "prd")
            # 检查PRD框架
            if [ -f "$OUTPUT_DIR/PRD框架.md" ]; then
                progress=100
            elif [ -f "$PRODUCT_DIR/prd_framework.md" ]; then
                progress=60
            else
                progress=0
            fi
            ;;
    esac
    
    echo $progress
}

# 检查所有任务
INTERVIEW_PROGRESS=$(check_progress "interview")
REPORT_PROGRESS=$(check_progress "report")
FLOWCHART_PROGRESS=$(check_progress "flowchart")
PROTOTYPE_PROGRESS=$(check_progress "prototype")
PRD_PROGRESS=$(check_progress "prd")

# 计算总体进度
TOTAL_PROGRESS=$(( (INTERVIEW_PROGRESS*30 + REPORT_PROGRESS*25 + FLOWCHART_PROGRESS*20 + PROTOTYPE_PROGRESS*15 + PRD_PROGRESS*10) / 100 ))

# 记录进度
echo "$(date '+%Y-%m-%d %H:%M:%S'),$INTERVIEW_PROGRESS,$REPORT_PROGRESS,$FLOWCHART_PROGRESS,$PROTOTYPE_PROGRESS,$PRD_PROGRESS,$TOTAL_PROGRESS" >> "$MONITOR_DIR/progress_log.csv"

# 输出进度
echo "进度更新:"
echo "  深度访谈: $INTERVIEW_PROGRESS%"
echo "  需求报告: $REPORT_PROGRESS%"
echo "  业务流程图: $FLOWCHART_PROGRESS%"
echo "  原型图: $PROTOTYPE_PROGRESS%"
echo "  PRD框架: $PRD_PROGRESS%"
echo "  总体进度: $TOTAL_PROGRESS%"
