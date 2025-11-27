# Stacker of postprogress_PostgreSQL_Script

> ## Excel
>
> This article, which focuses on the way in which postmorql dead locks are orchestrated, is of great value and hopefully helpful.Follow the pocket to see it

---

1. Ask for the active sql to see which updates are available for updates.

Select \*
from pg_stat_activity
where state = 'active';

2\. Existing lock in query table

select a.locktype, a.database, a.pid, a.mode, a.relation, b.relname
from pg_locks a
join pg_class b on a.relation = b.oid
where lower(b.relname) = 'h5_game';

3\. Kill the locking process

Select pg_terminator_backend(pid)
from pg_stat_activity
where state = 'active'
and pid! pg_backend_pid()
\--and pid = 14172
and pid in (select a. id
from pg_locks a
join pg_class b on a.relation = b.oid
where lower(b.relname) = 'news_content')

Lock mode

/\* NoLock is not a lock mode, but a flag value meaning "don't get a block" \*/
\#define NoLock

\#define AccessShareLock 1 /\* SELECT _/
\#define RowShareLock 2 /_ SELECT FOR UPDATE/FOR SHARE _/
\#define RowExclusiveLock 3 /_ INSERT, UPDATE, DELETE _/
\#define ShareUpdateExclusiveLock 4 /_ VACUM (non-FULL), ANALYZE, CREATE
\* INDEX CONCURRENTLY _/
\#definition ShareLock 5 /_ CREATE INDEX (WITHOUT CONCURRENTLY)_/
\#define ShareRowExclusiveLock 6 /_ like CLEXUSIVE MODE, but allows ROW
\* SHARE _/
\#define ExclusiveLock 7 /_ blocks ROW SHARE/SEELCT. .FOR
\* UPDATE _/
\#define AccessExclusiveLock 8/_ ALTER TABLE, DROP TABLE, VACUM
\* FULL, and unquaralified LOCK TABLE \*/

**Supplement：Postprogresql Deathlock**

Background：

All action on the table is stuck, probably because it is being updated to cause it to be dead and to start an troubleshooting.

### Resolve an：query pg\_stat\_activity with no record

pg Version 10.2

Select pid,query,\* from pg_stat_activity where datame='dead locked database' and wait_event_type = 'Lock';
select pg_ancel_backend('id' of the dead lock's data');##can only kill selection, no action on the other
pg_terminte_backend ('idvalue of the dead lock' data'); #select, drop, etc.

When executed, select and delete tables are found to be performed properly, but truncate and drop tables are running and are not misstated.

"Drop table" and "truncate table" require an application to lock "ACCESS EXCLUSIVE", when this command is blocked, indicating that there is still an operation on this table, such as query, etc.

Only SQL can access the "ACCESS EXCLUSIVE" lock on this table only if this query is completed, "drop table" or "truncate table" or add fields.

### Solve 2：query pg\_locks if this object has lock

Select oid,relname from pg_class where relname='table name';
select locktype,pid,relation,mode,granted,\* from pg_locks where relation=';
select pg_terminte_backend('process ID');

Problem solving!!!

坑：一开始不知道pg\_cancel\_backend(‘死锁那条数据的pid值');##只能杀死select 语句, 对其他语句不生效，杀了进程查询发现还存在，反复杀反复存在，换了pg\_terminate\_backend(‘进程ID')问题就解决了。

The above is a personal experience and it is hoped that it will be a reference for everyone and that there will be more support for the script.If there is an error or a lack of consideration, let us know how to do so.

Original link：https://blog.csdn.net/fsstyle/article/details/8917720
