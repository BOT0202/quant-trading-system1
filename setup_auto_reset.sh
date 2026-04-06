#!/bin/bash

# 设置3天不说话自动重置系统

echo "🔄 设置3天不说话自动重置系统"
echo "========================================"

RESET_SCRIPT="/root/.openclaw/workspace/three_day_reset_system.sh"
CRON_JOB="0 9 * * * $RESET_SCRIPT check >> /root/.openclaw/workspace/collaboration/logs/reset_cron.log 2>&1"

# 1. 给脚本执行权限
echo "🔧 设置脚本权限..."
chmod +x "$RESET_SCRIPT"

# 2. 创建必要的日志文件
echo "📁 创建日志文件..."
mkdir -p /root/.openclaw/workspace/collaboration/logs
touch /root/.openclaw/workspace/collaboration/logs/reset_cron.log
touch /root/.openclaw/workspace/collaboration/logs/role_activity.log
touch /root/.openclaw/workspace/collaboration/logs/reset_system.log

# 3. 初始化活动记录
echo "📝 初始化活动记录..."
"$RESET_SCRIPT" record system "3天重置系统初始化"

# 记录各角色的初始活动
"$RESET_SCRIPT" record product "系统初始化 - 项目启动"
"$RESET_SCRIPT" record tech "系统初始化 - 项目启动"
"$RESET_SCRIPT" record ops "系统初始化 - 项目启动"
"$RESET_SCRIPT" record test "系统初始化 - 项目启动"

# 4. 设置cron定时任务
echo "⏰ 设置cron定时任务..."
if command -v crontab &> /dev/null; then
    # 检查是否已存在该任务
    if ! crontab -l 2>/dev/null | grep -q "$RESET_SCRIPT check"; then
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        echo "✅ cron任务已添加: 每天9:00自动检查"
    else
        echo "⚠️  cron任务已存在"
    fi
else
    echo "❌ crontab命令不可用，无法设置自动任务"
    echo "💡 可以手动运行: $RESET_SCRIPT check"
fi

# 5. 创建手动检查脚本
echo "📜 创建手动检查脚本..."
cat > /root/.openclaw/workspace/check_role_activity.sh << 'EOF'
#!/bin/bash

# 手动检查角色活动脚本

echo "🔍 手动检查角色活动状态"
echo "========================================"

RESET_SCRIPT="/root/.openclaw/workspace/three_day_reset_system.sh"

echo "📊 当前时间: $(date)"
echo ""

# 运行检查
"$RESET_SCRIPT" check

echo ""
echo "💡 其他命令:"
echo "   记录活动: $RESET_SCRIPT record <角色> <活动描述>"
echo "   强制重置: $RESET_SCRIPT force-reset <角色>"
echo "   查看日志: $RESET_SCRIPT report"
echo "   获取帮助: $RESET_SCRIPT help"
EOF

chmod +x /root/.openclaw/workspace/check_role_activity.sh

# 6. 创建重置系统使用指南
echo "📚 创建使用指南..."
cat > /root/.openclaw/workspace/RESET_SYSTEM_GUIDE.md << 'EOF'
# 🔄 3天不说话重置系统 - 使用指南

## 🎯 系统概述

这是一个自动监控系统，用于检测量化系统项目中各角色的活动状态。如果某个角色**3天没有活动记录**，系统会自动重置其状态并发送通知。

## ⏰ 重置规则

### 触发条件：
- 角色连续 **3天（72小时）** 无任何活动记录
- 活动包括：工作产出、消息发送、任务更新等

### 重置操作：
1. **清理临时文件** - 删除3天前的临时文件
2. **发送重置通知** - 提醒角色重新激活
3. **更新项目看板** - 将状态改为"已重置"
4. **进度清零** - 任务进度重置为0%

### 豁免情况：
- 周末和节假日不计入（可配置）
- 有请假记录的角色
- 系统维护期间

## 🔧 系统文件

### 核心脚本：
```
/root/.openclaw/workspace/three_day_reset_system.sh
```

### 日志文件：
```
collaboration/logs/
├── role_activity.log     # 角色活动记录
├── reset_system.log      # 重置操作记录
└── reset_cron.log        # 定时任务日志
```

### 工具脚本：
```
/root/.openclaw/workspace/check_role_activity.sh   # 手动检查
/root/.openclaw/workspace/setup_auto_reset.sh      # 安装脚本
```

## 🚀 使用方法

### 1. 手动检查活动状态
```bash
cd /root/.openclaw/workspace
./check_role_activity.sh
```

