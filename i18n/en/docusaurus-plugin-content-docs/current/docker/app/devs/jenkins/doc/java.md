# java start related record

- [参考文章](http://www.javashuo.com/article/p-mdhxsxqr-eq.html)

```shell
nohup java -Xms500m -Xmx500m -Xmn250m -Xss256k -server -XX:+HeapDumpOnOutOfMemoryError -jar $JAR_PATH/test-0.0.1-SNAPSHOT.jar --spring.profiles.active=daily -verbose:class &
## 说明：
# --spring.profiles.active=daily， 这个能够在spring-boot启动中指定系统变量，多环境(测试、预发、线上配置)的区分
# 在排查jar包冲突时，能够指定启动的-verbose:class  打印出启动的应用实际加载类的路径，来排查来源。
# jvm堆设值： -Xms500m -Xmx500m -Xmn250m -Xss256k
# nohup 不挂断地运行命令；& 在后台运行 ，通常两个一块儿用。 eg：nohup command &
# -server:服务器模式，在多个CPU时性能佳，启动慢但性能好，能合理管理内存。
# -XX:+HeapDumpOnOutOfMemoryError：在堆溢出时保存快照
```

```shell
## -server and -client specification：
# -server：must be the first guarantee, Good performance in multiple CPUs, and a mode named client, featuring disaster startuping, But efficient running performance and memory management, generally used for client applications or development debate and launching Java directly in a 32-digit environment. The Server mode is characterised by low start-up, But it is very efficient for running performance and memory management to be applied to the production environment and enabled by default in a 64-bit JDK environment.
```
