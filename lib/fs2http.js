(function() {
  var exports, fs2http, middleware, u, unsafeProtection, withoutPathUpdate;

  u = require('underscore');

  fs2http = {};

  fs2http.routes = require('./routes');

  fs2http.options = {
    'path': {
      'rename': '/fs2http/rename',
      'chown': '/fs2http/chown',
      'chmod': '/fs2http/chmod',
      'stat': '/fs2http/stat',
      'rmdir': '/fs2http/rmdir',
      'mkdir': '/fs2http/mkdir',
      'readdir': '/fs2http/readdir',
      'utimes': '/fs2http/utimes',
      'futimes': '/fs2http/futimes',
      'readFile': '/fs2http/readFile',
      'writeFile': '/fs2http/writeFile',
      'symlink': '/fs2http/symlink',
      'unlink': '/fs2http/unlink',
      'readlink': '/fs2http/readlink',
      'exists': '/fs2http/exists',
      'chownRec': '/fs2http/chownRec',
      'chmodRec': '/fs2http/chmodRec',
      'rmRec': '/fs2http/rmRec',
      'copyRec': '/fs2http/copyRec',
      'ls': '/fs2http/ls',
      'cat': '/fs2http/cat',
      'mv': '/fs2http/mv',
      'cp': '/fs2http/cp',
      'rm': '/fs2http/rm',
      'find': '/fs2http/find',
      'grep': '/fs2http/grep',
      'chmod': '/fs2http/chmod',
      'chown': '/fs2http/chown'
    },
    'files': {
      'passwdFile': '/etc/passwd',
      'groupFile': '/etc/group'
    }
  };

  unsafeProtection = function(req, res, path, callback) {
    return callback();
  };

  withoutPathUpdate = function(req, res, path, callback) {
    return callback(path);
  };

  middleware = function(req, res, next) {
    return next();
  };

  fs2http.protections = {};

  fs2http.protections.read = unsafeProtection;

  fs2http.protections.write = unsafeProtection;

  fs2http.updatePath = withoutPathUpdate;

  fs2http.middleware = middleware;

  /*
   * Add the app
  */

  fs2http.use = function(app) {
    fs2http.app = app;
    app.fs2http = fs2http;
    fs2http.app.post(fs2http.options.path.rename, fs2http.middleware, fs2http.routes.rename);
    fs2http.app.post(fs2http.options.path.chown, fs2http.middleware, fs2http.routes.chown);
    fs2http.app.post(fs2http.options.path.chmod, fs2http.middleware, fs2http.routes.chmod);
    fs2http.app.get(fs2http.options.path.stat, fs2http.middleware, fs2http.routes.stat);
    fs2http.app.del(fs2http.options.path.rmdir, fs2http.middleware, fs2http.routes.rmdir);
    fs2http.app.post(fs2http.options.path.mkdir, fs2http.middleware, fs2http.routes.mkdir);
    fs2http.app.get(fs2http.options.path.readdir, fs2http.middleware, fs2http.routes.readdir);
    fs2http.app.post(fs2http.options.path.utimes, fs2http.middleware, fs2http.routes.utimes);
    fs2http.app.get(fs2http.options.path.readFile, fs2http.middleware, fs2http.routes.readFile);
    fs2http.app.post(fs2http.options.path.writeFile, fs2http.middleware, fs2http.routes.writeFile);
    fs2http.app.post(fs2http.options.path.symlink, fs2http.middleware, fs2http.routes.symlink);
    fs2http.app.del(fs2http.options.path.unlink, fs2http.middleware, fs2http.routes.unlink);
    fs2http.app.get(fs2http.options.path.readlink, fs2http.middleware, fs2http.routes.readlink);
    fs2http.app.get(fs2http.options.path.exists, fs2http.middleware, fs2http.routes.exists);
    fs2http.app.post(fs2http.options.path.chownRec, fs2http.middleware, fs2http.routes.chownRec);
    fs2http.app.post(fs2http.options.path.chmodRec, fs2http.middleware, fs2http.routes.chmodRec);
    fs2http.app.del(fs2http.options.path.rmRec, fs2http.middleware, fs2http.routes.rmRec);
    fs2http.app.post(fs2http.options.path.copyRec, fs2http.middleware, fs2http.routes.copyRec);
    return fs2http.app.get(fs2http.options.path.ls, fs2http.middleware, fs2http.routes.ls);
  };

  exports = module.exports = fs2http;

}).call(this);
