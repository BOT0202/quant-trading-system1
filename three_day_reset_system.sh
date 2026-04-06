#!/bin/bash

# 3天不说话重置系统
# 监控各角色活动，3天无活动则自动重置状态

echo "🔄 3天不说话重置系统"
echo "========================================"

# 配置文件
CONFIG_DIR="/root/.openclaw/workspace/collaboration"
LOG_DIR="$CONFIG_DIR/logs"
RESET_LOG="$LOG_DIR/reset_system.log"
ACTIVITY_LOG="$LOG_DIR/role_activity.log"
RESET_THRESHOLD_DAYS=3

# 创建必要的目录和文件
mkdir -p "$LOG_DIR"
touch "$ACTIVITY_LOG"
touch "$RESET_LOG"

# 记录活动函数
record_activity() {
    local ROLE=$1
    local ACTION=$2
    local TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    
    echo "$TIMESTAMP | $ROLE | $ACTION" >> "$ACTIVITY_LOG"
    echo "✅ 记录活动: $ROLE - $ACTION"
}

# 检查重置函数
check_and_reset() {
    local ROLE=$1
    local CURRENT_TIME=$(date +%s)
    local RESET_THRESHOLD_SECONDS=$((RESET_THRESHOLD_DAYS * 24 * 60 * 60))
    
    # 查找该角色最后活动时间
    local LAST_ACTIVITY=$(grep "| $ROLE |" "$ACTIVITY_LOG" | tail -1)
    
    if [ -z "$LAST_ACTIVITY" ]; then
        echo "⚠️  $ROLE 无活动记录，可能是新角色"
        return 1
    fi
    
    # 提取时间戳
    local LAST_TIMESTAMP=$(echo "$LAST_ACTIVITY" | cut -d'|' -f1 | xargs)
    local LAST_TIME=$(date -d "$LAST_TIMESTAMP" +%s 2>/dev/null || echo "0")
    
    if [ "$LAST_TIME" = "0" ]; then
        echo "❌ 无法解析时间戳: $LAST_TIMESTAMP"
        return 1
    fi
    
    # 计算时间差
    local TIME_DIFF=$((CURRENT_TIME - LAST_TIME))
    
    if [ $TIME_DIFF -ge $RESET_THRESHOLD_SECONDS ]; then
        echo "🚨 $ROLE 已 $RESET_THRESHOLD_DAYS 天无活动，需要重置！"
        reset_role "$ROLE"
        return 0
    else
        local DAYS_LEFT=$(echo "scale=1; ($RESET_THRESHOLD_SECONDS - $TIME_DIFF) / 86400" | bc)
        echo "✅ $ROLE 活动正常，距离重置还有 $DAYS_LEFT 天"
        return 1
    fi
}

# 重置角色函数
reset_role() {
    local ROLE=$1
    local TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    local RESET_REASON="3天无活动自动重置"
    
    echo "========================================" >> "$RESET_LOG"
    echo "重置时间: $TIMESTAMP" >> "$RESET_LOG"
    echo "重置角色: $ROLE" >> "$RESET_LOG"
    echo "重置原因: $RESET_REASON" >> "$RESET_LOG"
    echo "最后活动: $(grep "| $ROLE |" "$ACTIVITY_LOG" | tail -1)" >> "$RESET_LOG"
    
    # 根据角色类型执行不同的重置操作
    case $ROLE in
        "product"|"产品经理")
            reset_product_manager
            ;;
        "tech"|"技术负责人")
            reset_tech_lead
            ;;
        "ops"|"运营专家")
            reset_ops_expert
            ;;
        "test"|"测试专家")
            reset_test_expert
            ;;
        *)
            echo "❌ 未知角色: $ROLE"
            return 1
            ;;
    esac
    
    # 发送重置通知
    send_reset_notification "$ROLE"
    
    # 记录重置后的首次活动
    record_activity "$ROLE" "系统重置后重新激活"
    
    echo "✅ $ROLE 重置完成" >> "$RESET_LOG"
    echo "========================================" >> "$RESET_LOG"
}

