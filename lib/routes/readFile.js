(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../utils');

  module.exports = function(req, res) {
    var encoding, path, result;
    path = req.query.path;
    encoding = req.query.encoding ? req.query.encoding : null;
    result = {};
    return fs.readFile(path, encoding, function(err, data) {
      if (err) utils.errorToResult(result, err, res);
      result['data'] = data;
      return res.send(result);
    });
  };

}).call(this);
