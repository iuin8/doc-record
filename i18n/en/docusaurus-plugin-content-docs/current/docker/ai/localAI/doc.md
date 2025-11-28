# localAI usage record

[官网](https://localai.io)

## Install

[快速开始](https://localai.io/basics/getting_started/)

```bash
# 一键安装, 但可能不适用低版本docker(好像拉下源码来后, 又正常了...)
# 25.04.03测试可用, 版本为localai/localai:v2.27.0-ffmpeg, 使用的模型为gemma-3-1b-it
# 在dify上的配置为(baseUrl: http://10.0.1.96:8888, model: gemma-3-1b-it)
curl https://localai.io/install.sh | sh

# 手动启动docker容器
docker run -p 8080:8080 --name local-ai -d -v $PWD/models:/build/models localai/localai:latest-aio-cpu
# 手动创建卷的方式
docker volume create localai-models
docker run -p 8080:8080 --name local-ai -d -v localai-models:/build/models localai/localai:latest-aio-cpu
```

- Without voice-over text models

Because FFMpeg licences, it is not included in the default image.If FFMpeg is required, use images with -ffmpeg. Please note that ffmpeg is required to use the audio relay LocalAI feature.

```bash
# Reference image
localai/localai:v2.26.0-ffmpeg
```
