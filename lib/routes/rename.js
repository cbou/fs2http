(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../utils');

  module.exports = function(req, res) {
    var path1, path2, result;
    path1 = req.body.path1;
    path2 = req.body.path2;
    result = {
      error: [],
      success: true
    };
    return fs.rename(path1, path2, function(err) {
      if (err) utils.errorToResult(result, err);
      return res.send(result);
    });
  };

}).call(this);
