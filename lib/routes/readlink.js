(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../utils');

  module.exports = function(req, res) {
    var path, result;
    path = req.query.path;
    result = {};
    return fs.readlink(path, function(err, linkString) {
      if (err) utils.errorToResult(result, err, res);
      result['linkString'] = linkString;
      return res.send(result);
    });
  };

}).call(this);
