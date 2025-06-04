使用以下指令即可一键部署BBR

CentOS推荐通过如下脚本安装BBR内核后再使用下一个脚本
```bash
wget -N --no-check-certificate "https://huan-starvm.github.io/app/BBR/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
```

Debian\Ubuntu\CentOS均可使用脚本：（CentOS推荐使用上面的那个脚本安装BBR内核后再执行这个脚本）
```bash
wget https://huan-starvm.github.io/app/BBR/install_kernel.sh && chmod +x install_kernel.sh && ./install_kernel.sh
```


脚本作者项目：
```bash
https://github.com/Chikage0o0/Linux-NetSpeed
```
