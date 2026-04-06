# 🎭 多方协作指南

## 🎯 系统概览

你已经成功创建了一个包含4个角色的协作系统：
1. **产品经理** (Alex) - 产品规划与需求
2. **技术负责人** (Brian) - 技术实现与架构
3. **运营专家** (Cathy) - 用户增长与运营
4. **测试专家** (Taylor) - 质量保障与测试

## 📁 系统结构

```
collaboration/
├── product/          # 产品经理工作区
├── tech/             # 技术负责人工作区
├── ops/              # 运营专家工作区
├── test_role/        # 测试专家工作区
├── shared/           # 共享工作区
├── message_queue/    # 消息队列
├── meetings/         # 会议记录
└── logs/             # 系统日志
```

## 🚀 快速开始

### 1. 查看当前会议状态
```bash
# 查看会议目录
ls -la collaboration/meetings/

# 查看会议纪要
cat collaboration/meetings/multi_meeting_*/meeting_notes.md
```

### 2. 检查各角色状态
```bash
# 查看产品经理状态
./role_response.sh product status

# 查看技术负责人状态
./role_response.sh tech status

# 查看运营专家状态
./role_response.sh ops status

# 查看测试专家状态
./role_response.sh test status
```

### 3. 查看角色收件箱
```bash
# 检查是否有会议通知
./role_response.sh product check
./role_response.sh tech check
./role_response.sh ops check
./role_response.sh test check
```

## 💬 与单个角色沟通

### 与产品经理沟通
```bash
# 发送消息
./send_message.sh you product "你好Alex，想讨论产品规划"

# 查看回复
./role_response.sh product check

# 让产品经理回复
./role_response.sh product respond <message_id>
```

### 与技术负责人沟通
```bash
# 发送消息
./send_message.sh you tech "你好Brian，有个技术问题请教"

# 查看回复
./role_response.sh tech check
```

### 与运营专家沟通
```bash
# 发送消息
./send_message.sh you ops "你好Cathy，想讨论用户增长策略"

# 查看回复
./role_response.sh ops check
```

### 与测试专家沟通
```bash
# 发送消息
./send_message.sh you test "你好Taylor，想讨论测试策略"

# 查看回复
./role_response.sh test check
```

## 🎪 组织多方会议

### 创建新会议
```bash
# 创建会议
./start_multi_meeting_fixed.sh

# 通知所有角色
./notify_meeting.sh <meeting_id> "会议主题"
```

### 启动现有会议
```bash
# 进入会议目录（使用实际的会议ID）
cd collaboration/meetings/multi_meeting_20260407_002222

# 启动会议控制
./meeting_control.sh
```

### 会议控制选项
在会议控制界面，你可以：
1. **查看会议纪要** - 查看当前会议记录
2. **角色发言** - 以任意角色发言
3. **添加行动项** - 分配任务给特定角色
4. **结束会议** - 生成完整会议纪要

## 🔄 完整协作流程示例

### 场景：开发新功能"智能推荐系统"

```bash
# 阶段1：需求提出
./send_message.sh you product "我们需要开发智能推荐系统"

# 阶段2：技术评估
./send_message.sh product tech "请评估推荐系统的技术可行性"

# 阶段3：运营规划
./send_message.sh you ops "推荐系统对用户活跃度的影响如何？"

# 阶段4：质量保障
./send_message.sh you test "请制定推荐系统的测试策略"

# 处理所有消息
./process_messages.sh

# 查看各角色反馈
./role_response.sh product check
./role_response.sh tech check
./role_response.sh ops check
./role_response.sh test check

# 阶段5：组织会议深入讨论
./start_multi_meeting_fixed.sh
./notify_meeting.sh <new_meeting_id> "智能推荐系统规划会议"

# 阶段6：启动会议
cd collaboration/meetings/<meeting_id>
./meeting_control.sh
```

## 📊 监控协作状态

### 查看消息队列
```bash
# 查看待处理消息
ls -la collaboration/message_queue/pending/

# 查看已处理消息
ls -la collaboration/message_queue/processed/
```

