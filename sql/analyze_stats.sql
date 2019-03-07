WITH table_opts AS (
  SELECT
    pg_class.oid, relname, nspname, array_to_string(reloptions, '') AS relopts
  FROM
     pg_class INNER JOIN pg_namespace ns ON relnamespace = ns.oid
), vacuum_settings AS (
  SELECT
    oid, relname, nspname,
    CASE
      WHEN relopts LIKE '%autovacuum_analyze_threshold%'
        THEN substring(relopts, '.*autovacuum_analyze_threshold=([0-9.]+).*')::integer
        ELSE current_setting('autovacuum_analyze_threshold')::integer
      END AS autovacuum_analyze_threshold,
    CASE
      WHEN relopts LIKE '%autovacuum_analyze_scale_factor%'
        THEN substring(relopts, '.*autovacuum_analyze_scale_factor=([0-9.]+).*')::real
        ELSE current_setting('autovacuum_analyze_scale_factor')::real
      END AS autovacuum_analyze_scale_factor
  FROM
    table_opts
)
SELECT
  vacuum_settings.relname AS table,
  to_char(psut.last_analyze, 'YYYY-MM-DD HH24:MI') AS last_analyze,
  to_char(psut.last_autoanalyze, 'YYYY-MM-DD HH24:MI') AS last_autoanalyze,
  to_char(pg_class.reltuples, '9G999G999G999') AS rowcount,
  to_char(pg_class.reltuples / NULLIF(pg_class.relpages, 0), '999G999.99') AS rows_per_page,
  to_char(autovacuum_analyze_threshold
       + (autovacuum_analyze_scale_factor::numeric * pg_class.reltuples), '9G999G999G999') AS autovacuum_analyze_threshold,
  CASE
    WHEN autovacuum_analyze_threshold + (autovacuum_analyze_scale_factor::numeric * pg_class.reltuples) < psut.n_dead_tup
    THEN 'yes'
  END AS will_analyze
FROM
  pg_stat_user_tables psut INNER JOIN pg_class ON psut.relid = pg_class.oid
    INNER JOIN vacuum_settings ON pg_class.oid = vacuum_settings.oid
ORDER BY 1
