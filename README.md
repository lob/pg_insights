# pg_extras

This repository contains sql scripts for monitoring Postgres database health.
They are based on commands from Heroku's
[pg_extras](https://github.com/heroku/heroku-pg-extras) repository.

## How to Use

You can run a script using `psql`'s `-f` option. For example:

```bash
$ psql lob_local -f cache_hit_rate.sql
```

It also works with aliases you have setup with `psql`:

```bash
$ psql_lob_prod -f cache_hit_rate.sql
```

## Scripts

#### [`bloat.sql`](sql/bloat.sql) (read permission)
* **Returns the approximate bloat from dead tuples for each table**
* This bloat can also be index bloat

#### [`buffer_cache_usage.sql`](sql/buffer_cache_usage.sql) (write permission)
* **Returns the distribution of shared buffers used for each table**
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

### [`table_size.sql`](sql/table_size.sql) (read permission)
* **Returns the size of each table in bytes**
* Does not include size of the tables' indices

#### [`table_size_with_indices.sql`](sql/table_size_with_indices.sql) (read permission)
* **Returns size of each table in bytes including all indices**

#### [`unused_indices.sql`](sql/unused_indices.sql) (read permission)
* **Returns indices that are rarely used**
* Note that sometimes the query optimizer will elect to avoid using indices for
  tables with a very small number of rows because it can be more efficient
