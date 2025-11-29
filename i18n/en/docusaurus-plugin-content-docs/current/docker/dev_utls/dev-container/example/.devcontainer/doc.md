# DevContainer Record

Free Volume Mount

```shell
"mounts": [
		"source=/Users/fa/.ssh,target=/root/.ssh,type=bind,consisty=cached"

```

About sshkey sharing
[参考文章](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials)
[ssh-add使用](https://raw.githubusercontent.com/183461750/doc-base/d97d6b14491ec2bcbc36bc487b3b237e653b1736/me/records/os/linux/remote.md?token=GHSAT0AAAAAACHFDDN6JNMW2C7PMWBS44QYZTPVHDA)
needs to check by ssh-add, whether a key for sharing needs to be added

```shell
# 首先，通过在终端中运行以下命令在后台启动 SSH 代理：
eval "$(ssh-agent -s)"
# 然后将这些行添加到您的 ~/.bash_profile 或 ~/.zprofile （对于 Zsh），以便它在登录时启动：
if [ -z "$SSH_AUTH_SOCK" ]; then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
   if [ "$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &> $HOME/.ssh/ssh-agent
   fi
   eval `cat $HOME/.ssh/ssh-agent`
fi
```
