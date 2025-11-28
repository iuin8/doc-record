# Logging issues related to jenkins deployment

## The jenkins instance seems to have been offline

    ```
    安装插件那个页面，就是提示你offline的那个页面，不要动。
    然后打开一个新的tab，输入网址 `http://192.168.211.103:8080/jenkins/pluginManager/advanced`。 
    这里面最底下有个【升级站点】，把其中的链接由https改成http的就好了，http://updates.jenkins.io/update-center.json。 
    然后在服务列表中关闭jenkins，再tomcat重新启动，这样就能正常联网了
    ```

## Unable to download maven plugin dependency

- Could not transfer fact org.apache.maven.plugins:maven-clean-plugin: pom:2.5 from solutions to such problems
- -Dmaven.wagon.http.ssl.insecurity=true -Dmaven.wagon. http.ssl.allow=true # add this configuration to maven_ops
- -Dmaven.wagon.http.ssl.insecurity=true - Dmaven.wagon. http.ssl.allow=true - Dmaven.wagon.http.ssl.ignee.validity.data=true is not used
- [参考文章](https://www.cnblogs.com/JavaArchitect/p/14383061.html)

![img.png](img/不能下载maven插件依赖/img.png)

---

## vue items, refresh pages to show 404 issues

- try_files $uri $uri/ /index.html; # 用于解决刷新页面后，显示404的问题
- [参考文章](https://www.cnblogs.com/caijinghong/p/14693820.html)

## npm mirror source problem

- [淘宝镜像源](https://registry.npmmirror.com/)
- [淘宝cnpm镜像源](https://registry.npm.taobao.org)
- [参考文章](https://cloud.tencent.com/developer/article/1372949)

## Append content to server configuration file by Dockerfile

    ````
    ```shell
    
    echo "FROM tomcat:8. " > Dockerfile
    echo "MAINER Fa" >> Dockerfile
    echo "RUN rm -rf /usr/local/tomcat/webapps/*" >> Dockerfile
    echo "RUN echo '' >> conf/catalina. roperties" >> Dockerfile
    echo "RUN echo 'tomcat.util.http.parser.HttpParser.requestTargetAllow=|{}' >> conf/catalina.properties" >> Dockerfile
    echo "RUN echo 'org. pache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true' >> conf/catalina.properties" >> Dockerfile
    echo "ADD ./target/*. ar /usr/local/tomcat/webapps/" >> Dockerfile
    echo "EXPOSE 80" >> Dockerfile
    # echo 'ENTRYPOINT ["/usr/local/tomcat/bin/cata.sh", "run"]" >> Dockerfile
    
    docker build -t docker-test.
    
    ```
    ````

## Java Related Issues

- Exceptions：org.springframe.web.util.NestedServletException: Handler dispatch failed; nested exception is java.lang.NoClassDefence. Could not initiate class sun.font.SunFontManager
  - Add a parameter to start java: -Djava.awt.headless=true
  - [参考文章](https://www.cnblogs.com/yanqin/p/7160889.html)

- 异常：找不到文件/opt/java/openjdk/lib/libfontmanager.so
  - The file could not be found in the docker image 11-jre-alpine, so remove --alpine, use 11-jref
