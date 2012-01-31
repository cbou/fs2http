(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../utils');

  module.exports = function(req, res) {
    var data, encoding, path, result;
    path = req.body.path;
    data = req.body.data;
    encoding = req.body.encoding ? req.body.encoding : void 0;
    result = {};
    return fs.writeFile(path, data, encoding, function(err) {
      if (err) utils.errorToResult(result, err, res);
      return res.send(result);
    });
  };

}).call(this);
