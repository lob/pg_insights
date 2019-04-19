SELECT relname,
  CASE idx_scan
    WHEN 0 THEN NULL
    ELSE round(100.0 * idx_scan / (seq_scan + idx_scan), 5)
  END percent_of_times_index_used,
  n_live_tup rows_in_table
FROM
  pg_stat_user_tables
ORDER BY
  n_live_tup DESC;
