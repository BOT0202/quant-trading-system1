#!/bin/bash

# 多方会议脚本 - 简化版本
# 支持产品、技术、运营、测试四个角色参与

echo "🎪 启动多方协作会议"
echo "========================================"

MEETING_ID="multi_meeting_$(date +%Y%m%d_%H%M%S)"
MEETING_DIR="collaboration/meetings/${MEETING_ID}"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# 创建会议目录
mkdir -p "$MEETING_DIR"

# 创建简单的会议纪要模板
cat > "$MEETING_DIR/meeting_notes.md" << EOF
# 多方协作会议纪要

## 会议信息
- **会议ID**: ${MEETING_ID}
- **时间**: ${TIMESTAMP}
- **参会角色**: 产品经理、技术负责人、运营专家、测试专家
- **主持人**: YangCheng

## 👥 参会人员
### 产品经理 (Alex)
关注：用户需求、产品价值、功能优先级

### 技术负责人 (Brian)
关注：技术可行性、系统架构、开发资源

### 运营专家 (Cathy)
关注：用户增长、市场反馈、运营效果

### 测试专家 (Taylor)
关注：质量保障、测试覆盖、风险控制

## 📋 会议议程
1. 项目背景介绍
2. 各角色视角分享
3. 关键问题讨论
4. 协作计划制定

## 📝 讨论记录
*会议讨论将记录在此处*

## ✅ 决议事项
1. 
2. 
3. 

## 📋 行动项
| 任务 | 负责人 | 截止时间 | 状态 |
|------|--------|----------|------|
|      |        |          |      |

## 🎯 下一步计划
- 
- 
- 

---
*会议纪要生成时间: ${TIMESTAMP}*
EOF

# 创建简单的会议控制脚本
cat > "$MEETING_DIR/meeting_control.sh" << 'EOF'
#!/bin/bash

echo "🎪 多方会议控制面板"
echo "========================================"
echo "参会角色: 产品经理、技术负责人、运营专家、测试专家"
echo ""

while true; do
    echo ""
    echo "请选择操作:"
    echo "1. 查看会议纪要"
    echo "2. 产品经理发言"
    echo "3. 技术负责人发言"
    echo "4. 运营专家发言"
    echo "5. 测试专家发言"
    echo "6. 添加行动项"
    echo "7. 结束会议"
    echo "0. 退出"
    echo ""
    read -p "选择: " choice
    
    case $choice in
        1)
            echo ""
            echo "📄 会议纪要:"
            echo "----------------------------------------"
            cat meeting_notes.md
            ;;
        2)
            echo ""
            echo "🎤 产品经理发言"
            read -p "发言内容: " content
            echo "[$(date "+%H:%M:%S")] 产品经理: $content" >> discussion.log
            echo "- 产品经理: $content" >> meeting_notes.md
            echo "✅ 发言已记录"
            ;;
        3)
            echo ""
            echo "⚙️  技术负责人发言"
            read -p "发言内容: " content
            echo "[$(date "+%H:%M:%S")] 技术负责人: $content" >> discussion.log
            echo "- 技术负责人: $content" >> meeting_notes.md
            echo "✅ 发言已记录"
            ;;
        4)
            echo ""
            echo "📈 运营专家发言"
            read -p "发言内容: " content
            echo "[$(date "+%H:%M:%S")] 运营专家: $content" >> discussion.log
            echo "- 运营专家: $content" >> meeting_notes.md
            echo "✅ 发言已记录"
            ;;
        5)
            echo ""
            echo "🧪 测试专家发言"
            read -p "发言内容: " content
            echo "[$(date "+%H:%M:%S")] 测试专家: $content" >> discussion.log
            echo "- 测试专家: $content" >> meeting_notes.md
            echo "✅ 发言已记录"
            ;;
        6)
            echo ""
            echo "📝 添加行动项"
            read -p "任务描述: " task
            echo "选择负责人:"
            echo "1. 产品经理"
            echo "2. 技术负责人"
            echo "3. 运营专家"
            echo "4. 测试专家"
            read -p "选择: " owner_choice
            
            case $owner_choice in
                1) owner="产品经理";;
                2) owner="技术负责人";;
                3) owner="运营专家";;
                4) owner="测试专家";;
                *) owner="待定";;
            esac
            
            read -p "截止时间: " deadline
            echo "| $task | $owner | $deadline | 待开始 |" >> actions.md
            echo "✅ 行动项已添加"
            ;;
        7)
            echo ""
            echo "🏁 结束会议"
            echo "----------------------------------------"
            
            # 合并行动项到纪要
            if [ -f actions.md ]; then
                echo "" >> meeting_notes.md
                echo "## 行动项" >> meeting_notes.md
                echo "| 任务 | 负责人 | 截止时间 | 状态 |" >> meeting_notes.md
                echo "|------|--------|----------|------|" >> meeting_notes.md
                cat actions.md >> meeting_notes.md
            fi
            
            echo "✅ 会议已结束"
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

echo "✅ 多方会议已创建！"
echo ""
echo "📁 会议目录: $MEETING_DIR"
echo ""
echo "🎪 参会角色:"
echo "  1. 产品经理 (Alex)"
echo "  2. 技术负责人 (Brian)"
echo "  3. 运营专家 (Cathy)"
echo "  4. 测试专家 (Taylor)"
echo ""
echo "🚀 启动会议:"
echo "  cd $MEETING_DIR && ./meeting_control.sh"
echo ""
echo "📣 通知角色参会:"
echo "  ./notify_meeting.sh ${MEETING_ID} '多方协作会议'"
echo ""
echo "🎯 开始你的多方协作会议吧！"