footrest = require('../lib/index')
Model = require('../lib/model').Model

Model.database = footrest.database('footrest')

class Address extends Model
  @type 'Address'

  @attr 'street', 'number', 'postcode'

  full: ->
    "#{@number} #{@street}, #{@postcode}"

class Person extends Model
  @type 'Person'

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
  
  it 'should inject its type into the document when saving', ->
    @address.save (@saved) =>
    waitsFor -> @saved?
    runs -> expect(@address.attr('type')).toEqual 'Address'
  
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
  
  it 'should successfully load a document', ->
    @address.save =>
      @rev = @address.rev
      Address.load @address.id, (@success, @loadedAddress) =>
    
    waitsFor -> @loadedAddress?
    runs ->
      expect(@success).toEqual true

      expect(@loadedAddress.id).toEqual @address.id
      expect(@loadedAddress.rev).toEqual @address.rev
      expect(@loadedAddress.full()).toEqual "123 Fake Street, AA0 0AA"
  
  it 'should give an error when loading a non-existent document', ->
    Address.load 'non-existent', (@success, @error) =>
    
    waitsFor -> @error?
    runs ->
      expect(@success).toEqual false
      expect(@error.error).toEqual 'not_found' # a little too raw for my liking, will do for now
  
  it 'should not load documents of another type', ->
    @address.save (@saved) =>
    waitsFor -> @saved?

    runs ->
      Person.load @address.id, (@success, @error) =>
      
      waitsFor -> @error?
      runs ->
        expect(@success).toEqual false
        expect(@error.error).toEqual 'type_mismatch'
  
  it 'should delete successfully', ->
    @address.save (@saved) => @address.delete (@deleted, @error) =>
    waitsFor -> @deleted

    runs ->
      expect(@deleted).toEqual true
      expect(@error).toEqual null

      Address.load @address.id, (@success, @error) =>
      
      waitsFor -> @success?
      runs ->
        expect(@success).toEqual false