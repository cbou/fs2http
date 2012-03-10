(function() {
  var fs, step, utils;

  fs = require('fs');

  step = require('step');

  utils = require('../utils');

  module.exports = function(req, res) {
    var data, encoding, path, result;
    path = req.body.path;
    data = req.body.data;
    encoding = req.body.encoding ? req.body.encoding : void 0;
    result = {};
    return utils.updatePath(req, res, path, function(path) {
      var sendResult, writeProtection;
      writeProtection = utils.writeProtection(req, res, path);
      sendResult = function(err) {
        if (err) {
          utils.forbiddenToResult(result, err, res);
          return res.send(result);
        } else {
          return fs.writeFile(path, data, encoding, function(err) {
            if (err) utils.errorToResult(result, err, res);
            return res.send(result);
          });
        }
      };
      return step(writeProtection, sendResult);
    });
  };

}).call(this);
