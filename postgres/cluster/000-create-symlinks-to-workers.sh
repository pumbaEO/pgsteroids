#!/bin/bash

set -e

# make bash behave
set -euo pipefail
IFS=$'\n\t'

# constants
workerlist=pg_worker_list.conf
citusconfdir=/etc/citus
externalworkerlist="$citusconfdir/$workerlist"

# create worker list file if it doesn't exist
touch "$externalworkerlist"

# ensure permissions, then symlink to datadir
chown postgres:postgres "$externalworkerlist"
gosu postgres ln -s "$externalworkerlist" "$PGDATA/$workerlist"

gosu postgres echo "shared_preload_libraries = 'citus'" >> $PGDATA/postgresql.conf.sample
