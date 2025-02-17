#!/bin/bash

# 输出版权信息
echo "此脚本由 星空云(https://www.starvm.cn) 编写，免费开源，如为收费均为倒卖，请勿相信"

# 输出提示信息
echo "正在运行中，请勿断开SSH..."

# 更新包列表并升级所有软件包（在后台运行）
nohup bash -c "
  apt update && apt full-upgrade -y &&
  apt install -y vim sudo net-tools wget curl bash &&
  sed -i '/^#PermitRootLogin prohibit-password/ s/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
  echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config &&
  systemctl restart ssh &&
  echo '运行完成!'
" &

# 继续输出运行提示
echo "脚本已在后台运行，运行完成后会显示提示"
