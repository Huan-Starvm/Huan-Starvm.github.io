#!/bin/bash
set -e

# 交互输入出口网卡
read -p "请输入出网网卡名字（例如 ens17）: " IFACE
if [ -z "$IFACE" ]; then
  echo "错误：未输入网卡名字，脚本退出。"
  exit 1
fi

# tun2socks 下载地址和文件名
URL="https://github.raw.starvm.top/Huan-Starvm/Huan-Starvm.github.io/refs/heads/main/app/tun2socks-linux-amd64.zip"
ZIP_NAME="tun2socks-linux-amd64.zip"
BIN_NAME="tun2socks-linux-amd64"
INSTALL_PATH="/usr/local/bin/tun2socks"

# SOCKS5 配置
SOCKS_USER="WwK72eJWFy"
SOCKS_PASS="yF9BuVPx7S"
SOCKS_HOST="2408:8653:dc00:20b:600::c"
SOCKS_PORT="46627"

echo "[*] 检测 unzip 是否安装"
if ! command -v unzip >/dev/null 2>&1; then
  echo "unzip 未安装，开始安装..."
  if command -v apt >/dev/null 2>&1; then
    sudo apt update && sudo apt install -y unzip
  elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y unzip
  else
    echo "请手动安装 unzip 后重试"
    exit 1
  fi
fi

if ! command -v tun2socks >/dev/null 2>&1; then
  echo "[*] 下载 tun2socks 压缩包..."
  wget -O $ZIP_NAME $URL

  echo "[*] 解压缩 $ZIP_NAME ..."
  unzip -o $ZIP_NAME

  echo "[*] 移动并重命名可执行文件到 $INSTALL_PATH ..."
  sudo mv $BIN_NAME $INSTALL_PATH
  sudo chmod +x $INSTALL_PATH

  echo "[*] 清理临时文件..."
  rm -f $ZIP_NAME
else
  echo "[*] tun2socks 已安装，跳过下载安装"
fi

TUN_IF="tun0"
echo "[*] 创建 TUN 设备 $TUN_IF ..."
ip tuntap add mode tun dev $TUN_IF 2>/dev/null || true
ip addr add 198.18.0.1/15 dev $TUN_IF || true
ip link set $TUN_IF up

echo "[*] 设置默认路由走 $TUN_IF ..."
OLD_GW=$(ip route | awk '/default/ {print $3; exit}')
ip route del default || true
ip route add default via 198.18.0.1 dev $TUN_IF metric 1
ip route add default via $OLD_GW metric 10

echo "[*] 启动 tun2socks，使用 SOCKS5 代理 $SOCKS_HOST:$SOCKS_PORT ..."
exec tun2socks \
  -device tun://$TUN_IF \
  -proxy socks5://$SOCKS_USER:$SOCKS_PASS@[$SOCKS_HOST]:$SOCKS_PORT \
  -interface $IFACE
