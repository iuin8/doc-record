# Use the official CentS base image (PPS: -pack openssh-server dependencies
# FROM ubuntu:24.04
FROM registry.cn-hangzhou.aliyuncs.com/iuin/ubuntu:24.04

WORKDIR /data/actions-runner

# ENV https_proxy=http://192.168.0.121:7890 http_proxy=http://192.168.0.121:7890all_proxy=socks5://192.168.0.121:789090

RUN apt-get update && apt-get install -y curl

# GitHub pages actions-runner
RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-x64-2.320.0.tar.gz &&&&&\s
    tar xzf ./actions-runner.tar.gz &&&../bin/installdependencies.sh
