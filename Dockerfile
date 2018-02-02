FROM nimlang/nim:latest

## Dependencies
RUN apt-get update
RUN apt-get install -y libssl-dev curl

# RUN git clone https://github.com/warmcat/libwebsockets.git
# WORKDIR libwebsockets
# RUN cmake CMakeLists.txt
# RUN make
# RUN make install
# RUN ldconfig

# RUN nimble install -y influx https://github.com/hlaaftana/websocket.nim@#patch-1 docopt
RUN nimble install -y influx docopt https://github.com/niv/websocket.nim@#head
RUN nimble install -y https://github.com/jamesalbert/grafana-nim@#head


# ADD ./bin/promptify /usr/local/bin/promptify

RUN mkdir /app
WORKDIR /app
