#!/bin/bash

# 多方会议脚本
# 支持产品、技术、运营、测试四个角色参与

echo "🎪 启动多方协作会议"
echo "========================================"

MEETING_ID="multi_meeting_$(date +%Y%m%d_%H%M%S)"
MEETING_DIR="collaboration/meetings/${MEETING_ID}"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# 创建会议目录
mkdir -p "$MEETING_DIR"

# 创建多方会议纪要模板
cat > "$MEETING_DIR/meeting_notes.md" << EOF
# 多方协作会议纪要

## 会议信息
- **会议ID**: ${MEETING_ID}
- **时间**: ${TIMESTAMP}
- **会议类型**: 多方协作会议
- **主持人**: YangCheng

## 👥 参会角色
### 产品经理 (Alex)
**核心关注**: 用户需求、产品价值、功能优先级
**会议期待**: 明确产品方向，获得技术和运营支持

### 技术负责人 (Brian)
**核心关注**: 技术可行性、系统架构、开发资源
**会议期待**: 明确技术方案，协调开发计划

### 运营专家 (Cathy)
**核心关注**: 用户增长、市场反馈、运营效果
**会议期待**: 了解产品规划，制定运营策略

### 测试专家 (Taylor)
**核心关注**: 质量保障、测试覆盖、风险控制
**会议期待**: 参与方案评审，制定测试计划

## 📋 会议议程
1. **项目背景介绍** (5分钟)
   - 项目目标与价值
   - 当前进展与挑战

2. **各角色视角分享** (15分钟)
   - 产品视角：需求与规划
   - 技术视角：方案与资源
   - 运营视角：市场与用户
   - 测试视角：质量与风险

3. **关键问题讨论** (20分钟)
   - 优先级冲突协调
   - 资源分配方案
   - 风险应对策略
   - 时间节点确定

4. **协作计划制定** (10分钟)
   - 明确各方职责
   - 制定时间表
   - 确定沟通机制

## 🎯 会议目标
### 产品目标
- [ ] 明确产品需求优先级
- [ ] 获得技术和运营支持承诺
- [ ] 确定产品上线时间

### 技术目标
- [ ] 确认技术方案可行性
- [ ] 明确开发资源需求
- [ ] 制定开发时间表

### 运营目标
- [ ] 了解产品核心价值点
- [ ] 制定用户获取策略
- [ ] 准备运营推广材料

### 测试目标
- [ ] 识别关键质量风险点
- [ ] 制定测试策略
- [ ] 确定质量验收标准

## 📊 各角色准备材料
### 产品经理需准备
- 产品需求文档
- 用户价值分析
- 市场竞争分析

### 技术负责人需准备
- 技术方案设计
- 开发资源评估
- 风险评估报告

### 运营专家需准备
- 市场调研数据
- 用户反馈分析
- 运营推广计划

### 测试专家需准备
- 测试策略草案
- 质量风险评估
- 测试资源需求

## 🔄 协作机制
### 沟通频率
- **每日站会**: 15分钟，同步进展
- **每周例会**: 1小时，协调问题
- **每月评审**: 2小时，复盘优化

### 决策机制
1. **共识决策**: 重要事项需四方达成共识
2. **分级决策**: 按影响范围分级决策
3. **紧急决策**: 紧急情况主持人决策

### 信息同步
- **统一看板**: 共享项目进度看板
- **透明文档**: 所有文档共享可访问
- **定期报告**: 每周生成协作报告

## 📝 会议记录
### 重要讨论点
1. 
2. 
3. 

### 关键决策
1. 
2. 
3. 

### 待解决问题
1. 
2. 
3. 

## ✅ 行动项
| 任务 | 负责人 | 协作方 | 截止时间 | 状态 |
|------|--------|--------|----------|------|
|      |        |        |          |      |
|      |        |        |          |      |
|      |        |        |          |      |

## 🎯 下一步计划
### 短期计划 (本周)
1. 
2. 
3. 

### 中期计划 (本月)
1. 
2. 
3. 

### 长期计划 (本季度)
1. 
2. 
3. 

## 📅 下次会议安排
- **时间**: 
- **主题**: 
- **准备要求**: 

---
*会议纪要生成时间: ${TIMESTAMP}*
*参会角色: 产品经理、技术负责人、运营专家、测试专家*
</EOF>

