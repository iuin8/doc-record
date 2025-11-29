```shell
Docker run -it
--name samba_docker #Rename a new container to initiate, stop, delete etc. After all, a long strength of characteristics is bad to enter
- p 139:139:139 #Map the host's 139 port to samba_docker's container with
-p 445: 445 #
-v /home/sharees/shareA# of the host's shared directory to map the container
-d dperson/s\amba #image using persons / samba as a template, Set up a container
-w "WORKGROUP" #From here is the parameter of dperson/samba, above which docker runs. Here you specify Working Group
-u "userA; 23456789" #Set account and password
-s "shareA;/home/shares/shareA;yes;no;no;userA; ser
 
The last row is separate by the name of the shared holder in：
respectively; The path shared in the samba container; the shared name is visible to all working group users; not only read (i). For the purpose of the review process, the expert review team shall take into account the following characteristics:
 
For permissions on files and holders created in the shared folder, class：
docker exec -it 4ae45cd4f49/bin/bash
modified the samba configuration document /etc/samba/s in the container. It is engh.
```

```shell
docker run -it --name samba_docker -p 139:139 -p 445-v /home/shares/shares:/home/shares --w -w -d dperson/samba -w "WORKGROUP" -u "user;pwd" -s "share;/home/shares/share;yes;no;no;user;user"

```
