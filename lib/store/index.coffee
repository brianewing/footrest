exports.get = (store) ->
  switch store
    when "couch"
      require('./couch')
    else
      throw new Exception "Store not available"