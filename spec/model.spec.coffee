Model = require('../lib/index').Model

class Thing extends Model
  @type 'Thing'

  @attr 'one', 'two'
  @attr 'three', default: 'Defacto!'

describe 'model', ->
  it 'should assign internal _props', ->
    thing = new Thing
      one: 'Hello'
      two: 'World'
    
    expect(thing._props['one']).toEqual 'Hello'
    expect(thing._props['two']).toEqual 'World'

    thing.one = 'Mad'
    expect(thing._props['one']).toEqual 'Mad'
  
  it 'should assign default parameters when created', ->
    thing = new Thing
      one: 'Hello'
    
    expect(thing.two).toEqual undefined
    expect(thing.three).toEqual 'Defacto!'

    thing2 = new Thing
      one: 'Hello'
      three: 'World'
    
    expect(thing2.three).toEqual 'World'