async	= require "async"
log	= require( "logging" ).from __filename
orm	= require "./orm"

my_server = new orm.Server( { "url": "http://localhost:5984/", "db": "orm" } )

class Person extends orm.BASE
	constructor: ( @first_name, @last_name ) ->
		
	say_hi: ( ) ->
		return "Hi " + @first_name + " " + @last_name

joe = new Person "Joe", "Public"

async.series [ ( cb ) ->
			my_server.link joe, cb
	], ( err, res ) ->
		log "Starting up"
		log joe
