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
		# Because of issues in keeping 'this', 'that' is now 'this' :)
		that = @

		# Run through each of the attributes..
		_keys = Object.keys @spec( )
		async.map _keys, ( key, cb ) ->

			# Make a query for the view document as an easy test of existence.
			that::Server.get_doc "_design/" + that.name + "/_view/" + "by-" + key, ( err, res ) ->
				if err and err is "not_found"
					# Try and create the view..

					# Get the whole design doc .. 
					# if we come back with an error on getting it, we'll need to create it.
					# otherwise we're going to have to issue an update to create the view.
					that::Server.get_doc "_design/" + that.name, ( err, doc ) ->
						if err
							# No design doc exists.. we should create one here.
							# TODO
							return cb err

						# Design doc exists..
						
						# Update doc.views with a new view.. and create new_doc
						
						# Then run
						#	that::Server.set_doc "_design/" + that.name, new_doc

						# For now just return here so that shit still works.
						return cb err

				else if err
					return cb err
				else
					# No error.
					cb null

		, ( err ) ->
			if err
				return cb err

			return cb null

	@spec: ( ) ->
		_return = { }
		_return[key] = typeof @::[key]( null, true ) for key, value of (@::) when key not in _hidden_functions
		_return

	@delete: ( ) ->
		

exports.Server	= Server
exports.Base	= Base
