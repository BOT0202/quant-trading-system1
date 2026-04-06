#!/bin/bash

# 简化版会议交互脚本

MEETING_DIR="collaboration/meetings/multi_meeting_20260407_002222"
cd "$MEETING_DIR"

echo "🎪 多方协作会议 - 简化控制面板"
echo "========================================"
echo "会议ID: multi_meeting_20260407_002222"
echo "时间: 2026-04-07 00:22:22"
echo "主持人: YangCheng"
echo ""
echo "👥 参会角色:"
echo "  1. 产品经理 (Alex) - 产品规划"
echo "  2. 技术负责人 (Brian) - 技术实现"
echo "  3. 运营专家 (Cathy) - 用户增长"
echo "  4. 测试专家 (Taylor) - 质量保障"
echo ""
echo "📋 当前议程:"
echo "  1. 项目背景介绍"
echo "  2. 各角色视角分享"
echo "  3. 关键问题讨论"
echo "  4. 协作计划制定"
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
    read -p "请输入数字选择: " choice
    
    case $choice in
        1)
            echo ""
            echo "📄 当前会议纪要:"
            echo "----------------------------------------"
            cat meeting_notes.md
            ;;
        2)
            echo ""
            echo "🎤 产品经理发言"
            read -p "请输入发言内容: " content
            if [ -n "$content" ]; then
                timestamp=$(date "+%H:%M:%S")
                echo "- 产品经理 ($timestamp): $content" >> meeting_notes.md
                echo "✅ 产品经理发言已记录"
            fi
            ;;
        3)
            echo ""
            echo "⚙️  技术负责人发言"
            read -p "请输入发言内容: " content
            if [ -n "$content" ]; then
                timestamp=$(date "+%H:%M:%S")
                echo "- 技术负责人 ($timestamp): $content" >> meeting_notes.md
                echo "✅ 技术负责人发言已记录"
            fi
            ;;
        4)
            echo ""
            echo "📈 运营专家发言"
            read -p "请输入发言内容: " content
            if [ -n "$content" ]; then
                timestamp=$(date "+%H:%M:%S")
                echo "- 运营专家 ($timestamp): $content" >> meeting_notes.md
                echo "✅ 运营专家发言已记录"
            fi
            ;;
        5)
            echo ""
            echo "🧪 测试专家发言"
            read -p "请输入发言内容: " content
            if [ -n "$content" ]; then
                timestamp=$(date "+%H:%M:%S")
                echo "- 测试专家 ($timestamp): $content" >> meeting_notes.md
                echo "✅ 测试专家发言已记录"
            fi
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
            echo "| $task | $owner | $deadline | 待开始 |" >> actions.tmp
            echo "✅ 行动项已添加"
            ;;
        7)
            echo ""
            echo "🏁 结束会议"
            echo "----------------------------------------"
            
            # 合并行动项到纪要
            if [ -f actions.tmp ]; then
                echo "" >> meeting_notes.md
                echo "## 行动项" >> meeting_notes.md
                echo "| 任务 | 负责人 | 截止时间 | 状态 |" >> meeting_notes.md
                echo "|------|--------|----------|------|" >> meeting_notes.md
                cat actions.tmp >> meeting_notes.md
                rm actions.tmp
            fi
            
            # 添加会议结束时间
            end_time=$(date "+%Y-%m-%d %H:%M:%S")
            echo "" >> meeting_notes.md
            echo "---" >> meeting_notes.md
            echo "*会议结束时间: $end_time*" >> meeting_notes.md
            
            echo "✅ 会议已结束"
            echo "📄 完整纪要保存在: meeting_notes.md"
            break
            ;;
        0)
            echo "退出会议"
            break
            ;;
        *)
            echo "❌ 无效选择，请重新输入"
            ;;
    esac
done

echo ""
echo "🎉 会议完成！"
echo "📁 会议文件: $(pwd)/meeting_notes.md"