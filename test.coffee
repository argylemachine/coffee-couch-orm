util	= require "util"
log	= require( "logging" ).from __filename
orm	= require "./orm"

class Person extends orm.Base

	constructor: ( @first_name, @age ) ->

	say_hi: ( ) ->
		"Hi " + @first_name + ", you're " + @age


log Person.prototype.get_attributes( )
