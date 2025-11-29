# yum install erlang

```shell

#Uninstalling erlang
yum -y remove erlang-*

#Press Action

#Install
using repository to install 
 wget https://packages.com/erlang-solutions-2.0-1.noarch.rpm
rpm -Uvh erlang-solutions-2.0-1.noarch.rpm

#Manually add repository entry
rpm -import https://packages.erlang-solutions.com/rpm/erlang_solutions. Sc

# Clear existing yum cache
yum clean all
# Generate cache
yum makecache
# Check if configured yum repolist
yum repolist

#View erlang installation version
yum list | grep erlang

yum list erlang -showduplicates | sort -r

#Installation, You can install the specified version
yum install -y erlang

#install erlang version
yum install erlang-24. -1.el7.aarch64

```
