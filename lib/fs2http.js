(function() {
  var exports, fs2http;

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

  /*
   * Add the app
  */

  fs2http.use = function(app) {
    fs2http.app = app;
    fs2http.app.post(fs2http.options.path.rename, fs2http.routes.rename);
    fs2http.app.post(fs2http.options.path.chown, fs2http.routes.chown);
    fs2http.app.post(fs2http.options.path.chmod, fs2http.routes.chmod);
    fs2http.app.get(fs2http.options.path.stat, fs2http.routes.stat);
    fs2http.app["delete"](fs2http.options.path.rmdir, fs2http.routes.rmdir);
    fs2http.app.post(fs2http.options.path.mkdir, fs2http.routes.mkdir);
    fs2http.app.get(fs2http.options.path.readdir, fs2http.routes.readdir);
    fs2http.app.post(fs2http.options.path.utimes, fs2http.routes.utimes);
    fs2http.app.get(fs2http.options.path.readFile, fs2http.routes.readFile);
    fs2http.app.post(fs2http.options.path.writeFile, fs2http.routes.writeFile);
    fs2http.app.get(fs2http.options.path.ls, fs2http.routes.ls);
    return fs2http;
  };

  exports = module.exports = fs2http;

}).call(this);
