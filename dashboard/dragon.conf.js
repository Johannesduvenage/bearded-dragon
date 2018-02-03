// getDashConf :: -> configurationObj
var getDashConf = function getDashConf () {
  'use strict';

  var pluginConfProto = {
    alias: undefined,                // Used to replace real measurement name in graphs.

    separator: ',',                  // Used to define series separator.

    //merge: [ 'instance' ],         // Used to merge multiple instances, types or descriptions
                                     // to one line.

    //multi: false,                  // Used to split single measurement instances to multiple
                                     // individual graphs.

    //regexp: /\d$/,                 // Used to filter instances by regexp.

    //datasources: [ 'graphite' ],   // Used to limit datasources per plugin.
                                     // If undefined all grafana InfluxDB
                                     // datasources will be used.

    tags: {                          // Used to identify data in InfluxDB.
      host: 'host',                  // Defaults are set to work with CollectD metric collector.
      instance: 'instance',
      description: 'type_instance',
      type: 'type'
    }
  };

  // Plugin constructor
  function Plugin (config) {
    Object.defineProperty(this, 'config', {
      value: _.merge({}, pluginConfProto, config),
      enumerable: false
    });
  }

  // collectd plugins configuration
  var plugins = {};

  plugins.price = new Plugin();
  plugins.price.config.multi = true;

  plugins.price.price = {
    'graph': {
      'price': {}
    },
    'panel': {
      'title': 'Price for @metric',
      'groupBy': null
    }
  };

  return {
    'plugins': plugins
  };
}
