#!/bin/bash

# 会议通知脚本
# 通知所有角色参加多方会议

if [ $# -lt 1 ]; then
    echo "❌ 用法: $0 <meeting_id> [会议主题]"
    echo "   示例: $0 multi_meeting_20250407_123456 '新产品规划会议'"
    exit 1
fi

MEETING_ID=$1
MEETING_TOPIC=${2:-"多方协作会议"}
MEETING_DIR="collaboration/meetings/${MEETING_ID}"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

if [ ! -d "$MEETING_DIR" ]; then
    echo "❌ 会议目录不存在: $MEETING_DIR"
    echo "   请先使用 ./start_multi_meeting.sh 创建会议"
    exit 1
fi

echo "📣 发送会议通知..."
echo "========================================"

# 通知产品经理
cat > collaboration/product/inbox/MEETING_INVITE_${MEETING_ID}.txt << EOF
会议邀请通知
============
主题: ${MEETING_TOPIC}
会议ID: ${MEETING_ID}
时间: ${TIMESTAMP}
地点: ${MEETING_DIR}

参会角色: 产品经理、技术负责人、运营专家、测试专家
主持人: YangCheng

📋 会议准备:
1. 查看会议材料: ${MEETING_DIR}/product_preparation.md
2. 填写准备材料
3. 准备讨论要点

🎯 产品经理需准备:
- 产品需求文档
- 用户价值分析
- 功能优先级

请准时参加！
EOF

# 通知技术负责人
cat > collaboration/tech/inbox/MEETING_INVITE_${MEETING_ID}.txt << EOF
会议邀请通知
============
主题: ${MEETING_TOPIC}
会议ID: ${MEETING_ID}
时间: ${TIMESTAMP}
地点: ${MEETING_DIR}

参会角色: 产品经理、技术负责人、运营专家、测试专家
主持人: YangCheng

📋 会议准备:
1. 查看会议材料: ${MEETING_DIR}/tech_preparation.md
2. 填写准备材料
3. 准备讨论要点

🎯 技术负责人需准备:
- 技术方案设计
- 开发资源评估
- 风险评估报告

请准时参加！
EOF

# 通知运营专家
cat > collaboration/ops/inbox/MEETING_INVITE_${MEETING_ID}.txt << EOF
会议邀请通知
============
主题: ${MEETING_TOPIC}
会议ID: ${MEETING_ID}
时间: ${TIMESTAMP}
地点: ${MEETING_DIR}

参会角色: 产品经理、技术负责人、运营专家、测试专家
主持人: YangCheng

📋 会议准备:
1. 查看会议材料: ${MEETING_DIR}/ops_preparation.md
2. 填写准备材料
3. 准备讨论要点

🎯 运营专家需准备:
- 市场调研数据
- 用户反馈分析
- 运营推广计划

请准时参加！
EOF

# 通知测试专家
cat > collaboration/test_role/inbox/MEETING_INVITE_${MEETING_ID}.txt << EOF
会议邀请通知
============
主题: ${MEETING_TOPIC}
会议ID: ${MEETING_ID}
时间: ${TIMESTAMP}
地点: ${MEETING_DIR}

参会角色: 产品经理、技术负责人、运营专家、测试专家
主持人: YangCheng

📋 会议准备:
1. 查看会议材料: ${MEETING_DIR}/test_preparation.md
2. 填写准备材料
3. 准备讨论要点

🎯 测试专家需准备:
- 测试策略草案
- 质量风险评估
- 测试资源需求

请准时参加！
EOF

# 发送消息通知
./send_message.sh coordinator product "会议通知：请参加${MEETING_TOPIC}，会议材料已准备" > /dev/null 2>&1
./send_message.sh coordinator tech "会议通知：请参加${MEETING_TOPIC}，请准备技术方案" > /dev/null 2>&1
./send_message.sh coordinator ops "会议通知：请参加${MEETING_TOPIC}，请准备运营数据" > /dev/null 2>&1
./send_message.sh coordinator test "会议通知：请参加${MEETING_TOPIC}，请准备测试策略" > /dev/null 2>&1

# 处理消息
./process_messages.sh > /dev/null 2>&1

echo "✅ 会议通知已发送给所有角色！"
echo ""
echo "📧 通知状态:"
echo "   产品经理: collaboration/product/inbox/MEETING_INVITE_${MEETING_ID}.txt"
echo "   技术负责人: collaboration/tech/inbox/MEETING_INVITE_${MEETING_ID}.txt"
echo "   运营专家: collaboration/ops/inbox/MEETING_INVITE_${MEETING_ID}.txt"
echo "   测试专家: collaboration/test_role/inbox/MEETING_INVITE_${MEETING_ID}.txt"
echo ""
echo "💬 消息通知: 已通过消息系统发送提醒"
echo ""
echo "📋 各角色可以开始准备会议材料:"
echo "   cd ${MEETING_DIR}"
echo "   vim product_preparation.md    # 产品经理准备"
echo "   vim tech_preparation.md       # 技术负责人准备"
echo "   vim ops_preparation.md        # 运营专家准备"
echo "   vim test_preparation.md       # 测试专家准备"
echo ""
echo "🚀 会议即将开始！"