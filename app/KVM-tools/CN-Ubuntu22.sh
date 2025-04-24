#!/bin/sh

# 更改软件源
cat > /etc/apt/sources.list << EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
EOF

# 更新软件包索引
apt-get update

# 安装常用程序
apt-get install wget net-tools bash sudo vim ifupdown -y

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

# 解锁APT源
sed -i '$a apt_preserve_sources_list: true' /etc/cloud/cloud.cfg

# 清除hosts文件内的无用字段
sed -i '/^#/d' /etc/hosts

# 重启cloud-init
systemctl restart cloud-init

# 设置上海时区
timedatectl set-timezone "Asia/Shanghai"

# 安装chrony组件
apt install chrony -y

# 编辑chrony配置文件为阿里云源
sed -i '/^pool ntp\.ubuntu\.com[[:space:]]*iburst maxsources 4$/{
N
/0\.ubuntu\.pool\.ntp\.org iburst maxsources 1$/{
N
/1\.ubuntu\.pool\.ntp\.org iburst maxsources 1$/{
N
/2\.ubuntu\.pool\.ntp\.org iburst maxsources 2$/c\
pool ntp1.aliyun.com iburst maxsources 4\
pool ntp2.aliyun.com iburst maxsources 1\
pool ntp3.aliyun.com iburst maxsources 1\
pool ntp4.aliyun.com iburst maxsources 2\
pool ntp5.aliyun.com iburst maxsources 2
}
}
}
' /etc/chrony/chrony.conf

# 重启chrony并开机自启
systemctl restart chrony && systemctl enable chrony

# 输出消息
echo -e "${Info}执行完毕"
