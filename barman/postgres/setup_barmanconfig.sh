#!/bin/bash
set -e

# Configure shared_preload_libraries
gosu postgres cat >> $PGDATA/postgresql.conf << EOL
wal_level = 'archive' # For PostgreSQL >= 9.0
archive_mode = on
archive_command = 'rsync -a -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" %p barman@backup:INCOMING_WALS_DIRECTORY/%f'
EOL
 
gosu postgres pg_ctl -D "$PGDATA" -w stop -m fast
gosu postgres pg_ctl -D "$PGDATA" -w start

# read the auto conf params
gosu postgres pg_ctl -D "$PGDATA" reload
