util	= require "util"
http	= require "http"

class Server
	constructor: ( @url, @db ) ->

	_get_dbs: ( cb ) ->
		# Get a list of databases back.
		http.get @url + "_all_dbs", ( res ) ->
			res.setEncoding "utf8"

			_response = ""

			res.on "error", ( err ) ->
				return cb err

			res.on "data", ( chunk ) ->
				_response += chunk

			res.on "end", ( ) ->
				return cb null, JSON.parse _response
		
	_create_db: ( db, cb ) ->
		# Creates a database..

server = new Server "http://localhost:5984/", "orm"

class Person
	constructor: (@name) ->
		
	say_hi: ( ) ->
		return "Hi " + @name

	debug: ( ) ->
		return @Server

Person.prototype.Server = server
util.log util.inspect Person, true, 9

rob = new Person "Rob"
util.log util.inspect rob.debug( )
