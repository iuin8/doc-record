# Jenkins uses maven

- Download to specified location

```bash
cd /var/lib/docker/volumes/web_jenkins_home/_data/
mkdir -p /soft/maven
cd /var/lib/docker/volumes/web_jenkins_home/_data/soft/maven

wget https://repo.maven.apache.org/mave/maven/apache-maven/3.8.4/apache-maven-3.8.4-bin.zip
unzip apache-maven-3.84-binzip

```

- Correspondents to config in jenkins

```bash
# maven installation path configuration
/var/jenkins_home/soft/maven
```
