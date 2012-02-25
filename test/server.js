(function() {
  var app, express, fs2http;

  express = require("express");

  fs2http = require("../lib/fs2http");

  app = module.exports = express.createServer();

  app.configure(function() {
    return app.use(express.bodyParser());
  });

  fs2http.use(app);

  fs2http.protections.read = function(req, res, path, callback) {
    var regex;
    regex = /\/tmp\/fs2http\/protection\/read-protected/g;
    setTimeout(function() {
      if (regex.test(path)) {
        return callback('path read protected');
      } else {
        return callback();
      }
    }, 1000);
    return;
  };

  fs2http.protections.write = function(req, res, path, callback) {
    var regex;
    regex = /\/tmp\/fs2http\/protection\/write-protected/g;
    if (regex.test(path)) {
      callback('path write protected');
    } else {
      callback();
    }
    return;
  };

  module["export"] = app;

  app.listen(3000);

}).call(this);
