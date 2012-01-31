(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../utils');

  module.exports = function(req, res) {
    var mode, path, result;
    path = req.body.path;
    mode = req.body.mode ? req.body.mode : void 0;
    result = {};
    return fs.mkdir(path, mode, function(err) {
      if (err) utils.errorToResult(result, err, res);
      return res.send(result);
    });
  };

}).call(this);
