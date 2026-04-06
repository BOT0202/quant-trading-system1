#!/bin/bash

# 协作会议脚本
# 启动产品、技术、运营三方会议

echo "🎯 启动三方协作会议"
echo "========================================"

MEETING_ID="meeting_$(date +%Y%m%d_%H%M%S)"
MEETING_DIR="collaboration/meetings/${MEETING_ID}"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# 创建会议目录
mkdir -p "$MEETING_DIR"

# 创建会议纪要模板
cat > "$MEETING_DIR/meeting_notes.md" << EOF
# 三方协作会议纪要

## 会议信息
- **会议ID**: ${MEETING_ID}
- **时间**: ${TIMESTAMP}
- **参与角色**: 产品经理、技术负责人、运营专家
- **会议类型**: 常规协作会议

## 📋 会议议程
1. 项目进度同步
2. 问题与障碍讨论
3. 下周计划制定
4. 协作优化建议

## 👥 参会人员
### 产品经理 (Alex)
**关注点**: 用户需求、产品路线图、功能优先级

### 技术负责人 (Brian)
**关注点**: 技术实现、系统稳定性、开发进度

### 运营专家 (Cathy)
**关注点**: 用户增长、活动效果、数据分析

## 📊 项目进度同步
### 产品经理汇报
**已完成**:
- [ ] 

**进行中**:
- [ ] 

**待开始**:
- [ ] 

**问题与风险**:
- 

### 技术负责人汇报
**已完成**:
- [ ] 

**进行中**:
- [ ] 

**待开始**:
- [ ] 

**技术难点**:
- 

### 运营专家汇报
**已完成**:
- [ ] 

**进行中**:
- [ ] 

**待开始**:
- [ ] 

**运营数据**:
- 

## 🚧 问题与障碍讨论
### 需要协作解决的问题
1. **问题描述**:
   - 
   - **影响**: 
   - **建议方案**: 
   - **负责人**: 
   - **截止时间**: 

2. **问题描述**:
   - 
   - **影响**: 
   - **建议方案**: 
   - **负责人**: 
   - **截止时间**: 

## 📅 下周计划
### 产品经理
1. 
2. 
3. 

### 技术负责人
1. 
2. 
3. 

### 运营专家
1. 
2. 
3. 

## 🔄 协作优化
### 沟通改进
- 

### 流程优化
- 

### 工具建议
- 

## ✅ 会议决议
1. 
2. 
3. 

## 📝 行动项
| 任务 | 负责人 | 截止时间 | 状态 |
|------|--------|----------|------|
|      |        |          |      |
|      |        |          |      |
|      |        |          |      |

## 🎯 下次会议
- **时间**: 
- **主题**: 
- **准备材料**: 

---
*会议纪要生成时间: ${TIMESTAMP}*
EOF

# 创建角色发言文件
for ROLE in product tech ops; do
    case $ROLE in
        "product")
            ROLE_NAME="产品经理"
            TEMPLATE="product"
            ;;
        "tech")
            ROLE_NAME="技术负责人"
            TEMPLATE="tech"
            ;;
        "ops")
            ROLE_NAME="运营专家"
            TEMPLATE="ops"
            ;;
    esac
    
    cat > "$MEETING_DIR/${ROLE}_preparation.md" << EOF
# ${ROLE_NAME} 会议准备材料

## 会议ID: ${MEETING_ID}
## 准备人: ${ROLE_NAME}
## 准备时间: ${TIMESTAMP}

## 一、近期工作回顾
### 主要成就
1. 
2. 
3. 

### 关键数据
- 
- 
- 

## 二、当前工作进展
### 进行中的项目
1. **项目名称**:
   - 进度: 
   - 状态: 
   - 下一步: 

2. **项目名称**:
   - 进度: 
   - 状态: 
   - 下一步: 

## 三、遇到的问题与挑战
### 需要其他角色协助的问题
1. 
   - **问题描述**:
   - **影响程度**:
   - **期望的支持**:

2. 
   - **问题描述**:
   - **影响程度**:
   - **期望的支持**:

### 内部问题
1. 
2. 

## 四、下周工作计划
### 优先级任务
1. 
2. 
3. 

### 协作需求
1. **需要从产品经理获得**:
   - 
   
2. **需要从技术负责人获得**:
   - 
   
3. **需要从运营专家获得**:
   - 

## 五、对协作流程的建议
### 沟通方面
- 

### 流程方面
- 

### 工具方面
- 

## 六、其他事项
- 

---
*${ROLE_NAME} 准备完成*
EOF
done

# 创建会议控制脚本
cat > "$MEETING_DIR/meeting_control.sh" << 'EOF'
#!/bin/bash

# 会议控制脚本

MEETING_ID=$(basename $(pwd))

echo "🎤 会议控制面板 - ${MEETING_ID}"
echo "========================================"

