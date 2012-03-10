(function() {
  var fs, step, utils;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

  module.exports = function(req, res) {
    var atime, mtime, path, result;
    path = req.body.path;
    atime = req.body.atime;
    mtime = req.body.mtime;
    result = {};
    return utils.updatePath(req, res, path, function(path) {
      var sendResult, writeProtection;
      writeProtection = utils.writeProtection(req, res, path);
      sendResult = function(err) {
        if (err) {
          utils.forbiddenToResult(result, err, res);
          return res.send(result);
        } else {
          return fs.utimes(path, atime, mtime, function(err) {
            if (err) utils.errorToResult(result, err, res);
            return res.send(result);
          });
        }
      };
      return step(writeProtection, sendResult);
    });
  };

}).call(this);
