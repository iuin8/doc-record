# Development of container related records

ps: Develop in Remote Container, or run and debug in Remote Containers locally

## Used in idea

- docker compose configuration adjustment
  - Check the project-name in the modifier option to place the app with the same project name in a compose.
    - Generated command is `docker compose -f ./docker-compose.yml-p ma-compose up -d`
      - Use --build option：when running docker-compose up command, add --build option to ensure that images are rebuilt every time.
        - eg: `docker compose -f ./docker-compose.yml --p ma-compose up -d --build`

## dev Container

- Resolve problem with domain name unresolvable
  - code /etc/resolv.conf

```bash
name 127.0.0.0.1
name server 127.0.0.11
# The following two configurations are derived from the current WiFi
name server 119.29.29.29
name 223.5.5.5

```

## docker ignores file usage

- Filename:[.dockerignore]with Dockerfile filesystem

```bash
*
!dist
!wap.conf

```

## Use of devcontainer.json

- About "SSH_AUTH_SOCK" configuration usage record[对应的devcontainer配置](./example/.devcontainer/devcontainer.json)
  - "SSH_AUTH_SOCK": $SSH_AUTH_SOCK, // 这个配置不生效的话，看看是不是需要在`ssh config`文件（~/.ssh/config）中配置`ForwardAgent yes`才行
