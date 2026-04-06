#!/bin/bash

# 创建测试角色脚本

echo "🎭 创建测试角色..."
echo "========================================"

# 创建测试角色目录
mkdir -p collaboration/test_role
mkdir -p collaboration/test_role/{inbox,processed,work}

# 创建测试角色配置
cat > collaboration/test_role/test_config.json << 'EOF'
{
  "role": "测试专家",
  "name": "Taylor",
  "responsibilities": [
    "测试策略制定",
    "测试用例设计",
    "缺陷管理",
    "质量评估",
    "自动化测试"
  ],
  "skills": [
    "功能测试",
    "性能测试",
    "安全测试",
    "自动化测试",
    "用户体验测试"
  ],
  "tools": ["测试管理工具", "自动化框架", "缺陷跟踪系统", "性能监控工具"],
  "communication_channels": ["产品团队", "技术团队", "运营团队"],
  "key_metrics": ["测试覆盖率", "缺陷发现率", "回归通过率", "上线质量"]
}
EOF

# 创建测试专家工作文档
cat > collaboration/test_role/work/test_strategy.md << 'EOF'
# 测试策略文档

## 测试专家：Taylor
## 职责范围：质量保障

## 📋 测试重点
1. **功能测试**
   - 核心业务流程验证
   - 边界条件测试
   - 异常场景测试

2. **性能测试**
   - 系统响应时间
   - 并发处理能力
   - 资源使用情况

3. **用户体验测试**
   - 界面友好性
   - 操作流畅度
   - 错误提示清晰度

4. **安全测试**
   - 数据加密
   - 权限控制
   - 输入验证

## 🔄 协作流程
### 与产品经理协作
- 参与需求评审，识别测试需求
- 验证功能是否符合产品设计
- 提供用户体验改进建议

### 与技术负责人协作
- 制定测试环境方案
- 协调自动化测试实施
- 跟踪缺陷修复进度

### 与运营专家协作
- 监控线上问题
- 分析用户反馈中的质量问题
- 评估新功能上线风险

## 📊 质量指标
| 指标 | 目标值 | 当前值 | 状态 |
|------|--------|--------|------|
| 测试覆盖率 | ≥90% | 待评估 | ⚠️ |
| 缺陷发现率 | ≥95% | 待评估 | ⚠️ |
| 回归通过率 | 100% | 待评估 | ⚠️ |
| 上线缺陷数 | ≤3个/版本 | 待评估 | ⚠️ |

## 🎯 当前任务
1. [ ] 建立测试环境
2. [ ] 设计测试用例模板
3. [ ] 制定自动化测试计划
4. [ ] 建立缺陷管理流程
EOF

# 创建测试专家日志
cat > collaboration/test_role/role_log.md << 'EOF'
# 测试专家工作日志

## 角色信息
- 名称: Taylor
- 角色: 测试专家
- 创建时间: $(date "+%Y-%m-%d %H:%M:%S")

## 工作原则
1. 质量第一，预防为主
2. 尽早介入，持续测试
3. 数据驱动，客观评估
4. 团队协作，共同负责

## 协作理念
- 与产品团队保持需求对齐
- 与技术团队共建质量文化
- 与运营团队共享质量数据
EOF

# 更新消息发送脚本以支持测试角色
echo ""
echo "🔄 更新消息系统支持测试角色..."

# 备份原脚本
cp send_message.sh send_message.sh.backup

# 更新角色验证部分
sed -i 's/VALID_ROLES="product tech ops"/VALID_ROLES="product tech ops test"/g' send_message.sh

# 更新角色响应脚本
cp role_response.sh role_response.sh.backup

# 添加测试角色支持
sed -i '/"ops")/a\        "test")\n            ROLE_NAME="测试专家"\n            ROLE_DIR="collaboration/test_role"\n            ;;' role_response.sh

echo "✅ 测试角色创建完成！"
echo ""
echo "🎭 新角色信息："
echo "   名称: Taylor"
echo "   角色: 测试专家"
echo "   职责: 质量保障、测试管理"
echo ""
echo "📁 角色目录: collaboration/test_role/"
echo "📋 配置文件: collaboration/test_role/test_config.json"
echo "📝 工作文档: collaboration/test_role/work/test_strategy.md"
echo ""
echo "🚀 现在可以与测试专家沟通了："
echo "   ./send_message.sh you test '你好Taylor，想讨论测试策略'"
echo "   ./role_response.sh test status"
echo ""
echo "🎯 测试专家将参与多方会议，提供质量保障视角。"