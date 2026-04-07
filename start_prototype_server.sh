#!/bin/bash

# GoldQuant原型公网服务器启动脚本
# 公网IP: 43.153.157.218
# 端口: 8080

echo "🚀 启动GoldQuant原型公网服务器..."
echo "公网IP: 43.153.157.218"
echo "端口: 8080"
echo ""

# 检查Python3是否可用
if command -v python3 &> /dev/null; then
    echo "✅ 检测到Python3，使用Python HTTP服务器"
    echo ""
    echo "📱 访问地址:"
    echo "主页面: http://43.153.157.218:8080/prototype_preview.html"
    echo "登录页面: http://43.153.157.218:8080/collaboration/product/prototype_refined/html/index.html"
    echo "仪表盘: http://43.153.157.218:8080/collaboration/product/prototype_refined/html/dashboard.html"
    echo ""
    echo "📋 所有页面列表:"
    echo "1. 登录页面: index.html"
    echo "2. 主仪表盘: dashboard.html"
    echo "3. 信号详情页: signal_detail.html"
    echo "4. 交易执行页: trade_execution.html"
    echo "5. 策略管理页: strategy_management.html"
    echo "6. 账户管理页: account_management.html"
    echo "7. 数据分析页: data_analysis.html"
    echo ""
    echo "⚡ 启动服务器..."
    cd /root/.openclaw/workspace
    python3 -m http.server 8080 --bind 0.0.0.0
    
elif command -v php &> /dev/null; then
    echo "✅ 检测到PHP，使用PHP内置服务器"
    echo ""
    echo "📱 访问地址: http://43.153.157.218:8080"
    echo ""
    echo "⚡ 启动服务器..."
    cd /root/.openclaw/workspace
    php -S 0.0.0.0:8080
    
else
    echo "❌ 未找到Python3或PHP，无法启动HTTP服务器"
    echo "请安装Python3: apt-get install python3"
    exit 1
fi