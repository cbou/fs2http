(function() {
  var fs, step, utils, wrench;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

  wrench = require('wrench');

  module.exports = function(req, res) {
    var path, result, sendResult, writeProtection;
    path = req.body.path;
    result = {};
    writeProtection = utils.writeProtection(req, res, path);
    sendResult = function(err) {
      if (err) {
        utils.forbiddenToResult(result, err, res);
        return res.send(result);
      } else {
        return fs.lstat(path, function(err, stats) {
          if (err) {
            utils.errorToResult(result, err, res);
            res.send(result);
            return;
          }
          if (stats && stats.isDirectory()) {
            return wrench.rmdirRecursive(path, function(err) {
              if (err) utils.errorToResult(result, err, res);
              return res.send(result);
            });
          } else if (stats && (stats.isFile() || stats.isSymbolicLink())) {
            return fs.unlink(path, function(err) {
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
      }
    };
    return step(writeProtection, sendResult);
  };

}).call(this);
