let doc = """
Bearded Dragon.

Usage:
  dragon import <service> for <asset> from <start> to <end> every <granularity>
  dragon listen <service> for <asset>
  dragon show <service>
  dragon tracking
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

from lib/importer import Import
from lib/listener import Listen
import lib/clients/http/gdax
import lib/clients/db/influxdb

let args = docopt(doc, version = "Bearded Dragon 0.1.0")

if args["import"]:
  Import({
    "service": $args["<service>"],
    "asset": $args["<asset>"],
    "start": $args["<start>"],
    "end": $args["<end>"],
    "granularity": $args["<granularity>"]
  }.newTable)

elif args["listen"]:
  var service = $args["<service>"]
  var asset   = $args["<asset>"]
  Listen(service, asset)
  # discard Listen()

elif args["show"]:
  echo Products(newGdaxHttpClient()).pretty

elif args["tracking"]:
  echo Databases(newInfluxDBClient("influxdb", "root", "root")).pretty
