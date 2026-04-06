#!/bin/bash

# 消息处理脚本
# 处理待处理的消息并分发给对应角色

echo "🔍 开始处理消息..."
echo "========================================"

PENDING_DIR="collaboration/message_queue/pending"
PROCESSED_DIR="collaboration/message_queue/processed"
ARCHIVE_DIR="collaboration/message_queue/archive"
LOG_FILE="collaboration/logs/collaboration_log.md"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# 创建必要的目录
mkdir -p "$PROCESSED_DIR" "$ARCHIVE_DIR"

# 获取所有待处理消息
MESSAGES=($(ls -1 "$PENDING_DIR"/*.json 2>/dev/null))

if [ ${#MESSAGES[@]} -eq 0 ]; then
    echo "📭 没有待处理的消息"
    exit 0
fi

echo "📨 发现 ${#MESSAGES[@]} 条待处理消息"

# 处理每条消息
for MESSAGE_FILE in "${MESSAGES[@]}"; do
    if [ ! -f "$MESSAGE_FILE" ]; then
        continue
    fi
    
    # 提取消息信息
    MESSAGE_ID=$(basename "$MESSAGE_FILE" .json | awk -F'_' '{print $NF}')
    FROM=$(basename "$MESSAGE_FILE" .json | awk -F'_' '{print $1}')
    TO=$(basename "$MESSAGE_FILE" .json | awk -F'_' '{print $3}')
    CONTENT=$(grep -o '"content": "[^"]*"' "$MESSAGE_FILE" | cut -d'"' -f4)
    
    echo ""
    echo "📬 处理消息 #${MESSAGE_ID}"
    echo "   发送者: ${FROM}"
    echo "   接收者: ${TO}"
    echo "   内容: ${CONTENT:0:50}..."
    
    # 根据接收者角色处理消息
    case $TO in
        "product")
            DEST_DIR="collaboration/product/inbox"
            ROLE_NAME="产品经理"
            ;;
        "tech")
            DEST_DIR="collaboration/tech/inbox"
            ROLE_NAME="技术负责人"
            ;;
        "ops")
            DEST_DIR="collaboration/ops/inbox"
            ROLE_NAME="运营专家"
            ;;
        *)
            DEST_DIR="collaboration/shared/messages"
            ROLE_NAME="共享"
            ;;
    esac
    
    # 创建收件箱目录
    mkdir -p "$DEST_DIR"
    
    # 复制消息到收件箱
    cp "$MESSAGE_FILE" "$DEST_DIR/"
    
    # 创建通知文件
    NOTICE_FILE="${DEST_DIR}/NEW_MESSAGE_${MESSAGE_ID}.txt"
    cat > "$NOTICE_FILE" << EOF
新消息通知
==========
时间: ${TIMESTAMP}
来自: ${FROM}
消息ID: ${MESSAGE_ID}
内容: ${CONTENT}

请查看详细消息文件: $(basename "$MESSAGE_FILE")
EOF
    
    # 移动消息到已处理目录
    mv "$MESSAGE_FILE" "$PROCESSED_DIR/"
    
    # 记录处理日志
    echo "$TIMESTAMP - 处理消息 #${MESSAGE_ID} (${FROM} → ${TO})" >> "$LOG_FILE"
    
    echo "   ✅ 已发送给 ${ROLE_NAME}"
done

# 归档旧消息（超过7天）
echo ""
echo "🗃️  归档旧消息..."
find "$PROCESSED_DIR" -name "*.json" -mtime +7 -exec mv {} "$ARCHIVE_DIR/" \; 2>/dev/null
ARCHIVED_COUNT=$?
if [ $ARCHIVED_COUNT -gt 0 ]; then
    echo "   已归档 $ARCHIVED_COUNT 条旧消息"
fi

# 更新状态报告
echo ""
echo "📊 消息处理完成"
echo "========================================"
echo "待处理消息: $(ls -1 "$PENDING_DIR"/*.json 2>/dev/null | wc -l) 条"
echo "已处理消息: $(ls -1 "$PROCESSED_DIR"/*.json 2>/dev/null | wc -l) 条"
echo "归档消息: $(ls -1 "$ARCHIVE_DIR"/*.json 2>/dev/null | wc -l) 条"
echo ""
echo "📁 收件箱状态:"
echo "   产品经理: $(ls -1 collaboration/product/inbox/*.json 2>/dev/null | wc -l) 条"
echo "   技术负责人: $(ls -1 collaboration/tech/inbox/*.json 2>/dev/null | wc -l) 条"
echo "   运营专家: $(ls -1 collaboration/ops/inbox/*.json 2>/dev/null | wc -l) 条"
echo ""
echo "✅ 消息处理完成！"