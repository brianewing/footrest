cradle = require('cradle')

exports.createConnection = (options) ->
  new cradle.Connection(options)

exports.database = (name, connectionOptions) ->
  (new cradle.Connection(connectionOptions)).database(name)

exports.Model = require('./model').Model