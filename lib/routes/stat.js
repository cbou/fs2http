(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../utils');

  module.exports = function(req, res) {
    var path, result;
    path = req.query.path;
    result = {
      error: [],
      success: true
    };
    return fs.stat(path, function(err, stats) {
      if (err) utils.errorToResult(result, err);
      result['stats'] = stats;
      return res.send(result);
    });
  };

}).call(this);
