#!/bin/bash

docker run -p 8080:8080 -it --name app --memory=1024M --cap-add=SYS_PTRACE -v `pwd`:/root/isucon8-qualify isucon8 sh run_app.sh
