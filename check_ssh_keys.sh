#!/bin/bash

# SSH密钥检查脚本

echo "🔑 SSH密钥检查"
echo "========================================"

# 1. 检查.ssh目录
echo "1. 检查.ssh目录..."
if [ -d ~/.ssh ]; then
    echo "✅ .ssh目录存在: ~/.ssh"
    ls -la ~/.ssh/
else
    echo "❌ .ssh目录不存在"
fi

echo ""

# 2. 检查常见SSH密钥文件
echo "2. 检查SSH密钥文件..."
KEY_FILES=("id_rsa" "id_rsa.pub" "id_ed25519" "id_ed25519.pub" "id_dsa" "id_dsa.pub")

for key_file in "${KEY_FILES[@]}"; do
    if [ -f ~/.ssh/$key_file ]; then
        echo "✅ 找到: ~/.ssh/$key_file"
        if [[ "$key_file" == *.pub ]]; then
            echo "   公钥内容:"
            cat ~/.ssh/$key_file
        fi
    fi
done

echo ""

# 3. 检查GitHub已知的SSH密钥
echo "3. 检查GitHub SSH配置..."
if [ -f ~/.ssh/known_hosts ]; then
    echo "✅ known_hosts文件存在"
    grep -i github ~/.ssh/known_hosts 2>/dev/null && echo "   包含GitHub主机" || echo "   不包含GitHub主机"
else
    echo "❌ known_hosts文件不存在"
fi

echo ""

# 4. 检查SSH代理
echo "4. 检查SSH代理..."
if command -v ssh-add &> /dev/null; then
    echo "✅ ssh-add命令可用"
    ssh-add -l 2>/dev/null && echo "   SSH代理中有密钥" || echo "   SSH代理中无密钥"
else
    echo "❌ ssh-add命令不可用"
fi

echo ""

# 5. 创建新的SSH密钥（如果需要）
echo "5. 创建新的SSH密钥..."
read -p "是否创建新的SSH密钥？(y/n): " CREATE_KEY

if [[ "$CREATE_KEY" == "y" || "$CREATE_KEY" == "Y" ]]; then
    echo ""
    echo "🔧 创建新的SSH密钥..."
    ssh-keygen -t ed25519 -C "BOT0202@quant-trading-system" -f ~/.ssh/id_ed25519 -N ""
    
    if [ $? -eq 0 ]; then
        echo "✅ SSH密钥创建成功！"
        echo ""
        echo "📋 公钥内容 (~/.ssh/id_ed25519.pub):"
        cat ~/.ssh/id_ed25519.pub
        echo ""
        echo "💡 将上面的公钥添加到GitHub:"
        echo "   1. 访问 https://github.com/settings/keys"
        echo "   2. 点击 'New SSH key'"
        echo "   3. 粘贴上面的公钥内容"
        echo "   4. 标题: quant-trading-system"
    else
        echo "❌ SSH密钥创建失败"
    fi
fi

echo ""
echo "========================================"
echo "📋 SSH密钥位置总结:"
echo "   私钥: ~/.ssh/id_rsa 或 ~/.ssh/id_ed25519"
echo "   公钥: ~/.ssh/id_rsa.pub 或 ~/.ssh/id_ed25519.pub"
echo ""
echo "🚀 使用SSH密钥推送到GitHub:"
echo "   1. 将公钥添加到GitHub"
echo "   2. 测试连接: ssh -T git@github.com"
echo "   3. 使用SSH地址: git@github.com:BOT0202/quant-trading-system1.git"
echo ""
echo "📞 如果需要帮助，请将公钥内容发送给我"