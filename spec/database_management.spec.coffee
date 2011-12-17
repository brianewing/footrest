footrest = require '../lib/index'

describe 'database management', ->
  beforeEach ->
    @database = footrest.database('footrest')

    @database.destroy => @destroyed = true
    waitsFor -> @destroyed?
  
  it 'should not exist by default', ->
    @database.exists (err, @exists) =>
    
    waitsFor -> @exists?
    runs -> expect(@exists).toEqual false
  
  it 'should create a database', ->
    @database.create (err, db) =>
      @created = (db.ok == true)
    
    waitsFor -> @created?
    runs -> expect(@created).toEqual true
  
  it 'should destroy a database', ->
    @database.create =>
      @database.destroy =>
        @database.exists (err, @exists) =>
    
    waitsFor -> @exists?
    runs -> expect(@exists).toEqual false