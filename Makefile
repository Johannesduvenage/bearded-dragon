all: build up compile

build:
	docker-compose build --no-cache

up:
	docker-compose up -d

compile:
	docker-compose exec bearded-dragon nim c -d:ssl -o:bin/dragon dragon.nim

dragon:
	docker-compose exec bearded-dragon ./bin/promptify ./bin/dragon

kill:
	docker-compose kill

restart:
	docker-compose restart

connect:
	docker-compose exec bearded-dragon bash

query:
	curl -sG 'http://localhost:8086/query?pretty=true' --data-urlencode "db=$(db)" --data-urlencode "q=$(q)"

clean: kill
	-rm -rf nimcache
	-rm -rf grafana
	-rm -rf influxdb
