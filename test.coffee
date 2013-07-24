util	= require "util"
log	= require( "logging" ).from __filename
orm	= require "./orm"

class Person extends orm.Base
	TEST = "FOOBAR"

	constructor: ( @name ) ->

	say_hi: ( ) ->
		return "Hi " + @name

	get_server: ( ) ->
		return @Server

server = new orm.Server "http://localhost:5984/", "orm"

orm.Base.prototype.Server = server

rob = new Person "Rob"

log util.inspect Person.find( )
