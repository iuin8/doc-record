# java Related Records

## Ali's open source jdk

[dragonwell](https://www.aliyun.com/product/dragonwell)

## openjdk download

[参考链接](https://www.cnblogs.com/haimishasha/p/9909055.html)

    ```
    # openjdk official net 
    http://hg.openjdk.java.net/
    
    # Amazon release
    https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/downloads-list.html
    wget https://corretto.aws/downloads/latest/amazon-retto-8-x64-linux-jdk.tar.gz
    wget https://corretto/downloads/latest/amazon-corretto-11-x-linux-jdk.tar.gz
    
    tar -zxvf openjdk-8u41-b04-linux-x64-14_jan_20.tar.gz # After downloading
    ```

## openjdk compilations

    ```
    yum install unzip
    unzip openjdk-8u40-src-b25-10_feb_2015.zip
    cd openjdk/
    sudo bash ./configure --with-target-bits=64 --with-boot-jdk=/home/jiazhifeng/workspace/jdk1.7.0_80/ --with-debug-level=slowdebug --enble-debt ZIP_BUGINFO_FILES=0
    sudo make all DISABLE_HOTPOT_OS_VERSION_CHECK=OK ZIP_FILES=0
    ```

> 说明下第一条命令configure用到的参数作用：\
> –with-target-bits=64 ：指定生成64位jdk；\
> –with-boot-jdk=/usr/java/jdk1.7.0_80/：启动jdk的路径；\
> –with-debug-level=slowdebug：编译时debug的级别，有release, fastdebug, slowdebug 三种级别；\
> –enable-debug-symbols ZIP_DEBUGINFO_FILES=0：生成调试的符号信息，并且不压缩；
