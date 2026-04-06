#!/bin/bash

# 最终配置脚本 - 为BOT0202用户完成GitHub自动化设置

echo "🚀 为BOT0202用户完成GitHub自动化设置"
echo "========================================"

GITHUB_USER="BOT0202"
REPO_NAME="quant-trading-system"
PROJECT_DIR="/root/quant-auto-sync"

echo "📋 配置信息:"
echo "   用户名: $GITHUB_USER"
echo "   仓库名: $REPO_NAME"
echo "   项目目录: $PROJECT_DIR"
echo ""

# 1. 更新所有脚本中的GitHub配置
echo "🔧 更新GitHub配置..."
sed -i "s/GITHUB_USER=\"\"/GITHUB_USER=\"$GITHUB_USER\"/g" "$PROJECT_DIR/setup_github.sh"
sed -i "s|https://github.com//|https://github.com/$GITHUB_USER/|g" "$PROJECT_DIR/README.md"
sed -i "s/你的用户名/$GITHUB_USER/g" "$PROJECT_DIR/README.md"

# 2. 创建GitHub仓库创建指南
echo "📝 创建GitHub仓库指南..."
cat > "$PROJECT_DIR/CREATE_GITHUB_REPO.md" << EOF
# 📋 创建GitHub仓库步骤

请按以下步骤在GitHub创建仓库：

## 步骤1: 访问GitHub
打开浏览器访问: https://github.com/new

## 步骤2: 填写仓库信息
- **Repository name**: quant-trading-system
- **Description**: 量化交易信号系统
- **Public** 或 **Private** (根据需求选择)
- **不要**勾选以下选项:
  - [ ] Initialize this repository with a README
  - [ ] Add .gitignore
  - [ ] Choose a license

## 步骤3: 创建仓库
点击 "Create repository" 按钮

