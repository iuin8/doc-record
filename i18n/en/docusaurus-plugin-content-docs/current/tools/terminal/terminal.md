# Command line use record document

## asdf Tool (The Multiple Runtime Version Manager)

asdf ensures that the team uses the same version of tools, supports many tools through the plugin system and acts as simplicity and familiarity as a single shell script included in the shell configuration.
asdf is not intended to be a package manager.It is a tool version manager.Only because you can create plugins for any tool and use asdf to manage its version, does not mean that this is the best course of action for this particular tool.

[官网地址](https://asdf-vm.com/)

```bash
# 安装
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
# 配置环境变量
code ~/.zshrc
. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"
# 查询插件
asdf plugin list all | grep python
# 安装插件
asdf plugin add python https://github.com/danhper/asdf-python.git
# 安装python
asdf install python latest
# 设置版本
asdf global python latest
```

## Nix Tools

Nix,Pure Function Package Manager

Nix is a powerful package manager for Linux and other Unix systems that makes package management reliable and replicable.
[官网地址](https://nixos.org/nix/)
