# 三网回程测试脚本(国内外都可以用好像)

## 更新系统源以保证最新
### Ubuntu/Debian
```dash
apt update
```
### CentOS
```dash
yum update
```

## 安装必要的运行环境
### Ubuntu/Debian
```dash
apt install -y wget
```
### CentOS
```dash
yum install -y wget
```

## 使用脚本（Ubuntu/Debian/CentOS通用，其他系统未测试）
```bash
wget https://huan-starvm.github.io/app/mtr_trace/mtr_trace.sh && bash mtr_trace.sh
```
