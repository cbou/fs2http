(function() {
  var fs, utils, wrench;

  fs = require('fs');

  utils = require('../utils');

  wrench = require('wrench');

  module.exports = function(req, res) {
    var gid, path, result, uid;
    path = req.body.path;
    uid = req.body.uid;
    gid = req.body.gid;
    result = {};
    return fs.stat(path, function(err, stats) {
      if (err) utils.errorToResult(result, err, res);
      if (stats && stats.isDirectory()) {
        try {
          wrench.chownSyncRecursive(path, uid, gid);
        } catch (err) {
          utils.errorToResult(result, err, res);
        }
        return res.send(result);
      } else if (stats && stats.isFile()) {
        return fs.chown(path, uid, gid, function(err) {
          if (err) utils.errorToResult(result, err, res);
          return res.send(result);
        });
      } else {
        err = {
          code: 'NOTIMPL',
          message: 'function not implemented yet'
        };
        utils.errorToResult(result, err, res);
        return res.send(result);
      }
    });
  };

}).call(this);
