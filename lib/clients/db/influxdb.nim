import influx
import strutils
import json
import tables
import httpclient

import ../../utils

type
  InfluxDBClient* = object
    cli: InfluxDB


proc newInfluxDBClient* (host: string, user: string, pass: string): InfluxDBClient =
  let cli = InfluxDB(protocol: HTTP, host: host, port: 8086, username: user, password: user) # , debugMode: true)
  return InfluxDBClient(cli: cli)


method CreateDatabase* (self: InfluxDBClient, database: string): JsonNode {.base.} =
  # CleanDatabaseName(database)
  try:
    let (resp, data) = self.cli.query("", "CREATE DATABASE " & database, HttpPost)
    if $resp != "OK":
      raise newException(IOError, "create failed: " & $resp)
    return data
  except IOError as e:
    return %* {
      "error": e.msg
    }


method Databases* (self: InfluxDBClient): JsonNode {.base.} =
  let (resp, data) = self.cli.query("", "SHOW DATABASES")
  if $resp != "OK":
    raise newException(IOError, "query failed: " & $resp)
  return data


method SelectAll* (self: InfluxDBClient, database: string): JsonNode {.base.} =
  # CleanDatabaseName(database)
  let (resp, data) = self.cli.query(database, "SELECT * FROM price")
  if $resp != "OK":
    raise newException(IOError, "select failed: " & $resp)
  return data


method Insert* (self: InfluxDBClient, database: var string, item: var JsonNode): JsonNode {.base.} =
  # item = [unix time, value]
  CleanDatabaseName(database)
  echo database
  echo $self.CreateDatabase(database)
  var timestampStr = $item[0].getFNum
  var timestamp: int64
  if timestampStr.contains("."):
    let seconds = timestampStr.split(".")[0]
    timestamp = parseBiggestInt(seconds & "000000000")
  else:
    timestamp = parseBiggestInt(timestampStr & "000000000")
  let proto = LineProtocol(measurement: "price", timestamp: timestamp, fields: @{
    "value": $item[1].getFNum
  }.toTable)
  echo $proto
  let (resp, data) = self.cli.write(database, @[proto])
  if $resp != "OK":
    raise newException(IOError, $resp & "; Check if database exists")
  return data


method InsertAll* (self: InfluxDBClient, database: var string, items: var JsonNode): void {.base.} =
  for item in items.mitems():
    discard self.Insert(database, item)
