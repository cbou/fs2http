(function() {
  var fs, step, utils;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

  module.exports = function(req, res) {
    var data, encoding, path, result, sendResult, writeProtection;
    path = req.body.path;
    data = req.body.data;
    encoding = req.body.encoding ? req.body.encoding : void 0;
    result = {};
    writeProtection = utils.writeProtection(req, res, path);
    sendResult = function(err) {
      if (err) {
        utils.forbiddenToResult(result, err, res);
      } else {
        fs.writeFile(path, data, encoding, function(err) {
          if (err) return utils.errorToResult(result, err, res);
        });
      }
      return res.send(result);
    };
    return step(writeProtection, sendResult);
  };

}).call(this);
