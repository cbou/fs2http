(function() {
  var fs, util;

  fs = require('fs');

  util = require('util');

  module.exports = function(req, res) {
    var path, result;
    path = req.query.path;
    result = {};
    return fs.readdir(path, function(err, files) {
      if (err) utils.errorToResult(result, err, res);
      result['files'] = files;
      return res.send(result);
    });
  };

}).call(this);
