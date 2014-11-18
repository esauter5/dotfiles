SELECT
  nspname,
  relname,
  attname,
  typname,
  (stanullfrac*100)::int AS null_percent,
  case when stadistinct >= 0 then stadistinct else abs(stadistinct)*reltuples end AS "distinct",
  case 1 when stakind1 then stavalues1 when stakind2 then stavalues2 end AS "values"
FROM
  pg_class c
  JOIN pg_namespace ns ON (ns.oid=relnamespace)
  JOIN pg_attribute ON (c.oid=attrelid)
  JOIN pg_type t ON (t.oid=atttypid)
  JOIN pg_statistic ON (c.oid=starelid AND staattnum=attnum)
WHERE
  nspname NOT LIKE E'pg\\_%'
  AND nspname != 'information_schema'
  AND relkind='r'
  AND NOT attisdropped
  AND attstattarget != 0
  AND reltuples >= 100
  AND stadistinct BETWEEN 0 AND 1
ORDER BY
  nspname,
  relname,
  attname;
