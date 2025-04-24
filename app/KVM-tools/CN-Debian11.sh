#!/bin/sh

# 更新软件包索引
cat > /etc/apt/sources.list << EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb http://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
deb-src http://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
EOF

# 更新软件包索引以及系统环境
export DEBIAN_FRONTEND=noninteractive
echo "openssh-server ssh/permit-root-login select Yes" | sudo debconf-set-selections
echo "openssh-server ssh/password-authentication boolean true" | sudo debconf-set-selections
apt-get update && apt-get full-upgrade -y

# 清理无用软件包
apt-get autoremove -y

# 安装常用程序
apt-get install wget net-tools bash sudo vim -y

# 获取127.0.0.1 IP
ifdown lo && ifup lo

# 开启BBR
kernel_version=$(uname -r)

if [[ $(echo ${kernel_version} | awk -F'.' '{print $1}') -ge 5 ]]; then
    echo "net.core.default_qdisc=cake" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
else
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
fi

sysctl -p

# 解锁hostname和hosts文件
sed -i '/^\s*- update_hostname/d;/^\s*- update_etc_hosts/d' /etc/cloud/cloud.cfg

# 清除hosts文件内的无用字段
sed -i '/^#/d' /etc/hosts

# 重启cloud-init
systemctl restart cloud-init

# 设置上海时区
timedatectl set-timezone "Asia/Shanghai"

# 安装chrony组件
apt install chrony -y

# 编辑chrony配置文件为阿里云源
sed -i 's/^pool 2.debian.pool.ntp.org iburst$/pool ntp1.aliyun.com iburst/; /pool ntp1.aliyun.com iburst/a pool ntp2.aliyun.com iburst\npool ntp3.aliyun.com iburst\npool ntp4.aliyun.com iburst\npool ntp5.aliyun.com iburst' /etc/chrony/chrony.conf

# 重启chrony并开机自启
systemctl restart chrony && systemctl enable chrony

# 输出消息
echo -e "${Info}执行完毕"
