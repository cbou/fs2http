(function() {
  var fs, utils, wrench;

  fs = require('fs');

  utils = require('../utils');

  wrench = require('wrench');

  module.exports = function(req, res) {
    var newpath, path, result;
    path = req.body.path;
    newpath = req.body.newpath;
    result = {};
    return fs.stat(path, function(err, stats) {
      if (err) utils.errorToResult(result, err, res);
      if (stats && stats.isDirectory()) {
        return wrench.copyDirRecursive(path, newpath, function(err) {
          if (err) utils.errorToResult(result, err, res);
          return res.send(result);
        });
      } else if (stats && stats.isFile()) {
        return utils.copyFile(path, newpath, function(err) {
          if (err) utils.errorToResult(result, err, res);
          return res.send(result);
        });
      } else {
        err = {
          code: 'NOTIMPL',
          message: 'function not implemented yet'
        };
        utils.errorToResult(result, err, res);
        return res.send(result);
      }
    });
  };

}).call(this);
