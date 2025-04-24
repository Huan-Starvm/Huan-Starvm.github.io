#!/bin/sh

# 更改软件源同时更新软件包索引以及系统环境
bash <(curl -sSL https://gitee.com/starvm/storage/raw/master/app/KVM-tools/main.sh) --source mirrors.tencent.com --protocol http --use-intranet-source false --install-epel true --backup false --upgrade-software true --clean-cache false --ignore-backup-tips

# 安装常用程序
yum install wget net-tools bash sudo vim -y

# 开启BBR
#kernel_version=$(uname -r)

#if [[ $(echo ${kernel_version} | awk -F'.' '{print $1}') -ge 5 ]]; then
#    echo "net.core.default_qdisc=cake" >> /etc/sysctl.conf
#    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
#else
#    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
#    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
#fi

#sysctl -p

# 解锁hostname和hosts文件
sed -i '/^\s*- update_hostname/d;/^\s*- update_etc_hosts/d' /etc/cloud/cloud.cfg

# 清除hosts文件内的无用字段
sed -i '/^#/d' /etc/hosts

# 重启cloud-init
systemctl restart cloud-init

# 设置上海时区
timedatectl set-timezone "Asia/Shanghai"

# 安装chrony组件
yum install chrony -y

# 编辑chrony配置文件为阿里云源
sed -i 's/^pool 2.centos.pool.ntp.org iburst$/pool ntp1.aliyun.com iburst/; /pool ntp1.aliyun.com iburst/a pool ntp2.aliyun.com iburst\npool ntp3.aliyun.com iburst\npool ntp4.aliyun.com iburst\npool ntp5.aliyun.com iburst' /etc/chrony.conf

# 重启chrony并开机自启
systemctl restart chronyd && systemctl enable chronyd

# 输出消息
echo -e "${Info}执行完毕"