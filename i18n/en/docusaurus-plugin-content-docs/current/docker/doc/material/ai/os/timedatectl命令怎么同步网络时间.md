# How to synchronize network time with timedatabase commands

To synchronize network time using the `timedate` command, you can follow the following steps to do：

1. Check current time synchronization status：
   - Run the following command in the criminal to view the current time synchronization status：`timedatetl status` [[1](https://tecadmin.net/synchronizing-a-linux-system-clock-with-ntp-server/).
   - Check the "System clock synchronized" field in the output, indicating that the time has been synchronized if displayed as "yes".

2. Enable network time synchronization with：
   - Run the following command in the criminal to enable network time synchronization with：`sudo timedatl set-ntp true` [[1]](https://tecadmin.net/synchronizing-a-linux-system-clock-with-ntp-server/).
   - This will enable automatic time synchronization between the system and the network time protocol (NTP) server.

3. Check time synchronization status：
   - Run the `timedatetl status` command again to check the time synchronization [[1](https://tecadmin.net/synchronizing-a-linux-system-clock-with-ntp-server/).
   - Make sure the "System clock synchronized" field is shown as "yes", indicating that time has been synchronized.

---

Learn more:

1. [Synchronizing a Linux System Clock with NTP Server](https://tecadmin.net/synchronizing-a-linux-system-clock-with-ntp-server/)
2. [How to Set Time, Timezone and Synchronize System Clock Using Timedataatl Command](https://www.tecmint.com/set-time-timezone-and-synchronize-time-using-timedatectl-command/)
3. [system - How to sync the time to network with timatl on Ubuntu 18.04? - Ask Ubuntu] (https://askubuntu.com/questions/1058593/how-to-sync-the-network-with-timedatel-on-ubuntu-18-04)
