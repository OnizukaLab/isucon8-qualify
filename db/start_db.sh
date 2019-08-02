# /bin/bash!
ROOT=/root/isucon8-qualify
mysql -uroot -e"CREATE USER isucon@'%' IDENTIFIED BY 'isucon';"
mysql -uroot -e"GRANT ALL on torb.* TO isucon@'%';"
mysql -uroot -e"CREATE USER isucon@'localhost' IDENTIFIED BY 'isucon';"
mysql -uroot -e"GRANT ALL on torb.* TO isucon@'locahost';" 
mysql -uroot -e"SET GLOBAL max_heap_table_size = 1024 * 1024 * 800;"
#${ROOT}/db/init.sh

ROOT_DIR=$(cd $(dirname $0)/..; pwd)
DB_DIR="$ROOT_DIR/db"
BENCH_DIR="$ROOT_DIR/bench"

export MYSQL_PWD=isucon

mysql -uisucon -e"DROP DATABASE IF EXISTS torb; CREATE DATABASE torb;"
mysql -uisucon torb < "$DB_DIR/schema.sql"

if [ ! -f "$DB_DIR/isucon8q-initial-dataset.sql.gz" ]; then
  echo "Run the following command beforehand." 1>&2
  echo "$ ( cd \"$BENCH_DIR\" && bin/gen-initial-dataset )" 1>&2
  exit 1
fi

mysql -uisucon torb -e 'ALTER TABLE reservations DROP KEY event_id_and_sheet_id_idx'
gzip -dc "$DB_DIR/isucon8q-initial-dataset.sql.gz" | mysql -uisucon torb
mysql -uisucon torb -e 'ALTER TABLE reservations ADD KEY event_id_and_sheet_id_idx (event_id, sheet_id)'

