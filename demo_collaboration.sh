#!/bin/bash

# 多角色协作演示脚本
# 展示完整的协作流程

echo "🎬 开始多角色协作演示"
echo "========================================"
echo ""

# 步骤1: 初始化系统
echo "1️⃣ 初始化协作系统..."
./start_collaboration.sh > /dev/null 2>&1
echo "✅ 系统初始化完成"
echo ""

# 步骤2: 产品经理提出需求
echo "2️⃣ 产品经理提出新功能需求..."
./send_message.sh product tech "我们需要开发用户行为分析功能，帮助运营团队更好地理解用户" > /dev/null 2>&1
echo "✅ 需求已发送给技术负责人"
echo ""

# 步骤3: 技术负责人请求更多信息
echo "3️⃣ 技术负责人请求更多技术细节..."
./send_message.sh tech product "收到需求，请提供具体的分析维度和数据来源要求" > /dev/null 2>&1
echo "✅ 技术问题已反馈"
echo ""

# 步骤4: 运营专家加入讨论
echo "4️⃣ 运营专家提供用户视角..."
./send_message.sh ops product "这个功能很重要！我们最需要的是用户留存分析和行为路径追踪" > /dev/null 2>&1
echo "✅ 运营需求已补充"
echo ""

# 步骤5: 处理所有消息
echo "5️⃣ 处理所有待处理消息..."
./process_messages.sh > /dev/null 2>&1
echo "✅ 消息处理完成"
echo ""

# 步骤6: 显示各角色收件箱状态
echo "6️⃣ 各角色收件箱状态:"
echo "----------------------------------------"
echo "产品经理收件箱:"
./role_response.sh product check 2>/dev/null | grep -A2 "有.*条未读消息" || echo "   暂无新消息"
echo ""
echo "技术负责人收件箱:"
./role_response.sh tech check 2>/dev/null | grep -A2 "有.*条未读消息" || echo "   暂无新消息"
echo ""
echo "运营专家收件箱:"
./role_response.sh ops check 2>/dev/null | grep -A2 "有.*条未读消息" || echo "   暂无新消息"
echo ""

# 步骤7: 技术负责人回复
echo "7️⃣ 技术负责人评估后回复..."
# 模拟技术负责人的回复
TECH_RESPONSE="经过评估，用户行为分析功能技术上可行。建议分两期实现：第一期先做基础数据收集和简单报表，第二期实现高级分析和预测功能。预计需要3周开发时间。"
echo "💬 技术负责人回复: $TECH_RESPONSE"
echo ""

# 步骤8: 创建会议深入讨论
echo "8️⃣ 创建三方会议深入讨论..."
./start_meeting.sh > /dev/null 2>&1
MEETING_DIR=$(find collaboration/meetings -type d -name "meeting_*" | sort -r | head -1)
echo "✅ 会议已创建: $MEETING_DIR"
echo ""

# 步骤9: 显示系统状态
echo "9️⃣ 系统状态汇总:"
echo "----------------------------------------"
echo "📁 协作目录结构:"
tree collaboration/ -L 2 2>/dev/null | grep -v "\.json" | head -20 || echo "   使用 'tree collaboration/' 查看完整结构"
echo ""
echo "📊 消息统计:"
echo "   待处理消息: $(ls -1 collaboration/message_queue/pending/*.json 2>/dev/null | wc -l)"
echo "   已处理消息: $(ls -1 collaboration/message_queue/processed/*.json 2>/dev/null | wc -l)"
echo "   会议记录: $(find collaboration/meetings -type f -name "meeting_notes.md" | wc -l)"
echo ""

# 步骤10: 演示总结
echo "🔟 演示总结"
echo "========================================"
echo "🎯 演示完成！你已经体验了完整的协作流程："
echo ""
echo "📋 演示步骤回顾:"
echo "   1. 系统初始化 → 创建三个角色工作区"
echo "   2. 产品需求 → 产品经理提出新功能"
echo "   3. 技术评估 → 技术负责人请求细节"
echo "   4. 运营补充 → 运营专家提供用户视角"
echo "   5. 消息处理 → 系统分发所有消息"
echo "   6. 状态检查 → 查看各角色收件箱"
echo "   7. 技术回复 → 技术负责人评估可行性"
echo "   8. 会议创建 → 启动三方深入讨论"
echo "   9. 系统监控 → 查看整体协作状态"
echo ""
echo "🚀 下一步建议:"
echo "   1. 查看详细文档: cat README.md"
echo "   2. 尝试完整流程: 按照README中的示例操作"
echo "   3. 自定义配置: 修改角色配置文件"
echo "   4. 扩展功能: 添加新的角色或消息类型"
echo ""
echo "💡 提示: 所有脚本都有详细的帮助信息，使用时不带参数即可查看"
echo "   示例: ./send_message.sh"
echo ""
echo "🎉 开始你的多角色协作之旅吧！"