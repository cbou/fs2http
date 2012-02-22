(function() {
  var fs, step, util, utils;

  fs = require('fs');

  step = require('step');

  util = require('util');

  utils = require('../utils');

  module.exports = function(req, res) {
    var path, readProtection, result, sendResult;
    path = req.query.path;
    result = {};
    readProtection = utils.readProtection(req, res, path);
    sendResult = function(err) {
      if (err) {
        utils.forbiddenToResult(result, err, res);
        return res.send(result);
      } else {
        return fs.readdir(path, function(err, files) {
          if (err) utils.errorToResult(result, err, res);
          result['files'] = files;
          return res.send(result);
        });
      }
    };
    return step(readProtection, sendResult);
  };

}).call(this);
