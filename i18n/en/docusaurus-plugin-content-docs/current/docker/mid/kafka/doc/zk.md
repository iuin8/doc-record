## Configure meanings in zk cluster configuration file

```shell
vim zoo.cfg
plus the following three-line configuration
server.1=10.88.0.19:2888:388;2181
server.2 =10.88.0.20:388:388;2181
server.3=10.88.0.28:388;2181
Here 10. 8.0.X indicates the IP addresses of the three zookerers, 3888 is the port of correspondence between the cookers, 3888 is the port of the zokeeper, which is generally fixed

```
