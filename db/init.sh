#!/bin/bash

ROOT_DIR=$(cd $(dirname $0)/..; pwd)
DB_DIR="$ROOT_DIR/db"
BENCH_DIR="$ROOT_DIR/bench"

export MYSQL_PWD=isucon

mysql -uisucon -e "DROP DATABASE IF EXISTS torb; CREATE DATABASE torb;"
mysql -uisucon torb < "$DB_DIR/schema.sql"

if [ ! -f "$DB_DIR/isucon8q-initial-dataset.sql.gz" ]; then
  echo "Run the following command beforehand." 1>&2
  echo "$ ( cd \"$BENCH_DIR\" && bin/gen-initial-dataset )" 1>&2
  exit 1
fi

mysql -uisucon torb -e 'ALTER TABLE reservations DROP KEY event_id_and_sheet_id_idx'
gzip -dc "$DB_DIR/isucon8q-initial-dataset.sql.gz" | mysql -uisucon torb
mysql -uisucon torb -e 'ALTER TABLE reservations ADD KEY event_id_and_sheet_id_idx (event_id, sheet_id)'
mysql -uisucon torb -e 'INSERT INTO sheets (id, rank, num, price, event_id) SELECT sheets_base.id, sheets_base.rank, num, sheets_base.price, events.id as events_id from sheets_base inner join events;'
mysql -uisucon torb -e 'UPDATE sheets SET isUsed = 1 WHERE (id,event_id) IN (SELECT sheet_id, event_id FROM reservations WHERE canceled_at IS NULL)'
mysql -uisucon torb -e 'ALTER TABLE sheets ADD KEY sheets_event_id_and_sheet_id_idx (isUsed, event_id, rank)'
mysql -uisucon torb -e 'ALTER TABLE sheets ADD KEY sheets_rank_and_num_idx (rank,num)'
