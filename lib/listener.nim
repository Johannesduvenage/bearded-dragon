import asyncdispatch
import clients/http/gdax.nim


proc Listen* (args: tuple[service, asset: string]) =
  var gc = newGdaxHttpClient()
  gc.ListenTicker(args.service, args.asset)
