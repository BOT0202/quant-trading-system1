#!/bin/bash
echo "⏰ 时间监控 - 20分钟技术紧急任务"
echo "当前时间: $(date)"
echo "开始时间: 00:15"
echo "截止时间: 00:35"

# 计算剩余时间
current_epoch=$(date +%s)
start_epoch=$(date -d "00:15" +%s 2>/dev/null || date -d "today 00:15" +%s)
end_epoch=$(date -d "00:35" +%s 2>/dev/null || date -d "today 00:35" +%s)

if [ $current_epoch -lt $start_epoch ]; then
    echo "状态: 还未开始"
    echo "剩余准备时间: $(( ($start_epoch - $current_epoch) / 60 ))分钟"
elif [ $current_epoch -ge $start_epoch ] && [ $current_epoch -lt $end_epoch ]; then
    elapsed=$(( ($current_epoch - $start_epoch) / 60 ))
    remaining=$(( ($end_epoch - $current_epoch) / 60 ))
    echo "状态: 进行中"
    echo "已用时间: ${elapsed}分钟"
    echo "剩余时间: ${remaining}分钟"
    
    # 阶段判断
    if [ $elapsed -lt 5 ]; then
        echo "当前阶段: 阶段1 - 快速评估和决策"
        echo "阶段剩余时间: $((5 - $elapsed))分钟"
    elif [ $elapsed -lt 10 ]; then
        echo "当前阶段: 阶段2 - 技术方案设计"
        echo "阶段剩余时间: $((10 - $elapsed))分钟"
    elif [ $elapsed -lt 15 ]; then
        echo "当前阶段: 阶段3 - 实施计划制定"
        echo "阶段剩余时间: $((15 - $elapsed))分钟"
    else
        echo "当前阶段: 阶段4 - 团队准备和沟通"
        echo "阶段剩余时间: $((20 - $elapsed))分钟"
    fi
else
    echo "状态: 已超时"
    overtime=$(( ($current_epoch - $end_epoch) / 60 ))
    echo "超时时间: ${overtime}分钟"
fi
