class Model
  constructor: (@props) ->
    @setupProps()
    @update @props

    @database = @constructor.database
  
  @attr = (attributes...) ->
    @attributes ||= []
    @attributes = @attributes.concat(attributes)
  
  @type = (type = false) ->
    @type = type if type
    @type
  
  setupProps: ->
    @_props = {}
    @_dirty = []

    @constructor.attributes.forEach (attr) =>
      @__defineGetter__ attr, =>
        @_props[attr]
      
      @__defineSetter__ attr, (val) =>
        @_props[attr] = val
        @_dirty.push attr
  
  update: (props) ->
    for key, value of props
      @[key] = value
  
  save: (callback) ->
    return false if @_dirty.length == 0
  
  type: -> @constructor.type()

exports.Model = Model