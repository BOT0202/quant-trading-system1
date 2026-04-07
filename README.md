# 🎭 多角色协作系统 - 产品、技术、运营

一个模拟产品经理、技术负责人、运营专家三个角色协作的完整框架。

## 🎯 系统特点

- **角色分明**: 每个角色有明确的职责和视角
- **消息驱动**: 通过消息队列进行角色间通信
- **会议支持**: 内置三方会议系统
- **状态跟踪**: 实时监控各角色工作状态
- **日志完整**: 完整的协作过程记录

## 🏗️ 系统架构

```
collaboration/
├── product/          # 产品经理工作区
├── tech/             # 技术负责人工作区
├── ops/              # 运营专家工作区
├── shared/           # 共享工作区
├── message_queue/    # 消息队列系统
├── meetings/         # 会议记录
└── logs/             # 系统日志
```

## 🚀 快速开始

### 1. 初始化系统
```bash
./start_collaboration.sh
```

### 2. 发送第一条消息
```bash
# 产品经理向技术负责人发送消息
./send_message.sh product tech "我们需要讨论新用户注册流程的优化方案"
```

### 3. 处理消息
```bash
# 处理所有待处理消息
./process_messages.sh
```

### 4. 角色响应
```bash
# 技术负责人检查收件箱
./role_response.sh tech check

# 技术负责人回复消息
./role_response.sh tech respond <message_id>
```

### 5. 启动协作会议
```bash
# 创建并启动三方会议
./start_meeting.sh
```

## 👥 角色定义

### 🎯 产品经理 (Product Manager)
**核心职责**: 用户需求、产品规划、功能设计
**关键指标**: 用户满意度、功能使用率、产品留存率

### ⚙️ 技术负责人 (Tech Lead)
**核心职责**: 架构设计、开发管理、技术选型
**关键指标**: 系统稳定性、开发效率、代码质量

### 📈 运营专家 (Operations Specialist)
**核心职责**: 用户增长、内容运营、数据分析
**关键指标**: 用户增长、活跃度、转化率

## 🔄 协作流程

### 典型场景：新功能开发
1. **产品提出需求** → 发送需求文档给技术
2. **技术评估方案** → 回复技术可行性分析
3. **运营规划推广** → 提供用户获取策略
4. **三方协调上线** → 会议讨论时间节点

### 典型场景：问题处理
1. **运营发现问题** → 报告用户反馈
2. **技术排查原因** → 分析问题根源
3. **产品决定方案** → 制定解决策略
4. **运营通知用户** → 同步处理结果

## 📊 监控与报告

### 查看系统状态
```bash
# 查看各角色状态
./role_response.sh product status
./role_response.sh tech status
./role_response.sh ops status

# 查看消息队列状态
ls -la collaboration/message_queue/
```

### 查看协作日志
```bash
# 查看系统日志
cat collaboration/logs/collaboration_log.md

# 查看消息日志
cat collaboration/logs/message_log.md
```

## 🛠️ 脚本说明

| 脚本 | 功能 | 示例 |
|------|------|------|
| `start_collaboration.sh` | 初始化协作系统 | `./start_collaboration.sh` |
| `send_message.sh` | 发送角色间消息 | `./send_message.sh product tech "消息内容"` |
| `process_messages.sh` | 处理待处理消息 | `./process_messages.sh` |
| `role_response.sh` | 角色响应操作 | `./role_response.sh tech check` |
| `start_meeting.sh` | 启动三方会议 | `./start_meeting.sh` |

## 📝 使用示例

### 示例1：完整的协作流程
```bash
# 1. 初始化
./start_collaboration.sh

# 2. 产品经理提出需求
./send_message.sh product tech "我们需要开发用户数据分析仪表板"

# 3. 处理消息
./process_messages.sh

# 4. 技术负责人查看并回复
./role_response.sh tech check
./role_response.sh tech respond <message_id>

# 5. 运营专家加入讨论
./send_message.sh ops product "这个功能对用户增长很有帮助，我们可以配合推广"

# 6. 启动会议深入讨论
./start_meeting.sh
```

