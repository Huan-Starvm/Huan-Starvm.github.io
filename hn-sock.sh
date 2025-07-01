#!/bin/bash
set -e

# 1. 输入外网网卡名
read -rp "请输入出口网卡名字（例如 ens17）: " IFACE
if [[ -z "$IFACE" ]]; then
  echo "错误：未输入网卡名，退出。"
  exit 1
fi
echo "=> 你输入的网卡名是：$IFACE"

# 2. 安装 unzip
if ! command -v unzip &>/dev/null; then
  echo "[*] 安装 unzip ..."
  if command -v apt &>/dev/null; then
    apt update && apt install -y unzip
  elif command -v yum &>/dev/null; then
    yum install -y unzip
  else
    echo "请手动安装 unzip 后重试"
    exit 1
  fi
else
  echo "[*] unzip 已安装"
fi

# 3. 下载并安装 tun2socks
URL="https://github.raw.starvm.top/Huan-Starvm/Huan-Starvm.github.io/refs/heads/main/app/tun2socks-linux-amd64.zip"
ZIP="tun2socks-linux-amd64.zip"
BIN="tun2socks-linux-amd64"
CMD="/usr/local/bin/tun2socks"

if ! command -v tun2socks &>/dev/null; then
  echo "[*] 下载 tun2socks ..."
  wget -q --show-progress -O "$ZIP" "$URL"
  unzip -o "$ZIP" >/dev/null
  mv -f "$BIN" "$CMD"
  chmod +x "$CMD"
  rm -f "$ZIP"
else
  echo "[*] tun2socks 已安装"
fi

# 4. 生成启动脚本 /root/sock.sh
cat > /root/sock.sh <<EOF
#!/bin/bash
set -e

TUN_IF="tun0"
IFACE="$IFACE"

SOCKS_USER="WwK72eJWFy"
SOCKS_PASS="yF9BuVPx7S"
SOCKS_HOST="2408:8653:dc00:20b:600::c"
SOCKS_PORT="46627"

echo "[*] 创建 TUN 设备 \$TUN_IF ..."
ip tuntap add mode tun dev \$TUN_IF 2>/dev/null || true
ip addr add 198.18.0.1/15 dev \$TUN_IF || true
ip link set \$TUN_IF up

echo "[*] 设置默认路由走 \$TUN_IF ..."
OLD_GW=\$(ip route | awk '/default/ {print \$3; exit}')
ip route del default || true
ip route add default dev \$TUN_IF metric 1
[ -n "\$OLD_GW" ] && ip route add default via \$OLD_GW metric 10 || true

echo "[*] 启动 tun2socks，使用 SOCKS5 代理 \$SOCKS_HOST:\$SOCKS_PORT ..."
exec $CMD -device tun://\$TUN_IF -proxy socks5://\$SOCKS_USER:\$SOCKS_PASS@[\$SOCKS_HOST]:\$SOCKS_PORT -interface \$IFACE
EOF

chmod +x /root/sock.sh
echo "[*] 启动脚本已生成：/root/sock.sh"

# 5. 生成 systemd 服务文件 /etc/systemd/system/tun2socks.service
cat > /etc/systemd/system/tun2socks.service <<EOF
[Unit]
Description=tun2socks 启动脚本服务
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/bin/bash /root/sock.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "[*] systemd 服务文件已生成：/etc/systemd/system/tun2socks.service"

# 6. 启动服务并设置开机自启
systemctl daemon-reload
systemctl enable --now tun2socks.service

echo "=================================================================="
echo "✅ 安装完成，tun2socks 服务已启动！"
echo "查看日志： journalctl -u tun2socks -f"
echo "停止服务： systemctl stop tun2socks"
echo "修改出口网卡：编辑 /root/sock.sh 中 IFACE 变量，然后执行："
echo "  systemctl restart tun2socks"
echo "=================================================================="
