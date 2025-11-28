# Use jdk in jenkins

- Download to specified location

```bash
cd /var/lib/docker/volumes/web_jenkins_home/_data/
mkdir -p ./soft/jdk
cd /var/lib/docker/volumes/web_jenkins_home/_data/soft/jdk

wget https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.tar.gz
tar -zxvf openjdk-8u41-b04-linux-x64-14_jan_20.tar.gz

```

- Correspondents to the configuration in Jenkins

```bash
# jdk install path configuration
/var/jenkins_home/soft/jdk
```
