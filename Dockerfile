FROM nimlang/nim:latest

RUN apt-get update
RUN apt-get install -y libssl-dev curl

# RUN git clone https://github.com/warmcat/libwebsockets.git
# WORKDIR libwebsockets
# RUN cmake CMakeLists.txt
# RUN make
# RUN make install
# RUN ldconfig

RUN nimble install -y influx docopt
RUN nimble install -y https://github.com/jamesalbert/websocket.nim@#patch-1
RUN nimble install -y https://github.com/jamesalbert/grafana-nim@#head


RUN mkdir /app
WORKDIR /app
