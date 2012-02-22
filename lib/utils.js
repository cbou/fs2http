(function() {
  var fs, path, util, utils;

  util = require('util');

  fs = require('fs');

  path = require('path');

  utils = {};

  utils.readProtection = function(req, res, path) {
    var protections;
    protections = req.app.fs2http.protections;
    return function(err) {
      var callback;
      if (err) throw err;
      callback = this;
      protections.read(req, res, path, callback);
      return;
    };
  };

  utils.writeProtection = function(req, res, path) {
    var protections;
    protections = req.app.fs2http.protections;
    return function(err) {
      var callback;
      if (err) throw err;
      callback = this;
      protections.write(req, res, path, callback);
      return;
    };
  };

  utils.forbiddenToResult = function(result, err, res) {
    if (!util.isArray(result['error'])) result['error'] = [];
    if (res) res.status(403);
    return result['error'].push(err);
  };

  utils.errorToResult = function(result, err, res) {
    if (!util.isArray(result['error'])) result['error'] = [];
    if (res) res.status(500);
    return result['error'].push(err);
  };

  utils.findValidGid = function() {
    var currentGid, currentUid, num, r, _path;
    _path = '/tmp/fs2http/findValidGid';
    if (!path.existsSync('/tmp/fs2http')) fs.mkdirSync('/tmp/fs2http');
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

  utils.copyFile = function(path, newpath, callback) {
    var readStream, writeStream;
    readStream = fs.createReadStream(path);
    writeStream = fs.createWriteStream(newpath);
    util.pump(readStream, writeStream, function(err) {
      return callback(err);
    });
    return null;
  };

  module.exports = utils;

}).call(this);
