SELECT
w.query as waiting_query,
w.pid as waiting_pid,
w.usename as waiting_user,
l.query as blocking_query,
l.pid as blocking_pid,
l.usename as blocking_user,
t.schemaname || '.' || t.relname as tablename
FROM pg_stat_activity w
JOIN pg_locks l1 on w.pid = l1.pid AND NOT l1.granted
JOIN pg_locks l2 on l1.relation = l2.relation AND l2.granted
JOIN pg_stat_activity l on l2.pid = l.pid
JOIN pg_stat_user_tables t ON l1.relation = t.relid
WHERE w.waiting;
