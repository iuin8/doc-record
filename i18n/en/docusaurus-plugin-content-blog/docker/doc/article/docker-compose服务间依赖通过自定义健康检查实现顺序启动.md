# Docker-compose service dependencies to start in sequence by custom health check

The `condition: service_healthy` configuration in Docker Compose is used to determine whether the service relied on is healthy.When a service is dependent on another service, `depends_on` and `condition: service_healthy` can be used to ensure that the service that depends is started healthy.

Below is some of the relevant： about how to judge the health of the service

1. Health check command：can be used to define the health inspection command of the container [[1]](https://blog.csdn.net/weixin_48447848/article/details/122632562) in Dockerfile or docker container.Health check orders can be any command that can return 0 or not 0 exit code, such as using `curl` to check if the service is accessible.

2. Health check parameter：Health Check command can use some parameters to configure intervals, timeout and retries etc.Common health check parameters include：
   - `--interval`：specifies the interval between checks, which is 30 seconds.
   - `--timeout`：specifies the timeout for each check-up, which is 30 seconds by default.
   - `--retrieves`：specifies a number of consecutive failures to mark the service as unhealthy, default to 3.
   - `--start-period`：specifies the time after the container starts to wait for the health check to begin. Default is 0 seconds.

3. `condition: service_healthy` configures：in Docker Compose, you can use `condition: service_healthy` to specify the health of the service dependent.The current service will only start when the health state of the service is healthy.This ensures that the service relied on is successfully started and available.

Below is an example of a docker-compose.yml file that shows how health checks and `condition: service_healthy` are used to judge if the service is healthy and start： in turn

```yaml
version: "3.8"

services:
  flask:
    build:
      context: ./flask
      dockerfile: Dockerfile
    image: flask-demo:latest
    environment:
      - REDIS_HOST=redis-server
      - REDIS_PASS=${REDIS_PASSWORD}
    healthcheck: 
      test: ["CMD", "curl", "-f", "http://localhost:5000"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 40s
    depends_on:
      redis-server:
        condition: service_healthy
    networks:
      - backend
      - frontend

  redis-server:
    image: redis
```

In the above example, the flask service relies on the re-server service.The flask service's health check command is using the `curl` command to check if `http://localhost:50000` is accessible.The flask service will only start if the redis-server service is healthy.

---

Learn more:

1. [Docker Series Docker Compose Service Dependencies and Health Inspection_docker-compose healthcheck-CSDN Blog (https://blog.csdn.net/weixin_48447848/article/details/122632562)
2. [[docker]-docker-compose determines the status of the container via healthcheckk and then starts _docker-compose healthcheck-CSDN blogs](https://blog.csdn.net/xujiamin0022016/article/details/123642210)
3. [Docker compose service dependency and health check - digging gold](https://juejin.cn/post/7250374485567619131)

## Reference

- [nocodb部署yml](https://github.com/nocodb/nocodb/blob/develop/docker-compose/pg/docker-compose.yml)
