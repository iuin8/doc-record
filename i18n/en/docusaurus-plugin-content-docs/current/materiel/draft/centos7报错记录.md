# centos7 Bad Record

## Resolve error docker failed to get D-Bus connection report

[参考文章](https://www.cnblogs.com/as007012/p/10042387.html)

systemctl start http.service
Failed to get D-Bus connection: No connection to service manager.

This is because dbus-daemon failed to start.The real systemctl is not unusable.Set your CMD or entrypoint to /usr/sbin/init.Services like dbus will be automatically activated.
Then you can use systemctl.Order below：
docker run --prieged -ti -e "container=docker" -v /sys/fs/cgroup:/sys/fs/cgroup centos/usr/sbin/init

## Secure log showing "failed to create session access denied" when using SSH for Linux instances.

[参考文章](https://help.aliyun.com/zh/ecs/the-secure-log-entry-failed-to-create-session-access-denied-is-displayed-when-you-log-on-to-a-linux-instance-through-ssh)

- Question Description

```bash
# Login to docker container command reporting the following errors. $ `systemctl status sshd`
# pam_selinux(sshd:session): Error sending edit message.
# failed to create session access denied

# at the same time the following message can be seen in the login interface. $ `ssh -p 333 127.0.0.1`
# Root@127.0.0. ''s password: 
# Last login: Fri Oct 105:50:17 2024 from gateway
# /bin/bash: Permission denied
# connection to 127.0.1 closed.

# Question reason: Starting SELinux, usually makes the system safer but disrupts the operating system files, creating an anomaly.

# Solution: setenforce 0|1, 0: set to permissive, 1: set to enforce
# Related commands: getenforce: get selinux, sestatus :view selinux status
setenforce 0
```
