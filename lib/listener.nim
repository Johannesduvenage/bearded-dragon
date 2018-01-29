import websocket, asyncnet, asyncdispatch
import json, net


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


proc Listen* (service: string): void =
  let ws = waitFor newAsyncWebsocket("wss://ws-feed.gdax.com:443/", ctx=newContext(verifyMode=CVerifyNone))
  echo "connected!"

  # proc reader() {.async.} =
  #   while true:
  #     let read = await ws.sock.readData(true)
  #     echo "read: " & $read.data
  #
  #
  # proc ping() {.async.} =
  #   while true:
  #     await sleepAsync(5000)
  #     await ws.sock.sendPing(true)
  #     # await ws.sock.sendText(j, false)
  #
  # asyncCheck reader()
  # asyncCheck ping()
  # runForever()
