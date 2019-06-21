#!/usr/bin/env bash
ROOT=/root/isucon8-qualify
APP=${ROOT}/webapp/python

/etc/init.d/mysql start
echo start
mysql -uroot -e"CREATE USER isucon@'%' IDENTIFIED BY 'isucon';"
mysql -uroot -e"GRANT ALL on torb.* TO isucon@'%';"
mysql -uroot -e"CREATE USER isucon@'localhost' IDENTIFIED BY 'isucon';"
mysql -uroot -e"GRANT ALL on torb.* TO isucon@'localhost';"
mysql -uroot -e"SET GLOBAL max_heap_table_size = 1024 * 1024 * 800;"

#mysql -uroot -e'SET global log_output = "FILE";'
#mysql -uroot -e'SET global general_log_file="/tmp/mysql_general.log";'
#mysql -uroot -e'SET global general_log = 1;'


${ROOT}/db/init.sh
DB_DATABASE=torb DB_HOST=127.0.0.1 DB_PORT=3306 DB_USER=isucon DB_PASS=isucon python ${APP}/app.py
