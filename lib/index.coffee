cradle = require('cradle')

exports.createConnection = (options) ->
  new cradle.Connection(options)