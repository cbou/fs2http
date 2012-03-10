(function() {
  var fs, step, utils;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

  module.exports = function(req, res) {
    var path1, path2, result;
    path1 = req.body.path1;
    path2 = req.body.path2;
    result = {};
    return utils.updatePath(req, res, path1, function(path1) {
      return utils.updatePath(req, res, path2, function(path2) {
        var sendResult, writeProtection1, writeProtection2;
        writeProtection1 = utils.writeProtection(req, res, path1);
        writeProtection2 = utils.writeProtection(req, res, path2);
        sendResult = function(err) {
          if (err) {
            utils.forbiddenToResult(result, err, res);
            return res.send(result);
          } else {
            return fs.rename(path1, path2, function(err) {
              if (err) utils.errorToResult(result, err, res);
              return res.send(result);
            });
          }
        };
        return step(writeProtection1, writeProtection2, sendResult);
      });
    });
  };

}).call(this);
