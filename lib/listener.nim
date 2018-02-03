# {.compile: "c/listener.c".}


# proc Listen* (): cint {.importc.}

import clients/http/gdax.nim


proc Listen* (service: string, asset: string): void =
  var gc = newGdaxHttpClient()
  gc.ListenTicker(service, asset)
