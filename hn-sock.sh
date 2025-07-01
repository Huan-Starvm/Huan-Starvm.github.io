#!/bin/bash
###############################################################################
# 一键安装 tun2socks + 创建 systemd 服务
# 适配：IPv6‑only 主机，通过 SOCKS5 代理拿 IPv4 出口
###############################################################################
set -e

################################### 用户输入 ##################################
read -rp "请输入出网网卡名字（例如 ens17）: " IFACE
if [[ -z "$IFACE" ]]; then
  echo "未输入网卡名，脚本退出。" >&2
  exit 1
fi
echo "=> 将使用网卡：$IFACE"

################################### 变量区 ####################################
URL="https://github.raw.starvm.top/Huan-Starvm/Huan-Starvm.github.io/refs/heads/main/app/tun2socks-linux-amd64.zip"
ZIP="tun2socks-linux-amd64.zip"
BIN="tun2socks-linux-amd64"
CMD="/usr/local/bin/tun2socks"

TUN="tun0"
WRAPPER="/usr/local/bin/run-tun2socks.sh"
UNIT="/etc/systemd/system/tun2socks.service"

# SOCKS5 认证信息
S_USER="WwK72eJWFy"
S_PASS="yF9BuVPx7S"
S_HOST="2408:8653:dc00:20b:600::c"
S_PORT="46627"

################################## 安装 unzip #################################
echo "[*] 检查 unzip..."
if ! command -v unzip &>/dev/null; then
  echo "  -> 未安装 unzip，自动安装"
  if command -v apt &>/dev/null;   then sudo apt update -y && sudo apt install -y unzip
  elif command -v yum &>/dev/null; then sudo yum install  -y unzip
  else
    echo "无法自动安装 unzip，请手动处理后重试。" >&2
    exit 1
  fi
fi

################################ 安装 tun2socks ################################
if ! command -v tun2socks &>/dev/null; then
  echo "[*] 下载 tun2socks..."
  wget -q --show-progress -O "$ZIP" "$URL"
  echo "[*] 解压..."
  unzip -o "$ZIP" >/dev/null
  sudo mv "$BIN" "$CMD"
  sudo chmod +x "$CMD"
  rm -f "$ZIP"
  echo "  -> 安装完成：$CMD"
else
  echo "[*] 已检测到 tun2socks，跳过安装"
fi

############################## 生成启动脚本 ###################################
echo "[*] 写入启动脚本 $WRAPPER ..."
sudo tee "$WRAPPER" >/dev/null <<EOF
#!/bin/bash
set -e
TUN_IF="$TUN"
IFACE="$IFACE"

ip tuntap add mode tun dev \$TUN_IF 2>/dev/null || true
ip addr add 198.18.0.1/15 dev \$TUN_IF 2>/dev/null || true
ip link set \$TUN_IF up

OLD_GW=\$(ip route | awk '/default/ {print \$3; exit}')
ip route del default 2>/dev/null || true
ip route add default dev \$TUN_IF metric 1
ip route add default via \$OLD_GW metric 10

exec $CMD \\
  -device tun://198.18.0.1/15@\$TUN_IF \\
  -proxy socks5://$S_USER:$S_PASS@[$S_HOST]:$S_PORT \\
  -interface \$IFACE
EOF
sudo chmod +x "$WRAPPER"

############################ 生成 systemd 单元 #################################
echo "[*] 写入 systemd 单元 $UNIT ..."
sudo tee "$UNIT" >/dev/null <<EOF
[Unit]
Description=TUN2SOCKS 全局代理
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=$WRAPPER
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

############################ 启用并启动服务 ###################################
echo "[*] 重新加载 systemd..."
sudo systemctl daemon-reload
echo "[*] 启动服务并设为开机自启..."
sudo systemctl enable --now tun2socks.service

cat <<EOT
====================================================================
✅ tun2socks 已后台运行！
  查看实时日志： journalctl -u tun2socks -f
  停止服务：     systemctl stop tun2socks
  修改网卡：     编辑 $WRAPPER 后
                 systemctl restart tun2socks
====================================================================
EOT
