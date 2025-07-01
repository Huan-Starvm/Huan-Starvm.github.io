#!/bin/bash
###############################################################################
# 安装 tun2socks 并生成固定参数的 systemd 服务
# 只让用户输入出口网卡名
###############################################################################
set -e

########## 1. 读取用户输入的物理网卡 ###########################################
read -rp "请输入出口网卡名字（例如 ens17）: " IFACE
if [[ -z "$IFACE" ]]; then
  echo "未输入网卡名，脚本退出。" >&2
  exit 1
fi
echo "=> 将在 ExecStart 中使用网卡：$IFACE"

########## 2. 基础变量 #########################################################
URL="https://github.raw.starvm.top/Huan-Starvm/Huan-Starvm.github.io/refs/heads/main/app/tun2socks-linux-amd64.zip"
ZIP="tun2socks-linux-amd64.zip"
BIN="tun2socks-linux-amd64"
CMD="/usr/local/bin/tun2socks"
UNIT="/etc/systemd/system/tun2socks.service"

# 固定 SOCKS5 认证信息
S_USER="WwK72eJWFy"
S_PASS="yF9BuVPx7S"
S_HOST="2408:8653:dc00:20b:600::c"
S_PORT="46627"

########## 3. 确保 unzip #######################################################
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

########## 4. 安装 tun2socks 二进制 ###########################################
if ! command -v tun2socks &>/dev/null; then
  echo "[*] 下载 tun2socks..."
  wget -q --show-progress -O "$ZIP" "$URL"
  echo "[*] 解压..."
  unzip -o "$ZIP" >/dev/null
  sudo mv "$BIN" "$CMD"
  sudo chmod +x "$CMD"
  rm -f "$ZIP"
  echo "  -> 已安装 $CMD"
else
  echo "[*] 已检测到 tun2socks，跳过安装"
fi

########## 5. 生成 systemd 单元 ###############################################
echo "[*] 生成 $UNIT ..."
sudo tee "$UNIT" >/dev/null <<EOF
[Unit]
Description=TUN2SOCKS 全局代理
After=network-online.target
Wants=network-online.target

[Service]
Type=simple

# --- 创建 tun0 ---
ExecStartPre=-/usr/bin/ip tuntap add mode tun dev tun0
ExecStartPre=-/usr/bin/ip addr add 198.18.0.1/15 dev tun0
ExecStartPre=/usr/bin/ip link set tun0 up

# --- 调整路由 ---
ExecStartPre=/usr/bin/sh -c '
  OLD=\$(ip route | awk "/default/ {print \\$3;exit}");
  ip route del default || true;
  ip route add default dev tun0 metric 1;
  [ -n "\$OLD" ] && ip route add default via \$OLD metric 10 || true
'

# --- 启动 tun2socks ---
ExecStart=$CMD \\
  -device tun://198.18.0.1/15@tun0 \\
  -proxy socks5://$S_USER:$S_PASS@[$S_HOST]:$S_PORT \\
  -interface $IFACE

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

########## 6. 启用并启动服务 ###################################################
echo "[*] 重新加载 systemd..."
sudo systemctl daemon-reload
echo "[*] 启动服务并设为开机自启..."
sudo systemctl enable --now tun2socks.service

cat <<EOT
====================================================================
✅ tun2socks 已后台运行！
  查看实时日志： journalctl -u tun2socks -f
  停止服务：     systemctl stop tun2socks
  修改网卡：     重新运行本脚本或手动编辑 $UNIT
====================================================================
EOT
