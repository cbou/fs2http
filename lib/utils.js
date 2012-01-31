(function() {
  var fs, path, util, utils;

  util = require('util');

  fs = require('fs');

  path = require('path');

  utils = {};

  utils.errorToResult = function(result, err, res) {
    if (!util.isArray(result['error'])) result['error'] = [];
    if (res) res.status(500);
    return result['error'].push(err);
  };

  utils.findValidGid = function() {
    var currentGid, currentUid, num, r, _path;
    _path = '/tmp/fs2http/findValidGid';
    if (path.existsSync(_path)) fs.rmdirSync(_path);
    fs.mkdirSync(_path);
    currentGid = fs.statSync(_path)['gid'];
    currentUid = fs.statSync(_path)['uid'];
    for (num = 1; num <= 3000; num++) {
      try {
        r = fs.chownSync(_path, currentUid, num);
        return num;
      } catch (err) {

      }
    }
    return currentGid;
  };

  module.exports = utils;

}).call(this);
