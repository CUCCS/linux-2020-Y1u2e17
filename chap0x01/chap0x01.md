# 实验一 无人值守Linux安装
## 一、实验目的
- 配置无人值守安装iso并在Virtualbox中完成自动化安装
- 利用Xshell对虚拟机远程控制，并配置ssh免密码登陆
- 使用sftp在虚拟机和宿主机之间传输文件

## 二、实验环境
- Win10
- Virtualbox
- Ubuntu 18.04 Server 64bit
  - 双网卡
    - NAT
    - Host-only

## 三、实验过程
### 1. 有人值守安装Ubuntu18.04-server虚拟机，配置双网卡
  1.1 启动安装ubuntu虚拟机
  1.2 配置双网卡
  - ```sudo vim /etc/netplan/01-netcfg.yaml```，添加以下内容
      ```
      enp0s8
      dhcp4:yes
      ```
    ![双网卡配置](images/33.jpg)
  - ```sudo netplan apply```  配置应用
  - ```ifconfig```  查看网卡信息

    ![网卡信息](images/34.png)

### 2. 利用Xshell远程登陆虚拟机，配置ssh免密码登陆
  2.1 下载安装Xshell
  - 卸载已有Xshell（因为之前下载的是官付费版，评估期已过，需要购买）
    - *<front color=red size=1>Error</front><front size=1>：卸载原来的版本的时候没有卸载干净，导致安装新的xshell提示只对当前安装文件有效</front>*
    - *<front color=green size=1>Solution</front><front size=1>：到C盘，C:\Program Files (x86)\InstallShield Installation Information，删掉{F3FDFD5A-A201-407B-887F-399484764ECA}这个文件夹</front>*
  - [下载 个人/学校免费版 Xshell](https://www.netsarang.com/zh/free-for-home-school/)
  2.2 配置ssh免密码登陆
    - 准备工作
    - 远程登陆虚拟机
      - 打开Xshell设置主机为Host-only网卡ip地址
      <br/>*注：此时未注册密钥，新建会话，会弹出推荐密钥，点击【一次性接受即可】，最好不要点击【接受并保存】*
    - 确认ssh server是否正常工作
    - 认证root 
    - 修改配置文件/etc/ssh/sshd_config
    - 创建~/.ssh/authorized_keys文件
  - 生成密钥（公钥与私钥）
  - 放置公钥(Public Key)到~/.ssh/authorized_key文件中
  - 配置ssh客户端使用密钥登录
    