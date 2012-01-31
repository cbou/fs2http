(function() {
  var app, express, fs2http;

  express = require("express");

  fs2http = require("../lib/fs2http");

  app = module.exports = express.createServer();

  app.configure(function() {
    return app.use(express.bodyParser());
  });

  fs2http.use(app);

  module["export"] = app;

  app.listen(3000);

}).call(this);
