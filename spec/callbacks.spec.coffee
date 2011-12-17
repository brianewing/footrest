footrest = require('../lib/index')
Model = require('../lib/model').Model

class User extends Model
  @type 'User'
  @database = footrest.database('footrest')

  @attr 'name', 'password', 'email', 'resume'
  @beforeSave 'cleanResume'

  cleanResume: ->
    @resume = @resume.replace /\r\n?/g, "\n"

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