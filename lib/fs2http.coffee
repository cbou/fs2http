fs2http = {}

fs2http.routes = require './routes'

# set default
fs2http.options = {
	'path' :
		# from node
		'rename' : '/fs2http/rename'
		'chown' : '/fs2http/chown'
		'chmod' : '/fs2http/chmod'
		'stat' : '/fs2http/stat'
		'rmdir' : '/fs2http/rmdir'
		'mkdir' : '/fs2http/mkdir'
		'readdir' : '/fs2http/readdir'
		'utimes' : '/fs2http/utimes'
		'futimes' : '/fs2http/futimes'
		'readFile' : '/fs2http/readFile'
		'writeFile' : '/fs2http/writeFile'
		'symlink' : '/fs2http/symlink'
		'unlink' : '/fs2http/unlink'
		'readlink' : '/fs2http/readlink'
		'exists' : '/fs2http/exists'

		# recursive routes
		'chownRec' : '/fs2http/chownRec'
		'chmodRec' : '/fs2http/chmodRec'
		'rmRec' : '/fs2http/rmRec'
		'copyRec' : '/fs2http/copyRec'

		# custom
		'ls' : '/fs2http/ls'

		# todo
		'cat' : '/fs2http/cat'
		'mv' : '/fs2http/mv'
		'cp' : '/fs2http/cp'
		'rm' : '/fs2http/rm'
		'find' : '/fs2http/find'
		'grep' : '/fs2http/grep'
		'chmod' : '/fs2http/chmod'
		'chown' : '/fs2http/chown'

	# files
	'files' :
		'passwdFile' : '/etc/passwd'
		'groupFile' : '/etc/group'
}

unsafeProtection = (req, res, path, callback) ->
	callback()

fs2http.protections = {}
fs2http.protections.read = unsafeProtection;
fs2http.protections.write = unsafeProtection;

###
 * Add the app
###
fs2http.use = (app) ->

	fs2http.app = app
	app.fs2http = fs2http
	
	# from node
	fs2http.app.post fs2http.options.path.rename, fs2http.routes.rename
	fs2http.app.post fs2http.options.path.chown, fs2http.routes.chown
	fs2http.app.post fs2http.options.path.chmod, fs2http.routes.chmod
	fs2http.app.get fs2http.options.path.stat, fs2http.routes.stat
	fs2http.app.del fs2http.options.path.rmdir, fs2http.routes.rmdir
	fs2http.app.post fs2http.options.path.mkdir, fs2http.routes.mkdir
	fs2http.app.get fs2http.options.path.readdir, fs2http.routes.readdir
	fs2http.app.post fs2http.options.path.utimes, fs2http.routes.utimes
	fs2http.app.get fs2http.options.path.readFile, fs2http.routes.readFile
	fs2http.app.post fs2http.options.path.writeFile, fs2http.routes.writeFile
	fs2http.app.post fs2http.options.path.symlink, fs2http.routes.symlink
	fs2http.app.del fs2http.options.path.unlink, fs2http.routes.unlink
	fs2http.app.get fs2http.options.path.readlink, fs2http.routes.readlink
	fs2http.app.get fs2http.options.path.exists, fs2http.routes.exists

	# recursive routes
	fs2http.app.post fs2http.options.path.chownRec, fs2http.routes.chownRec
	fs2http.app.post fs2http.options.path.chmodRec, fs2http.routes.chmodRec
	fs2http.app.del fs2http.options.path.rmRec, fs2http.routes.rmRec
	fs2http.app.post fs2http.options.path.copyRec, fs2http.routes.copyRec

	# custom
	fs2http.app.get fs2http.options.path.ls, fs2http.routes.ls

exports = module.exports = fs2http;