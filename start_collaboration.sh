#!/bin/bash

# 多角色协作系统启动脚本
# 启动产品、技术、运营三个角色的协作环境

echo "🚀 启动多角色协作系统..."
echo "========================================"

# 创建协作目录
mkdir -p collaboration/{product,tech,ops,shared}
mkdir -p collaboration/logs

# 初始化角色配置文件
echo "📁 初始化角色配置..."

# 产品经理配置
cat > collaboration/product/product_config.json << 'EOF'
{
  "role": "产品经理",
  "name": "Alex",
  "responsibilities": [
    "市场调研",
    "产品规划",
    "需求分析",
    "原型设计",
    "项目管理"
  ],
  "tools": ["用户画像", "需求池", "原型工具", "数据分析平台"],
  "communication_channels": ["技术团队", "运营团队", "用户反馈"],
  "key_metrics": ["用户满意度", "功能使用率", "产品留存率"]
}
EOF

# 技术负责人配置
cat > collaboration/tech/tech_config.json << 'EOF'
{
  "role": "技术负责人",
  "name": "Brian",
  "responsibilities": [
    "架构设计",
    "开发管理",
    "代码审查",
    "技术选型",
    "性能优化"
  ],
  "tech_stack": ["后端", "前端", "数据库", "DevOps"],
  "communication_channels": ["产品团队", "运营团队", "测试团队"],
  "key_metrics": ["系统稳定性", "开发效率", "代码质量"]
}
EOF

# 运营专家配置
cat > collaboration/ops/ops_config.json << 'EOF'
{
  "role": "运营专家",
  "name": "Cathy",
  "responsibilities": [
    "用户增长",
    "内容运营",
    "数据分析",
    "活动策划",
    "用户支持"
  ],
  "channels": ["社交媒体", "邮件营销", "内容平台", "用户社区"],
  "communication_channels": ["产品团队", "技术团队", "用户群体"],
  "key_metrics": ["用户增长", "活跃度", "转化率", "用户满意度"]
}
EOF

# 创建共享工作区
cat > collaboration/shared/project_board.md << 'EOF'
# 项目协作看板

## 📋 当前项目
1. 新用户注册流程优化
2. 数据分析仪表板开发
3. 季度运营活动策划

## 🎯 本周目标
- 产品：完成用户调研报告
- 技术：修复登录性能问题
- 运营：策划用户增长活动

## 📊 关键指标
| 指标 | 当前值 | 目标值 | 负责人 |
|------|--------|--------|--------|
| 日活跃用户 | 15,000 | 20,000 | 运营 |
| 注册转化率 | 25% | 30% | 产品+运营 |
| 系统可用性 | 99.5% | 99.9% | 技术 |
| 用户满意度 | 4.2/5 | 4.5/5 | 产品 |

## 🔄 协作任务
- [ ] 产品 → 技术：提供新功能需求文档
- [ ] 技术 → 运营：开放用户行为数据接口
- [ ] 运营 → 产品：提交用户反馈分析报告
EOF

# 创建消息队列目录
mkdir -p collaboration/message_queue/{pending,processed,archive}

# 创建协作日志
cat > collaboration/logs/collaboration_log.md << 'EOF'
# 协作日志
$(date "+%Y-%m-%d %H:%M:%S") - 系统启动
=======================================

## 启动信息
- 时间: $(date)
- 角色: 产品经理、技术负责人、运营专家
- 状态: 已就绪

## 初始任务
1. 角色自我介绍
2. 同步当前项目状态
3. 制定本周协作计划

## 沟通规则
1. 所有消息通过消息队列传递
2. 重要决策需要三方确认
3. 每日同步进度和问题
EOF

# 设置权限
chmod -R 755 collaboration/

echo "✅ 系统初始化完成！"
echo ""
echo "📊 系统结构："
echo "  collaboration/"
echo "  ├── product/     # 产品经理工作区"
echo "  ├── tech/        # 技术负责人工作区"
echo "  ├── ops/         # 运营专家工作区"
echo "  ├── shared/      # 共享工作区"
echo "  ├── message_queue/ # 消息队列"
echo "  └── logs/        # 协作日志"
echo ""
echo "🎯 启动协作："
echo "  1. 查看项目看板：cat collaboration/shared/project_board.md"
echo "  2. 发送第一条消息：echo 'Hello from Product!' > collaboration/message_queue/pending/product_to_tech.txt"
echo "  3. 查看协作日志：cat collaboration/logs/collaboration_log.md"
echo ""
echo "💡 提示：使用以下命令开始角色间对话："
echo "  ./send_message.sh <from_role> <to_role> <message>"
echo "  ./process_messages.sh"
echo ""
echo "🚀 协作系统已就绪，开始你的多角色协作吧！"