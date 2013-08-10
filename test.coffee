log	= require( "logging" ).from __filename
orm	= require "./orm"
util	= require "util"

class Person extends orm.Base

	constructor: ( @first_name, @age ) ->

	say_hi: ( ) ->
		"Hi " + @first_name + ", you're " + @age

	something_else: ( ) ->
		@hi = "bar"

	_hidden_func: ( ) ->
		@meh = "fo"
		"Do something funky."

rob = new Person "rob", 22
rob.set_helpers( )

log rob
