# K8s Jumpbox 容器 SSH 配置说明

> authorized_keys挂载后权限不对导致ssh忽略authorized_keys的问题

## 一、背景
容器内运行 sshd 服务，需通过 Secret 注入 `authorized_keys` 实现公钥登录，同时容器自身会生成 SSH 私钥，要求 `/root/.ssh/` 可写。

## 二、挂载方案

### 1. emptyDir 临时目录（提供可写的 .ssh 目录）
- **作用**：容器生成的私钥、known_hosts 等文件需要写入 `/root/.ssh/`
- **类型**：EmptyDir
- **挂载路径**：`/root/.ssh/`
- **权限**：读写

### 2. Secret 挂载 authorized_keys（单文件 subPath 方式）
- **作用**：注入公钥认证文件
- **类型**：Secret（jumpbox）
- **Key**：`authorized_keys`
- **挂载路径**：`/tmp/authorized_keys`
- **subPath**：`authorized_keys`
- **权限**：只读

> 不直接挂载到 `/root/.ssh/authorized_keys`，避免 Secret 只读导致无法 chmod。

## 三、权限修正（关键）

### 问题
- Secret 挂载文件默认 `644`，sshd 要求 `authorized_keys` 必须 `600`
- emptyDir 目录默认 `777`，sshd 要求 `.ssh` 目录必须 `700`
- Secret 只读，容器内无法直接 `chmod`

### 解决方案：postStart 生命周期钩子

```
containers:
  - name: dev-jumpbox
    image: 'registry.cn-hangzhou.aliyuncs.com/iuin/jumpboxc:v0.66.0_v6.3.1'
    # ... 你原来的 env 等配置 ...
    
    # 👇 加这段
    lifecycle:
      postStart:
        exec:
          command:
            - /bin/sh
            - -c
            - |
              cp /tmp/authorized_keys /root/.ssh/authorized_keys
              chmod 700 /root/.ssh
              chmod 600 /root/.ssh/authorized_keys
```

## 四、最终效果
```
/root/.ssh/                    drwx------ (700)
├── authorized_keys            -rw------- (600)   ← 从 Secret 复制
├── id_ed25519_container       -rw------- (600)   ← 容器生成
└── id_ed25519_container.pub   -rw-r--r-- (644)
```

## 五、核心 YAML 片段
```yaml
# volumeMounts
volumeMounts:
  - mountPath: /root/.ssh/
    name: ssh-dir
  - mountPath: /tmp/authorized_keys
    name: ssh-keys
    readOnly: true
    subPath: authorized_keys

# volumes
volumes:
  - name: ssh-dir
    emptyDir: {}
  - name: ssh-keys
    secret:
      secretName: jumpbox
      items:
        - key: authorized_keys
          path: authorized_keys
```
