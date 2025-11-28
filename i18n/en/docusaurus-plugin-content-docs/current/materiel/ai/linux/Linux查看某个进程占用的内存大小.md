# Linux view memory size used by a process

In Linux systems, there are several ways to view the memory size used by a process. Below are some common methods：

**Method：uses the `ps` command**

The `ps` command shows the status of the process, including memory usage.

e.g.：

```bash
ps -aux | grep <process name>
```

This command allows you to get information about the process in which the `RSS` column shows the physical memory of the process (in KB).

**MethodII：uses the `top` command**

The `top` command is a dynamic system performance monitoring tool.

In the `top` interface, the `P` key can be sorted by CPU usage and the `M` key can be sorted by memory usage to process.Find the process you are following and see how they are using your memory.

**Method III：Use `pap` command**

The `paper` command can report the memory mapping of the process and its use.

e.g.：

```bash
pmap <process ID>
```

It shows the detailed memory distribution of the process.

Assume that we want to view the memory size of a process called `nginx` and use the above command to get the information.Use `ps -aux | grep nginx` for example, output may be similar to：

```bash
root 1234 0.0 0.1 123456 7890? S 14:00 nginx: master process /usr/sbin/nginx
```

`123456` is the physical memory of this process (in KB).
