
# python记录

## 安装

- 使用 pyenv 安装 Python3.12（适合多版本管理）

> 涉及的场景记录: 在安装 DeerFlow 时, 用到了这种方式

```bash
# 1. 安装 pyenv 依赖
sudo apt install git curl build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl -y
# 2. 安装 pyenv
curl https://pyenv.run | bash
# 3. 配置 pyenv 环境变量
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
source ~/.bashrc
# 4. 安装 Python3.12.4
pyenv install 3.12.4
# 5. 设置全局使用 Python3.12.4
pyenv global 3.12.4
# 6. 验证安装
python --version
pip --version
```

## ipynb使用

安装模块
[参考文章](https://blog.csdn.net/weixin_44477448/article/details/128915301)

```shell
import sys
!{sys.executable} -m pip install matplotlib

```

## vscode中使用

相关插件: Polyglot Notebooks(扩展Id: ms-dotnettools.dotnet-interactive-vscode)

```bash
# 需要安装的依赖
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh

```
