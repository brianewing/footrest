exports.save = (database, docs, callback) ->
  database.save docs, (error, response) ->
    if error
      callback(false, error)
    else
      callback(true, _id: response.id, _rev: response.rev)

exports.load = (database, id, callback) ->
  database.get id, (error, doc) ->
    if error
      callback(false, error)
    else
      callback(true, doc)

exports.delete = (database, id, callback) ->
  database.remove id, (error) ->
    callback(!error)