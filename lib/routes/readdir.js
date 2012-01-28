(function() {
  var fs, util;

  fs = require('fs');

  util = require('util');

  module.exports = function(req, res) {
    var dir, result;
    dir = req.query.dir;
    result = {
      error: [],
      success: true
    };
    return fs.readdir(dir, function(err, files) {
      if (err) utils.errorToResult(result, err);
      result['files'] = files;
      return res.send(result);
    });
  };

}).call(this);
