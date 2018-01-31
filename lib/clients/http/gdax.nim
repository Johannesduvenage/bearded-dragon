import httpclient, json, tables, strutils

let url = "https://api.gdax.com/"

type
  GdaxHttpClient* = object
    cli: HttpClient


# proc newGdaxHttpClient* (host: string, user: string, pass: string): GdaxHttpClient =
proc newGdaxHttpClient* (): GdaxHttpClient =
  let client = newHttpClient()
  # client.headers = newHttpHeaders({
  #   "Content-Type": "application/json",
  #   "Accept": "application/json",
  #   "Authorization": "Basic " & encode(user & ":" & pass)
  # })
  return GdaxHttpClient(cli: client)


# TODO: save this for auth
# proc newGdaxHttpClient* (host: string, key: string): GdaxHttpClient =
#   let url = "http://" & host & "/api/"
#   let client = newHttpClient()
#   client.headers = newHttpHeaders({
#     "Content-Type": "application/json",
#     "Accept": "application/json",
#     "Authorization": "Bearer " & key
#   })
#   return GdaxHttpClient(cli: client, url: url)


method Request (self: GdaxHttpClient, route: string): JsonNode {.base.} =
  let resp = self.cli.getContent(url & route)
  return parseJson(resp)


method Post (self: GdaxHttpClient, route: string, body: JsonNode): JsonNode {.base.} =
  let resp = self.cli.postContent(url & route, body = $body)
  return parseJson(resp)


method Products* (self: GdaxHttpClient): JsonNode {.base.} =
  try:
    return self.Request("products")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method ProductOrderBook* (self: GdaxHttpClient, productId: string, level: int = 1): JsonNode {.base.} =
  try:
    if level < 0 and level > 3:
      raise newException(IOError, "level must be 1, 2, or 3")
    return self.Request("products/"&productId&"/book")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method ProductTicker* (self: GdaxHttpClient, productId: string): JsonNode {.base.} =
  try:
    return self.Request("products/"&productId&"/ticker")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method ProductTrades* (self: GdaxHttpClient, productId: string): JsonNode {.base.} =
  try:
    return self.Request("products/"&productId&"/trades")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method ProductCandles* (self: GdaxHttpClient, opts: TableRef[string, string]): JsonNode {.base.} =
  try:
    let qstring = format("?start=$1&end=$2&granularity=$3",
                         opts["start"], opts["end"], opts["granularity"])
    return self.Request("products/"&opts["asset"]&"/candles"&qstring)
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }
