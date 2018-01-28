# import websocket, asyncnet, asyncdispatch
# import json
#
# var j = """
# {
#   "type": "subscribe",
#   "product_ids": [
#       "ETH-USD",
#       "ETH-EUR"
#   ],
#   "channels": [
#       "level2",
#       "heartbeat",
#       {
#           "name": "ticker",
#           "product_ids": [
#               "ETH-BTC",
#               "ETH-USD"
#           ]
#       }
#   ]
# }
# """
#
# let ws = waitFor newAsyncWebsocket("wss://ws-feed.gdax.com",
#   Port 80, "/", ssl = false)
# echo "connected!"
#
# proc reader() {.async.} =
#   while true:
#     let read = await ws.sock.readData(true)
#     echo "read: " & $read.data
#
# proc ping() {.async.} =
#   while true:
#     await sleepAsync(2000)
#     await ws.sock.sendText(j, true)
#
# asyncCheck reader()
# asyncCheck ping()
# runForever()
