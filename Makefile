all: build run compile

clean: kill
	-rm -rf nimcache
	-rm -rf grafana
	-rm -rf influxdb

logs:
	docker logs -f `docker ps -aqf "name=beardeddragon_bearded-dragon_1"`

compile:
	docker-compose exec bearded-dragon nim c -d:ssl -o:bin/dragon dragon.nim

build:
	docker-compose build --no-cache

run:
	docker-compose up -d

dragon:
	docker-compose exec bearded-dragon ./bin/promptify ./bin/dragon

kill:
	docker-compose kill

restart:
	docker-compose restart
	make logs

connect:
	docker-compose exec bearded-dragon bash

query:
	curl -sG 'http://localhost:8086/query?pretty=true' --data-urlencode "db=$(db)" --data-urlencode "q=$(q)"
