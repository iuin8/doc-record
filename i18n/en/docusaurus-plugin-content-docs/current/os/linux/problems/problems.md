# Issue Log

## yum

Bad Content:

```text
This system is not registered with an entitlement server. You can use subcriminal-manager to register.
```

```bash
vim /etc/yum/pluginconf.d/subscription-manager.conf
# enabled=0
```

Bad Content:

```text
http://mirrors.aliyun.com/centos/7/os/x86_64/repodata/repomd.xml: [Errno 12] Timeout on http://mirrors.aliun.com/centos/7/os/x86_64/repodata/repomd.xml: (28, 'Operation too slot. Less than 1000 bytes/sec transferred the last 30 seconds')
```

[参考文章](https://juejin.cn/post/7161690775980507166)
Aliyum source problem

[参考文章](https://cloud.tencent.com/document/product/213/52559#dab668ec-1b0e-4112-a147-5071fdb19a9e)
Switch to Tent Sources

```bash
# Switch to Tent Source
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.tencent.com/repo/centos7_base.repo
```

```bash
# Switch the yum source of the Tent SCLO (no access, no first note)
# wge-O /etc/yum.repos.d/CentOS-SCLo-scl.repo http://mirrors.cloud.tencent.com/repo/CentOS-SCLo-scl.repo
# wget -O /etc/yum.repos.d/CentOS-SCLo-rh.repo http://mirrors.cloud.tenent.com/repo/CentOS-SCLo-rh.repo
```

```bash
yum clean all
yum makeache
```

## vm.max_map_count

vm.max_map_count is an argument for Linux kernel that controls the amount of the maximum memory map area (memory map area) that a process can act. His parameter is important for some applications (especially Java applications) because they need to create large areas of memory when they are running.

By default, the value of vm.max_map_count may be low (e.g. 65530), which may not be sufficient for some applications. n application may account OutOfMemoryError or similar errors when trying to create more memory applying areas.

Set vm.max_map_count to at least 262144 to solve this problem because this value is usally large enough to meet the needs of most applications.

To view the current vm.max_map_count value, the following order can be run in the term under：

```bash
sysctl vm.max_map_count
```

To change the value of vm.max_map_count the following order can be run in the term (as root user)：

```bash
sysctl -w vm.max_map_count=262144
```

To make changes permanent, the following lines can be added to /etc/sysctl.conf in：

```bash
vm.max_map_count=262144
```

When the `sysctl -p` command to apply changes.

Please note that increasing the value of vm. ex_map_count may increase the system's resource consumption, so make sure to know its potential impact before changing this parameter.
