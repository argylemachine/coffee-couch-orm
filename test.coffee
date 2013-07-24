util	= require "util"
log	= require( "logging" ).from __filename
orm	= require "./orm"

class Person extends orm.Base

	name: ( @name=null ) ->
		if not name
			return ""
		@name
	
	age: ( @age=null ) ->
		if not age
			return 0
		@age

	get_server: ( ) ->
		return @Server

server = new orm.Server "http://localhost:5984/", "orm"

orm.Base.prototype.Server = server

rob = new Person "Rob"

Person.find_all ( err, res ) ->
	log "Error is " + err
	log "Res is " + res
