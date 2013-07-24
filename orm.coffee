log	= require("logging").from __filename
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

	say_hi_server: ( ) ->
		return "Hi from server: " + @url + " " + @db

class Base
	_hidden_functions = [ "constructor", "Server" ]
	@find: ( ) ->
		# @name is class name.
		# @:: is the class of what was being searched for.
		for key, value of (@::) when key not in _hidden_functions
			log "I got '" + key + "': '" + value + "'\n"

		return { }

	@delete: ( ) ->
		

exports.Server	= Server
exports.Base	= Base
