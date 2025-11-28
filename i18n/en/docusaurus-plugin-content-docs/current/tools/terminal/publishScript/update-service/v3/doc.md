# Quick Release Service: use with idea and gradle (customize multienvironment)

> **v3 Version Update**
> Date: 2025-09-28
>
> - Simplified Script Logic
> - Support config file
> - Support multi-environment configuration
> - Support idea and gradle use

[相关配置文件地址](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/v3)

## Use Instructions

[部分说明可参考v2版本](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/v2/doc.md)

### Add custom task

Modify the following configuration to add custom tasks to achieve multi-environment release

- [发布服务任务gradle配置](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/v3/project/script/publishServerTask.gradle)

- [添加对应环境的gradle属性](https://github.com/183461750/doc-record/blob/main/docs/tools/terminal/publishScript/update-service/v3/project/gradle-demo.properties)
