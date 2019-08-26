# pg_insights

Convenient SQL for monitoring Postgres database health. This repository is
inspired by commands from Heroku's
[pg_extras](https://github.com/heroku/heroku-pg-extras) repository.

## How to Use

### psql

You can run a script using `psql`'s `-f` option. For example:

```bash
$ psql postgres -f sql/cache_hit_rate.sql
```

It also works with aliases you have setup with `psql`:

```bash
$ alias psql_my_db="psql -h my_db.com -d my_db -U admin"
$ psql_my_db -f sql/cache_hit_rate.sql
```

### Other

You can also copy/paste any of the SQL in the [`sql/`](sql) directory and run
with the Postgres client of your choice.

## Scripts

#### [`active_autovacuums.sql`](sql/active_autovacuums.sql) (admin permission)
* **Returns all running autovacuums operations**

#### [`analyze_stats.sql`](sql/analyze_stats.sql) (read permission)
* **Returns autovacuum analyze stats for each table**

#### [`bloat.sql`](sql/bloat.sql) (read permission)
* **Returns the approximate bloat from dead tuples for each table**
* This bloat can also be index bloat

#### [`buffer_cache_usage.sql`](sql/buffer_cache_usage.sql) (admin permission)
* **Returns the distribution of shared buffers used for each table**
* *Requires the [pg_buffercache](https://www.postgresql.org/docs/current/pgbuffercache.html) extension*
* Includes the total bytes of a table in shared buffers, the percentage of
  shared buffers a table is using, and the percentage of a table the exists
  in shared buffers

#### [`cache_hit_rate.sql`](sql/cache_hit_rate.sql) (read permission)
* **Returns the cache hit rate for indices and tables**
* This is the rate of queries that only hit in-memory shared buffers rather
  than having to fetch from disk
* Note that a queries that are cache misses in Postgres's shared buffers may
  still hit the in-memory OS page cache, so a miss not technically go all the
  way to the disk
* Both of these rates should be 99+% ideally

#### [`index_hit_rate.sql`](sql/index_hit_rate.sql) (read permission)
* **Returns the index hit rate for each table**
* This rate represents the percentage of queries that utilize 1 or more indices
  when querying a table
* These rates should be 99+% ideally

#### [`index_size.sql`](sql/index_size.sql) (read permission)
* **Returns the size of each index in bytes**

#### [`reset_stats.sql`](sql/reset_stats.sql) (admin permission)
* **Resets pg_stats statistics tables**

#### [`table_settings.sql`](sql/table_settings.sql) (read permission)
* **Returns the table-specific settings of each table.**

#### [`table_size.sql`](sql/table_size.sql) (read permission)
* **Returns the size of each table in bytes**
* Does not include size of the tables' indices

#### [`table_size_with_indices.sql`](sql/table_size_with_indices.sql) (read permission)
* **Returns size of each table in bytes including all indices**

#### [`unused_indices.sql`](sql/unused_indices.sql) (read permission)
* **Returns indices that are rarely used**
* Note that sometimes the query optimizer will elect to avoid using indices for
  tables with a very small number of rows because it can be more efficient

#### [`vacuum_stats.sql`](sql/vacuum_stats.sql) (read permission)
* **Returns autovacuum stats for each table**

## Contributing

Pull requests for bug fixes, improvements, or new SQL are always welcome!
