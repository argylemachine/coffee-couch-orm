log	= require("logging").from __filename
http	= require "http"
url	= require "url"
events	= require "events"

class Server

	constructor: ( @url, @db ) ->
		
	req: ( path, method, data, content_type, cb ) ->

		# Allow either all 5 or just 2
		# * req /foo, "POST", "some data", "text/plain", ( ) ->
		# * req /foo, ( ) ->
		if not data and not content_type and not cb
			cb	= method
			method	= "GET"

		_url = @url + @db + "/" + path

		log "Request: (#{method}) #{_url}."

		_opts = url.parse _url
		_opts["method"] = method
		if content_type
			_opts["headers"]			= { }
			_opts["headers"]["Content-Type"]	= content_type
		
		req = http.request _opts, ( res ) ->
			res.setEncoding "utf8"

			_r = ""

			res.on "data", ( chunk ) ->
				_r += chunk
			
			res.on "end", ( ) ->
				try
					_obj = JSON.parse _r
					if 'error' of _obj
						return cb _obj['error']
					cb null, _obj
				catch err
					cb err
			
		req.on "error", ( err ) ->
			cb err

		# If there was data specified, write it out to the request.
		if data
			req.write data

		req.end( )

	update: ( _id, attr, val, cb ) ->
		# Update the document _id by setting the attribute 'attr' to 'val'.

		# Get the current document
		@get _id, ( err, doc ) ->
			if err
				return cb err

			# Set the attribute to be the value we got.
			doc[attr] = val

			# Set the document back on the server.
			@set _id, doc, ( err, res ) ->
				if err
					return cb err
				cb null

	get: ( _id, cb ) ->
		# Get a particular document.
		@req _id, ( err, doc ) ->
			if err
				return cb err
			cb null, doc

	set: ( _id, doc, cb ) ->
		# Set the particular document with ID _id to be doc.
		# Mainly a wrapper for a PUT request with specific content type.
		@req _id, "PUT", doc, "text/json", cb

	post: ( doc, cb ) ->
		# Helper to post a new document to the couchdb server.
		@req "", "POST", JSON.stringify( doc ), "application/json", cb

class Base extends events.EventEmitter

	constructor: ( _id ) ->

		# If no document id was specified, then make a post request
		# to the server to request one.
		if not _id
			@Server.post { }, ( err, res ) =>
				
				# If we error out at this stage things aren't good!
				if err
					return log err

				log res

				# Set the id to be instance wide.
				@_id = res['id']

				# Call set_helpers
				@set_helpers( )

			return

		# Set the id that was specified instance wide.
		@_id = _id

		# Call set_helpers..
		@set_helpers( )
		
	get_attributes: ( ) ->
		_ret = [ ]
		for key, value of (@) when typeof( @[key] ) is "function" and not ( key.charAt( 0 ) is "_" )
			str_value = String value

			# Search value for instance objects..
			# Note the space at the end, this is so that we get attributes not functions..
			# At a later point this may need to be expanded as overwriting functions could happen in child class.
			reg = /this\.[A-Za-z_]* /g
			
			matches = str_value.match reg

			if not matches
				continue

			# Parse matches to remove the 'this.' prefix, and trim it.
			_matches = [ ]
			for match in matches
				_matches.push match.substring( 5 ).trim( )

			matches = _matches

			for match in matches when match not in _ret
				_ret.push match 
		_ret

	set_helpers: ( ) ->

		log "Got to set helpers.. id is #{@_id}"
		# Iterate through all the attributes we shuld hook up with getters and setters.
		for attribute in @get_attributes( )
			
			# Note that we grab the current value of the attribute so that we don't lose any data that may exist from a constructor.
			_current_attribute_value = @[attribute]

			@.__defineGetter__ attribute, @_generate_getter attribute
			@.__defineSetter__ attribute, @_generate_setter attribute
			
			# Set the attribute back to its state before the getter/setter.
			@[attribute] = _current_attribute_value

	_generate_getter: ( attr ) ->
		# Helper function that generates a getter function for the attribute that is passed in.
		k = ( ) ->

			# Set the local variable 
			@["_"+attr]

			# Make the async request to update the local variable.
			@Server.get @_id, ( err, doc ) ->

				# If we get an error, simply set the attribute to undefined
				# and return back.
				if err 
					@["_"+attr] = undefined
					return

				# Wrap this in a try because the doc may not have that attribute anymore.
				try
					@["_"+attr] = doc[attr]
				catch
					@["_"+attr] = undefined
		k

	_generate_setter: ( attr ) ->
		k = ( val ) ->
			@["_"+attr] = val
		k

exports.Base	= Base
exports.Server	= Server
