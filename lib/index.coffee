cradle = require('cradle')

exports.createConnection = (options) ->
  new cradle.Connection(options)

exports.Model = require('./model').Model