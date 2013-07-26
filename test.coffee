util	= require "util"
log	= require( "logging" ).from __filename
orm	= require "./orm"

class Person extends orm.Base

	constructor: ( @name, @age ) ->

	name: new orm.Value
	
	age: new orm.Value

	_some_thing: ( foo ) ->
		"bar"

server = new orm.Server "http://localhost:5984/", "orm"

orm.Base.prototype.Server = server

rob = new Person "Rob", 22
log rob.age

rob.age = 21
log rob.age

Person.find_one { "name": "Rob" }, ( err, res ) ->
	log "Error is " + util.inspect err
	log "Res is " + res
	log rob
	log util.inspect rob, 9, true
