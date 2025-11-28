# Why is it only accessible via an IP of 127.0.0.0.0. After passing through ssh -R to a port and cannot be accessed via an Extranet IP? What can be done to access via an Extranet IP?

By default, the SSH server will only list to the relocation port on the local address (127. This is for security reasons and to prevent unauthorized visits.

To gain access via the Extranet IP, the following step： is required

1. Modify configuration file：to open SSH server on SSH (usally /etc/ssh/sshd_config), find and modify the following line：

   ```shell
   GatewayPorts yes
   ```

   This will allow the SSH server to list to all imported ports on the network interface, not just local loop addresses.

2. Restart the SSH server：to save the configuration file and restart the SSH server for the changes to take effect. He following common can be used to restart the SSH server：

   ```shell
   sudo service ssh restart
   # or
   systemctl start sshd
   ```

3. Using an Extranet IP to access：on your client, you can now access exported ports via an Extranet IP using the SSH client. or example, if you forward ports to the SSH server 2222 and the SSH server has an extranet IP of 203. 1.113.1, you can connect to forward： using the following command.

   ```shell
   ssh - p 2222 user@203.0.113.1
   ```

   This will connect to the SSH server and forward traffic to the advance report.

Please note that administrators permissions may be required to modify the profile of the SSH server. n addition, Opening the forward port of the SSH server may entail security risks and ensure that only trusted hosts are allowed access to advance ports.

---

slug: /docker/doc/material/ai/os/ssh-port-forwarding-external-access

Learn more:

1. [sshhow to implement Intranet access? - known](https://www.zhihu.com/question/398993211)
2. [three ports forwarded by SSH - jeremy's technical drive] (https://jeremyxu2010.github.io/2018/12/ssh%E7%9A%84%E4%B8%89%E7%A7%8D%E7%AB%AF%E5%8F%A3%E8%BD%AC%E5%8F%91/)
3. [Methodod of connecting inner hosts via ssh (firewall host) - memphise - blog garden](https://www.cnblogs.com/memphise/articles/6472207.html)

## Related issues

> sudo service ssh restart
> command failed and ssh is installed, how to fix
> Failed to start ssh.service: Unit not found.

Based on the search results, the "failed to start ssh. ervice: Unit not found" error may be due to using wrong orders or different version of the system. How are several possible ways to solve this problem with：

1. Try using the right command：to restart the SSH service using the appropriate common based on your system version. n CentOS 7 and higher, the following command is required for：

   ```shell
   sudo systemctl start sshd
   ```

   In Ubuntu 16.04 and higher, the following command： should be used

   ```shell
   sudo systemctl start ssh
   ```

   If the same error persists, please continue the following steps.

2. Check the status of the SSH service for：using the following command to check the status of the SSH service to ensure that it is properly installed and running：

   ```shell
   sudo systemctl status sshd
   ```

   If the SSH service is not installed or not running, try installing the SSH server and start the service.

3. Install SSH server：if SSH service is properly installed but cannot be started, try installing the SSH server.First, uninstall existing SSH server：

   ```shell
   sudo apt-get purge openssh-server
   ```

   Then install SSH server：

   ```shell
   sudo apt-get install openssh-server
   ```

   Finally, try restoring the SSH service.

If the problem persists, please provide more details, Such as the full content of the error message and any related log files, so that we can better help you solve the problem.

---

slug: /docker/doc/material/ai/os/ssh-port-forwarding-external-access

Learn more:

1. [Failed to start sh.service: Unit not found.-CSDN blog](https://blog.csdn.net/u010433704/article/details/120057040)
2. [Failed to start ssh.service: Unit not found. - Unexpected Organ - Blog Gard] (https://www.cnblogs.com/Courage129/p/14073162.html)
3. [ssh - Cannot start sshd service: Failed to start openssh.service: Unit not found - Server Fault](https://serverfault.com/questions/904430/cannot-start-sshd-service-failed-to-start-openssh-service-unit-not-found)
