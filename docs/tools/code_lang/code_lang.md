
# 编程语言相关记录

## Python

```bash
# 安装pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python get-pip.py
# 查看版本
pip --version

```

- 基本流程

```md
在项目根目录下创建虚拟环境：`python -m venv venv`
激活虚拟环境：
   - Linux/macOS: `source venv/bin/activate`
   - Windows: `venv\Scripts\activate`
确保已安装所有依赖：`pip install -r requirements.txt`
    - 如果安装失败，请手动安装依赖：`pip install requests`
    - 更新requirements.txt：`pip freeze > requirements.txt`
运行应用：`python main.py`
在浏览器中访问：`http://localhost:5000`
退出虚拟环境：`deactivate`

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
# 创建虚拟环境
conda create -n myenv python=3.8
# 激活虚拟环境
conda activate myenv
# 安装依赖
pip install -r requirements.txt
# 运行应用
python main.py
# 退出虚拟环境
conda deactivate
```

## java

```bash
# 查看已安装的JDK
/usr/libexec/java_home -V

# 或者
ls /Library/Java/JavaVirtualMachines/

# xpp导致xml解析异常, 导致日志xml文件解析异常, 排除xpp3依赖
./gradlew :support-service:dependencies --configuration runtimeClasspath -Dorg.gradle.java.home=/Users/fa/Library/Java/JavaVirtualMachines/corretto-17.0.15/Contents/Home | grep -i xpp

# 全局排除（推荐）
# // 根项目 build.gradle
# allprojects {
#     configurations.all {
#         exclude group: 'xpp3', module: 'xpp3'
#     }
# }

# 首先找出是哪个依赖引入了 XPP：
./gradlew :support-service:dependencyInsight --configuration runtimeClasspath -Dorg.gradle.java.home=/Users/fa/Library/Java/JavaVirtualMachines/corretto-17.0.15/Contents/Home --dependency xpp3
# 然后针对性地排除：
# implementation('org.springframework.boot:spring-boot-starter-web') {
#     exclude group: 'xpp3', module: 'xpp3'
# }

# configurations.all {
#     exclude group: 'xpp3'
#     exclude module: 'xpp3'
# }

./gradlew clean build

rm -rf ~/.gradle/caches
```

```bash
# 查看日志相关依赖
./gradlew :support-service:dependencies --configuration runtimeClasspath  -Dorg.gradle.java.home=/Users/fa/Library/Java/JavaVirtualMachines/corretto-17.0.15/Contents/Home | grep -i "log\|slf4j"

# 检查依赖是否有冲突
# ./gradlew dependencies --configuration runtimeClasspath | grep -i "conflict\|duplicate"
./gradlew :support-service:dependencies --configuration runtimeClasspath  -Dorg.gradle.java.home=/Users/fa/Library/Java/JavaVirtualMachines/corretto-17.0.15/Contents/Home | grep -i "conflict\|duplicate"

```

```bash
# # 检查OCR依赖引入了哪些日志相关库
./gradlew :support-service:dependencyInsight --configuration runtimeClasspath --dependency com.aliyun:ocr_api20210707:3.1.3  -Dorg.gradle.java.home=/Users/fa/Library/Java/JavaVirtualMachines/corretto-17.0.15/Contents/Home
```
