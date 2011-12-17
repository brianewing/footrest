CouchStore = require('./couch').CouchStore

exports.get = (store) ->
  switch store
    when "couch"
      CouchStore
    else
      throw new Exception "Store not available"