# 重置产品经理
reset_product_manager() {
    echo "🔄 重置产品经理状态..."
    
    # 1. 清理旧的工作文件（保留重要文档）
    local WORK_DIR="$CONFIG_DIR/product/work"
    if [ -d "$WORK_DIR" ]; then
        # 保留最近3天的文件
        find "$WORK_DIR" -type f -mtime +3 -name "*.tmp" -delete 2>/dev/null
        find "$WORK_DIR" -type f -mtime +7 -name "draft_*" -delete 2>/dev/null
    fi
    
    # 2. 发送重新激活通知
    cat > "$CONFIG_DIR/product/inbox/SYSTEM_RESET_NOTICE.txt" << EOF
系统重置通知
============
时间: $(date)
发件人: 系统管理员
收件人: 产品经理 Alex

🚨 系统重置通知
由于检测到您已3天无活动，系统已自动重置您的状态。

## 重置操作
1. 清理了临时文件
2. 重置了任务状态
3. 发送了重新激活通知

## 需要您立即行动
1. 查看当前任务状态
2. 更新工作进度
3. 重新建立协作沟通

## 项目重要性
当前项目处于关键阶段，您的参与至关重要。

✅ 请立即重新开始工作
📅 今日必须更新进度
📞 如有问题立即反馈

---
*此为自动系统通知*
EOF
    
    # 3. 更新项目看板状态
    update_project_board "产品经理" "🔄 已重置 (需重新激活)"
    
    echo "✅ 产品经理重置完成"
}

# 重置技术负责人
reset_tech_lead() {
    echo "🔄 重置技术负责人状态..."
    
    # 发送重新激活通知
    cat > "$CONFIG_DIR/tech/inbox/SYSTEM_RESET_NOTICE.txt" << EOF
系统重置通知
============
时间: $(date)
发件人: 系统管理员
收件人: 技术负责人 Brian

🚨 系统重置通知
由于检测到您已3天无活动，系统已自动重置您的状态。

## 需要您立即行动
1. 检查技术架构设计进度
2. 更新开发计划
3. 重新建立技术沟通

## 技术任务紧迫性
- 需求评审会: 4月10日
- 架构设计截止: 4月14日
- 开发启动: 4月22日

✅ 请立即重新开始工作
EOF
    
    update_project_board "技术负责人" "🔄 已重置 (需重新激活)"
    echo "✅ 技术负责人重置完成"
}

# 重置运营专家
reset_ops_expert() {
    echo "🔄 重置运营专家状态..."
    
    cat > "$CONFIG_DIR/ops/inbox/SYSTEM_RESET_NOTICE.txt" << EOF
系统重置通知
============
时间: $(date)
发件人: 系统管理员
收件人: 运营专家 Cathy

🚨 系统重置通知
由于检测到您已3天无活动，系统已自动重置您的状态。

## 需要您立即行动
1. 检查策略收集进度
2. 更新策略评估计划
3. 重新建立数据协调

## 运营任务重要性
- 策略收集截止: 4月14日
- 回测框架需要尽快建立
- 数据源需要确认

✅ 请立即重新开始工作
EOF
    
    update_project_board "运营专家" "🔄 已重置 (需重新激活)"
    echo "✅ 运营专家重置完成"
}

# 重置测试专家
reset_test_expert() {
    echo "🔄 重置测试专家状态..."
    
    cat > "$CONFIG_DIR/test_role/inbox/SYSTEM_RESET_NOTICE.txt" << EOF
系统重置通知
============
时间: $(date)
发件人: 系统管理员
收件人: 测试专家 Taylor

🚨 系统重置通知
由于检测到您已3天无活动，系统已自动重置您的状态。

## 需要您立即行动
1. 检查测试计划进度
2. 更新测试用例设计
3. 重新建立测试协调

## 测试任务关键性
- 测试计划需要与开发同步
- 用户体验测试需要提前准备
- 风险测试方案需要设计

✅ 请立即重新开始工作
EOF
    
    update_project_board "测试专家" "🔄 已重置 (需重新激活)"
    echo "✅ 测试专家重置完成"
}

# 更新项目看板
update_project_board() {
    local ROLE=$1
    local STATUS=$2
    
    local BOARD_FILE="$CONFIG_DIR/shared/quant_project_board.md"
    if [ -f "$BOARD_FILE" ]; then
        # 备份原文件
        cp "$BOARD_FILE" "$BOARD_FILE.backup.$(date +%Y%m%d_%H%M%S)"
        
        # 更新状态
        sed -i "s/| $ROLE |.*| 🔄 进行中 |/| $ROLE | 任务待更新 | 0% | $STATUS |/" "$BOARD_FILE"
        sed -i "s/| $ROLE |.*| ⚡ 已开始执行 |/| $ROLE | 任务待更新 | 0% | $STATUS |/" "$BOARD_FILE"
        sed -i "s/| $ROLE |.*| ⚠️ 已催促 |/| $ROLE | 任务待更新 | 0% | $STATUS |/" "$BOARD_FILE"
        
        echo "📊 项目看板已更新: $ROLE -> $STATUS"
    fi
}

