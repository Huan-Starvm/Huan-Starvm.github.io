#!/bin/bash
set -e

read -rp "请输入出口网卡名字（例如 ens17）: " IFACE
if [[ -z "$IFACE" ]]; then
  echo "未输入网卡名，退出。"
  exit 1
fi
echo "=> 使用网卡：$IFACE"

URL="https://github.raw.starvm.top/Huan-Starvm/Huan-Starvm.github.io/refs/heads/main/app/tun2socks-linux-amd64.zip"
ZIP="tun2socks-linux-amd64.zip"
BIN="tun2socks-linux-amd64"
CMD="/usr/local/bin/tun2socks"
UNIT="/etc/systemd/system/tun2socks.service"

S_USER="WwK72eJWFy"
S_PASS="yF9BuVPx7S"
S_HOST="2408:8653:dc00:20b:600::c"
S_PORT="46627"

if ! command -v unzip &>/dev/null; then
  echo "安装 unzip..."
  if command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y unzip
  elif command -v yum &>/dev/null; then
    sudo yum install -y unzip
  else
    echo "请手动安装 unzip" >&2
    exit 1
  fi
fi

if ! command -v tun2socks &>/dev/null; then
  echo "下载 tun2socks..."
  wget -q --show-progress -O "$ZIP" "$URL"
  unzip -o "$ZIP" >/dev/null
  sudo mv "$BIN" "$CMD"
  sudo chmod +x "$CMD"
  rm -f "$ZIP"
else
  echo "检测到 tun2socks，跳过下载"
fi

echo "写入 systemd 服务文件 $UNIT ..."
sudo tee "$UNIT" >/dev/null <<EOF
[Unit]
Description=TUN2SOCKS 全局代理
After=network-online.target
Wants=network-online.target

[Service]
Type=simple

ExecStartPre=-/usr/bin/ip tuntap add mode tun dev tun0
ExecStartPre=-/usr/bin/ip addr add 198.18.0.1/15 dev tun0
ExecStartPre=/usr/bin/ip link set tun0 up

ExecStartPre=/usr/bin/sh -c '
  OLD=\$(ip route | awk "/default/ {print \\\$3;exit}");
  ip route del default || true;
  ip route add default dev tun0 metric 1;
  [ -n "\$OLD" ] && ip route add default via \$OLD metric 10 || true
'

ExecStart=$CMD -device tun://198.18.0.1/15@tun0 -proxy socks5://$S_USER:$S_PASS@[$S_HOST]:$S_PORT -interface $IFACE

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "重载 systemd 并启动 tun2socks 服务..."
sudo systemctl daemon-reload
sudo systemctl enable --now tun2socks.service

cat <<EOT

====================================================================
✅ tun2socks 服务已启动！

查看日志：journalctl -u tun2socks -f
停止服务：systemctl stop tun2socks
修改出口网卡：编辑 $UNIT 中 ExecStart 行，修改 -interface 后的网卡名，执行
              systemctl daemon-reload && systemctl restart tun2socks
====================================================================
EOT
