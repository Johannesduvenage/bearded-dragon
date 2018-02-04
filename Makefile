all: build up compile

build:
	docker-compose build --no-cache

up:
	docker-compose up -d

exec:
	docker-compose exec bearded-dragon $(cmd)

decache:
	-find . -name nimcache | xargs rm -rf

compile: decache
	make exec cmd="nim c -d:ssl --threads:on -o:bin/dragon dragon"

test: decache
	make exec cmd="nim c -r -d:ssl --threads:on -o:bin/dragon_test tests/dragon_test"

dragon:
	make exec cmd="./bin/dragon shell"

connect:
	make exec cmd="bash"

kill:
	docker-compose kill

restart:
	docker-compose restart

query:
	curl -sG 'http://localhost:8086/query?pretty=true' --data-urlencode "db=$(db)" --data-urlencode "q=$(q)"

db:
	make query q="show databases"

series:
	make query db=$(db) q="show series"

clean: kill
	-rm -rf nimcache
	-rm -rf grafana
	-rm -rf influxdb
