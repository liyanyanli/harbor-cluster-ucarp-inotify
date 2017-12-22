该项目是基于inotify+rsync实现持久化数据的同步！

安装步骤：

前提条件:
 1.docker安装（不要直接yum install docker像node节点一样装docker）
 2.配置 docker   --insecure-registry
 3.harbor双机之间ssh(root)免密登录 (可参考使用 ssh.sh脚本)

安装:

 setp 1: install harbor and clair
    ./1_main.sh /root/release_harbor[install path] 10.10.103.140[VIP] smtp.exmail.qq.com[mail server] 25[mail port] ******@qq.com[mail addr] aaaa[mail password] 598892742@qq.com[mail addr] 123[harbor admin password]

 setp 2: install ucarp , inotify and rsync
    ./2_ha.sh /root/release_harbor[install path] 40[ucarp id] love[ucarp password] 10.10.103.222[vip] 10.10.103.141[local ip] eth0[netword card name] 10.10.103.143[Another IP]

