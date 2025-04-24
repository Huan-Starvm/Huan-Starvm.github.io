# 实现了哪些功能

**1.文件名带CN字段的脚本为国内服务器提供了换源**

**2.执行了update以及upgrade，方便后续的环境安装**

**3.解锁hostname、hosts文件**

**4.同步上海时间时区(CN字段脚本使用阿里云源进行同步时间)**

**5.非CentOS系统脚本一键开启了BBR**

**6.解决了魔方云默认提供的Debian镜像127.0.0.1 IP ping不通的问题**

**7.安装`vim`、`sudo`、`bash`、`wget`、`net-tools`功能**

## 注意事项：部分操作过程中可能需要输入回车，或者Y才能接着执行

## 如何使用
### 国内云服务器
PS：由于github.io被国内部分运营商阻断，所以将国内脚本迁移到了Gitee上，但是执行起来的内容是一样的
#### Debian 12系统(看清楚版本号，没有自动检测系统的功能)
```bash
wget -qO- https://gitee.com/starvm/storage/raw/master/app/KVM-tools/CN-Debian12.sh | bash
```
#### Debian 11系统(看清楚版本号，没有自动检测系统的功能)
```bash
wget -qO- https://gitee.com/starvm/storage/raw/master/app/KVM-tools/CN-Debian11.sh | bash
```
#### Ubuntu 24.04系统(看清楚版本号，没有自动检测系统的功能)
```bash
wget -qO- https://gitee.com/starvm/storage/raw/master/app/KVM-tools/CN-Ubuntu24.sh | bash
```
#### Ubuntu 22.04系统(看清楚版本号，没有自动检测系统的功能)
```bash
wget -qO- https://gitee.com/starvm/storage/raw/master/app/KVM-tools/CN-Ubuntu22.sh | bash
```
#### Ubuntu 20.04系统(看清楚版本号，没有自动检测系统的功能)
```bash
wget -qO- https://gitee.com/starvm/storage/raw/master/app/KVM-tools/CN-Ubuntu20.sh | bash
```
#### CentOS 8 Stream系统(看清楚版本号，没有自动检测系统的功能)
```bash
curl -sSL https://gitee.com/starvm/storage/raw/master/app/KVM-tools/CN-CentOS-8-Stream.sh | bash
```
#### CentOS 7.6/7.9系统(看清楚版本号，没有自动检测系统的功能)
