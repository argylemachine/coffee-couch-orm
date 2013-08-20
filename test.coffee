log	= require( "logging" ).from __filename
orm	= require "./orm"
util	= require "util"

class Person extends orm.Base

	constructor: ( @first_name, @age ) ->
		super( @_id )

	say_hi: ( ) ->
		"Hi " + @first_name + ", you're " + @age

	something_else: ( ) ->
		@hi = "bar"

	_hidden_func: ( ) ->
		@meh = "fo"
		"Do something funky."

# Create a new instance of the server, and set the instance to be class wide. ( All instances of orm.Base ).
orm.Base.prototype.Server = new orm.Server "http://localhost:5984/", "orm"

Person.prototype.find { "first_name": "Robert", "age": 23 }, ( err, people ) ->
	log "People are #{util.inspect people}"

	log people[0]
