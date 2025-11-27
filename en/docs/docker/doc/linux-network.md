# linux network notes

## Linux web card on

```shell
# Network configuration file position
cd /etc/sysconfig/network-scripts/
# Edit profile
vi ifcfg-eth0 
# OBOOT="no" #Do not open network card on startup. We can set this to yes
# and restart network
service network restart
```

## firewalld docker port mapping, firewall open port

\` [参考文章](http://t.csdn.cn/Xo6XZ)

```shell
# Host ip: 192.168.31.19
 
docker run -itd --name tomcat -p 8080:8080 tomcat /usr/local/apache-tomcat-9.0.30/bin/startup. h
# Firewall liberalization 8080 port
firewall-cmd --add-port=808080/tcp --permanent
 
# Question：found access to：192.168.31. 9:8080 Access is unavailable, after closing firewalls, access to
 
# Solutions, docker0 web card added to trusted domain
firewall-cmd --permanent --zone=trusted --change-interface=docker0
# Restart loading configuration
firewall-cmd --reload
 
# firewall-cmd command：http://www. nblogs.com/Raodi/p/11625487.html
```

> If you don't have any validity, you will use the Agent Restart method. It sometimes seems to be a half-day break, and it is good to reboot the last!
