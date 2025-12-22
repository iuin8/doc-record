
# 远程连接相关记录

## 不用密码直接登陆 -- ssh密钥登陆

打开你的git-bash，输入`ssh-keygen` ，然后输入时，三个空回车即可。

接着执行`ssh-copy-id <用户名>@<主机IP>`

最后使用ssh尝试连接，哇，一气呵成，直接连上了！
> 需要远程多台时，`ssh-keygen`这个命令也只需一次即可，`ssh-copy-id <用户名>@<主机IP>`这个使用多次即可

---

## 密钥相关

推荐使用 ed25519 算法生成密钥，它比传统的 RSA 更安全且性能更好：​

```bash
# 生成ed25519密钥对​
ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/id_ed25519 -N ""

# 优势：​
# 密钥长度更短（仅 68 个字符）​
# 加密强度更高​
# 生成和验证速度更快
```

```bash
ssh-keygen -t rsa -b 4096 -C "你的邮箱地址"

# 参数说明：
# -t rsa：指定密钥算法为 RSA（兼容性最强，推荐默认）；
# -b 4096：密钥长度 4096 位（安全性更高，替代默认的 2048 位）；
# -C "邮箱"：给密钥添加备注（方便区分多个密钥，通常用邮箱或用途标识）。
```

### 密钥管理

好像没啥用, 不管了

```bash
# 配置自动启动​
echo 'eval $(ssh-agent -s)' >> ~/.zshrc
echo 'ssh-add ~/.ssh/id_ed25519_iu 2>/dev/null' >> ~/.zshrc
echo 'eval $(ssh-agent -s)' >> ~/.bashrc​
echo 'ssh-add ~/.ssh/id_ed25519_iu 2>/dev/null' >> ~/.bashrc

```

```bash
# SSH代理自动配置​
if ! pgrep -u "$USER" ssh-agent > /dev/null; then​
  ssh-agent -t 86400 > "$XDG_RUNTIME_DIR/ssh-agent.env"​
fi​
​
if [[ ! -z "$SSH_AUTH_SOCK" && ! -S "$SSH_AUTH_SOCK" ]]; then​
  source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null​
fi
```
