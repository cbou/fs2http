(function() {
  var fs, step, utils;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

  module.exports = function(req, res) {
    var path, result;
    path = req.query.path;
    result = {};
    return utils.updatePath(req, res, path, function(path) {
      var readProtection, sendResult;
      readProtection = utils.readProtection(req, res, path);
      sendResult = function(err) {
        if (err) {
          utils.forbiddenToResult(result, err, res);
          return res.send(result);
        } else {
          return fs.stat(path, function(err, stats) {
            if (err) utils.errorToResult(result, err, res);
            result['stats'] = stats;
            return res.send(result);
          });
        }
      };
      return step(readProtection, sendResult);
    });
  };

}).call(this);
