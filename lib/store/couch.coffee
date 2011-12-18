exports.save = (database, docs, callback) ->
  database.save docs, (error, response) ->
      if error
        callback(false, error)
      else
        callback(true, _id: response.id, _rev: response.rev)