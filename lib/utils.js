(function() {
  var utils;

  utils = {};

  utils.errorToResult = function(result, err) {
    result['error'].push(err);
    return result['success'] = false;
  };

  module.exports = utils;

}).call(this);
