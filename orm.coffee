log	= require("logging").from __filename

class Base

	debug: ( ) ->
		log "Got here"
		log @

	get_attributes: ( ) ->
		_ret = [ ]
		for key, value of (@) when typeof @[key] is "function"
			# Make sure key is function..
			log "Key is '#{key}' and value is '#{value}'"

exports.Base	= Base
