# 🚀 每小时自动GitHub上传系统 - 完整指南

## 🎯 系统概述

已为你设置了一个完整的自动化系统，**每小时自动备份量化交易信号系统项目到GitHub**。

## 📁 系统结构

### 1. 主项目目录
```
/root/quant-auto-sync/
├── sync_to_github.sh      # 核心同步脚本
├── setup_github.sh        # GitHub仓库设置
├── run_hourly.sh          # 每小时运行脚本
├── start_auto_sync.sh     # 启动自动服务
├── stop_auto_sync.sh      # 停止自动服务
├── README.md              # 使用指南
├── backups/               # 本地备份（保留7天）
└── logs/                  # 运行日志
```

### 2. 源项目目录
```
/root/.openclaw/workspace/
├── collaboration/         # 量化系统协作文件
├── *.sh                   # 所有协作脚本
├── *.md                   # 所有文档
└── AUTO_GITHUB_GUIDE.md   # 本指南
```

## 🚀 快速开始（3步完成）

### 步骤1：在GitHub创建仓库
1. 访问 https://github.com/new
2. 填写信息：
   - Repository name: `quant-trading-system`（或其他名称）
   - Description: `量化交易信号系统`
   - 选择 Public（公开）或 Private（私有）
   - **不要**初始化README、.gitignore等

### 步骤2：设置GitHub连接
```bash
cd /root/quant-auto-sync
./setup_github.sh
```
按照提示操作，输入你的GitHub用户名。

### 步骤3：启动自动服务
```bash
cd /root/quant-auto-sync
./start_auto_sync.sh
```
服务将在后台运行，每小时自动同步一次。

## 🔧 详细操作指南

### 1. 手动运行一次同步（测试）
```bash
cd /root/quant-auto-sync
./sync_to_github.sh
```

### 2. 查看同步日志
```bash
# 查看今日同步日志
tail -f /root/quant-auto-sync/logs/sync_$(date +%Y%m%d).log

# 查看所有日志文件
ls -la /root/quant-auto-sync/logs/
```

### 3. 查看本地备份
```bash
ls -la /root/quant-auto-sync/backups/
```

### 4. 查看GitHub仓库
```
https://github.com/你的用户名/quant-trading-system
```

## ⚙️ 系统配置

### 修改同步频率
默认每小时同步一次，如需修改：
```bash
# 编辑运行脚本
vim /root/quant-auto-sync/run_hourly.sh
# 修改 sleep 3600（3600秒=1小时）
# 例如：sleep 1800 = 每30分钟
```

### 修改备份保留时间
默认保留7天备份，如需修改：
```bash
# 编辑同步脚本
vim /root/quant-auto-sync/sync_to_github.sh
# 修改 -mtime +7（7天）
# 例如：-mtime +30 = 保留30天
```

### 添加GitHub Token认证
如果需要更安全的认证：
```bash
# 1. 创建GitHub Token
# 访问：https://github.com/settings/tokens
# 选择 repo 权限

# 2. 更新远程仓库地址
cd /root/quant-auto-sync
git remote set-url origin https://你的token@github.com/用户名/仓库.git
```

## 📊 监控与管理

### 检查服务状态
```bash
# 查看是否在运行
ps aux | grep run_hourly

# 查看进程详情
ps aux | grep -v grep | grep run_hourly
```

### 查看Git状态
```bash
cd /root/quant-auto-sync
git status          # 查看更改状态
git log --oneline -5  # 查看最近提交
git remote -v       # 查看远程仓库
```

### 停止自动服务
```bash
cd /root/quant-auto-sync
./stop_auto_sync.sh
```

### 重新启动服务
```bash
cd /root/quant-auto-sync
./stop_auto_sync.sh
./start_auto_sync.sh
```

## 🐛 故障排除

### 问题1：GitHub推送失败
**症状**：日志中显示推送失败
**解决**：
```bash
# 检查网络连接
ping github.com

# 检查GitHub仓库权限
cd /root/quant-auto-sync
git remote -v

# 手动测试推送
git push origin main
```

### 问题2：服务没有运行
**症状**：`ps aux | grep run_hourly` 没有结果
**解决**：
```bash
# 重新启动
cd /root/quant-auto-sync
./start_auto_sync.sh

# 查看启动日志
tail -f /root/quant-auto-sync/logs/daemon.log
```

### 问题3：磁盘空间不足
**症状**：备份失败或系统变慢
**解决**：
```bash
# 查看磁盘使用
df -h

# 手动清理旧备份
find /root/quant-auto-sync/backups -type d -mtime +7 -exec rm -rf {} \;

# 清理旧日志
find /root/quant-auto-sync/logs -type f -mtime +30 -delete
```

