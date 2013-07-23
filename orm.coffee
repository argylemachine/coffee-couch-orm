class Server
	constructor: ( database_options ) ->
		@validate_database_options database_options, ( err ) ->
			if err
				throw err
			@database_options = database_options

	validate_database_options: ( database_options, cb ) ->
		for required in [ "url", "db" ]
			if not database_options[required]?
				return cb "Required field " + required + " not specified."
		cb null

	link: ( _instance, cb ) =>
		_instance.server = this
		cb null
class BASE
	new: ( ) ->
		# Creates a new object and document...

	delete: ( ) ->
		# Removes the document and the object.

	find: ( ) ->
		# Find like types in the database.

exports.Server	= Server
exports.BASE	= BASE
