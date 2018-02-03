bearded-dragon
==============

Like Gekko, but faster and better

![](https://img.etsystatic.com/il/0a5bbf/640243540/il_fullxfull.640243540_37dt.jpg)

## Getting Started


This project is managed completely in docker. It's best to interface with it
via the Makefile. The following targets are available:
  - build: build the Dockerfile
  - up: bring up all the services in docker-compose.yml
  - compile: compile the nim source and output the binary to bin
  - dragon: run an interactive dragon shell
  - kill: bring down and remove containers
  - restart: bring down and back up all containers
  - connect: run a bash shell on the bearded-dragon container
  - query: run an influxdb query (params: db="<database>", q="<query>")
  - clean: kills containers, removes nimcache and the influxdb + grafana volumes

The first thing you want to do is bring the project up. Do this with `make`.


#### Volumes


To keep data persistent, we mount certain directories that will maintain state
for InfluxDB and Grafana. `./dashboard` provides a dynamic dashboard
for live streaming data with `dragon listen`. `./influxdb` and `./grafana` are
created when you run `make up` and mount to `/data` and `/var/lib/grafana` to
their respective containers. You can grab all of this data and plug it into your
own service. The root directory of the project is mounted to `/app` on the
main bearded-dragon container where most of the commands will be run.

Check out `docker-compose.yml` for more info.

#### Interactive Shell


Dragon provides an interactive shell that provides a history (stored in `./.history`).
Here you can run successive commands, even start multiple live streams and watch
them progress in grafana (it will give you a link). Here's an example of a typical
walkthrough in the shell.

First, let's start up the shell:

```sh
$ make dragon

... fancy banner ...

dragon>
```

Cool, let's see which commands we can run:

```sh
dragon> help
Usage:
  dragon import <service> for <asset> from <start> to <end> every <granularity>
  dragon listen <service> for <asset>
  dragon show <service>
  dragon tracking
  dragon (-h | --help | help)
  dragon (--version | version)
```

Notice the arguments service, asset, start, end, and granularity.

For start, end, and granularity; refer to the [gdax docs](https://docs.gdax.com/#get-historic-rates)

Service and asset are pretty universal. Service is where we want to grab data from (e.g. gdax)
Asset is the currency pair we want to target.

If you are unfamiliar with the assets a service provides, just run:

```sh
dragon> show gdax
...
{
    "id": "BTC-USD",
    "base_currency": "BTC",
    "quote_currency": "USD",
    "base_min_size": "0.001",
    "base_max_size": "70",
    "quote_increment": "0.01",
    "display_name": "BTC/USD",
    "status": "online",
    "margin_enabled": false,
    "status_message": null,
    "min_market_funds": "10",
    "max_market_funds": "1000000",
    "post_only": false,
    "limit_only": false,
    "cancel_only": false
},
...
```

This will return a list of objects describing each asset. When we provide an asset
to dragon, we pass it by the same name as its `id` (in this case, "BTC-USD", case-insensitive)

Now If I wanted to download gdax data for the price of Bitcoin to US Dollar
from Jan 2, 2018 3P.M. to Jan 20, 2018 2A.M. polling every 1 hour, I would run:

```sh
dragon> import gdax for btc-usd from 2018-01-02T15:00:00Z to 2018-01-20T2:00:00Z every 1h
```

If you want to live stream an asset's price, run:

```sh
dragon> listen gdax for btc-usd
View your feed here: http://localhost:3000/dashboard/script/dragon.js?metric=price&from=now-5m&to=now&refresh=1s
```

Open the link returned in the browser to find a list of Grafana dashboards displaying
the price of all the assets you are tracking. These graphs refresh every second (which you can change via the `refresh` query parameter)


## Credentials


#### InfluxDB

user: root

pass: root


#### Grafana

user: admin

pass: admin


## Development


#### InfluxDB

If your developing anything related to InfluxDB, you probably need to make
queries frequently. The easiest way is to use `make query`:

```sh
$ make query q="show databases"
$ make query db="gdax_btc_usd_..." q="select value from price"
```

You could also just run an InfluxDB shell with `docker-compose exec influxdb influx`
