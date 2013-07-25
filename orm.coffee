async	= require "async"
log	= require("logging").from __filename
http	= require "http"

class Server
	constructor: ( @url, @db ) ->

	_get_dbs: ( cb ) ->
		# Get a list of databases back.
		@_get @url + "_all_dbs", ( err, res ) ->
		
	_create_db: ( db, cb ) ->
		# Creates a database..

	_get: ( url, cb ) ->
		log url
		# Just wraps http.get to make it a little easier.
		http.get url, ( res ) ->
			res.setEncoding "utf8"
			_r = ""
			res.on "error", ( err ) ->
				return cb err
			res.on "data", ( chunk ) ->
				_r += chunk
			res.on "end", ( ) ->
				_k = JSON.parse _r
				if _k.error?
					return cb _k.error
				
				return cb null, _k

	get_doc: ( id, cb ) ->
		@_get @url + @db + "/" + id, ( err, res ) ->
			if err
				return cb err
			return cb null, res

class Base
	_hidden_functions = [ "constructor", "Server" ]

	@find_all: ( filter, cb ) ->
		@ensure_views ( err, res ) ->
			if err
				return cb err

			# At this point make a request based on the filter..
			# Use @::Server.. 

			return cb null, res

	@ensure_views: ( cb ) ->

		# Make a query for the design document. If we can't get that, we know we need to create all the views.
		@::Server.get_doc "_design/" + @name, ( err, doc ) =>
			if err
				# Make all of them..
				_new_doc = { "language": "javascript", "views": { } }
	
				for key, value of @spec( )
					view_name = "by-" + key
					_new_doc.views[view_name] = { "map":	"""
										function(doc) {
											// Make sure that we only match correct documents.
											if( doc._type != "#{key}" ){
												return;
											}
											emit( doc.#{key}, doc );
										}
										""" }
				return cb _new_doc

			# Verify the document to make sure it contains all the correct views.
			return cb null

	@spec: ( ) ->
		_return = { }
		_return[key] = typeof @::[key]( null, true ) for key, value of (@::) when key not in _hidden_functions
		_return

	@delete: ( ) ->
		

exports.Server	= Server
exports.Base	= Base
