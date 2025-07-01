#!/bin/bash
###############################################################################
# 安装 tun2socks + 生成 systemd 服务（IPv6‑only 客户端用）
# 作者：ChatGPT（根据你需求定制）
###############################################################################
set -e

### 1. 交互获取出口网卡 ########################################################
read -p "请输入出网网卡名字（例如 ens17）: " IFACE
if [[ -z "$IFACE" ]]; then
  echo "错误：未输入网卡名字，脚本退出。" >&2
  exit 1
fi

### 2. 变量设置 ################################################################
URL="https://github.raw.starvm.top/Huan-Starvm/Huan-Starvm.github.io/refs/heads/main/app/tun2socks-linux-amd64.zip"
ZIP_NAME="tun2socks-linux-amd64.zip"
BIN_NAME="tun2socks-linux-amd64"        # 解压后文件名
INSTALL_PATH="/usr/local/bin/tun2socks" # 目标可执行文件

SOCKS_USER="WwK72eJWFy"
SOCKS_PASS="yF9BuVPx7S"
SOCKS_HOST="2408:8653:dc00:20b:600::c"
SOCKS_PORT="46627"

TUN_IF="tun0"
WRAPPER="/usr/local/bin/run-tun2socks.sh"
UNIT_FILE="/etc/systemd/system/tun2socks.service"

### 3. 安装 unzip ##############################################################
echo "[*] 检查 unzip ..."
if ! command -v unzip &>/dev/null; then
  echo "  -> 未安装，自动安装 unzip"
  if command -v apt &>/dev/null;   then sudo apt update -y && sudo apt install -y unzip
  elif command -v yum &>/dev/null; then sudo yum install  -y unzip
  else
    echo "无法自动安装 unzip，请手动安装后重试。" >&2
    exit 1
  fi
fi

### 4. 安装 tun2socks ##########################################################
if ! command -v tun2socks &>/dev/null; then
  echo "[*] 下载 tun2socks ..."
  wget -q --show-progress -O "$ZIP_NAME" "$URL"

  echo "[*] 解压 ..."
  unzip -o "$ZIP_NAME" >/dev/null
  sudo mv "$BIN_NAME" "$INSTALL_PATH"
  sudo chmod +x "$INSTALL_PATH"
  rm -f "$ZIP_NAME"
  echo "  -> tun2socks 安装完成：$INSTALL_PATH"
else
  echo "[*] 已检测到 tun2socks，跳过下载。"
fi

### 5. 生成包装启动脚本 ########################################################
echo "[*] 生成 $WRAPPER ..."
sudo tee "$WRAPPER" >/dev/null <<EOF
#!/bin/bash
set -e
TUN_IF="$TUN_IF"
IFACE="$IFACE"

# 创建 / 启动 TUN
ip tuntap add mode tun dev \$TUN_IF 2>/dev/null || true
ip addr add 198.18.0.1/15 dev \$TUN_IF 2>/dev/null || true
ip link set \$TUN_IF up

# 调整默认路由
OLD_GW=\$(ip route | awk '/default/ {print \$3; exit}')
ip route del default 2>/dev/null || true
ip route add default dev \$TUN_IF metric 1
ip route add default via \$OLD_GW metric 10

# 启动 tun2socks 本体
exec $INSTALL_PATH \\
  -device tun://\$TUN_IF \\
  -proxy socks5://$SOCKS_USER:$SOCKS_PASS@[$SOCKS_HOST]:$SOCKS_PORT \\
  -interface \$IFACE
EOF
sudo chmod +x "$WRAPPER"

### 6. 生成 systemd 服务 #######################################################
echo "[*] 写入 $UNIT_FILE ..."
sudo tee "$UNIT_FILE" >/dev/null <<EOF
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

### 7. 启用并启动服务 ###########################################################
echo "[*] 重新加载 systemd ..."
sudo systemctl daemon-reload
echo "[*] 启动并设为开机自启 ..."
sudo systemctl enable --now tun2socks.service

echo "===================================================================="
echo "✅ tun2socks 已后台运行！"
echo "  查看实时日志： journalctl -u tun2socks -f"
echo "  停止服务：     systemctl stop tun2socks"
echo "  修改网卡：     编辑 $WRAPPER 并重启服务"
echo "===================================================================="
