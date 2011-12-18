_ = require('underscore')
couch = require('./store').get('couch')

class Model
  constructor: (@props = {}) ->
    @setupProps()
    @update @props
    @persisted = @props._id?
    @addDefaults()

    @database = @constructor.database
    @store = couch
  
  @attr = (attributes...) ->
    @attributes ||= []

    if typeof(attributes[attributes.length-1]) is "object"
      options = attributes.pop()

      if options.default
        @defaults ||= {}
        @defaults = _.clone @defaults

        attributes.forEach (attribute) =>
          @defaults[attribute] = options.default
    
    @attributes = _.uniq @attributes.concat(attributes)
  
  @beforeSave = (callbacks...) -> @bind 'beforeSave', callbacks...
  @afterSave = (callbacks...) -> @bind 'afterSave', callbacks...

  @bind = (event, callbacks...) ->
    @_callbacks ||= {}
    @_callbacks = _.clone @_callbacks
    @_callbacks[event] ||= []

    @_callbacks[event] = @_callbacks[event].concat callbacks
  
  fire: (event, args...) ->
    return false unless @constructor._callbacks? and @constructor._callbacks[event]?

    @constructor._callbacks[event].forEach (callback) =>
      callback = @[callback] unless typeof(callback) == "function"

      callback.apply @, args...
  
  @type = (type = false) ->
    @_type = type if type
    @_type
  
  setupProps: ->
    @_props = {}
    @_dirty = []

    @constructor.attributes.forEach (attr) =>
      @__defineGetter__ attr, =>
        @_props[attr]
      
      @__defineSetter__ attr, (val) =>
        @_props[attr] = val
        @_dirty.push attr
    
    @__defineGetter__ 'id', => @_props['_id']
    @__defineSetter__ 'id', (val) => @_props['_id'] = val
    @__defineGetter__ 'rev', => @_props['_rev']
  
  addDefaults: ->
    @update(@constructor.defaults, false) if @constructor.defaults? and not @persisted
  
  update: (props, override = true) ->
    for key, value of props
      if override
        @[key] = value
      else
        @[key] ||= value
  
  save: (callback) ->
    if @_dirty.length == 0
      callback false
      return
    
    @fire "beforeSave"
    @store.save @database, @_props, (success, props) =>
      @_props[key] = val for key, val of props
      @_dirty = []

      @fire "afterSave"
      callback success
  
  type: -> @constructor.type()

exports.Model = Model