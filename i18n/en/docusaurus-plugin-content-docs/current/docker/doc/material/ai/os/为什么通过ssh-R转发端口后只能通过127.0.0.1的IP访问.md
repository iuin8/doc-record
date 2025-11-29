# Why is it only accessible via an IP of 127.0.0.0.1 after passing through ssh -R to a port and cannot be accessed via an Extranet IP? What can be done to access via an Extranet IP?

By default, the SSH server will only listen to the relay port on the local ring address (127.0.0.0.1).This is for security reasons and to prevent unauthorized visits.

To access forwarded ports via the Extranet IP, the following step： is required

1. Modify configuration file：to open SSH server on SSH server (usually /etc/ssh/sshd_config), find and modify the following line：

   ```shell
   GatewayPorts yes
   ```

   This will allow the SSH server to listen to all forwarded ports on the network interface, not just local loop addresses.

2. Restart the SSH server：to save the configuration file and restart the SSH server for the changes to take effect.The following command can be used to restart the SSH server：

   ```shell
   sudo service ssh restart
   # or
   systemctl start sshd
   ```

3. Using an Extranet IP to access：on your client, you can now access forwarded ports via an Extranet IP using the SSH client.For example, if you forward ports to the SSH server port 2222 and the SSH server has an extranet IP of 203.0.113.1, you can connect to forward port： using the following command

   ```shell
   ssh - p 2222 user@203.0.113.1
   ```

   This will connect to the SSH server and forward traffic to the forwarded port.

Please note that administrator permissions may be required to modify the profile of the SSH server.In addition, opening the forwarding port of the SSH server may entail security risks and please ensure that only trusted hosts are allowed access to forwarded ports.

---

slug: /docker/doc/material/ai/os/ssh-port-forwarding-external-access

Learn more:

1. [sshhow to implement Intranet access? - known](https://www.zhihu.com/question/398993211)
2. [three ports forwarded by SSH - jeremy's technical drive](https://jeremyxu2010.github.io/2018/12/ssh%E7%9A%84%E4%B8%89%E7%A7%8D%E7%AB%AF%E5%8F%A3%E8%BD%AC%E5%8F%91/)
3. [Method of connecting inner hosts via ssh (firewall host) - memphise - blog garden](https://www.cnblogs.com/memphise/articles/6472207.html)

## Related issues

> sudo service ssh restart
> command failed and ssh is installed, how to fix
> Failed to start ssh.service: Unit not found.

Based on the search results, the "Failed to start ssh.service: Unit not found" error may be due to using wrong commands or different version of the system.Below are several possible ways to solve this problem with：

1. Try using the right command：to restart the SSH service using the appropriate command based on your system version.In CentOS 7 and higher, the following command is required for：

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

   If the SSH service is not installed or not running, try reinstalling the SSH server and start the service.

3. Reinstall SSH server：if SSH service is properly installed but cannot be started, try reinstalling the SSH server.First, uninstall existing SSH server：

   ```shell
   sudo apt-get purge openssh-server
   ```

   Then reinstall SSH server：

   ```shell
   sudo apt-get install openssh-server
   ```

   Finally, try restarting the SSH service.

If the problem persists, please provide more details, such as the full content of the error message and any related log files, so that we can better help you solve the problem.

---

slug: /docker/doc/material/ai/os/ssh-port-forwarding-external-access

Learn more:

1. [Failed to start ssh.service: Unit not found.-CSDN blog](https://blog.csdn.net/u010433704/article/details/120057040)
2. [Failed to start ssh.service: Unit not found. - Unexpected Organ - Blog Gard] (https://www.cnblogs.com/Courage129/p/14073162.html)
3. [ssh - Cannot start sshd service: Failed to start openssh.service: Unit not found - Server Fault](https://serverfault.com/questions/904430/cannot-start-sshd-service-failed-to-start-openssh-service-unit-not-found)
