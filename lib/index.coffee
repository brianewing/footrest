cradle = require('cradle')
url = require('url')

uriToOptions = (uri) ->
  uri = url.parse(uri)
  
  host: uri.hostname
  port: uri.port
  auth:
    username: uri.auth?.split(':')[0]
    password: uri.auth?.split(':')[1]

exports.createConnection = (options) ->
  if options.url
    options = uriToOptions(options.url)
  
  new cradle.Connection(options)

exports.database = (name, connectionOptions) ->
  (new cradle.Connection(connectionOptions)).database(name)

exports.Model = require('./model').Model