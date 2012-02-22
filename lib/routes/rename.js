(function() {
  var fs, step, utils;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

  module.exports = function(req, res) {
    var path1, path2, result, sendResult, writeProtection1, writeProtection2;
    path1 = req.body.path1;
    path2 = req.body.path2;
    result = {};
    writeProtection1 = utils.writeProtection(req, res, path1);
    writeProtection2 = utils.writeProtection(req, res, path2);
    sendResult = function(err) {
      if (err) {
        utils.forbiddenToResult(result, err, res);
      } else {
        fs.rename(path1, path2, function(err) {
          if (err) return utils.errorToResult(result, err, res);
        });
      }
      return res.send(result);
    };
    return step(writeProtection1, writeProtection2, sendResult);
  };

}).call(this);
