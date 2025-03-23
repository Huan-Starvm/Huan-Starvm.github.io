#!/bin/sh

# 更新软件包索引
apk update

# 安装 OpenSSH 服务器
apk add openssh

# 启用 sshd 服务
rc-update add sshd
service sshd start

# 允许 root 通过 SSH 登录
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config

# 允许密码登录
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 重启 SSH 以应用更改
service sshd restart

echo "OpenSSH 安装完成，并已启用 root 密码登录"