### 示例2：问题处理流程
```bash
# 1. 运营报告问题
./send_message.sh ops tech "用户反馈登录缓慢，平均响应时间超过5秒"

# 2. 技术负责人处理
./process_messages.sh
./role_response.sh tech check
./role_response.sh tech respond <message_id>

# 3. 产品经理协调
./send_message.sh product ops "请收集更多用户反馈，我们优先处理这个问题"

# 4. 三方会议制定解决方案
./start_meeting.sh
```

## 🔧 自定义配置

### 修改角色配置
```bash
# 编辑产品经理配置
vim collaboration/product/product_config.json

# 编辑技术负责人配置
vim collaboration/tech/tech_config.json

# 编辑运营专家配置
vim collaboration/ops/ops_config.json
```

### 扩展系统功能
1. **添加新角色**: 复制现有角色模板并修改配置
2. **自定义消息类型**: 修改消息JSON格式
3. **集成外部工具**: 在脚本中添加API调用
4. **自动化工作流**: 创建定时任务脚本

## 📈 最佳实践

### 沟通规范
1. **消息清晰**: 每条消息包含明确的目的和期望
2. **及时响应**: 重要消息应在24小时内回复
3. **记录完整**: 所有决策和讨论都要记录

### 会议效率
1. **会前准备**: 各角色提前填写准备材料
2. **议程明确**: 按照既定议程进行讨论
3. **行动明确**: 每个决议都要有明确的行动项

### 协作优化
1. **定期复盘**: 每周回顾协作效果
2. **流程改进**: 根据问题优化协作流程
3. **工具升级**: 根据需要引入新的协作工具

## 🐛 故障排除

### 常见问题
1. **消息未送达**: 检查`process_messages.sh`是否运行
2. **角色无法响应**: 检查角色目录权限
3. **会议无法启动**: 检查`meeting_control.sh`执行权限

### 日志查看
```bash
# 查看系统错误日志
tail -f collaboration/logs/error.log

# 查看消息处理日志
tail -f collaboration/logs/message_processing.log
```

## 📚 相关文档

- [多角色协作系统设计](./multi_role_collaboration.md)
- [角色职责说明](./collaboration/product/product_config.json)
- [消息格式规范](./collaboration/message_queue/format.md)
- [会议流程指南](./collaboration/meetings/process.md)

## 🎉 开始协作

现在你已经准备好开始多角色协作了！建议从以下步骤开始：

1. **熟悉系统**: 运行初始化脚本了解系统结构
2. **测试消息**: 发送几条测试消息熟悉流程
3. **模拟会议**: 启动一次测试会议体验完整流程
4. **实际应用**: 将系统应用到你的实际项目中

祝你协作愉快！🎯

## 🔄 3天不说话重置系统

### 系统概述
自动监控各角色活动状态，3天无活动则自动重置角色状态。

### 主要功能
1. **活动监控** - 记录各角色的工作活动
2. **自动重置** - 3天无活动自动重置状态
3. **通知提醒** - 发送重置通知和重新激活要求
4. **进度保护** - 避免项目因角色不活跃而停滞

### 使用方法
```bash
# 手动检查活动状态
./check_role_activity.sh

# 记录角色活动
./three_day_reset_system.sh record product "完成需求调研"

# 每日工作开始记录
./start_daily_work.sh

# 每周活动报告
./weekly_activity_report.sh
```

### 自动化设置
- **每天9:00**自动检查活动状态
- **3天无活动**自动触发重置
- **集成到协作系统**中自动记录活动

### 文件位置
- 核心脚本: `three_day_reset_system.sh`
- 活动日志: `collaboration/logs/role_activity.log`
- 重置日志: `collaboration/logs/reset_system.log`
- 使用指南: `RESET_SYSTEM_GUIDE.md`
