import httpclient
import json
import sequtils
import strutils
import tables

import clients/http/gdax
import clients/db/influxdb

let time_units = {
  "1m": "60",
  "5m": "300",
  "15m": "900",
  "1h": "3600",
  "6h": "21600",
  "1d": "86400"
}.newTable

proc Import* (opts: TableRef[string, string]): void =
  let ic = newInfluxDBClient("influxdb")
  opts["granularity"] = time_units[opts["granularity"]]
  var gc = newGdaxHttpClient()
  let buckets = gc.ProductCandles(opts)
  ic.InsertAll(opts["asset"], buckets)
  # TODO: create grafana datasource + dashboard
  # TODO: echo grafana link
