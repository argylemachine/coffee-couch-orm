async	= require "async"
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

	get_doc: ( id, cb ) ->
		log "Querying ID " + id
		return cb "No!"

class Base
	_hidden_functions = [ "constructor", "Server" ]

	@find_all: ( cb ) ->
		@ensure_views ( err, res ) ->
			if err
				return cb err
			return cb null, res

	@ensure_views: ( cb ) ->
		# Because of issues in keeping 'this', 'that' is now 'this' :)
		that = @
		async.map [ key for key, value of @spec( ) ], ( key, cb ) ->
			# Make a query for the document..
			that::Server.get_doc "_design/" + that.name + "/_view/" + "by-" + key, ( err, res ) ->
				if err
					# At this point try and create the view..
					#TODO

					return cb err
				cb null

		, ( err ) ->
			if err
				return cb err

			return cb null

	@spec: ( ) ->
		_return = { }
		_return[key] = typeof @::[key]( ) for key, value of (@::) when key not in _hidden_functions
		_return

	@delete: ( ) ->
		

exports.Server	= Server
exports.Base	= Base
