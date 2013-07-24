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

	get_doc: ( id ) ->
		log "GOT HERE"

class Base
	_hidden_functions = [ "constructor", "Server" ]
	@find_all: ( ) ->

	@ensure_views: ( cb ) ->
		for key in @spec( )
			_view_doc = @::Server.get_doc "_design" + @name + "/" + "by-" + key
			if _view_doc.error?
				return cb _view_doc.error

		return cb null

	@spec: ( ) ->
		_return = { }
		_return[key] = typeof @::[key]( ) for key, value of (@::) when key not in _hidden_functions
		_return

	@delete: ( ) ->
		

exports.Server	= Server
exports.Base	= Base