### 2. 记录角色活动
```bash
# 记录产品经理活动
./three_day_reset_system.sh record product "完成交易员访谈"

# 记录技术负责人活动  
./three_day_reset_system.sh record tech "完成架构设计"

# 记录运营专家活动
./three_day_reset_system.sh record ops "收集10个策略"

# 记录测试专家活动
./three_day_reset_system.sh record test "设计测试用例"
```

### 3. 强制重置角色
```bash
# 强制重置某个角色（不等待3天）
./three_day_reset_system.sh force-reset product
```

### 4. 查看重置日志
```bash
./three_day_reset_system.sh report
```

### 5. 获取帮助
```bash
./three_day_reset_system.sh help
```

## 📊 活动记录格式

### 记录示例：
```
2026-04-07 10:30:00 | product | 完成交易员访谈
2026-04-07 11:45:00 | tech | 开始架构设计
2026-04-07 14:20:00 | ops | 收集策略清单
2026-04-07 16:00:00 | test | 设计测试计划
```

### 支持的角色标识：
- `product` 或 `产品经理`
- `tech` 或 `技术负责人`
- `ops` 或 `运营专家`
- `test` 或 `测试专家`
- `system` - 系统操作

## ⚙️ 自动化设置

### 定时检查：
系统已设置为**每天9:00**自动检查各角色活动状态。

### 查看定时任务：
```bash
crontab -l
```

### 修改检查频率：
```bash
# 编辑cron任务
crontab -e

# 修改时间表达式，例如：
# 每6小时检查一次：0 */6 * * *
# 每天两次：0 9,18 * * *
# 每小时检查：0 * * * *
```

## 🛠️ 集成到协作系统

### 在协作脚本中记录活动：
```bash
# 在send_message.sh中添加
./three_day_reset_system.sh record "$FROM" "发送消息给$TO"

# 在role_response.sh中添加  
./three_day_reset_system.sh record "$ROLE" "更新状态响应"
```

### 在任务完成时记录：
```bash
# 当产品经理完成任务时
./three_day_reset_system.sh record product "完成$TASK_NAME"
```

## 📈 监控和报告

### 每日检查报告：
```bash
# 生成每日活动报告
./three_day_reset_system.sh check | tee /tmp/daily_activity_report.txt
```

### 每周汇总报告：
```bash
# 查看本周活动统计
grep "$(date +%Y-%m)" collaboration/logs/role_activity.log | wc -l
```

### 重置统计：
```bash
# 查看本月重置次数
grep "重置时间" collaboration/logs/reset_system.log | grep "$(date +%Y-%m)" | wc -l
```

## 🐛 故障排除

### 问题1：活动未正确记录
**症状**：角色有工作但系统显示无活动
**解决**：
```bash
# 手动记录活动
./three_day_reset_system.sh record <角色> "<活动描述>"

# 检查日志文件
tail -f collaboration/logs/role_activity.log
```

### 问题2：误重置
**症状**：角色有活动但仍被重置
**解决**：
```bash
# 检查活动记录
grep "<角色>" collaboration/logs/role_activity.log

# 检查时间计算
./three_day_reset_system.sh check
```

### 问题3：cron任务未运行
**症状**：每天9:00没有自动检查
**解决**：
```bash
# 检查cron服务
systemctl status cron

# 手动运行检查
./three_day_reset_system.sh check

# 重新设置cron
./setup_auto_reset.sh
```

## 🔄 系统维护

### 清理旧日志：
```bash
# 保留30天日志
find collaboration/logs -name "*.log" -mtime +30 -delete
```

### 备份重置记录：
```bash
# 每月备份一次
cp collaboration/logs/reset_system.log collaboration/logs/reset_system_$(date +%Y%m).log
```

### 更新重置阈值：
```bash
# 编辑脚本修改天数
vim /root/.openclaw/workspace/three_day_reset_system.sh
# 修改: RESET_THRESHOLD_DAYS=3
```

## 🎯 最佳实践

### 建议的活动记录时机：
1. **每日开始工作**时记录
2. **完成重要任务**时记录
3. **发送协作消息**时记录
4. **更新项目文档**时记录

### 避免误重置：
1. 确保每天至少记录一次活动
2. 周末前记录"周末休息"活动
3. 请假时记录"请假中"状态

### 监控建议：
1. 每天查看一次活动报告
2. 每周检查重置日志
3. 每月分析活动模式

---
**系统状态**: 🟢 已启用  
**重置阈值**: 3天无活动  
**检查频率**: 每天9:00自动检查  
**最后初始化**: $(date)  

**系统将确保项目各角色保持活跃，避免因长时间不活动导致项目停滞。**