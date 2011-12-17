class Model
  constructor: (@props = {}) ->
    @setupProps()
    @update @props
    @persisted = @props._id?
    @addDefaults()

    @database = @constructor.database
  
  @attr = (attributes...) ->
    @attributes ||= []

    if typeof(attributes[attributes.length-1]) is "object"
      console.log "Got a wee object"
      options = attributes.pop()

      if options.default
        @defaults ||= {}
        attributes.forEach (attribute) =>
          @defaults[attribute] = options.default
    
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
  
  addDefaults: ->
    @update(@constructor.defaults, false) if @constructor.defaults? and not @persisted
  
  update: (props, override = true) ->
    for key, value of props
      if override
        @[key] = value
      else
        @[key] ||= value
  
  save: (callback) ->
    return false if @_dirty.length == 0
  
  type: -> @constructor.type()

exports.Model = Model