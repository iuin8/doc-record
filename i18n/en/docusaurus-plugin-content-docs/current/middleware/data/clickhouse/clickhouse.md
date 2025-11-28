# clickhouse

## Install the specified version

[参考官网](https://clickhouse.com/docs/zh/getting-started/install#from-tgz-archives)

```bash
# Execute the installation script (enter the password of the `default` user in the middle and whether the default user is allowed to access anywhere)
# of the `LATEST_VERSION` environment variable in the script can fill in the version you want to install, default to the latest stable version (available here[https://github. om/ClickHouse/ClickHouse/tags])
cash clickhouse-install.sh
# Launch
sudo /etc/init.d/clickouse-server start
# Connect
clickhouse-client
# Example
SELECT 1
```
