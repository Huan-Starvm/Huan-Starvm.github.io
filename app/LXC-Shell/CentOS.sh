#!/bin/bash

# 输出版权信息
echo "此脚本由 星空云(https://www.starvm.cn) 编写，免费开源，如为收费均为倒卖，请勿相信"

# 输出提示信息
echo "正在运行中，请勿断开SSH..."

# 更新包列表并升级所有软件包
yum update -y

# 安装必需的软件包
yum install -y vim sudo net-tools curl

# 修改 SSH 配置以允许 root 登录
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 重启 SSH 服务
systemctl restart ssh

echo "运行完成！"