### 查看系统日志
```bash
# 查看协作日志
cat collaboration/logs/collaboration_log.md

# 查看消息日志
cat collaboration/logs/message_log.md
```

### 查看各角色工作状态
```bash
# 查看产品经理工作文档
cat collaboration/product/work/*.md 2>/dev/null

# 查看技术负责人工作文档
cat collaboration/tech/work/*.md 2>/dev/null

# 查看运营专家工作文档
cat collaboration/ops/work/*.md 2>/dev/null

# 查看测试专家工作文档
cat collaboration/test_role/work/*.md 2>/dev/null
```

## 🛠️ 实用技巧

### 技巧1：批量发送消息
```bash
# 同时向多个角色发送消息
./send_message.sh you product "需求A"
./send_message.sh you tech "需求A技术评估"
./send_message.sh you ops "需求A运营规划"
./send_message.sh you test "需求A测试策略"
./process_messages.sh
```

### 技巧2：创建协作看板
```bash
# 更新共享看板
cat > collaboration/shared/project_board.md << 'EOF'
# 当前协作项目

## 🎯 进行中的项目
1. 智能推荐系统
   - 产品：需求分析中
   - 技术：架构设计中
   - 运营：市场调研中
   - 测试：策略制定中

## 📅 本周重点
- 周一：需求评审会
- 周三：技术方案讨论
- 周五：测试计划确认
EOF
```

### 技巧3：记录协作历史
```bash
# 查看完整的协作历史
tail -f collaboration/logs/collaboration_log.md

# 导出协作报告
cat collaboration/logs/*.md > collaboration_report.md
```

## 🎮 互动练习

### 练习1：处理用户反馈问题
```bash
# 1. 运营发现用户反馈
./send_message.sh ops product "用户反馈搜索功能响应慢"

# 2. 技术排查问题
./send_message.sh product tech "请排查搜索功能性能问题"

# 3. 测试验证修复
./send_message.sh tech test "修复后请进行性能测试"

# 4. 组织紧急会议
./start_multi_meeting_fixed.sh
./notify_meeting.sh <meeting_id> "搜索功能性能问题紧急会议"
```

### 练习2：规划季度产品路线图
```bash
# 1. 产品提出季度规划
./send_message.sh you product "我们需要制定Q2产品路线图"

# 2. 各角色提供输入
./send_message.sh product tech "请提供技术资源评估"
./send_message.sh product ops "请提供市场趋势分析"
./send_message.sh product test "请提供质量风险评估"

# 3. 处理消息并查看反馈
./process_messages.sh
./role_response.sh tech check
./role_response.sh ops check
./role_response.sh test check

# 4. 组织规划会议
./start_multi_meeting_fixed.sh
./notify_meeting.sh <meeting_id> "Q2产品路线图规划会议"
```

## 🔧 故障排除

### 常见问题
1. **消息未送达**：运行 `./process_messages.sh`
2. **角色无法响应**：检查角色目录权限
3. **会议无法启动**：检查会议控制脚本权限

### 重置系统
```bash
# 如果需要重新开始
rm -rf collaboration/
./start_collaboration.sh
./create_test_role.sh
```

## 🎯 现在开始协作！

### 选项1：启动现有会议
```bash
cd collaboration/meetings/multi_meeting_20260407_002222
./meeting_control.sh
```

### 选项2：与特定角色沟通
```bash
# 选择你想沟通的角色：
./send_message.sh you product "我想讨论..."
# 或
./send_message.sh you tech "我想请教..."
# 或
./send_message.sh you ops "我想了解..."
# 或
./send_message.sh you test "我想咨询..."
```

### 选项3：创建新协作项目
告诉我你想：
1. **开发什么新功能？**
2. **解决什么问题？**
3. **优化什么流程？**

我会指导你使用相应的协作命令。

---

**你现在拥有一个完整的4角色协作系统，可以开始你的多方协作了！** 🎉

记住，你可以：
- 与单个角色深入讨论
- 组织多方会议协调工作
- 监控整个协作过程
- 记录完整的协作历史

祝你协作愉快！🚀