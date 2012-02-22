(function() {
  var fs, step, utils;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

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
        return fs.unlink(path, function(err) {
          if (err) utils.errorToResult(result, err, res);
          return res.send(result);
        });
      }
    };
    return step(writeProtection, sendResult);
  };

}).call(this);
