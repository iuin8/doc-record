# java.lang.OutOfMemoryError : unable to create new nationale Thread

```bash
# Use this command to view running threads
ps -elfT | wc -l
ps -elfT | grep appName|wc -l 
# # to get the number of running threads (you can use top or ps to get process pid)：
ps -p <PROCESS_PID> -lfT | wc -l
# of which processes are creating threads
ps huH
# The number of threads that users can own are limited. Check
ulimit -a
# /proc/sys/kernel/threads-max file to supply the thread limit within the system. Root can change this value
# Change the limit (in this instance 4096 lines)：
ulimit-u 4096
# jps list all java processes (just solve.
jps
```
