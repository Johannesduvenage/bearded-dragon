# {.compile: "c/listener.c".}


# proc Listen* (): cint {.importc.}

import clients/http/gdax.nim


proc Listen* (service: string, asset: var string): void =
  var gc = newGdaxHttpClient()
  gc.ListenTicker(service, asset)

  # TODO: create database named <service>-<asset>-<time> if it doesn't exist

  # let ws = waitFor newAsyncWebsocket("echo.websocket.org", Port 80, "/", ssl=false)



  # TODO: every tick, insert new data into influx

  # TODO: be able to view live updates from grafana
