(function() {
  var fs, step, utils;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

  module.exports = function(req, res) {
    var atime, mtime, path, result, sendResult, writeProtection;
    path = req.body.path;
    atime = req.body.atime;
    mtime = req.body.mtime;
    result = {};
    writeProtection = utils.writeProtection(req, res, path);
    sendResult = function(err) {
      if (err) {
        utils.forbiddenToResult(result, err, res);
      } else {
        fs.utimes(path, atime, mtime, function(err) {
          if (err) return utils.errorToResult(result, err, res);
        });
      }
      return res.send(result);
    };
    return step(writeProtection, sendResult);
  };

}).call(this);
