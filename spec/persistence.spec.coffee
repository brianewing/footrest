footrest = require('../lib/index')
Model = require('../lib/model').Model

class Address extends Model
  @type 'Address'
  @database = footrest.createConnection().database('footrest')

  @attr 'street', 'number', 'postcode'

describe 'persistence', ->
  beforeEach ->
    @database = Address.database

    @database.destroy => @database.create => @recreated = true
    waitsFor -> @recreated?

    @address = new Address
      street: 'Fake Street'
      number: 123
      postcode: 'AA0 0AA'
  
  it 'should save successfully', ->
    @address.save (@saved) =>
    waitsFor -> @saved?
    runs -> expect(@saved).toEqual true
  
  it 'should update its id and revision attributes when saved', ->
    @address.save (@saved) =>
    
    waitsFor -> @saved?
    runs ->
      expect(@address.id).not.toEqual null
      expect(@address.rev).not.toEqual null
  
  it 'should update its revision when saved', ->
    @address.save (@saved) =>
      @rev = @address.rev
      @id = @address.id

      @address.number = 21
      @address.save (@updated) =>
    
    waitsFor -> @saved? and @updated?
    runs ->
      expect(@address.rev).not.toEqual @rev
      expect(@address.id).toEqual @id