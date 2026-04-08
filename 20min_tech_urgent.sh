#!/bin/bash

# 20分钟技术紧急执行监控脚本
# 开始时间: 00:15
# 截止时间: 00:35

echo "🚀 20分钟技术紧急执行监控启动"
echo "================================"
echo "开始时间: $(date)"
echo "截止时间: 00:35"
echo "总时长: 20分钟"
echo ""

# 创建监控目录
MONITOR_DIR="collaboration/20min_tech_monitor"
mkdir -p $MONITOR_DIR

# 阶段1: 快速评估和决策 (00:15-00:20)
echo "📋 阶段1: 快速评估和决策 (00:15-00:20)"
echo "----------------------------------------"
echo "目标: 完成技术可行性评估和决策"
echo "任务:"
echo "  1. 阅读需求文档 (1分钟)"
echo "  2. 技术可行性评估 (2分钟)"
echo "  3. 决策确认 (2分钟)"
echo "产出:"
echo "  • Backtrader采用决策记录.md"
echo "  • 技术可行性评估摘要.md"
echo ""

# 创建阶段1提醒
echo "⏰ 阶段1提醒: 需要在5分钟内完成评估和决策" > $MONITOR_DIR/reminder_phase1.txt
echo "开始时间: 00:15" >> $MONITOR_DIR/reminder_phase1.txt
echo "截止时间: 00:20" >> $MONITOR_DIR/reminder_phase1.txt
echo "剩余时间: 5分钟" >> $MONITOR_DIR/reminder_phase1.txt

# 阶段2: 技术方案设计 (00:20-00:25)
echo "📋 阶段2: 技术方案设计 (00:20-00:25)"
echo "----------------------------------------"
echo "目标: 设计Backtrader集成技术架构"
echo "任务:"
echo "  1. 架构设计 (2分钟)"
echo "  2. 技术栈确认 (2分钟)"
echo "  3. 数据流设计 (1分钟)"
echo "产出:"
echo "  • Backtrader集成架构图.png (概念图)"
echo "  • 技术栈选型确认.md"
echo "  • 系统数据流设计.md"
echo ""

# 创建阶段2提醒
echo "⏰ 阶段2提醒: 需要在5分钟内完成方案设计" > $MONITOR_DIR/reminder_phase2.txt
echo "开始时间: 00:20" >> $MONITOR_DIR/reminder_phase2.txt
echo "截止时间: 00:25" >> $MONITOR_DIR/reminder_phase2.txt
echo "剩余时间: 5分钟" >> $MONITOR_DIR/reminder_phase2.txt

# 阶段3: 实施计划制定 (00:25-00:30)
echo "📋 阶段3: 实施计划制定 (00:25-00:30)"
echo "----------------------------------------"
echo "目标: 制定详细的4周实施计划"
echo "任务:"
echo "  1. 时间规划 (2分钟)"
echo "  2. 资源规划 (2分钟)"
echo "  3. 风险评估 (1分钟)"
echo "产出:"
echo "  • 4周实施详细计划.md"
echo "  • 资源需求清单.md"
echo "  • 风险评估和应对.md"
echo ""

# 创建阶段3提醒
echo "⏰ 阶段3提醒: 需要在5分钟内完成计划制定" > $MONITOR_DIR/reminder_phase3.txt
echo "开始时间: 00:25" >> $MONITOR_DIR/reminder_phase3.txt
echo "截止时间: 00:30" >> $MONITOR_DIR/reminder_phase3.txt
echo "剩余时间: 5分钟" >> $MONITOR_DIR/reminder_phase3.txt

# 阶段4: 团队准备和沟通 (00:30-00:35)
echo "📋 阶段4: 团队准备和沟通 (00:30-00:35)"
echo "----------------------------------------"
echo "目标: 完成团队准备和项目更新"
echo "任务:"
echo "  1. 开发环境准备 (2分钟)"
echo "  2. 团队通知 (1分钟)"
echo "  3. 文档整理和交付 (2分钟)"
echo "产出:"
echo "  • 开发环境准备清单.md"
echo "  • 团队培训计划.md"
echo "  • 20分钟执行总结报告.md"
echo ""

# 创建阶段4提醒
echo "⏰ 阶段4提醒: 需要在5分钟内完成团队准备" > $MONITOR_DIR/reminder_phase4.txt
echo "开始时间: 00:30" >> $MONITOR_DIR/reminder_phase4.txt
echo "截止时间: 00:35" >> $MONITOR_DIR/reminder_phase4.txt
echo "剩余时间: 5分钟" >> $MONITOR_DIR/reminder_phase4.txt

