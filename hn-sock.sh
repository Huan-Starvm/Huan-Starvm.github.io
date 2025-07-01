#!/bin/bash
set -e

# 1. 让用户输入外网网卡名
read -rp "请输入出口网卡名字（例如 ens17）: " IFACE
if [[ -z "$IFACE" ]]; then
  echo "未输入网卡名，退出。"
  exit 1
fi
echo "=> 使用网卡：$IFACE"

# 2. 安装 unzip（如果未安装）
if ! command -v unzip &>/dev/null; then
  echo "安装 unzip..."
  if command -v apt &>/dev/null; then
    apt update && apt install -y unzip
  elif command -v yum &>/dev/null; then
    yum install -y unzip
  else
    echo "请手动安装 unzip" >&2
    exit 1
  fi
else
  echo "检测到 unzip，跳过安装"
fi

# 3. 下载 tun2socks 并安装（如果未安装）
URL="https://github.raw.starvm.top/Huan-Starvm/Huan-Starvm.github.io/refs/heads/main/app/tun2socks-linux-amd64.zip"
ZIP="tun2socks-linux-amd64.zip"
BIN="tun2socks-linux-amd64"
CMD="/usr/local/bin/tun2socks"

if ! command -v tun2socks &>/dev/null; then
  echo "下载 tun2socks..."
  wget -q --show-progress -O "$ZIP" "$URL"
  unzip -o "$ZIP" >/dev/null
  mv -f "$BIN" "$CMD"
  chmod +x "$CMD"
  rm -f "$ZIP"
else
  echo "检测到 tun2socks，跳过下载"
fi

# 4. 生成启动脚本 run-tun2socks.sh
RUN_SH="/usr/local/bin/run-tun2socks.sh"
SOCKS_USER="WwK72eJWFy"
SOCKS_PASS="yF9BuVPx7S"
SOCKS_HOST="2408:8653:dc00:20b:600::c"
SOCKS_PORT="46627"

cat > "$RUN_SH" <<EOF
#!/bin/bash
set -e

IFACE="$IFACE"

# 创建 tun0 设备及配置
ip tuntap add mode tun dev tun0 || true
ip addr add 198.18.0.1/15 dev tun0 || true
ip link set tun0 up

# 调整默认路由
OLD=\$(ip route | awk '/default/ {print \$3; exit}')
ip route del default || true
ip route add default dev tun0 metric 1
[ -n "\$OLD" ] && ip route add default via \$OLD metric 10 || true

# 启动 tun2socks
exec $CMD -device tun://198.18.0.1/15@tun0 -proxy socks5://$SOCKS_USER:$SOCKS_PASS@[\$SOCKS_HOST]:$SOCKS_PORT -interface \$IFACE
EOF

chmod +x "$RUN_SH"
echo "启动脚本已生成：$RUN_SH"

# 5. 生成 systemd 服务文件
SERVICE_FILE="/etc/systemd/system/tun2socks.service"

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=tun2socks 启动脚本服务
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=$RUN_SH
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "systemd 服务文件已生成：$SERVICE_FILE"

# 6. 启动并开机自启服务
systemctl daemon-reload
systemctl enable --now tun2socks.service

cat <<EOT

====================================================================
✅ tun2socks 安装完成，服务已启动！

查看日志：
  journalctl -u tun2socks -f

停止服务：
  systemctl stop tun2socks

修改出口网卡：
  编辑 $RUN_SH 中的 IFACE 变量，保存后执行：
    systemctl restart tun2socks
====================================================================
EOT
