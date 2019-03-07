SELECT
  datname AS database,
  pid,
  usename AS username,
  state,
  query,
  backend_start,
  xact_start,
  query_start,
  state_change
FROM pg_stat_activity
WHERE query LIKE 'autovacuum:%';
