let doc = """
Bearded Dragon.

Usage:
  dragon import <service> from <from-date> to <to-date> every <time-units>
  dragon listen (gdax)
  dragon (-h | --help | help)
  dragon (--version | version)

Options:
  -h --help help        Show this screen.
  --version version     Show version.
  service               (gdax)
"""

import strutils
import docopt

from lib/importer import Import
import lib/listener

let args = docopt(doc, version = "Bearded Dragon 0.1.0")

if args["import"]:
  let service   = $args["<service>"]
  let from_date = $args["<from-date>"]
  let to_date   = $args["<to-date>"]
  let every     = $args["<time-units>"]
  Import(service, from_date, to_date, every)
