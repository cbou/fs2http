(function() {
  var async, fs, util;

  fs = require('fs');

  util = require('util');

  async = require('async');

  module.exports = function(req, res) {
    var dir;
    dir = req.query['dir'];
    return fs.readdir(dir, function(err, files) {
      var result;
      if (util.isArray(files)) {
        result = {};
        result['files'] = {};
        result['success'] = true;
        result['errors'] = [];
        async.forEach(files, function(file, callback) {
          return result['files'][file] = fs.statSync(dir + '/' + file, function(err) {
            result['success'] = true;
            return result['errors'] = [err];
          });
        });
        return res.send(result);
      } else {
        return res.send('[]');
      }
    });
  };

}).call(this);
