util	= require "util"
log	= require( "logging" ).from __filename
orm	= require "./orm"

class Person extends orm.Base

	@fname	= "foo"
	@age	= "number"
	@foo	= "number"

	constructor: ( @_name ) ->
		log "Got here"

	name: orm.Value ( _name ) ->
		if not _name
			return @_name
		@_name = _name

	set_age: ( @age, _r_type=null ) ->
		if _r_type
			return 0
		@age

	_some_thing: ( foo ) ->
		"bar"

server = new orm.Server "http://localhost:5984/", "orm"

orm.Base.prototype.Server = server

rob = new Person "Rob"
rob.name = "foo"

Person.find_one { "name": "Rob" }, ( err, res ) ->
	log "Error is " + util.inspect err
	log "Res is " + res
	log rob
	log util.inspect rob, 9, true
