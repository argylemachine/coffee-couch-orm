log	= require("logging").from __filename
http	= require "http"
url	= require "url"

class Server

	constructor: ( @url, @db ) ->
		
	req: ( path, method, data, content_type, cb ) ->

		# Allow either all 5 or just 2
		# * req /foo, "POST", "some data", "text/plain", ( ) ->
		# * req /foo, ( ) ->
		if not data and not content_type and not cb
			cb	= method
			method	= "GET"

		_opts = url.parse @url + @db + @path
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
					_obj = JSON.parse chunk
					cb _obj
				catch err
					cb { "error": err }
			
		req.on "error", ( err ) ->
			cb { "error": err }
		
class Base

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

	get_helpers: ( ) ->
		_ret = [ ]
		for attribute in @get_attributes( )
			_ret.push @_generate_getter attribute
			_ret.push @_generate_setter attribute
		null

	_generate_getter: ( attr ) ->
		# Helper function that generates a getter function for the attribute that is passed in.
		
	_generate_setter: ( attr ) ->
		

exports.Base	= Base
