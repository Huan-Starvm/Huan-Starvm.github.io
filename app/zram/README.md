## Setup zram (systemd required)

### 16G zram setup
```
wget -O /etc/systemd/system/zram.service https://raw.githubusercontent.com/Huan-Starvm/Huan-Starvm.github.io/refs/heads/main/app/zram/16g.service && systemctl enable zram && systemctl restart zram
```
### 8G zram setup
```
wget -O /etc/systemd/system/zram.service https://raw.githubusercontent.com/Huan-Starvm/Huan-Starvm.github.io/refs/heads/main/app/zram/8g.service && systemctl enable --now zram && systemctl restart zram
```
### 4G zram setup
```
wget -O /etc/systemd/system/zram.service https://raw.githubusercontent.com/Huan-Starvm/Huan-Starvm.github.io/refs/heads/main/app/zram/4g.service && systemctl enable zram && systemctl restart zram
```
### 2G zram setup
```
wget -O /etc/systemd/system/zram.service https://raw.githubusercontent.com/Huan-Starvm/Huan-Starvm.github.io/refs/heads/main/app/zram/2g.service && systemctl enable zram && systemctl restart zram
```
