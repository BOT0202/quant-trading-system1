#!/bin/bash

# 消息发送脚本
# 用法：./send_message.sh <from_role> <to_role> <message>

if [ $# -lt 3 ]; then
    echo "❌ 用法: $0 <from_role> <to_role> <message>"
    echo "   角色: product, tech, ops"
    echo "   示例: ./send_message.sh product tech '我们需要讨论新功能的实现方案'"
    exit 1
fi

FROM=$1
TO=$2
MESSAGE=$3
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
MESSAGE_ID=$(date +%s%N | md5sum | head -c 8)

# 验证角色
VALID_ROLES="product tech ops test"
if [[ ! " $VALID_ROLES " =~ " $FROM " ]]; then
    echo "❌ 无效的发送者角色: $FROM"
    echo "   有效角色: product, tech, ops"
    exit 1
fi

if [[ ! " $VALID_ROLES " =~ " $TO " ]]; then
    echo "❌ 无效的接收者角色: $TO"
    echo "   有效角色: product, tech, ops"
    exit 1
fi

# 创建消息文件
MESSAGE_FILE="collaboration/message_queue/pending/${FROM}_to_${TO}_${MESSAGE_ID}.json"

cat > "$MESSAGE_FILE" << EOF
{
  "id": "${MESSAGE_ID}",
  "from": "${FROM}",
  "to": "${TO}",
  "timestamp": "${TIMESTAMP}",
  "type": "message",
  "content": "${MESSAGE}",
  "status": "pending"
}
EOF

echo "✅ 消息已发送！"
echo "📨 消息ID: ${MESSAGE_ID}"
echo "📤 发送者: ${FROM}"
echo "📥 接收者: ${TO}"
echo "📝 内容: ${MESSAGE}"
echo "📁 文件: ${MESSAGE_FILE}"

# 记录到日志
echo "$TIMESTAMP - [$FROM → $TO] $MESSAGE" >> collaboration/logs/message_log.md

# 显示当前待处理消息
PENDING_COUNT=$(ls -1 collaboration/message_queue/pending/*.json 2>/dev/null | wc -l)
echo ""
echo "📊 当前待处理消息: ${PENDING_COUNT} 条"