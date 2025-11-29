# Processes

## Not enough resources to create local threads

### java.lang.OutOfMemoryError: unable to create new nationhood

- Confirm if resources are required

```bash
# To see which user started by which app does not have resources (here is the case for www.users)
su

# of user max processes (PS: the maximum number of user processes viewed by different users)
ulimit -a
# max user processes (-u) 4096

# Current user uses
top -H 

```

- Modify user maximum number of processes

[参考文章](https://www.cnblogs.com/operationhome/p/11966041.html)

```bash
# View apps that do not have enough resources to start by which user (here is the case for www.users)
www

# centos7 version of configuration
vim /etc/security/limits.d/20-nproc. onf
# Write to the same
# www toft 40960

# Check if
ulimit -a
# max user processes (-u) 40960

```
