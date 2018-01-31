import influx
import strutils
import json
import tables
import httpclient


proc CleanDatabaseName(database: var string): void =
  database = database.toLower.replace("-", "_")


type
  InfluxDBClient* = object
    cli: InfluxDB


proc newInfluxDBClient* (host: string): InfluxDBClient =
  let cli = InfluxDB(protocol: HTTP, host: host, port: 8086, username: "root", password: "root") # , debugMode: true)
  return InfluxDBClient(cli: cli)


proc CreateDatabase* (self: InfluxDBClient, database: var string): JsonNode =
  CleanDatabaseName(database)
  let (resp, data) = self.cli.query("", "CREATE DATABASE " & database, HttpPost)
  if $resp != "OK":
    raise newException(IOError, "create failed: " & $resp)
  return data


proc Databases* (self: InfluxDBClient): JsonNode =
  let (resp, data) = self.cli.query("", "SHOW DATABASES")
  if $resp != "OK":
    raise newException(IOError, "create failed: " & $resp)
  return data


proc SelectAll* (self: InfluxDBClient, database: var string): JsonNode =
  CleanDatabaseName(database)
  let (resp, data) = self.cli.query(database, "SELECT * FROM price")
  if $resp != "OK":
    raise newException(IOError, "select failed: " & $resp)
  return data


proc Insert* (self: InfluxDBClient, database: var string, item: JsonNode): JsonNode =
  CleanDatabaseName(database)
  discard self.CreateDatabase(database)
  let timestamp = parseInt(item[0].getStr & "000000000")
  let proto = LineProtocol(measurement: "price", timestamp: timestamp, fields: @{
    "value": item[4].getStr
  }.toTable)
  let (resp, data) = self.cli.write(database, @[proto])
  if $resp != "OK":
    raise newException(IOError, $resp & "; Check if database exists")
  return data


proc InsertAll* (self: InfluxDBClient, database: var string, items: JsonNode): void =
  for item in items:
    discard self.Insert(database, item)