## 步骤4: 获取仓库地址
创建成功后，页面会显示仓库地址:
\`\`\`
https://github.com/BOT0202/quant-trading-system.git
\`\`\`

## 步骤5: 返回终端继续设置
仓库创建完成后，在终端运行:
\`\`\`
cd /root/quant-auto-sync
./setup_github.sh
\`\`\`

## 验证
创建成功后，可以访问:
https://github.com/BOT0202/quant-trading-system
EOF

# 3. 创建快速启动脚本
echo "📜 创建快速启动脚本..."
cat > "$PROJECT_DIR/quick_start.sh" << 'EOF'
#!/bin/bash

# 量化系统快速启动脚本

echo "🚀 量化系统快速启动"
echo "========================================"

echo "📋 当前配置:"
echo "   用户名: BOT0202"
echo "   仓库名: quant-trading-system"
echo "   项目目录: /root/quant-auto-sync"
echo ""

echo "🔍 检查系统状态..."
echo "1. 检查目录结构:"
ls -la /root/quant-auto-sync/

echo ""
echo "2. 检查脚本权限:"
ls -la /root/quant-auto-sync/*.sh

echo ""
echo "3. 检查量化项目:"
ls -la /root/.openclaw/workspace/collaboration/shared/

echo ""
echo "📝 下一步操作:"
echo "1. 创建GitHub仓库 (如果尚未创建)"
echo "   指南: cat /root/quant-auto-sync/CREATE_GITHUB_REPO.md"
echo ""
echo "2. 设置GitHub连接"
echo "   cd /root/quant-auto-sync"
echo "   ./setup_github.sh"
echo ""
echo "3. 测试同步"
echo "   ./sync_to_github.sh"
echo ""
echo "4. 启动自动服务"
echo "   ./start_auto_sync.sh"
echo ""
echo "🌐 GitHub仓库地址:"
echo "   https://github.com/BOT0202/quant-trading-system"
EOF

chmod +x "$PROJECT_DIR/quick_start.sh"

# 4. 创建状态检查脚本
cat > "$PROJECT_DIR/check_status.sh" << 'EOF'
#!/bin/bash

# 系统状态检查脚本

echo "🔍 系统状态检查 - BOT0202"
echo "========================================"

echo "📊 1. 自动化系统状态:"
echo "   目录: /root/quant-auto-sync"
echo "   文件数: $(find /root/quant-auto-sync -type f | wc -l)"
echo "   脚本数: $(find /root/quant-auto-sync -name "*.sh" | wc -l)"
echo "   备份数: $(find /root/quant-auto-sync/backups -type d 2>/dev/null | wc -l)"
echo "   日志数: $(find /root/quant-auto-sync/logs -type f 2>/dev/null | wc -l)"

echo ""
echo "📈 2. 量化项目状态:"
echo "   项目目录: /root/.openclaw/workspace"
echo "   协作文件: $(find /root/.openclaw/workspace/collaboration -type f 2>/dev/null | wc -l)"
echo "   脚本文件: $(find /root/.openclaw/workspace -name "*.sh" | wc -l)"
echo "   文档文件: $(find /root/.openclaw/workspace -name "*.md" | wc -l)"

echo ""
echo "⚙️  3. 服务运行状态:"
if ps aux | grep -v grep | grep -q "run_hourly.sh"; then
    echo "   ✅ 自动服务正在运行"
    ps aux | grep -v grep | grep "run_hourly.sh" | awk '{print "   PID: "$2" | 启动时间: "$9}'
else
    echo "   ⚠️  自动服务未运行"
    echo "   启动命令: cd /root/quant-auto-sync && ./start_auto_sync.sh"
fi

echo ""
echo "🌐 4. GitHub配置:"
echo "   用户名: BOT0202"
echo "   仓库名: quant-trading-system"
echo "   仓库地址: https://github.com/BOT0202/quant-trading-system"

echo ""
echo "📋 5. 最近日志:"
if [ -f "/root/quant-auto-sync/logs/sync_$(date +%Y%m%d).log" ]; then
    echo "   今日同步日志:"
    tail -3 "/root/quant-auto-sync/logs/sync_$(date +%Y%m%d).log"
else
    echo "   暂无今日日志"
fi

echo ""
echo "🎯 6. 建议操作:"
if [ ! -d "/root/quant-auto-sync/.git" ]; then
    echo "   ⚠️  Git未初始化，需要运行: ./setup_github.sh"
else
    echo "   ✅ Git已初始化"
fi

if ! ps aux | grep -v grep | grep -q "run_hourly.sh"; then
    echo "   ⚠️  自动服务未运行，需要启动: ./start_auto_sync.sh"
else
    echo "   ✅ 自动服务正在运行"
fi

echo ""
echo "========================================"
echo "✅ 状态检查完成"
echo "💡 详细指南: cat /root/quant-auto-sync/README.md"
EOF

chmod +x "$PROJECT_DIR/check_status.sh"

# 5. 创建一键完成脚本
cat > "$PROJECT_DIR/one_click_setup.sh" << 'EOF'
#!/bin/bash

# 一键完成设置脚本

echo "🎯 一键完成GitHub自动化设置"
echo "========================================"

echo "📋 配置信息:"
echo "   GitHub用户: BOT0202"
echo "   仓库名称: quant-trading-system"
echo "   项目目录: /root/quant-auto-sync"
echo ""

echo "🔍 检查前置条件..."
# 检查是否已创建GitHub仓库
echo "请确认是否已在GitHub创建仓库:"
echo "   地址: https://github.com/BOT0202/quant-trading-system"
echo ""
read -p "是否已创建GitHub仓库? (y/n): " REPO_CREATED

if [[ "$REPO_CREATED" != "y" && "$REPO_CREATED" != "Y" ]]; then
    echo ""
    echo "📝 请先创建GitHub仓库:"
    echo "1. 访问 https://github.com/new"
    echo "2. 仓库名: quant-trading-system"
    echo "3. 不要初始化任何文件"
    echo "4. 创建后返回继续"
    echo ""
    read -p "按回车继续查看详细指南..." 
    cat /root/quant-auto-sync/CREATE_GITHUB_REPO.md
    exit 0
fi

echo ""
echo "🚀 开始自动化设置..."
echo ""

# 步骤1: 设置GitHub连接
echo "1. 设置GitHub连接..."
cd /root/quant-auto-sync
./setup_github.sh

echo ""
echo "2. 测试同步..."
./sync_to_github.sh

echo ""
echo "3. 启动自动服务..."
./start_auto_sync.sh

echo ""
echo "4. 检查状态..."
./check_status.sh

echo ""
echo "🎉 设置完成！"
echo "========================================"
echo "✅ 自动化系统已就绪"
echo "⏰ 每小时自动备份到GitHub"
echo "📁 本地备份保留7天"
echo "📝 所有操作都有日志记录"
echo ""
echo "🌐 GitHub仓库: https://github.com/BOT0202/quant-trading-system"
echo "📊 监控状态: ./check_status.sh"
echo "🔄 手动同步: ./sync_to_github.sh"
echo "🛑 停止服务: ./stop_auto_sync.sh"
EOF

chmod +x "$PROJECT_DIR/one_click_setup.sh"

# 6. 更新主README
cat >> "$PROJECT_DIR/README.md" << 'EOF'

## 🎯 BOT0202用户专用指南

### 已完成的配置
- ✅ GitHub用户名已设置为: BOT0202
- ✅ 仓库名称已设置为: quant-trading-system
- ✅ 所有脚本已更新配置

### 快速开始命令
```bash
# 1. 检查状态
cd /root/quant-auto-sync
./check_status.sh

# 2. 一键设置（如果已创建GitHub仓库）
./one_click_setup.sh

# 3. 快速查看
./quick_start.sh
```

### GitHub仓库
```
https://github.com/BOT0202/quant-trading-system
```

### 重要文件
- `CREATE_GITHUB_REPO.md` - 创建GitHub仓库详细步骤
- `one_click_setup.sh` - 一键完成设置
- `check_status.sh` - 系统状态检查
- `quick_start.sh` - 快速启动指南
EOF

echo ""
echo "✅ 为BOT0202用户的配置已完成！"
echo "========================================"
echo "📁 项目目录: /root/quant-auto-sync"
echo "👤 GitHub用户: BOT0202"
echo "📦 仓库名称: quant-trading-system"
echo ""
echo "🚀 可用命令:"
echo "   1. 检查状态: cd /root/quant-auto-sync && ./check_status.sh"
echo "   2. 快速启动: cd /root/quant-auto-sync && ./quick_start.sh"
echo "   3. 一键设置: cd /root/quant-auto-sync && ./one_click_setup.sh"
echo ""
echo "📝 下一步:"
echo "   1. 确保已在GitHub创建仓库: quant-trading-system"
echo "   2. 运行一键设置脚本完成配置"
echo "   3. 系统将每小时自动备份到GitHub"
echo ""
echo "🌐 GitHub仓库地址:"
echo "   https://github.com/BOT0202/quant-trading-system"
echo ""
echo "🎉 配置完成！系统已为BOT0202用户优化就绪。"