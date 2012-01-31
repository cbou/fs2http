(function() {
  var util, utils;

  util = require('util');

  utils = {};

  utils.errorToResult = function(result, err, res) {
    if (!util.isArray(result['error'])) result['error'] = [];
    if (res) res.status(500);
    return result['error'].push(err);
  };

  module.exports = utils;

}).call(this);
