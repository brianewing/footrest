footrest = require('../lib/index')
Model = require('../lib/model').Model

class User extends Model
  @type 'User'
  @database = footrest.database('footrest')

  @attr 'name', 'password', 'email', 'resume'
  @beforeSave 'cleanResume'
  @afterSave 'reverseName'

  cleanResume: ->
    @resume = @resume.replace /\r\n?/g, "\n" if @resume
  
  reverseName: ->
    @name = @name.split('').reverse().join('')

describe 'callbacks', ->
  beforeEach ->
    @database = User.database

    @database.destroy => @database.create => @recreated = true
    waitsFor -> @recreated?
  
  it 'should call beforeSave callbacks before saving', ->
    user = new User
      name: 'Brian'
      resume: "Line one\r\n\r\r\r\nLine two"
    
    expect(user.resume).toEqual "Line one\r\n\r\r\r\nLine two"
    user.save (success) ->
      expect(user.resume).toEqual "Line one\n\n\n\nLine two"
      expect(user._dirty).not.toContain 'resume'
  
  it 'should call afterSave callbacks after saving', ->
    user = new User
      name: 'Brian'
    
    user.save (success) ->
      expect(user.name).toEqual 'nairB'
      expect(user._dirty).toContain 'name'