# 发送重置通知
send_reset_notification() {
    local ROLE=$1
    local TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    
    # 创建系统通知
    cat > "$CONFIG_DIR/shared/system_notifications.md" << EOF
## 系统重置通知 - $TIMESTAMP

### 重置角色: $ROLE
### 重置原因: 3天无活动检测
### 重置时间: $TIMESTAMP

### 影响:
1. 角色状态已重置为初始
2. 任务进度已清零
3. 已发送重新激活通知

### 要求:
1. 该角色需要立即重新开始工作
2. 需要在24小时内更新进度
3. 需要重新建立协作沟通

---
*系统自动生成*
EOF
    
    echo "📧 重置通知已发送给 $ROLE"
}

# 显示活动报告
show_activity_report() {
    echo ""
    echo "📊 角色活动报告"
    echo "========================================"
    
    local ROLES=("product" "tech" "ops" "test")
    local ROLE_NAMES=("产品经理" "技术负责人" "运营专家" "测试专家")
    
    for i in "${!ROLES[@]}"; do
        local ROLE="${ROLES[$i]}"
        local ROLE_NAME="${ROLE_NAMES[$i]}"
        
        local LAST_ACTIVITY=$(grep "| $ROLE |" "$ACTIVITY_LOG" | tail -1)
        local LAST_ACTIVITY2=$(grep "| $ROLE_NAME |" "$ACTIVITY_LOG" | tail -1)
        
        if [ -n "$LAST_ACTIVITY" ]; then
            echo "👤 $ROLE_NAME ($ROLE):"
            echo "   最后活动: $LAST_ACTIVITY"
        elif [ -n "$LAST_ACTIVITY2" ]; then
            echo "👤 $ROLE_NAME ($ROLE):"
            echo "   最后活动: $LAST_ACTIVITY2"
        else
            echo "👤 $ROLE_NAME ($ROLE):"
            echo "   无活动记录"
        fi
        
        # 检查是否需要重置
        check_and_reset "$ROLE"
        echo ""
    done
}

# 初始化活动记录（如果今天还没有记录）
initialize_daily_activity() {
    local TODAY=$(date "+%Y-%m-%d")
    local TODAY_ACTIVITIES=$(grep "^$TODAY" "$ACTIVITY_LOG" | wc -l)
    
    if [ "$TODAY_ACTIVITIES" -eq 0 ]; then
        echo "📅 初始化今日活动记录..."
        record_activity "system" "每日活动检查开始"
        
        # 为每个角色记录系统检查活动
        record_activity "product" "系统每日检查"
        record_activity "tech" "系统每日检查"
        record_activity "ops" "系统每日检查"
        record_activity "test" "系统每日检查"
    fi
}

# 主函数
main() {
    local ACTION=${1:-"check"}
    
    case $ACTION in
        "check")
            echo "🔍 检查各角色活动状态..."
            initialize_daily_activity
            show_activity_report
            ;;
        "record")
            if [ $# -lt 3 ]; then
                echo "❌ 用法: $0 record <角色> <活动描述>"
                echo "   角色: product, tech, ops, test"
                echo "   示例: $0 record product '完成交易员访谈'"
                exit 1
            fi
            record_activity "$2" "$3"
            ;;
        "force-reset")
            if [ $# -lt 2 ]; then
                echo "❌ 用法: $0 force-reset <角色>"
                echo "   角色: product, tech, ops, test"
                exit 1
            fi
            reset_role "$2"
            ;;
        "report")
            echo "📋 重置系统日志报告"
            echo "========================================"
            if [ -f "$RESET_LOG" ]; then
                tail -20 "$RESET_LOG"
            else
                echo "暂无重置记录"
            fi
            ;;
        "help")
            echo "🔄 3天不说话重置系统 - 使用说明"
            echo "========================================"
            echo "命令:"
            echo "  $0 check              - 检查各角色活动状态"
            echo "  $0 record <角色> <活动> - 记录角色活动"
            echo "  $0 force-reset <角色>  - 强制重置角色"
            echo "  $0 report             - 查看重置日志"
            echo "  $0 help               - 显示帮助"
            echo ""
            echo "角色: product(产品经理), tech(技术负责人), ops(运营专家), test(测试专家)"
            echo ""
            echo "示例:"
            echo "  $0 record product '完成需求调研'"
            echo "  $0 check"
            echo "  $0 force-reset tech"
            ;;
        *)
            echo "❌ 未知命令: $ACTION"
            echo "使用: $0 help 查看帮助"
            ;;
    esac
}

# 运行主函数
main "$@"