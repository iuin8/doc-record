# Query sql for all table data in pgsql database

Below is a sample： for SQL statements for all table data in the PostgreSQL database

Methodod 1：uses pg_class table

```sql
SELECT relname AS table_name, relicense AS row_count
FROM pg_class
WHERE relkind = 'r'
and relnamespace = (SECLECT oid FROM pg_namespace WHERE nspname = 'public');
```

This query statement returns the table name and the amount of data for all tables. You can replace `public` with the actual schema name you want to query.

Methodod II：uses pg_stat_user_tables view

```sql
SELECT schemaname, relname, n_live_up AS row_count
FROM pg_stat_user_tables;
```

This query returns the schema name, table name and corresponding data for all user tables.

The above is an example of the SQL statement for all table data in the Query PostgreSQL database. You can select the appropriate method to search according to specific needs.

References：

- [postgresql queries the number of all table data under the current schema - Program ape friend 666-bloggard][[1](https://www.cnblogs.com/chenghu/p/17201210.html)
- [PostgreSQL query log count _pg for all tables - CSDN blog][[2](https://blog.csdn.net/londa/article/details/109046131)
- [查看PostgreSQL数据库中所有表_pg查看库内表-CSDN博客][[3]](https://blog.csdn.net/huangbaokang/article/details/88862791)

---

Learn more:

1. [postcongresql queries the number of all table data under the current schema - Program ape friend 666 - Blog Gard] (https://www.cnblogs.com/chenghu/p/17201210.html)
2. [PostgreSQL Query logs for all tables_pg query data for all tables - CSDN blog](https://blog.csdn.net/londa/article/details/109046131)
3. [查看PostgreSQL数据库中所有表_pg查看库内表-CSDN博客](https://blog.csdn.net/huangbaokang/article/details/88862791)
