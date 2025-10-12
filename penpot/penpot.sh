#!/usr/bin/env bash

if [ "$1" == "start" ]; then 
	if ! docker info >/dev/null 2>&1; then
		systemctl start docker.socket
	fi

	if ! [ $? -eq 0 ]; then
		$?
	else
		(docker compose -p penpot -f docker-compose.yaml up -d && \
		firefox	http://localhost:9001 >/dev/null 2>&1) &
	fi
elif [ "$1" == "stop" ]; then
	docker compose -p penpot -f docker-compose.yaml down
	if [ "$2" == "all" ]; then
		systemctl stop docker.socket
	fi
fi


