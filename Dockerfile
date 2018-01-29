FROM nimlang/nim:latest

## Dependencies
RUN apt-get update
RUN apt-get install -y libssl-dev
# RUN nimble install -y influx https://github.com/hlaaftana/websocket.nim@#patch-1 docopt
RUN nimble install -y influx docopt https://github.com/niv/websocket.nim@#head

ADD ./bin/promptify /usr/local/bin/promptify

RUN mkdir /app
WORKDIR /app
