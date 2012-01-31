(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../utils');

  module.exports = function(req, res) {
    var link, path, result, type;
    link = req.body.link;
    path = req.body.path;
    type = req.body.type ? req.body.type : void 0;
    result = {};
    return fs.symlink(path, link, type, function(err) {
      if (err) utils.errorToResult(result, err, res);
      return res.send(result);
    });
  };

}).call(this);
