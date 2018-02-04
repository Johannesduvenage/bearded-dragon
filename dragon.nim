let doc = """
Bearded Dragon.

Usage:
  dragon import <service> for <asset> from <start> to <end> every <granularity>
  dragon listen <service> for <asset>
  dragon show <service>
  dragon tracking
  dragon shell
  dragon exit
  dragon (-h | --help | help)
  dragon (--version | version)

Options:
  -h --help help        Show this screen.
  --version version     Show version.
  service               (gdax)
"""

import strutils
import docopt
import json
import rdstdin
import asyncdispatch

from lib/importer import Import
from lib/listener import Listen
import lib/clients/http/gdax
import lib/clients/db/influxdb


let MAX_LISTENERS = 3
var listeners = 0
var thr: array[3, Thread[tuple[service, asset: string]]]


proc Handler(args: Table[string, Value]) =
  if args["shell"]:
    while true:
      try:
        let argv = split(readLineFromStdin "dragon> ")
        Handler(docopt(doc, argv=argv, quit=false))
      except DocoptExit:
        continue

  if args["import"]:
    Import({
      "service": $args["<service>"],
      "asset": $args["<asset>"],
      "start": $args["<start>"],
      "end": $args["<end>"],
      "granularity": $args["<granularity>"]
    }.newTable)

  elif args["listen"]:
    if listeners >= MAX_LISTENERS:
      echo "You cannot listen to more than 6 assets"
      return
    var service = $args["<service>"]
    var asset   = $args["<asset>"]
    createThread(thr[listeners], Listen, (service, asset))
    inc(listeners)
    echo "listing to " & $listeners & "/" & $MAX_LISTENERS & " assets"
    echo "View your feed here: http://localhost:3000/dashboard/script/dragon.js?metric=price&from=now-5m&to=now&refresh=1s"

  elif args["show"]:
    echo Products(newGdaxHttpClient()).pretty

  elif args["tracking"]:
    echo Databases(newInfluxDBClient("influxdb", 8086, "root", "root")).pretty

  elif args["exit"]:
    quit()

when isMainModule:
  Handler(docopt(doc, version = "Bearded Dragon 0.1.0"))
