# pgsql使用记录

## 格式化long类型时间字段

```sql
-- long类型时间字段格式化
SELECT
    to_timestamp(create_time/1000) AT TIME ZONE 'Asia/Shanghai' AS create_time_local,
    *
FROM table_name;
```
