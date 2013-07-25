util	= require "util"
log	= require( "logging" ).from __filename
orm	= require "./orm"

class Person extends orm.Base

	name: ( @name, _r_type=null ) ->
		if _r_type
			return ""
		@name
	
	age: ( @age, _r_type=null ) ->
		if _r_type
			return 0
		@age

	_some_thing: ( foo ) ->
		"bar"

server = new orm.Server "http://localhost:5984/", "orm"

orm.Base.prototype.Server = server

rob = new Person "Rob"

Person.find_all { "some": "filter" }, ( err, res ) ->
	log "Error is " + util.inspect err
	log "Res is " + res