# 为每个角色创建会议准备模板
for ROLE in product tech ops test; do
    case $ROLE in
        "product")
            ROLE_NAME="产品经理"
            ROLE_PERSON="Alex"
            FOCUS_AREAS="用户需求分析、产品功能设计、商业价值评估"
            ;;
        "tech")
            ROLE_NAME="技术负责人"
            ROLE_PERSON="Brian"
            FOCUS_AREAS="技术方案设计、开发资源规划、系统架构评估"
            ;;
        "ops")
            ROLE_NAME="运营专家"
            ROLE_PERSON="Cathy"
            FOCUS_AREAS="市场调研分析、用户增长策略、运营效果评估"
            ;;
        "test")
            ROLE_NAME="测试专家"
            ROLE_PERSON="Taylor"
            FOCUS_AREAS="质量保障策略、测试方案设计、风险评估控制"
            ;;
    esac
    
    cat > "$MEETING_DIR/${ROLE}_preparation.md" << EOF
# ${ROLE_NAME}会议准备材料

## 会议ID: ${MEETING_ID}
## 准备人: ${ROLE_PERSON} (${ROLE_NAME})
## 准备时间: ${TIMESTAMP}

## 一、角色职责与关注点
### 核心职责
${FOCUS_AREAS}

### 本次会议关注重点
1. 
2. 
3. 

## 二、当前工作状态
### 进行中的项目/任务
1. **项目名称**:
   - 当前进度: 
   - 关键成果: 
   - 面临挑战: 

2. **项目名称**:
   - 当前进度: 
   - 关键成果: 
   - 面临挑战: 

### 关键数据指标
| 指标名称 | 当前值 | 目标值 | 趋势 |
|----------|--------|--------|------|
|          |        |        |      |
|          |        |        |      |

## 三、对会议议题的看法
### 支持的观点
1. 
   - **理由**: 
   - **依据**: 

2. 
   - **理由**: 
   - **依据**: 

### 关注的问题
1. 
   - **问题描述**: 
   - **潜在影响**: 
   - **建议方案**: 

2. 
   - **问题描述**: 
   - **潜在影响**: 
   - **建议方案**: 

## 四、协作需求与期望
### 需要其他角色支持
1. **需要从产品经理获得**:
   - 

2. **需要从技术负责人获得**:
   - 

3. **需要从运营专家获得**:
   - 

4. **需要从测试专家获得**:
   - 

### 可以提供支持
1. **可以向产品经理提供**:
   - 

2. **可以向技术负责人提供**:
   - 

3. **可以向运营专家提供**:
   - 

4. **可以向测试专家提供**:
   - 

## 五、资源与约束
### 可用资源
- 人力资源: 
- 时间资源: 
- 技术资源: 
- 预算资源: 

### 约束条件
- 时间约束: 
- 技术约束: 
- 资源约束: 
- 其他约束: 

## 六、建议与提案
### 对本次会议的建议
1. 
2. 
3. 

### 对协作流程的改进建议
1. 
2. 
3. 

## 七、其他事项
- 

---
*${ROLE_NAME} ${ROLE_PERSON} 准备完成*
*请于会议前提交此准备材料*
EOF
done

# 创建多方会议控制脚本
cat > "$MEETING_DIR/multi_meeting_control.sh" << 'EOF'
#!/bin/bash

# 多方会议控制脚本

MEETING_ID=$(basename $(pwd))
TIMESTAMP=$(date "+%H:%M:%S")

echo "🎪 多方会议控制面板 - ${MEETING_ID}"
echo "========================================"
echo "参会角色: 产品经理(Alex) 技术负责人(Brian) 运营专家(Cathy) 测试专家(Taylor)"
echo ""

# 初始化会议文件
touch meeting_discussion.log
touch meeting_decisions.md
touch meeting_actions.md
touch meeting_questions.md

