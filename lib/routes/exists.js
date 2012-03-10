(function() {
  var path, step, utils;

  path = require('path');

  step = require('step');

  utils = require('../utils');

  module.exports = function(req, res) {
    var readProtection, result, _path;
    _path = req.query.path;
    result = {};
    readProtection = utils.readProtection(req, res, _path);
    return utils.updatePath(req, res, _path, function(_path) {
      var sendResult;
      sendResult = function(err) {
        if (err) {
          utils.forbiddenToResult(result, err, res);
          return res.send(result);
        } else {
          try {
            return path.exists(_path, function(exist) {
              result['exists'] = exist;
              return res.send(result);
            });
          } catch (err) {
            utils.errorToResult(result, err, res);
            return res.send(result);
          }
        }
      };
      return step(readProtection, sendResult);
    });
  };

}).call(this);
