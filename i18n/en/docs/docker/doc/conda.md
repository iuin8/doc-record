# Usage

- [conda官网](https://docs.conda.io/en/latest/index.html)

## Install

```shell
# 下载安装脚本
wget https://repo.anaconda.com/miniconda/Miniconda3-py38_23.1.0-1-Linux-aarch64.sh
# 执行脚本安装
bash bash Miniconda3-py38_23.1.0-1-Linux-aarch64.sh
# 最后，重新打开终端执行下面的命令验证是否安装成功
conda list
# 更新
conda update conda
```

## Create Environment

```shell
conda creation -n python3.4 python=3.

## Example
`bash
    # create and activate the virtual environment
    conda creation --name animated_drawings python=3.8. 3
    conda activation animated_drawings

    # clone AnimateedDrawings and use pip to install
    git class https://github. om/facebookresearch/AnimateDrawings.git
    cd AnimateDrawings
    pip install -e.
`

```
