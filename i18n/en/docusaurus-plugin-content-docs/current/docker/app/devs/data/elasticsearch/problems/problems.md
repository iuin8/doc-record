# Issue Log

```md
{"@timestamp":"2024-05-25T06:33:04.830Z", "log.level":"ERROR", "message":"node validation exception\n[1] bootstrap checks failed. You must address the points described in the following [1] lines before starting Elasticsearch. For more information see [https://www.elastic.co/guide/en/elasticsearch/reference/8.11/bootstrap-checks.html]\nbootstrap check failure [1] of [1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]; for more information see [https://www.elastic.co/guide/en/elasticsearch/reference/8.11/_maximum_map_count_check.html]", "ecs.version": "1.2.0","service.name":"ES_ECS","event.dataset":"elasticsearch.server","process.thread.name":"main","log.logger":"org.elasticsearch.bootstrap.Elasticsearch","elasticsearch.node.name":"es01","elasticsearch.cluster.name":"es-docker-cluster"}

我用docker-compose启动es, 报错了

AI答:

根据您提供的错误日志和之前的笔记，您在使用Docker Compose启动Elasticsearch时遇到了"max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]"的错误。这是一个常见的问题，通常是因为Elasticsearch需要较高的`vm.max_map_count`设置来正常运行，而默认值通常不足以满足其需求。

要解决这个问题，您需要在宿主机上增加`vm.max_map_count`的值。这里有两种方法可以做到这一点：

1. **临时设置**（重启后失效）：
   执行以下命令：
   ```shell
   sudo sysctl -w vm.max_map_count=262144
```

This will take effect as soon as possible, but you will need to re-execute this order if the host returns are made.

2. **Permanent Settings**：

   Edit `/etc/sysctl.conf` file, insert： at the end of the file

    ```shell
    vm.max_map_count=262144
    ```

   When executing the `sysctl -p` command for the changes to take effect. He raises the age of this method is that the setting will be maintained even if the host restoration takes place.

Note that if you use the WSL2 backend or other virtualization environment of Docker Desktop, you may need to set it in different places. or example, in WSL2, you may need to implement the following command in Windows, or in PowerShell, To improve the WSL2 VM settings：\`\`\`\`\`shell
wsl -d docker-desktop syctl -w vm. ax_map_count=262144
\`\`\`\`
or, depending on your environment, to find environment-specific settings.

`````

Once these settings have been completed, reboot your Elasticsearch contains and should be able to resolve the `vm. ex_map_count` error posted on startup.

````

```
`````
