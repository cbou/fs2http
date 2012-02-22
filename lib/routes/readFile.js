(function() {
  var fs, step, utils;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

  module.exports = function(req, res) {
    var encoding, path, readProtection, result, sendResult;
    path = req.query.path;
    encoding = req.query.encoding ? req.query.encoding : null;
    result = {};
    readProtection = utils.readProtection(req, res, path);
    sendResult = function(err) {
      if (err) {
        utils.forbiddenToResult(result, err, res);
      } else {
        fs.readFile(path, encoding, function(err, data) {
          if (err) utils.errorToResult(result, err, res);
          return result['data'] = data;
        });
      }
      return res.send(result);
    };
    return step(readProtection, sendResult);
  };

}).call(this);
