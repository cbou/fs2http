fs2http = {}

fs2http.routes = require './routes'

unsafeProtection = (req, res, path, callback) ->
	callback()

withoutPathUpdate = (req, res, path, callback) ->
	callback(path)

middleware = (req, res, next) ->
	next()

fs2http.protections = {}
fs2http.protections.read = unsafeProtection
fs2http.protections.write = unsafeProtection

fs2http.updatePath = withoutPathUpdate
fs2http.middleware = middleware

###
 * Add the app
###
fs2http.use = (app) ->

	fs2http.app = app
	app.fs2http = fs2http
	
	# from node
	for name, route of fs2http.routes
		if typeof route == 'object'
			fs2http.app[route.method] route.url, fs2http.middleware, route.function

exports = module.exports = fs2http;