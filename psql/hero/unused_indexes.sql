/* show unused and almost unused indexes, ordered by their size relative to */
/* the number of index scans. Exclude indexes of very small tables (less than */
/* 5 pages), where the planner will almost invariably select a sequential */
/* scan, but may not in the future as the table grows. */
WITH index_stats AS (
  SELECT
    schemaname || '.' || relname AS table,
    indexrelname AS index,
    idx_scan + idx_tup_read + idx_tup_fetch as index_usage,
    indexrelid,
    relid
  FROM pg_stat_user_indexes
)
SELECT index_stats.table, index_stats.index, index_usage,
    pg_size_pretty(pg_relation_size(i.indexrelid)) AS index_size
FROM index_stats JOIN pg_index i USING (indexrelid)
WHERE NOT indisunique AND index_usage < 50 AND pg_relation_size(relid) > 5 * 8192
ORDER BY pg_relation_size(i.indexrelid) / nullif(index_usage, 0) DESC NULLS FIRST,
pg_relation_size(i.indexrelid) DESC;
