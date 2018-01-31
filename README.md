bearded-dragon
==============

Like Gekko, but faster


## Getting Started

run `make`
  - builds nimlang/nim docker image
  - run bearded-dragon, influxdb, and grafana containers
  - compiles bearded-dragon source

## Interactive Prompt

run `make dragon`

This opens an interactive prompt where you can run commands like:
  - `import gdax from 2018-01-02 to 2018-01-04 every 1h`: import a specified time range of data from a specified service
  - `listen gdax for usd-btc`: listen to live data from a specified service, product
  - `show gdax`: show available products for specified service
  - `tracking`: show which products you're currently tracking

## Importing

Importing slurps data from a specified service (e.g. gdax) and stores it
inside Influxdb. You can create dashboards in Grafana at (http://localhost:3000)[http://localhost:3000].
All Influxdb and Grafana data is stored persistently. Run `make clean` to start fresh.

The only thing that's pre-added is the data source in Grafana pointing to an InfluxDB database called `btc_usd`.

## Credentials

#### InfluxDB

user: root
pass: root

#### Grafana

user: admin
pass: admin
