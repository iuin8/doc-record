# centres use a date to command synchronization of network time

In CentOS, the data command can be used to synchronize network time. Below is step： to synchronize network time using the data common.

1. Set the timezone：
   first, make sure the server is set correctly. He following command can be used to view the current time zone settings：

   ``````shell
   titattl status | grep 'Time zone'
   ``

   If the time zone is incorrect, The time zone can be set to the time zone (Asia/Shanghai)：

   `````shell
   timedatel set-timezone Asia/Shanghai
   ````

   ``````
2. Sync network time with：
   using the following orders to synchronize network time：

   `````shell
   date -s (curl -s --head http:// www.baidu. om | grep '^Date:' | cut-d' -f3-6) Z"
   ````
   This command will get the current time from the 100th server and set the system time to that time.

   `````
3. Verify time synchronization with：
   using the community below to verify whether time synchronized with：

   `````shell
   d
   ````
   this community shows the current system time.
   `````

Please note that synchronizing network time with data may not be the most Accurate method. Better way to synchronize network time using update or ntp service. You can refer to the use of the update and ntp services mentioned in the search results.

---

Learn more:

1. [CentOS 7 Sync Time 2 Methods - Small zblog] (https://blog.xiaoz.org/archives/12989)
2. [2 methods of synchronizing network time in Linux/CentOS are understood - Tencent cloud developer community] (https://cloud.tencent.com/developer/article/1721411)
3. [CentOS设置系统时间与网络时间同步-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1795159)
