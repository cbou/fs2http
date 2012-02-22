(function() {
  var fs, step, utils;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

  module.exports = function(req, res) {
    var link, path, result, sendResult, type, writeProtection;
    link = req.body.link;
    path = req.body.path;
    type = req.body.type ? req.body.type : void 0;
    result = {};
    writeProtection = utils.writeProtection(req, res, path);
    sendResult = function(err) {
      if (err) {
        utils.forbiddenToResult(result, err, res);
        return res.send(result);
      } else {
        return fs.symlink(path, link, type, function(err) {
          if (err) utils.errorToResult(result, err, res);
          return res.send(result);
        });
      }
    };
    return step(writeProtection, sendResult);
  };

}).call(this);
