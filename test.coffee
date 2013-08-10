log	= require( "logging" ).from __filename
orm	= require "./orm"

class Person extends orm.Base

	constructor: ( @first_name, @age ) ->

	say_hi: ( ) ->
		"Hi " + @first_name + ", you're " + @age

	something_else: ( ) ->
		@hi = "bar"

	_hidden_func: ( ) ->
		@meh = "fo"
		"Do something funky."

log Person.prototype.get_attributes( )
log Person.prototype.get_helpers( )
