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
## 执行官方安装脚本
**三个系统都执行这个脚本**
```bash
bash <(wget -qO- -o- https://git.io/v2ray.sh)
```

**为解决被大陆部分地区屏蔽问题，作者进行了备份（应该没哪个人会大陆部署这个玩意了吧）**
```bash
bash <(wget -qO- -o- https://huan-starvm.github.io/app/V2ray/v2ray.sh)
```
**更新速度略低于官方，建议执行上面的官方脚本**
