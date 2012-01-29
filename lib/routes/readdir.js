(function() {
  var fs, util;

  fs = require('fs');

  util = require('util');

  module.exports = function(req, res) {
    var path, result;
    path = req.query.path;
    result = {
      error: [],
      success: true
    };
    return fs.readdir(path, function(err, files) {
      if (err) utils.errorToResult(result, err);
      result['files'] = files;
      return res.send(result);
    });
  };

}).call(this);
