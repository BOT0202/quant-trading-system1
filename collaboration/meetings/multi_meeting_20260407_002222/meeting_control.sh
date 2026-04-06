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
