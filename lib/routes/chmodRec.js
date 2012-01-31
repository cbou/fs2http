(function() {
  var fs, utils, wrench;

  fs = require('fs');

  utils = require('../utils');

  wrench = require('wrench');

  module.exports = function(req, res) {
    var mode, path, result;
    path = req.body.path;
    mode = req.body.mode;
    result = {};
    return fs.stat(path, function(err, stats) {
      if (err) utils.errorToResult(result, err, res);
      if (stats && stats.isDirectory()) {
        try {
          wrench.chmodSyncRecursive(path, mode);
        } catch (err) {
          utils.errorToResult(result, err, res);
        }
        return res.send(result);
      } else if (stats && stats.isFile()) {
        return fs.chmod(path, mode, function(err) {
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