# 创建最终检查清单
echo "✅ 最终交付物检查清单" > $MONITOR_DIR/final_checklist.txt
echo "======================" >> $MONITOR_DIR/final_checklist.txt
echo "" >> $MONITOR_DIR/final_checklist.txt
echo "核心文档 (必须完成):" >> $MONITOR_DIR/final_checklist.txt
echo "1. [ ] Backtrader采用决策记录.md" >> $MONITOR_DIR/final_checklist.txt
echo "2. [ ] Backtrader集成架构设计.md" >> $MONITOR_DIR/final_checklist.txt
echo "3. [ ] 4周实施详细计划.md" >> $MONITOR_DIR/final_checklist.txt
echo "4. [ ] 资源需求清单.md" >> $MONITOR_DIR/final_checklist.txt
echo "5. [ ] 风险评估和应对.md" >> $MONITOR_DIR/final_checklist.txt
echo "" >> $MONITOR_DIR/final_checklist.txt
echo "支持文档 (建议完成):" >> $MONITOR_DIR/final_checklist.txt
echo "1. [ ] 技术可行性评估摘要.md" >> $MONITOR_DIR/final_checklist.txt
echo "2. [ ] 开发环境准备清单.md" >> $MONITOR_DIR/final_checklist.txt
echo "3. [ ] 团队培训计划.md" >> $MONITOR_DIR/final_checklist.txt
echo "4. [ ] 20分钟执行总结报告.md" >> $MONITOR_DIR/final_checklist.txt
echo "" >> $MONITOR_DIR/final_checklist.txt
echo "项目更新 (必须完成):" >> $MONITOR_DIR/final_checklist.txt
echo "1. [ ] 项目看板状态更新" >> $MONITOR_DIR/final_checklist.txt
echo "2. [ ] 团队通知和沟通" >> $MONITOR_DIR/final_checklist.txt
echo "3. [ ] 下一步行动准备" >> $MONITOR_DIR/final_checklist.txt

# 创建时间监控脚本
cat > $MONITOR_DIR/time_monitor.sh << 'EOF'
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
EOF

chmod +x $MONITOR_DIR/time_monitor.sh

# 创建进度报告模板
cat > $MONITOR_DIR/progress_report_template.md << 'EOF'
# 📊 20分钟技术紧急任务进度报告

## 报告时间
- **生成时间**: $(date)
- **阶段**: [填写当前阶段]
- **剩余时间**: [填写剩余分钟]分钟

## 任务完成情况

### 阶段1: 快速评估和决策
- [ ] 阅读需求文档
- [ ] 技术可行性评估
- [ ] 决策确认

### 阶段2: 技术方案设计
- [ ] 架构设计
- [ ] 技术栈确认
- [ ] 数据流设计

### 阶段3: 实施计划制定
- [ ] 时间规划
- [ ] 资源规划
- [ ] 风险评估

### 阶段4: 团队准备和沟通
- [ ] 开发环境准备
- [ ] 团队通知
- [ ] 文档整理和交付

## 产出物状态

### 已完成文档
1. 
2. 
3. 

### 进行中文档
1. 
2. 
3. 

### 待开始文档
1. 
2. 
3. 

## 遇到的问题
1. 
2. 
3. 

## 下一步行动
1. 
2. 
3. 

## 紧急程度评估
- [ ] 正常进行
- [ ] 稍有延迟
- [ ] 需要帮助
- [ ] 严重滞后
EOF

echo ""
echo "📁 监控文件已创建:"
echo "  • $MONITOR_DIR/reminder_phase1.txt"
echo "  • $MONITOR_DIR/reminder_phase2.txt"
echo "  • $MONITOR_DIR/reminder_phase3.txt"
echo "  • $MONITOR_DIR/reminder_phase4.txt"
echo "  • $MONITOR_DIR/final_checklist.txt"
echo "  • $MONITOR_DIR/time_monitor.sh"
echo "  • $MONITOR_DIR/progress_report_template.md"
echo ""
echo "🎯 执行建议:"
echo "  1. 每5分钟运行一次: ./$MONITOR_DIR/time_monitor.sh"
echo "  2. 每阶段完成后更新进度报告"
echo "  3. 遇到问题立即使用进度报告模板上报"
echo ""
echo "🚀 开始执行20分钟技术紧急任务!"
echo "祝技术团队高效完成任务! 💪"