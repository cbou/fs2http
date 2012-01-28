(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../utils');

  module.exports = function(req, res) {
    var encoding, filename, result;
    filename = req.query.filename;
    encoding = req.query.encoding ? req.query.encoding : null;
    result = {
      error: [],
      success: true
    };
    return fs.readFile(filename, encoding, function(err, data) {
      if (err) utils.errorToResult(result, err);
      result['data'] = data;
      return res.send(result);
    });
  };

}).call(this);
