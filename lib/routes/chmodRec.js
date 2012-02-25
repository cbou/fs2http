(function() {
  var fs, step, utils, wrench;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

  wrench = require('wrench');

  module.exports = function(req, res) {
    var mode, path, result, sendResult, writeProtection;
    path = req.body.path;
    mode = req.body.mode;
    result = {};
    writeProtection = utils.writeProtection(req, res, path);
    sendResult = function(err) {
      if (err) {
        utils.forbiddenToResult(result, err, res);
        return res.send(result);
      } else {
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
      }
    };
    return step(writeProtection, sendResult);
  };

}).call(this);
