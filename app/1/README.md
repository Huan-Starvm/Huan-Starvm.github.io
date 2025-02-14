**注：作者写明仅支持CentOS、Ubuntu、Debian系统，其中作者建议Debian最佳**
## 更新系统源
**CentOS:**
```bash
yum update
```
**Ubuntu、Debian:**
```bash
apt update
```
## 安装依赖
**CentOS:**
```bash
yum install wget curl bash unzip -y
```
**Ubuntu、Debian:**
```bash
apt install wget curl bash unzip -y
```
## 执行安装脚本
**三个系统都执行这个脚本**
```bash
bash <(wget -qO- -o- https://git.io/v2ray.sh)
```

作者备份
bash <(wget -qO- -o- https://f6188916.github.io/app/v2ray/v2ray.sh)
