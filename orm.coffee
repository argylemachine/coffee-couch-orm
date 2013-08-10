log	= require("logging").from __filename

class Base

	debug: ( ) ->
		log "Got here"
		log @

	get_attributes: ( ) ->
		_ret = [ ]
		for key, value of (@) when typeof @[key] is "function"
			str_value = String value

			# Search value for /this\./ ..
			reg = /this\.[A-Za-z_]*/g
			
			matches = str_value.match reg
			log matches

		_ret

exports.Base	= Base
