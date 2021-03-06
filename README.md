Footrest: Lightweight ODM for CouchDB on Node ![Build status](https://secure.travis-ci.org/brianewing/footrest.png)
========

What is this is don't even?
---------------------------

Footrest lets you define models that will be backed by a Couch database.
It tries to work in exactly the way you'd expect it to, with an ActiveModel-esque API.

Whilst it's still being put together, footrest will support callbacks (beforeSave, afterSave, etc) and validations.

**See below for examples.**

Footrest was designed to be used in **CoffeeScript**.
For now, using it in Javascript will be an exercise for the reader as it ties in nicely with CoffeeScript's classical inheritance.

Read the tests for a better idea how footrest can be used until better documentation is available

Running the tests
------------

0. Run CouchDB on localhost:5984 in admin party mode
0. `npm test`
0. Watch it pass ☺

Long example
------------

Hopefully this feels as natural to you as it does to me.

```coffeescript
Model = require('footrest').Model

# this can be set per-model in the class definition, at runtime, etc
Model.database = require('footrest').database('footrest')

class Animal extends Model
  @type 'Animal'
  @attr 'species', 'name'

class Dog extends Animal
  @attr 'name'
  @attr 'species', default: 'dog'
  @attr 'breed', default: 'greyhound'
  @attr 'bites', default: true
  @attr 'age'
  @attr 'ageDogYears'

  @beforeSave 'calculateDogYears'

  strokeable: ->
    @cute or not @bites
  
  calculateDogYears: ->
    @ageDogYears = if @age then @age * 7 else 0

class Terrier extends Dog
  @attr 'breed', default: 'west_highland_terrier'
  @attr 'bites', default: false
  @attr 'cute', default: true

spot = new Dog
  name: 'Spot'
  age: 3

oscar = new Terrier(name: 'Oscar', age: 2)

oscar.strokeable() # => true
spot.strokeable() # => false
oscar.species # => 'dog'

oscar.cute = false
oscar.bites = true
oscar.strokeable() # => true

oscar.ageDogYears # => null, not saved yet

oscar.id # => null
oscar.hello # => undefined

oscar.save (success) ->
  oscar.id # => "73e98a88a53cbd6d9028a03d6e004fe4"
  oscar.rev # => "1-c3f75784f5f9a82faadac4ded1306412"

  oscar.ageDogYears # => 14
```