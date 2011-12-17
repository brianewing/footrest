class CouchStore
  constructor: (@model, @database) ->
  
  save: (docs, callback) ->
    @database.save docs, (error, response) ->
      callback(!error, _id: response.id, _rev: response.rev)

exports.CouchStore = CouchStore