while true; do
    echo ""
    echo "请选择操作:"
    echo "1. 查看会议纪要"
    echo "2. 角色发言"
    echo "3. 添加决议事项"
    echo "4. 记录问题"
    echo "5. 更新行动项"
    echo "6. 查看角色准备材料"
    echo "7. 生成会议总结"
    echo "8. 结束会议"
    echo "0. 退出"
    echo ""
    read -p "选择: " choice
    
    case $choice in
        1)
            echo ""
            echo "📄 会议纪要:"
            echo "----------------------------------------"
            cat meeting_notes.md | head -80
            echo "..."
            ;;
        2)
            echo ""
            echo "💬 角色发言"
            echo "----------------------------------------"
            echo "选择发言角色:"
            echo "1. 产品经理 (Alex)"
            echo "2. 技术负责人 (Brian)"
            echo "3. 运营专家 (Cathy)"
            echo "4. 测试专家 (Taylor)"
            echo "5. 主持人 (YangCheng)"
            echo ""
            read -p "选择角色: " role_choice
            
            case $role_choice in
                1) ROLE="产品经理"; ROLE_SHORT="product";;
                2) ROLE="技术负责人"; ROLE_SHORT="tech";;
                3) ROLE="运营专家"; ROLE_SHORT="ops";;
                4) ROLE="测试专家"; ROLE_SHORT="test";;
                5) ROLE="主持人"; ROLE_SHORT="host";;
                *) echo "❌ 无效选择"; continue;;
            esac
            
            echo ""
            echo "🎤 ${ROLE}发言"
            echo "请输入发言内容 (Ctrl+D 结束):"
            echo ""
            INPUT=$(cat)
            
            if [ -n "$INPUT" ]; then
                TIMESTAMP=$(date "+%H:%M:%S")
                echo "[${TIMESTAMP}] ${ROLE}: $INPUT" >> meeting_discussion.log
                echo "✅ ${ROLE}发言已记录"
                
                # 如果是重要发言，提示是否添加到纪要
                echo ""
                read -p "是否将此发言添加到会议纪要？(y/n): " add_to_notes
                if [[ "$add_to_notes" == "y" || "$add_to_notes" == "Y" ]]; then
                    echo "- ${ROLE}: $INPUT" >> meeting_notes.md
                    echo "✅ 已添加到会议纪要"
                fi
            else
                echo "❌ 发言内容不能为空"
            fi
            ;;
        3)
            echo ""
            echo "✅ 添加决议事项"
            echo "----------------------------------------"
            read -p "决议内容: " resolution
            read -p "提出角色: " proposer
            read -p "支持角色 (用逗号分隔): " supporters
            
            TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
            echo ""
            echo "## 决议: $resolution" >> meeting_decisions.md
            echo "- 提出者: $proposer" >> meeting_decisions.md
            echo "- 支持者: $supporters" >> meeting_decisions.md
            echo "- 时间: $TIMESTAMP" >> meeting_decisions.md
            echo "" >> meeting_decisions.md
            
            echo "✅ 决议已记录"
            
            # 添加到会议纪要
            echo "" >> meeting_notes.md
            echo "### 决议事项" >> meeting_notes.md
            echo "1. **$resolution**" >> meeting_notes.md
            echo "   - 提出: $proposer" >> meeting_notes.md
            echo "   - 支持: $supporters" >> meeting_notes.md
            echo "   - 时间: $TIMESTAMP" >> meeting_notes.md
            ;;
        4)
            echo ""
            echo "❓ 记录问题"
            echo "----------------------------------------"
            read -p "问题描述: " question
            read -p "提出角色: " questioner
            read -p "紧急程度 (高/中/低): " urgency
            read -p "负责人: " owner
            
            TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
            echo ""
            echo "## 问题: $question" >> meeting_questions.md
            echo "- 提出者: $questioner" >> meeting_questions.md
            echo "- 紧急程度: $urgency" >> meeting_questions.md
            echo "- 负责人: $owner" >> meeting_questions.md
            echo "- 提出时间: $TIMESTAMP" >> meeting_questions.md
            echo "" >> meeting_questions.md
            
            echo "✅ 问题已记录"
            ;;
        5)
            echo ""
            echo "📝 更新行动项"
            echo "----------------------------------------"
            read -p "任务描述: " task
            echo "选择负责人:"
            echo "1. 产品经理"
            echo "2. 技术负责人"
            echo "3. 运营专家"
            echo "4. 测试专家"
            echo "5. 多方协作"
            echo ""
            read -p "选择: " owner_choice
            
            case $owner_choice in
                1) OWNER="产品经理";;
                2) OWNER="技术负责人";;
                3) OWNER="运营专家";;
                4) OWNER="测试专家";;
                5) OWNER="多方协作";;
                *) OWNER="待定";;
            esac
            
            read -p "截止时间: " deadline
            read -p "优先级 (高/中/低): " priority
            
            echo ""
            echo "| $task | $OWNER | $deadline | $priority | 待开始 |" >> meeting_actions.md
            echo "✅ 行动项已添加"
            
            # 更新会议纪要中的行动项表格
            if ! grep -q "行动项" meeting_notes.md; then
                echo "" >> meeting_notes.md
                echo "## ✅ 行动项" >> meeting_notes.md
                echo "| 任务 | 负责人 | 截止时间 | 优先级 | 状态 |" >> meeting_notes.md
                echo "|------|--------|----------|--------|------|" >> meeting_notes.md
            fi
            echo "| $task | $OWNER | $deadline | $priority | 待开始 |" >> meeting_notes.md
            ;;
        6)
            echo ""
            echo "📋 角色准备材料"
            echo "----------------------------------------"
            echo "选择查看哪个角色的准备材料:"
            echo "1. 产品经理"
            echo "2. 技术负责人"
            echo "3. 运营专家"
            echo "4. 测试专家"
            echo ""
            read -p "选择: " prep_choice
            
            case $prep_choice in
                1) PREP_FILE="product_preparation.md";;
                2) PREP_FILE="tech_preparation.md";;
                3) PREP_FILE="ops_preparation.md";;
                4) PREP_FILE="test_preparation.md";;
                *) echo "❌ 无效选择"; continue;;
            esac
            
            if [ -f "$PREP_FILE" ]; then
                echo ""
                echo "📄 $PREP_FILE:"
                echo "----------------------------------------"
                cat "$PREP_FILE" | head -40
                echo "..."
            else
                echo "❌ 文件不存在: $PREP_FILE"
            fi
            ;;
        7)
            echo ""
            echo "📊 生成会议总结"
            echo "----------------------------------------"
            read -p "会议总结: " summary
            TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
            
            echo "" >> meeting_notes.md
            echo "## 会议总结" >> meeting_notes.md
            echo "$summary" >> meeting_notes.md
            echo "" >> meeting_notes.md
            
            # 合并讨论记录
            if [ -f meeting_discussion.log ]; then
                echo "" >> meeting_notes.md
                echo "## 讨论记录" >> meeting_notes.md
                cat meeting_discussion.log >> meeting_notes.md
            fi
            
            # 合并决议事项
            if [ -f meeting_decisions.md ]; then
                echo "" >> meeting_notes.md
                echo "## 决议事项" >> meeting_notes.md
                cat meeting_decisions.md >> meeting_notes.md
            fi
            
            # 合并问题记录
            if [ -f meeting_questions.md ]; then
                echo "" >> meeting_notes.md
                echo "## 待解决问题" >> meeting_notes.md
                cat meeting_questions.md >> meeting_notes.md
            fi
            
            # 合并行动项
            if [ -f meeting_actions.md ]; then
                echo "" >> meeting_notes.md
                echo "## 行动项" >> meeting_notes.md
                echo "| 任务 | 负责人 | 截止时间 | 优先级 | 状态 |" >> meeting                echo "|------|--------|----------|--------|------|" >> meeting_notes.md
                cat meeting_actions.md >> meeting_notes.md
            fi

            echo "## 会议结束时间" >> meeting_notes.md
            echo "- ${TIMESTAMP}" >> meeting_notes.md

            echo "✅ 会议总结已生成"
            ;; 
        8)
            echo ""
            echo "🏁 结束会议"
            echo "----------------------------------------"
            echo "📁 会议文件保存在: $(pwd)"
            echo "📄 主要文件:"
            echo "  • meeting_notes.md - 完整会议纪要"
            echo "  • meeting_discussion.log - 讨论记录"
            echo "  • meeting_decisions.md - 决议事项"
            echo "  • meeting_actions.md - 行动项"
            echo "  • meeting_questions.md - 待解决问题"
            echo ""
            # 通知各角色会议结束
            for ROLE in product tech ops test; do
                echo "会议结束，纪要已生成在 ${MEETING_ID}" > collaboration/${ROLE}/inbox/MEETING_END_NOTICE.txt
            done
            echo "✅ 已通知所有角色会议结束"
            break
            ;;
        0)
            echo "退出会议控制"
            break
            ;;
        *)
            echo "❌ 无效选择"
            ;;
    esac
done

chmod +x multi_meeting_control.sh

echo "✅ 多方会议已创建！"
echo ""
echo "📁 会议目录: $MEETING_DIR"
echo ""
echo "🎪 参会角色:"
echo "  1. 产品经理 (Alex) - 产品规划与需求"
echo "  2. 技术负责人 (Brian) - 技术实现与架构"
echo "  3. 运营专家 (Cathy) - 用户增长与运营"
echo "  4. 测试专家 (Taylor) - 质量保障与测试"
echo ""
echo "🚀 启动会议:"
echo "  cd $MEETING_DIR && ./multi_meeting_control.sh"
echo ""
echo "💡 会议流程建议:"
echo "  1. 各角色查看并填写准备材料"
echo "  2. 主持人介绍会议目标和议程"
echo "  3. 各角色轮流分享视角"
echo "  4. 讨论关键问题和解决方案"
echo "  5. 制定协作计划和行动项"
echo "  6. 生成会议纪要和总结"
echo ""
echo "🎯 开始你的多方协作会议吧！"
