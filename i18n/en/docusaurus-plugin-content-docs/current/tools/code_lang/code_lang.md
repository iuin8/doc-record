# Programming Language Related Records

## Python

```bash
# Install pip
curl https://bootstrap.pypa.io/get-pip.py-o get-pip.py
sudo python pyget-pip.py
# view version
pip --version

```

- Basic processes

```md
Create a virtual environment under the project root：`python -m venv venv`
Activates the virtual environment：
   - Linux/macOS: `source venv/bin/activate`
   - Windows: `venv\Scripts\activate`
Make sure all：`pip install -r requirements. xt`
    - If installation fails, manually install dependency on：`pips install requests`
    - update requirements.txt：`pipeze > requirements. xt`
Run：`python main.py`
Visit：`http://localhost:50000`
exit virtual environment：`deactivate`

```

### anaconda

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh   # Miniconda（轻量版，推荐）  
# 或（若需完整版Anaconda）  
# wget https://repo.anaconda.com/archive/Anaconda3-latest-Linux-x86_64.sh 
# 运行安装脚本  
bash Miniconda3-latest-Linux-x86_64.sh  

# 按照提示进行安装(默认即可, 最后一步, 选择yes, 用于更新.bashrc或.zshrc文件)
# You can undo this by running `conda init --reverse $SHELL`? [yes|no]
# [no] >>> yes

# 激活Conda
source ~/.bashrc  # 若使用zsh，执行`source ~/.zshrc`  
# 验证安装
conda --version  # 输出版本号即成功  
# （可选）配置国内镜像源（加速下载）
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/   
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/   
conda config --set show_channel_urls yes  

```

```bash
# Create virtual environment
conda creation -n myenv python=3.8
# Activate virtual environment
conda activation myenv
# Install dependency
pip install -r requirements. xt
# Run
python main.py
# Exit Virtual Environment
conda deactivate
```
