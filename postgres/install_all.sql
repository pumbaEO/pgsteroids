-- enabled logger
\c postgres
ALTER SYSTEM SET logging_collector = on;
ALTER SYSTEM SET log_directory = '/var/log/postgresql/';
ALTER SYSTEM SET log_duration = on;
ALTER SYSTEM SET log_min_duration_statement = 1;
ALTER SYSTEM SET log_checkpoints = on;
ALTER SYSTEM SET log_connections = on;
ALTER SYSTEM SET log_disconnections = on;
ALTER SYSTEM SET log_lock_waits = on;
ALTER SYSTEM SET log_temp_files = 0;
ALTER SYSTEM SET log_line_prefix = '%t [%p]: [%l-1] ';
ALTER SYSTEM SET lc_messages = 'C';
ALTER SYSTEM SET logging_collector=on;

--enable tablespace for system tables of onec-enterprise
ALTER SYSTEM SET temp_tablespaces = 'additional_temp_tblspc'
create TABLESPACE additional_temp_tblspc LOCATION '/src/four/pg_tmp_tblspace';

-- enable hypotetics index
CREATE EXTENSION hypopg;

CREATE database powa;
\c powa
CREATE EXTENSION pg_stat_statements;
CREATE EXTENSION btree_gist;
CREATE EXTENSION pg_qualstats;
CREATE EXTENSION pg_stat_kcache;
CREATE EXTENSION pg_track_settings;
CREATE EXTENSION powa;

\c template1
CREATE EXTENSION hypopg;
CREATE EXTENSION pgstattuple;
-- enable prewarm for system tables
CREATE EXTENSION pg_prewarm;
CREATE EXTENSION pg_buffercache;
