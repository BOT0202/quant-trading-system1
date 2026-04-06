#!/bin/bash

# GitHub备份脚本 - 量化交易信号系统项目

echo "🚀 开始备份量化系统项目到GitHub..."
echo "========================================"

# 创建备份目录结构
BACKUP_DIR="/tmp/quant_system_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR/collaboration"
mkdir -p "$BACKUP_DIR/scripts"
mkdir -p "$BACKUP_DIR/docs"

echo "📁 创建备份目录: $BACKUP_DIR"

# 1. 复制协作文件
echo "📋 复制协作文件..."
cp -r /root/.openclaw/workspace/collaboration/* "$BACKUP_DIR/collaboration/" 2>/dev/null

# 2. 复制脚本文件
echo "📜 复制脚本文件..."
cp /root/.openclaw/workspace/*.sh "$BACKUP_DIR/scripts/" 2>/dev/null
cp /root/.openclaw/workspace/*.md "$BACKUP_DIR/docs/" 2>/dev/null

# 3. 创建项目README
cat > "$BACKUP_DIR/README.md" << 'EOF'
# 🎯 量化交易信号系统项目

## 项目概述
这是一个外盘黄金量化交易信号系统项目，为交易员提供基于多种策略的交易信号辅助决策。

## 项目结构
```
quant_system_project/
├── collaboration/          # 协作文件
│   ├── product/           # 产品经理工作区
│   ├── tech/              # 技术负责人工作区
│   ├── ops/               # 运营专家工作区
│   ├── test_role/         # 测试专家工作区
│   ├── shared/            # 共享工作区
│   ├── meetings/          # 会议记录
│   └── logs/              # 系统日志
├── scripts/               # 项目脚本
├── docs/                  # 项目文档
└── README.md              # 项目说明
```

## 项目角色
1. **产品经理 (Alex)** - 产品规划与需求分析
2. **技术负责人 (Brian)** - 技术架构与系统开发
3. **运营专家 (Cathy)** - 策略收集与优化
4. **测试专家 (Taylor)** - 质量保障与用户体验

## 核心功能
- 多策略信号生成与整合
- 实时行情数据接入
- 信号推送与通知
- 策略回测与优化
- 风险控制与管理

## 技术栈
- 后端: 微服务架构
- 前端: Web应用
- 数据库: 时序数据库 + 关系数据库
- 部署: Docker + Kubernetes
- 监控: Prometheus + Grafana

## 项目状态
- **启动时间**: 2026-04-07
- **当前阶段**: 需求分析与设计
- **目标上线**: 2026-05-20

## 重要文件
1. `collaboration/shared/quant_project_board.md` - 项目协作看板
2. `collaboration/meetings/*/quant_meeting_notes.md` - 会议纪要
3. `scripts/` - 所有协作脚本

## 使用说明
1. 查看项目看板: `cat collaboration/shared/quant_project_board.md`
2. 启动协作系统: `./scripts/start_collaboration.sh`
3. 查看角色状态: `./scripts/role_response.sh <role> status`

## 备份信息
- 备份时间: $(date)
- 备份版本: v1.0
- 项目状态: 已启动

---
*这是一个多角色协作的量化交易系统项目备份*
EOF

# 4. 创建.gitignore文件
cat > "$BACKUP_DIR/.gitignore" << 'EOF'
# 忽略临时文件
*.tmp
*.log
*.bak

# 忽略敏感数据
*secret*
*password*
*key*
*credential*

# 忽略系统文件
.DS_Store
Thumbs.db

# 忽略IDE文件
.vscode/
.idea/
*.swp
*.swo

# 忽略大文件
*.zip
*.tar.gz
*.rar
EOF

# 5. 创建Git初始化脚本
cat > "$BACKUP_DIR/setup_git.sh" << 'EOF'
#!/bin/bash

# Git初始化脚本

echo "🔧 初始化Git仓库..."
git init

echo "📝 添加所有文件..."
git add .

echo "💾 提交初始版本..."
git commit -m "Initial commit: Quant Trading Signal System Project

- 项目启动会议纪要
- 各角色配置和任务
- 协作脚本和文档
- 项目看板和计划"

echo "✅ Git仓库初始化完成！"
echo ""
echo "🚀 推送到GitHub的步骤:"
echo "1. 在GitHub创建新仓库: https://github.com/new"
echo "2. 添加远程仓库: git remote add origin https://github.com/你的用户名/仓库名.git"
echo "3. 推送代码: git push -u origin main"
echo ""
echo "💡 提示: 如果需要，可以先修改仓库中的敏感信息再推送"
EOF

chmod +x "$BACKUP_DIR/setup_git.sh"

# 6. 创建压缩包
echo "📦 创建压缩包..."
cd /tmp
tar -czf "quant_system_project_$(date +%Y%m%d).tar.gz" "$(basename $BACKUP_DIR)"

# 7. 显示备份信息
echo ""
echo "✅ 备份完成！"
echo "========================================"
echo "📁 备份目录: $BACKUP_DIR"
echo "📦 压缩文件: /tmp/quant_system_project_$(date +%Y%m%d).tar.gz"
echo ""
echo "📊 备份内容统计:"
echo "   协作文件: $(find "$BACKUP_DIR/collaboration" -type f | wc -l) 个"
echo "   脚本文件: $(find "$BACKUP_DIR/scripts" -type f | wc -l) 个"
echo "   文档文件: $(find "$BACKUP_DIR/docs" -type f | wc -l) 个"
echo "   总文件数: $(find "$BACKUP_DIR" -type f | wc -l) 个"
echo ""
echo "🚀 下一步操作:"
echo "1. 查看备份内容: ls -la $BACKUP_DIR"
echo "2. 初始化Git仓库: cd $BACKUP_DIR && ./setup_git.sh"
echo "3. 推送到GitHub: 按照setup_git.sh中的说明操作"
echo "4. 下载压缩包备用"
echo ""
echo "💡 提示: 建议定期备份项目进展到GitHub"