all: build run compile

clean:
	-rm -rf nimcache

logs:
	docker logs -f `docker ps -aqf "name=beardeddragon_bearded-dragon_1"`

compile:
	docker-compose exec bearded-dragon nim c -d:ssl -o:bin/dragon dragon.nim

build:
	docker-compose build

run:
	docker-compose up -d

dragon:
	docker-compose exec bearded-dragon promptify ./bin/dragon

kill:
	docker-compose kill

restart:
	docker-compose restart
	make logs
