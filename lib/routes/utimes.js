(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../utils');

  module.exports = function(req, res) {
    var atime, mtime, path, result;
    path = req.body.path;
    atime = req.body.atime;
    mtime = req.body.mtime;
    result = {};
    return fs.utimes(path, atime, mtime, function(err) {
      if (err) utils.errorToResult(result, err, res);
      return res.send(result);
    });
  };

}).call(this);
