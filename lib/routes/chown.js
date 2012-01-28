(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../utils');

  module.exports = function(req, res) {
    var gid, path, result, uid;
    path = req.body.path;
    uid = req.body.uid;
    gid = req.body.gid;
    result = {
      error: [],
      success: true
    };
    return fs.chown(path, uid, gid, function(err) {
      if (err) utils.errorToResult(result, err);
      return res.send(result);
    });
  };

}).call(this);
