Model = require('../lib/model').Model

class Animal extends Model
  @type 'Animal'

  @attr 'name', 'species'

class Dog extends Animal
  @attr 'species', default: 'dog'
  @attr 'breed', default: 'greyhound'
  @attr 'pedigree', default: true

class Terrier extends Dog
  @attr 'breed', default: 'west_highland_terrier'
  @attr 'pedigree', default: false
  @attr 'cute', default: true

class Cat extends Animal
  @attr 'species', default: 'cat'
  @attr 'breed', default: 'siamese'

class ShortHair extends Cat
  @attr 'breed', default: 'shorthair'

describe 'inheritance', ->
  it 'should have different attributes', ->
    expect(Dog.attributes).toContain 'pedigree'
    expect(Cat.attributes).not.toContain 'pedigree'
    expect(Animal.attributes).not.toContain 'breed'

    expect(Terrier.attributes).toContain 'cute'
    expect(Dog.attributes).not.toContain 'cute'

  it 'should maintain separate properties and defaults', ->
    terrier = new Terrier()
    expect(terrier.species).toEqual 'dog'
    expect(terrier.breed).toEqual 'west_highland_terrier'

    dog = new Dog()
    expect(dog.species).toEqual 'dog'
    expect(dog.breed).toEqual 'greyhound'

    cat = new Cat()
    expect(cat.species).toEqual 'cat'
    expect(cat.breed).toEqual 'siamese'

    shorthair = new ShortHair()
    expect(shorthair.species).toEqual 'cat'
    expect(shorthair.breed).toEqual 'shorthair'
  
  it 'should maintain same type as parent', ->
    terrier = new Terrier()
    expect(terrier.type()).toEqual 'Animal'