### 问题4：文件权限错误
**症状**：脚本无法执行
**解决**：
```bash
# 修复权限
chmod +x /root/quant-auto-sync/*.sh
chmod +x /root/quant-auto-sync/scripts/*.sh 2>/dev/null
```

## 🔄 工作流程说明

### 每小时自动执行：
1. **备份文件**：复制当前项目状态到本地备份目录
2. **更新Git目录**：准备要提交的文件
3. **Git操作**：
   - 检查是否有更改
   - 如果有更改，提交并推送到GitHub
   - 如果没有更改，跳过提交
4. **清理旧文件**：删除7天前的本地备份

### 手动触发：
任何时候都可以手动运行 `./sync_to_github.sh` 立即同步。

## 📈 性能优化建议

### 1. 排除大文件
如果项目中有大文件，建议添加到 `.gitignore`：
```bash
# 在项目根目录创建 .gitignore
cat > /root/.openclaw/workspace/.gitignore << EOF
# 忽略大文件
*.zip
*.tar.gz
*.rar
*.pdf
*.mp4

# 忽略临时文件
*.tmp
*.log
*.bak

# 忽略敏感信息
*secret*
*password*
*key*
EOF
```

### 2. 使用Git LFS（大文件存储）
如果必须包含大文件：
```bash
# 安装Git LFS
git lfs install

# 跟踪大文件类型
git lfs track "*.zip"
git lfs track "*.tar.gz"

# 提交更改
git add .gitattributes
git commit -m "添加Git LFS支持"
```

### 3. 增量备份优化
当前是全量备份，如果文件很多，可以考虑增量备份。

## 🛡️ 安全注意事项

### 1. 保护敏感信息
- 不要将密码、API密钥等提交到GitHub
- 使用环境变量或配置文件排除敏感信息
- 考虑使用私有仓库

### 2. 定期检查
- 每周检查一次同步日志
- 每月检查一次GitHub仓库状态
- 定期验证备份的完整性

### 3. 灾难恢复
- 本地备份保留7天，提供短期恢复
- GitHub仓库作为长期远程备份
- 重要版本可以打Tag标记

## 📋 检查清单

### 初始设置检查
- [ ] GitHub仓库已创建
- [ ] `./setup_github.sh` 已运行
- [ ] `./sync_to_github.sh` 测试成功
- [ ] `./start_auto_sync.sh` 已启动

### 日常维护检查
- [ ] 服务正在运行 (`ps aux | grep run_hourly`)
- [ ] 最近同步成功（查看日志）
- [ ] GitHub仓库有最新提交
- [ ] 磁盘空间充足 (`df -h`)

### 月度检查
- [ ] 清理旧备份和日志
- [ ] 验证GitHub仓库完整性
- [ ] 更新系统脚本（如有需要）
- [ ] 检查安全设置

## 🆘 紧急情况处理

### 服务崩溃
```bash
# 1. 停止服务
cd /root/quant-auto-sync && ./stop_auto_sync.sh

# 2. 查看崩溃日志
tail -100 /root/quant-auto-sync/logs/daemon.log

# 3. 修复问题后重启
cd /root/quant-auto-sync && ./start_auto_sync.sh
```

### 数据丢失恢复
```bash
# 从最新备份恢复
LATEST_BACKUP=$(ls -td /root/quant-auto-sync/backups/* | head -1)
cp -r "$LATEST_BACKUP"/* /root/.openclaw/workspace/

# 从GitHub恢复
cd /root/quant-auto-sync
git fetch origin
git reset --hard origin/main
```

### 重新初始化系统
```bash
# 完全重新设置
cd /root/quant-auto-sync
./stop_auto_sync.sh
rm -rf .git
./setup_github.sh
./start_auto_sync.sh
```

## 🎉 完成状态

### ✅ 已完成的设置：
1. **自动化同步系统** - 每小时自动运行
2. **本地备份机制** - 保留7天历史
3. **完整日志系统** - 所有操作都有记录
4. **管理脚本** - 启动、停止、监控

### 🚀 立即验证：
```bash
# 1. 检查系统状态
cd /root/quant-auto-sync && ./start_auto_sync.sh

# 2. 查看GitHub仓库
echo "请访问: https://github.com/你的用户名/quant-trading-system"

# 3. 查看运行状态
ps aux | grep run_hourly
tail -f /root/quant-auto-sync/logs/sync_$(date +%Y%m%d).log
```

### 📞 获取帮助：
如果遇到问题，可以：
1. 查看日志文件：`/root/quant-auto-sync/logs/`
2. 检查Git状态：`cd /root/quant-auto-sync && git status`
3. 重新运行设置：`cd /root/quant-auto-sync && ./setup_github.sh`

---
**系统设置时间**: $(date)  
**项目状态**: 自动化GitHub上传已就绪  
**下次自动运行**: 下一小时的整点  

**你的量化交易信号系统现在已配置为每小时自动备份到GitHub！** 🎯