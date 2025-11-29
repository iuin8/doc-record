# centos use a date to command synchronization of network time

In CentOS, the data command can be used to synchronize network time.Below is step： to sync network time using the data command

1. Set the timezone：
   first, make sure the server timezone is set correctly.The following command can be used to view the current time zone settings：

   `````shell
   timedattl status | grep 'Time zone'
   ``

   If the time zone is incorrect, the time zone can be set to the time zone (Asia/Shanghai)：

   ````shell
   timedatetl set-timezone Asia/Shanghai
   ```

   `````
2. Sync network time with：
   using the following commands to sync network time：

   `````shell
   date -s "(curl -s --head http:// www.baidu.com | grep '^Date:' | cut-d' -f3-6) Z"
   ````
   This command will get the current time from the 100th server and set the system time to that time.

   `````
3. Verify time synchronization with：
   using the command below to verify whether time synchronized with：

   `````shell
   d
   ````
   this command shows the current system time.
   `````

Please note that synchronizing network time with data may not be the most accurate method.A better way to synchronize network time using ntpdate or ntp service.You can refer to the use of the ntpdate and ntp services mentioned in the search results.

---

Learn more:

1. [CentOS 7 Sync Time 2 Methods - Small zblog](https://blog.xiaoz.org/archives/12989)
2. [2 methods of synchronizing network time in Linux/CentOS are understood - Tencent cloud developer community](https://cloud.tencent.com/developer/article/1721411)
3. [CentOS设置系统时间与网络时间同步-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1795159)
