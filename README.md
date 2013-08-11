coffee-couch-orm
================

This software is not ready for use yet!

Behind the scenes the ORM system creates the hooks for setters and getters to make requests to the CouchDB server. There currently is no plan for a caching layer, although that could be easily expanded by modifying orm.Base slightly.

Basic Usage
===========

Still heavily under development - do not use.

```coffeescript
util	= require "util"
orm	= require "couch-orm"

# Simple example of person..
class Person extends orm.Base
	constructor: ( @first_name, @age ) ->
		
	_hidden_func: ( ) ->
		"Some logic here that shouldn't be included in the orm."
	
# Set a new server connection ORM wide so that any defintions use this server.
orm.Base.Server = new orm.Server "http://couchdb:5984/", "orm"

# Create a new instance of a person object.
# Note that all ORM functionality is hidden.
rob = new Person "Rob", 22

# Query from the CouchDB database:
util.log rob.first_name

# Update the CouchDB database:
rob.first_name = "Bob"
```

Install
=======
npm install couch-orm
