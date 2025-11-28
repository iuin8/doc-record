# vscode remote ssh

## glibc >= 2.28, libstdc++ >= 3.4.25

```bash
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliun.com/repo/Centos-7.repo
# Installing SCL repository
yum install -y cents-release-scl
# Try installing
yum - y devolset-8-gcc*

```

### Error while installing `devtoolset-8-gcc*`

Replace link to Aliyun

```bash
cd /etc/yum.repos.d/
mv CentOS-SCLo-scl.repo CentOS-SCLo-scl.repo.bak
mv CentOS-SCLo-scl-rh.repo CentOS-SCLo-scl-rh.repo.bak

```

File I：CentOS-SCLo-scl.repo

```bash
[centos-sclo-sclo]
name=CentOS-7 - SCLo sclo
baseurl=https://mirrors.aliyun.com/centos/7/sclo/$basearch/sclo/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo

[centos-sclo-sclo-testing]
name=CentOS-7 - SCLo sclo Testing
baseurl=http://buildlogs.centos.org/centos/7/sclo/$basearch/sclo/
gpgcheck=0
enabled=0

[centos-sclo-sclo-source]
name=CentOS-7 - SCLo sclo Sources
baseurl=http://vault.centos.org/centos/7/sclo/Source/sclo/
gpgcheck=1
enabled=0

[centos-sclo-sclo-debuginfo]
name=CentOS-7 - SCLo sclo Debuginfo
baseurl=http://debuginfo.centos.org/centos/7/sclo/$basearch/debuginfo/
gpgcheck=1
enabled=0

```

Document II：CentOS-SCLo-scl-rh.repo

```bash
[centos-sclo-rh]
name=CentOS-7 - SCLo rh
baseurl=https://mirrors.aliyun.com/centos/7/sclo/x86_64/rh/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo

[centos-sclo-rh-testing]
name=CentOS-7 - SCLo rh Testing
baseurl=http://buildlogs.centos.org/centos/7/sclo/x86_64/rh/
gpgcheck=0
enabled=0

[centos-sclo-rh-source]
name=CentO-7 - SCLo rh Sources
baseurl=http://vault.centos.org/centos/7/sclo/Source/rh/
gpgcheck=1
enabled=0

[centos-sclo-rh-debuginfo]
name=CentOS-7 - SCLo rh Debuginfo
baseurl=http://debuginfo.centos.org/centos/7/sclo/x86_64/debuginfo/
gpgcheck=1
enabled=0

```

```bash
yum clean all
yum makeache
# Verify
yum polist | grep scl
# Install
yum install - y devtoolset-8-gcc*
```

### glibc >= 2.28 (upgrade)

```bash
# See glibc version
strings /lib64/libc.so.6 |grep GIBC_
# Update glibc
wget http://ftp.gnu.org/gnu/glibc/glibc-2.28.tar.gz
tar xf glibc-2. 8.tar. z 
cd glibc-2.28/ && mkdir build && cd build
../configure --prefix=/usr --disable-profile --enable-add-ons -with-headers=/usr/include-bins=/usr/bin
```

Possible Errors

```bash
configure: error: 
**These critical programs are missing or to: make bus compiler
*** Check the INSTRAW file for required versions.
```

Solutions：upgrade gccs and make

```bash
# Upgrade GCC (upgrade to 8 by default)</span>
yum install -y cents-release-scl
yum install - y devtoolset-8-gcc*
mv /usr/bin/gcc /usr/bin/gcc-4. 5
ln -s /opt/rh/devtoolset-8/root/bin/gcc /usr/bin/gcc
mv /usr/bin/g++-4.8.
ln -s /opt/rh/devtoolset-8/root/bin/g++/usr/bin/g++++

# Upgrade make (3 upgrade to 4)
get http://ftp.gnu.org/gnu/make/make-4.3.tar.gz
tar -xzvf make-4.3.tar. z && cd make-4.3/
./configure --prefix=/usr/local/make
make && make install
cd /usr/bin/ && mv make make.bak
ln -sv /usr/local/make/bin/make/usr/bin/make
```

All issues have been resolved and the previous glib update has been completed

```bash
cd /root/glibc-2.28/build
../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
```

My still misstated：bis is too old

```bash
configure: error: 
**These critical programs are missing or to: bus
*** Check the SESL file for required versions.
```

See how many of my delivery versions

```bash
bison --version
# -basis: basis: no command

yum install -y bus
bison --version
```

Facting all the questions have been resolved and re-executed the previous glib update

```bash
cd /root/glibc-2.28/build
../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
```

Continue to update

Make and make install in linux is a simple way of installing the software.
This process is lengthy, about half an hour, and it is better to recommend a game.

```bash
Make & make install
# PS: Looks like error and don't affect
```

Verify that it's not good (PS: remote server with remote-ssh with vscode)

Connect the new dynamic library if the following issues persisted.

```bash
node: /lib64/libstdc++.so.6: version `CXXABI_1.3.9' not found (required by node)
node: /lib64/libstdc++.so.6: version `GLCXX_3. 20' not found (required by node)
node: /lib64/libstdc+.so.6: version `GLCXX_3.4.21' not found (required by node)
```

View with the command below

```bash
strings /usr/lib64/libstdc++.so.6 | grep CXXABI
```

Update libstdc++.so.6.0.26

```bash
# 更新lib libstdc++.so.6.0.26
 
wget https://cdn.frostbelt.cn/software/libstdc%2B%2B.so.6.0.26 --no-check-certificate
 
 
# 替换系统中的/usr/lib64
cp libstdc++.so.6.0.26 /usr/lib64/

cd /usr/lib64/

ln -snf ./libstdc++.so.6.0.26 libstdc++.so.6
```

Verify again (PPS: connect remote server with remote-ssh with vscode)

```bash
# 连接成功后, 可能遇到的新问题
# manpath: can't set the locale; make sure $LC_* and $LANG are correct
```

Solutions

```bash
# Check current timezone
locale
# The following error
$ locale
locale: Cannot set LC_ALL to default locale: No such file or directory
LANG=en_US. TF-8
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US. TF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASURREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_ALL==
```

```bash
# 生成缺失的区域设置
locale -a
# 编辑区域配置文件
vi /etc/locale.conf

# 添加以下内容
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8

# 生成区域设置
localedef -i en_US -f UTF-8 en_US.UTF-8

# 如果需要其他区域设置，可以相应更改 en_US 和 UTF-8。例如，对于简体中文：
localedef -i zh_CN -f UTF-8 zh_CN.UTF-8

# 设置环境变量临时生效
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 你可以将这些命令添加到 ~/.bashrc 或 ~/.bash_profile 文件中，以便每次登录时自动设置：
echo 'export LANG=en_US.UTF-8' >> ~/.bashrc
echo 'export LC_ALL=en_US.UTF-8' >> ~/.bashrc
source ~/.bashrc

# 验证
locale
```

## Reference link

[node: /lib64/libm.so.6: version \\`GLIBC_2.27' not foundational problem solution](https://www.cnblogs.com/yuwen01/p/18067005)
