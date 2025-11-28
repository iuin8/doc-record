# Quick Release Service: use with idea and gradle (customize multienvironment)

> **v4 Version Update**
> Date: 2025-09-30
>
> - Support to view re-time logs
>   - Use idea's national feature to automatically different error log (view by independent tab), quick visibility and troubleshotter issues

![service-logs-to-idea-console](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/imgs/service-logs-to-idea-console-1.png?raw=true)

![service-logs-to-idea-console](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/imgs/service-logs-to-idea-console-2.png?raw=true)

Unfortunately the error log group function of idea, which is only built-in with the prefix `Caused by:` and does not appear to be open to customizations

[全版本更新日志](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/version.md)

[相关配置文件地址](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/v4)

## Use Instructions

[部分说明可参考v2版本](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/v2/doc.md)

### Add custom task

Modify the following configuration to add customized tasks to achieve multi-environment release

- [发布服务任务gradle配置](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/v4/project/script/publishServerTask.gradle)

- [添加对应环境的gradle属性](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/v4/project/gradle-demo.properties)
