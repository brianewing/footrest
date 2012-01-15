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

describe 'database object creation', ->
  it 'should parse various options from database URI', ->
    db = footrest.createConnection url: 'https://bob:thebuilder@remote.couch:1234'

    expect(db.auth.username).toEqual 'bob'
    expect(db.auth.password).toEqual 'thebuilder'
    expect(db.host).toEqual 'remote.couch'
    expect(db.port.toString()).toEqual '1234'
  
  it 'should parse options from database URI without auth and port', ->
    db = footrest.createConnection url: 'http://remote.couch'

    expect(db.auth.username).toEqual null
    expect(db.auth.password).toEqual null
    expect(db.host).toEqual 'remote.couch'
    expect(db.port.toString()).toEqual '5984'