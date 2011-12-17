class CouchStore
  constructor: (@model, @database) ->
  
  save: (docs, callback) ->
    @database.save docs, (error, response) ->
      if error
        callback(false, error)
      else
        callback(true, _id: response.id, _rev: response.rev)

exports.CouchStore = CouchStore