util	= require "util"
log	= require( "logging" ).from __filename
orm	= require "./orm"

log "Defining some basic types.."
class Person extends orm.Base
	constructor: ( @name ) ->

	say_hi: ( ) ->
		return "Hi " + @name

	get_server: ( ) ->
		return @Server

log "Creating an instance of server."
server = new orm.Server "http://localhost:5984/", "orm"

log "Setting the Base 'Server' attribute to be the newly created instance."
orm.Base.prototype.Server = server

log "Creating a person 'rob'"
rob = new Person "Rob"

log "Changing the server to some dummy thing."
orm.Base.prototype.Server = "Foobar"

log "Creating a person 'joe'"
joe = new Person "joe"

log util.inspect rob.get_server( )
log util.inspect joe.get_server( )
