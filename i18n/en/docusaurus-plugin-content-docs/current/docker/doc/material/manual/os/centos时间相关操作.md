# Center time related actions

Set the time zone (CenOS 7)
to execute command timatl status|grep 'Time zone' to view the current time zone. If it is not the time zone for China (Asia/Shanghai), it needs to be set to the time zone first, otherwise there will be a time difference between time zones.

```shell
#already Asia/Shanghai, no need to set
[root@xiaoz shadowsocks]# timectl status|grep 'Time zone'
       Time zone: Asia/Shanghai (CST, +0800)
```

Set timezone for executing the following commands

```shell
#Set hardware clock to match local clock with
timedatetl set-local-rtc 1
#Set timezone to Zhang
timatl set-timezone Asia/Shanghai
```

Using ntpdte sync time
is now more commonly used to synchronize time using ntpdte commands using the following：

```shell
#安装ntpdate
yum -y install ntpdate
#同步时间
ntpdate -u  pool.ntp.org
#同步完成后,date命令查看时间是否正确
date
```

Share the next few more commonly used ntp servers, get more if needed at：[ntp官网](http://www.ntp.org.cn)

```shell
#China
cn.ntp.org.cn
#Hong Kong
hk.ntp.org.cn
#US
us.ntp.org.cn
```

同步时间后可能部分服务器过一段时间又会出现偏差，因此最好设置crontab来定时同步时间，方法如下：

```shell
#安装crontab
yum -y install crontab
#创建crontab任务
crontab -e
#添加定时任务
*/20 * * * * /usr/sbin/ntpdate pool.ntp.org > /dev/null 2>&1
#重启crontab
service crond reload
```

The scheduled tasks above will be synchronized every 20 minutes, note /usr/sbin/ntpdate is the absolute path to the ntpdate command, different servers may be different, use the which command to find the absolute path below：

```shell
[root@xiaoz ~]# which update
/usr/sbin/ntUpdate
```

Using rdateSync time
ntpdate services require udp/123 ports, but some providers have banned all UDP protocols, so you will find any ntpdt always syncing errors.

```shell
#Below is a column of ntpdateSync time reported by
[root@sharktech ~]# ntUpdate -u pool.ntp.org
 Jun 16:13:46 ntUpdate[8389]: no server suitable for synchronization found
```

This time we can use the rdate command to synchronize the time with the following：

```shell
#Install rd
yum -y install rd
#Synchronize time
rd -s time-b.nist.gov
#View time is correct
date
```

As above, we would like to add time to regular synchronization in the following： methods:

```shell
#安装crontab
yum -y install crontab
#创建crontab任务
crontab -e
#添加定时任务
*/20 * * * * /usr/bin/rdate -s time-b.nist.gov > /dev/null 2>&1
#重启crontab
service crond reload
```

There are some other rdate time servers below：

```shell
s1d.time.edu.cn #South East University
s1e.time.edu.cn #Tsinghua University
s2a.time.edu.cn #Tsinghua University
s2b.time.edu.cn #Tsinghua University
s2c.time.edu.cn #Post and Post University
ntp.sjtu.edu. n 202.120.2.101 #(address of NTP server in the network centre of Shanghai Transport University)
s1a.time.edu.cn #Beijing Post and Telecommunications University
s1b.time.edu.cn #Chiang University
s1c.time.edu.cn #Beijing University
clock.cuhk.edu.hk #Hong Kong University Time Center
```

Summary
is simpler for syncing time using ntpdt or rdate, the approximate process is 'set timezone' -> 'Synchronize time' -> 'Set time mission'.In actual tests, xiaoz found that if some of the service providers blocked UDP ports, ntpdate commands could not be synchronized, but with rdate's command, child shoes in a similar situation could be tried.
