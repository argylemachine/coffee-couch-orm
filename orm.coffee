async	= require "async"
log	= require("logging").from __filename
http	= require "http"
url	= require "url"

class Server
	constructor: ( @_url, @db ) ->

	_get_dbs: ( cb ) ->
		# Get a list of databases back.
		@_get @_url + "_all_dbs", ( err, res ) ->
		
	_create_db: ( db, cb ) ->
		# Creates a database..

	_get: ( _url, cb ) ->
		log _url
		# Just wraps http.get to make it a little easier.
		http.get _url, ( res ) ->
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

	_put: ( _url, data, content_type, cb ) ->
		# Helper for http.request with a PUT type.

		# Parse the given url so that we can generate most of the options object
		o = url.parse _url

		# Fill in other parts of the options object.
		o.method	= "PUT"
		o.headers	= { "Content-Type": content_type }

		# Make the request.
		req = http.request o, ( res ) ->
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

		# Write the data to the request and end the request.
		req.write data
		req.end( )
			

	doc: ( id, value, cb ) ->
		# Do a little shuffle to allow both
		#  * doc( id, cb )
		#  * doc( id, value, cb )
		if not cb
			cb	= value
			value	= null
	
		# Just do a simple get request for the particular id.
		if not value
			@_get @_url + @db + "/" + id, ( err, res ) ->
				if err
					return cb err
				return cb null, res
		else
			# Value was specified

			# Do a put request to set the document.
			@_put @_url + @db + "/" + id, JSON.stringify( value ), "application/json", ( err, res ) ->
				if err 
					return cb err
				return cb null, res

	view: ( design_name, view, cb ) ->
		# Just a helper to wrap a doc request really.
		@doc @_url + @db + "/_design/" + design_name + "/_view/" + view, cb

class Base
	_hidden_functions = [ "constructor", "Server" ]

	@find_all: ( filter, cb ) ->
		@ensure_views ( err ) ->
			if err
				return cb err

			# At this point make a request based on the filter..
			@::Server.
			# Use @::Server.. 

			return cb null

	@generate_views: ( spec, cb ) ->
		# Generate the views for the given spec.
		# Returns an object that usually gets shoved / merged into doc.views
		_r = { }
		for key, value of spec
			view_name = "by-" + key
			_r[view_name] = { "map":	"""
							function( doc ){
								// Make sure we only match the correct documents..
								if( doc._type != "#{@name}" ){
									return
								}
								emit( doc.#{key}, doc );
							}
							""" }
		cb null, _r

	@ensure_views: ( cb ) ->

		# Make a query for the design document. If we can't get that, we know we need to create all the views.
		@::Server.doc "_design/" + @name, ( err, doc ) =>
			if err
				# Make all of them..
				_new_doc = { "language": "javascript", "views": { } }

				@generate_views @spec( ), ( err, views ) =>
					if err
						return cb err

					# We have views, so shove them into the new design document that we're building.
					_new_doc.views = views
					
					# Shove the document to the server and make sure its committed..
					@::Server.doc "_design/" + @name, _new_doc, ( err ) ->
						if err
							return cb err
						return cb null
			else
				# Figure out what views we will need to generate ( if any ).

				log "Found design doc"

				to_generate	= { }
				existing_views	= Object.keys doc.views

				# Iterate over all the keys that should exist..
				for key, value of @spec( )

					# If the key doesn't exist in the document we just pulled, shove it into to_generate.
					if not key in existing_views
						to_generate[key] = value
		
				# Exit out here if we have all the views we should in the design document already.
				if Object.keys( to_generate ).length is 0
					log "No need to update doc."
					return cb null

				# Get the views and send the request to update the document..
				@generate_views to_generate, ( err, views ) =>
					if err
						return cb null

					# Iterate through the response and update the 'doc' object which we grabbed.
					for key, value of views
						if not doc.views[key]?
							doc.views[key] = views[key]
						
					# Make a request to set the document..
					@::Server.doc "_design/" + @name, doc, ( err ) ->
						if err 
							return cb err
						return cb null

	@spec: ( ) ->
		_return = { }
		for key, value of (@::) when ( key not in _hidden_functions and key.charAt( 0 ) isnt "_" )
			_return[key] = typeof @::[key]( null, true )
		_return

	@delete: ( ) ->
		

exports.Server	= Server
exports.Base	= Base
