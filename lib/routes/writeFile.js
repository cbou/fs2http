(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../utils');

  module.exports = function(req, res) {
    var data, encoding, filename, result;
    filename = req.body.filename;
    data = req.body.data;
    encoding = req.body.encoding ? req.body.encoding : void 0;
    result = {
      error: [],
      success: true
    };
    return fs.writeFile(filename, data, encoding, function(err) {
      if (err) utils.errorToResult(result, err);
      return res.send(result);
    });
  };

}).call(this);
