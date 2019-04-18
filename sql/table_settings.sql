SELECT relname, unnest(reloptions)
FROM PG_CLASS
JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace
WHERE pg_namespace.nspname = 'public' AND reloptions IS NOT NULL;
