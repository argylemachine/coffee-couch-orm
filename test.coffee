util	= require "util"
log	= require( "logging" ).from __filename
orm	= require "./orm"

class Person extends orm.Base

	constructor: ( @_name ) ->

	name: ( @_name, _r_type=null ) ->
		if _r_type
			return ""
		@_name
	
	age: ( @_age, _r_type=null ) ->
		if _r_type
			return 0
		@_age

	_some_thing: ( foo ) ->
		"bar"

server = new orm.Server "http://localhost:5984/", "orm"

orm.Base.prototype.Server = server

rob = new Person "Rob"

Person.find_one { "name": "Rob" }, ( err, res ) ->
	log "Error is " + util.inspect err
	log "Res is " + res
	log rob
	log util.inspect rob, 9, true
