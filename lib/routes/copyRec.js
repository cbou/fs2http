(function() {
  var fs, step, utils, wrench;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

  wrench = require('wrench');

  module.exports = function(req, res) {
    var newpath, path, result;
    path = req.body.path;
    newpath = req.body.newpath;
    result = {};
    return utils.updatePath(req, res, path, function(path) {
      return utils.updatePath(req, res, newpath, function(newpath) {
        var readProtection, sendResult, writeProtection;
        writeProtection = utils.writeProtection(req, res, newpath);
        readProtection = utils.readProtection(req, res, path);
        sendResult = function(err) {
          if (err) {
            utils.forbiddenToResult(result, err, res);
            return res.send(result);
          } else {
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
          }
        };
        return step(writeProtection, readProtection, sendResult);
      });
    });
  };

}).call(this);
