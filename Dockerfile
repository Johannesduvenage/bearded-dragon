FROM nimlang/nim:latest

## Dependencies
RUN apt-get update
RUN apt-get install -y libssl-dev
RUN nimble install -y influx websocket docopt

ADD ./bin/promptify /usr/local/bin/promptify

RUN mkdir /app
WORKDIR /app
