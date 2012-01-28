(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../utils');

  module.exports = function(req, res) {
    var path, result;
    path = req.body.path;
    result = {
      error: [],
      success: true
    };
    return fs.rmdir(path, function(err) {
      if (err) utils.errorToResult(result, err);
      return res.send(result);
    });
  };

}).call(this);