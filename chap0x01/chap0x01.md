# 实验一 无人值守Linux安装
## 一、实验目的
- 配置无人值守安装iso并在Virtualbox中完成自动化安装
- 利用xshell对虚拟机远程控制，并配置ssh免密码登陆
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
- 启动安装ubuntu虚拟机
- 配置双网卡
  - ```sudo vim /etc/netplan/01-netcfg.yaml```，添加以下内容
      ```
      enp0s8
      dhcp4:yes
      ```
    ![双网卡配置](images/33.jpg)
    