#!/bin/bash

ROOT_DIR=$(cd $(dirname $0)/..; pwd)
DB_DIR="$ROOT_DIR/db"
BENCH_DIR="$ROOT_DIR/bench"

export MYSQL_PWD=isucon
sqlite3 /torb.db < "${DB_DIR}/schema.sql"

if [ ! -f "$DB_DIR/isucon8q-initial-dataset.sql.gz" ]; then
  echo "Run the following command beforehand." 1>&2
  echo "$ ( cd \"$BENCH_DIR\" && bin/gen-initial-dataset )" 1>&2
  exit 1
fi

gzip -dc "$DB_DIR/isucon8q-initial-dataset.sql.gz" |  sed -e "s/SET NAMES utf8mb4;//" | sqlite3 /torb.db
sqlite3 /torb.db 'CREATE INDEX event_id_and_sheet_id_idx ON reservations (event_id, sheet_id);'
