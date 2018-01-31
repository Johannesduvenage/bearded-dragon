import websocket, asyncnet, asyncdispatch
import json, net

import clients/http/gdax.nim


var j = """
{
    "type": "subscribe",
    "product_ids": [
        "BTC-USD"
    ],
    "channels": [
        "level2"
        {
            "name": "ticker",
            "product_ids": [
                "BTC-USD"
            ]
        }
    ]
}
"""


proc Listen* (service: string, asset: string): void =

  var gc = newGdaxHttpClient()
  echo gc.ProductTicker("BTC-USD")

  # TODO: create database named <service>-<asset>-<time> if it doesn't exist

  # let ws = waitFor newAsyncWebsocket("ws-feed-public.sandbox.gdax.com", Port 443, "/", ssl=true)
  # let ws = waitFor newAsyncWebsocket("wss://ws-feed-public.sandbox.gdax.com:443/ticker", ctx=newContext(verifyMode=CVerifyNone))
  # echo "connected!"

  # TODO: initiate connection, sustain subscription

  # TODO: every tick, insert new data into influx

  # TODO: be able to view live updates from grafana

  # proc reader() {.async.} =
  #   while true:
  #     let read = await ws.sock.readData(true)
  #     echo "read: " & $read.data
  #
  #
  # proc ping() {.async.} =
  #   while true:
  #     await sleepAsync(3000)
  #     await ws.sock.sendPing(true)
  #     # await ws.sock.sendText(j, false)
  #
  # asyncCheck reader()
  # asyncCheck ping()
  # runForever()