while true; do
    echo ""
    echo "请选择操作:"
    echo "1. 查看会议纪要"
    echo "2. 产品经理发言"
    echo "3. 技术负责人发言"
    echo "4. 运营专家发言"
    echo "5. 添加决议事项"
    echo "6. 更新行动项"
    echo "7. 结束会议"
    echo "0. 退出"
    echo ""
    read -p "选择: " choice
    
    case $choice in
        1)
            echo ""
            echo "📄 会议纪要:"
            echo "----------------------------------------"
            cat meeting_notes.md | head -50
            echo "..."
            ;;
        2)
            echo ""
            echo "🎯 产品经理发言"
            echo "----------------------------------------"
            echo "请输入发言内容 (Ctrl+D 结束):"
            echo ""
            PRODUCT_INPUT=$(cat)
            TIMESTAMP=$(date "+%H:%M:%S")
            echo ""
            echo "[${TIMESTAMP}] 产品经理: $PRODUCT_INPUT" >> meeting_discussion.log
            echo "✅ 发言已记录"
            ;;
        3)
            echo ""
            echo "⚙️  技术负责人发言"
            echo "----------------------------------------"
            echo "请输入发言内容 (Ctrl+D 结束):"
            echo ""
            TECH_INPUT=$(cat)
            TIMESTAMP=$(date "+%H:%M:%S")
            echo ""
            echo "[${TIMESTAMP}] 技术负责人: $TECH_INPUT" >> meeting_discussion.log
            echo "✅ 发言已记录"
            ;;
        4)
            echo ""
            echo "📈 运营专家发言"
            echo "----------------------------------------"
            echo "请输入发言内容 (Ctrl+D 结束):"
            echo ""
            OPS_INPUT=$(cat)
            TIMESTAMP=$(date "+%H:%M:%S")
            echo ""
            echo "[${TIMESTAMP}] 运营专家: $OPS_INPUT" >> meeting_discussion.log
            echo "✅ 发言已记录"
            ;;
        5)
            echo ""
            echo "✅ 添加决议事项"
            echo "----------------------------------------"
            read -p "决议内容: " resolution
            TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
            echo ""
            echo "- ${resolution} [${TIMESTAMP}]" >> meeting_resolutions.md
            echo "✅ 决议已添加"
            ;;
        6)
            echo ""
            echo "📝 更新行动项"
            echo "----------------------------------------"
            read -p "任务描述: " task
            read -p "负责人 (product/tech/ops): " owner
            read -p "截止时间: " deadline
            echo ""
            echo "| $task | $owner | $deadline | 待开始 |" >> meeting_actions.md
            echo "✅ 行动项已添加"
            ;;
        7)
            echo ""
            echo "🏁 结束会议"
            echo "----------------------------------------"
            read -p "会议总结: " summary
            TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
            echo ""
            echo "## 会议总结" >> meeting_notes.md
            echo "$summary" >> meeting_notes.md
            echo "" >> meeting_notes.md
            echo "## 会议结束时间" >> meeting_notes.md
            echo "- ${TIMESTAMP}" >> meeting_notes.md
            
            # 合并讨论记录
            if [ -f meeting_discussion.log ]; then
                echo "" >> meeting_notes.md
                echo "## 讨论记录" >> meeting_notes.md
                cat meeting_discussion.log >> meeting_notes.md
            fi
            
            # 合并决议事项
            if [ -f meeting_resolutions.md ]; then
                echo "" >> meeting_notes.md
                echo "## 会议决议" >> meeting_notes.md
                cat meeting_resolutions.md >> meeting_notes.md
            fi
            
            # 合并行动项
            if [ -f meeting_actions.md ]; then
                echo "" >> meeting_notes.md
                echo "## 行动项" >> meeting_notes.md
                echo "| 任务 | 负责人 | 截止时间 | 状态 |" >> meeting_notes.md
                echo "|------|--------|----------|------|" >> meeting_notes.md
                cat meeting_actions.md >> meeting_notes.md
            fi
            
            echo "✅ 会议已结束，纪要已更新"
            echo "📁 会议文件保存在: $(pwd)"
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
EOF

chmod +x "$MEETING_DIR/meeting_control.sh"

# 初始化其他会议文件
touch "$MEETING_DIR/meeting_discussion.log"
touch "$MEETING_DIR/meeting_resolutions.md"
touch "$MEETING_DIR/meeting_actions.md"

echo "✅ 会议已创建！"
echo ""
echo "📁 会议目录: $MEETING_DIR"
echo ""
echo "📋 会议文件:"
echo "  • meeting_notes.md          # 会议纪要模板"
echo "  • product_preparation.md    # 产品经理准备材料"
echo "  • tech_preparation.md       # 技术负责人准备材料"
echo "  • ops_preparation.md        # 运营专家准备材料"
echo "  • meeting_control.sh        # 会议控制脚本"
echo ""
echo "🚀 启动会议:"
echo "  cd $MEETING_DIR && ./meeting_control.sh"
echo ""
echo "💡 会议流程建议:"
echo "  1. 各角色查看准备材料模板"
echo "  2. 填写各自的准备材料"
echo "  3. 启动会议控制脚本开始讨论"
echo "  4. 按照议程进行三方讨论"
echo "  5. 记录决议和行动项"
echo "  6. 结束会议并生成完整纪要"
echo ""
echo "🎯 开始你的三方协作会议吧！"