FROM golang:latest

RUN mv /bin/sh /bin/sh_tmp && ln -s /bin/bash /bin/sh

RUN apt-get update && apt-get install -y python-setuptools zlib1g-dev && easy_install pip
RUN apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl git jq
RUN apt-get install -y mysql-server mysql-client default-libmysqlclient-dev libmariadbclient-dev
RUN pip install py-spy

RUN git clone https://github.com/ansible/ansible.git --recursive /opt/ansible
RUN cd /opt/ansible && source /opt/ansible/hacking/env-setup && source /opt/ansible/hacking/env-setup -q
RUN pip install -r /opt/ansible/requirements.txt
RUN cd /opt/ansible && git pull --rebase && git submodule update --init --recursive
RUN rm /bin/sh && mv /bin/sh_tmp /bin/sh
RUN git clone https://github.com/tagomoris/xbuild.git /opt/xbuild
RUN mkdir /root/local && /opt/xbuild/go-install 1.10.3 /root/local/go && /opt/xbuild/python-install 3.7.0 /root/local/python
ENV PATH /root/local/go/bin:/root/local/python/bin:$PATH

RUN git clone https://github.com/isucon/isucon8-qualify.git $HOME/isucon8-qualify && cd $HOME/isucon8-qualify/bench && make deps && make
RUN cd /root/isucon8-qualify/bench && ./bin/gen-initial-dataset
RUN pip install -r /root/isucon8-qualify/webapp/python/requirements.txt

# MySQL to SQLite3
RUN wget https://gist.githubusercontent.com/esperlu/943776/raw/be469f0a0ab8962350f3c5ebe8459218b915f817/mysql2sqlite.sh -O /mysql2sqlite.sh
RUN apt-get install sqlite3

WORKDIR /root/isucon8-qualify/webapp/python
