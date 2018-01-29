import httpclient
import json
import sequtils
import strutils
import influx
import tables


let time_units = %* {
  "1m": "60",
  "5m": "300",
  "15m": "900",
  "1h": "3600",
  "6h": "21600",
  "1d": "86400"
}

let apis = %* {
  "gdax": "https://api.gdax.com/products/"
}

proc Import* (service: string, from_date: string, to_date: string, every: string): void =
  # clients
  let client = newHttpClient()
  let influxdb = InfluxDB(protocol: HTTP, host: "influxdb", port: 8086, username: "root", password: "root")

  let uri = apis[service].getStr
  let granularity = time_units[every].getStr
  let qstring = format("?start=$1&end=$2&granularity=$3", from_date, to_date, granularity)
  let url = uri & "BTC-USD/candles" & qstring
  let resp = client.getContent(url)
  let buckets = parseJson(resp)
  for bucket in buckets.items():
    let timestamp = parseInt(intToStr(int(bucket[0].getNum())) & "000000000")
    let close = formatFloat(float(bucket[4].getFNum()))
    let data = LineProtocol(measurement: "price", timestamp: timestamp, fields: @{
      "value": close
    }.toTable)
    let (write_response, write_data) = influxdb.write("btc_usd", @[data])
