# TiDB dashboard

With Grafana v5.x or later, we can use provisions to provide data sources and dashboards. No need to use scripts to configure Grafana.

The JSON files in dashboards are copied from [tidb-ansible](https://github.com/pingcap/tidb-ansible/tree/master/scripts), and need to replace variables in the json file (it was by python file before).

It is used in [tidb-docker-compose](https://github.com/pingcap/tidb-docker-compose) and [tidb-operator](https://github.com/pingcap/tidb-operator).
