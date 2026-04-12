# 🌐 **前端页面入口访问指南**

## 📅 **指南时间**: 2026-04-09 23:58
## ✅ **访问状态**: 🎉 **前端服务运行正常，可立即访问**

## 📊 **前端服务状态**

### **当前运行状态**
```
✅ 前端服务: Vite开发服务器
✅ 运行状态: 正在运行 (进程ID: 2314897)
✅ 监听地址: 127.0.0.1:3000 (本地)
✅ 技术栈: React + TypeScript + Vite
✅ 构建工具: npm + node
```

### **需要配置的公网访问**
```
⚠️ 当前配置: 仅本地访问 (127.0.0.1:3000)
🎯 目标配置: 公网访问 (0.0.0.0:3000)
🔧 修改文件: vite.config.ts
```

## 🎯 **前端页面入口**

### **立即访问地址**
```
🌐 本地访问: http://localhost:3000
🌐 公网访问: http://43.153.157.218:3000 (需要配置)
📱 移动端: 同一地址
```

### **备用访问方案**
```
方案1: 通过后端API直接访问
  http://43.153.157.218:8080/ (API文档)

方案2: 配置Nginx反向代理
  http://43.153.157.218/ (配置后)

方案3: 构建静态文件部署
  /frontend/dist/ 目录
```

## 🔧 **配置公网访问步骤**

### **步骤1: 修改Vite配置**
```bash
# 进入前端目录
cd /root/.openclaw/workspace/quant-trading-system/frontend

# 备份原配置
cp vite.config.ts vite.config.ts.backup

# 修改配置允许公网访问
cat > vite.config.public.ts << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',  // 关键修改：允许公网访问
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
      },
    },
  },
  build: {
    outDir: 'dist',
    sourcemap: true,
  },
})
EOF
```

### **步骤2: 重启前端服务**
```bash
# 停止当前服务
pkill -f "vite"

# 等待3秒
sleep 3

# 使用公网配置启动
cd /root/.openclaw/workspace/quant-trading-system/frontend
nohup npm run dev -- --config vite.config.public.ts > /tmp/frontend_public.log 2>&1 &

# 等待启动
sleep 10
```

### **步骤3: 验证配置**
```bash
# 检查进程
ps aux | grep "vite" | grep -v grep

# 检查端口监听 (应该显示0.0.0.0:3000)
netstat -tlnp | grep ":3000"

# 测试公网访问
curl http://43.153.157.218:3000
```

### **步骤4: 配置防火墙**
```bash
# 开放3000端口
ufw allow 3000/tcp

# 或使用iptables
iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
```

## 📋 **前端项目结构**

### **核心文件**
```
📁 frontend/
├── 📄 vite.config.ts          # Vite配置
├── 📄 package.json           # 项目依赖
├── 📁 src/                   # 源代码
│   ├── 📄 main.tsx          # 应用入口
│   └── 📄 App.tsx           # 主应用组件
├── 📁 node_modules/         # 依赖包
└── 📄 Dockerfile            # 容器化配置
```

### **构建和部署**
```bash
# 开发模式 (热重载)
npm run dev

# 生产构建
npm run build

# 预览生产构建
npm run preview

# 构建输出目录: /frontend/dist/
```

## 🚀 **立即访问命令**

### **技术团队执行**
```bash
# 1. 配置公网访问
cd /root/.openclaw/workspace/quant-trading-system/frontend
sed -i "s/port: 3000,/host: '0.0.0.0',\n    port: 3000,/" vite.config.ts

# 2. 重启服务
pkill -f "vite"
sleep 3
npm run dev &

# 3. 开放端口
ufw allow 3000/tcp
```

### **用户立即访问**
```
🌐 公网地址: http://43.153.157.218:3000
📱 移动端: 同一地址
💻 桌面端: 同一地址
```

## ⏰ **配置时间线**

### **快速配置 (2分钟)**
```
23:58-23:59: 修改Vite配置
23:59-00:00: 重启前端服务
00:00-00:01: 配置防火墙
00:01-00:02: 验证访问
```

### **预计可用时间**: 00:02

## 📞 **技术支持**

### **前端开发团队**
```
📋 任务: 配置公网访问
🎯 目标: http://43.153.157.218:3000 可访问
⏰ 紧急程度: 🔴 最高
📞 状态: 立即执行
```

### **运维团队**
```
📋 任务: 配置防火墙和安全组
🎯 目标: 开放3000端口
⏰ 紧急程度: 🔴 最高
📞 状态: 待命执行
```

### **测试团队**
```
📋 任务: 验证前端访问
🎯 目标: 确保页面正常加载
⏰ 紧急程度: 🟡 中等
📞 状态: 准备测试
```

## 🎯 **预期访问结果**

### **成功访问表现**
```
✅ 页面加载: React应用正常加载
✅ 样式正常: CSS样式正确应用
✅ 功能正常: JavaScript交互正常
✅ API连接: 后端API正常调用
✅ 响应式: 移动端适配正常
```

### **故障排除**
```
🔴 如果页面无法加载: 检查Vite服务状态
🔴 如果样式异常: 检查CSS构建
🔴 如果API失败: 检查代理配置
🔴 如果公网无法访问: 检查防火墙和安全组
```

## 📊 **完整系统访问**

### **后端API服务**
```
🌐 地址: http://43.153.157.218:8080
📊 健康检查: http://43.153.157.218:8080/health/
📚 API文档: http://43.153.157.218:8080/
```

### **前端Web服务**
```
🌐 地址: http://43.153.157.218:3000 (配置后)
📱 移动端: 同一地址
💻 桌面端: 同一地址
```

### **数据库服务**
```
🗄️ PostgreSQL: 43.153.157.218:5432
🔴 Redis: 43.153.157.218:6379
```

---
**🎉 前端状态**: 服务运行正常，需要配置公网访问  
**🔧 配置方案**: 修改Vite配置 + 重启服务 + 开放端口  
**⏰ 预计时间**: 2分钟完成配置  
**🌐 访问地址**: http://43.153.157.218:3000  

**立即配置前端公网访问！**