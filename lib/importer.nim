import tables
import grafanim

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
  let ic = newInfluxDBClient("influxdb", 8086, "root", "root")
  let gc = newGrafanaClient("grafana", 3000, "admin", "admin")
  opts["granularity"] = time_units[opts["granularity"]]
  var ghc = newGdaxHttpClient()
  var buckets = ghc.ProductCandles(opts)
  # ic.InsertAll(opts["asset"], buckets)
  # gc.NewInfluxDBDatasource()
  # gc.NewDashboard()
  # TODO: create grafana datasource + dashboard
  # TODO: echo grafana link
