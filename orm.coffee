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

			if not matches
				continue

			for match in matches when match not in _ret
				_ret.push match
		_ret

exports.Base	= Base
