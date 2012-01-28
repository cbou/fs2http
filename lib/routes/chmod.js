(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../utils');

  module.exports = function(req, res) {
    var mode, path, result;
    path = req.body.path;
    mode = req.body.mode;
    result = {
      error: [],
      success: true
    };
    return fs.chmod(path, mode, function(err) {
      if (err) utils.errorToResult(result, err);
      return res.send(result);
    });
  };

}).call(this);
