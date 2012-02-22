(function() {
  var fs, step, utils;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

  module.exports = function(req, res) {
    var path, readProtection, result, sendResult;
    path = req.query.path;
    result = {};
    readProtection = utils.readProtection(req, res, path);
    sendResult = function(err) {
      if (err) {
        utils.forbiddenToResult(result, err, res);
      } else {
        fs.readlink(path, function(err, linkString) {
          if (err) utils.errorToResult(result, err, res);
          return result['linkString'] = linkString;
        });
      }
      return res.send(result);
    };
    return step(readProtection, sendResult);
  };

}).call(this);
