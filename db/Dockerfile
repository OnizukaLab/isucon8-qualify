FROM mysql:5.7

RUN apt-get update && apt-get install -y git && apt-get clean
RUN cd /root && git clone https://github.com/OnizukaLab/isucon8-qualify.git
ADD ./start_db.sh /docker-entrypoint-initdb.d/
ADD ./isucon8q-initial-dataset.sql.gz /root/isucon8-qualify/db/
