(function() {
  var path, utils;

  path = require('path');

  utils = require('../utils');

  module.exports = function(req, res) {
    var result, _path;
    _path = req.query.path;
    result = {};
    try {
      return path.exists(_path, function(exist) {
        result['exists'] = exist;
        return res.send(result);
      });
    } catch (err) {
      utils.errorToResult(result, err, res);
      return res.send(result);
    }
  };

}).call(this);
