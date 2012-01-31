(function() {
  var APIeasy, app, assert, fs, newGid, path, prefixPath, suite, utils, wrench;

  APIeasy = require("api-easy");

  assert = require("assert");

  suite = APIeasy.describe("fs2http: Recursive routes");

  fs = require('fs');

  wrench = require('wrench');

  path = require('path');

  utils = require('../lib/utils');

  app = require('./server');

  newGid = utils.findValidGid();

  prefixPath = '/tmp/fs2http/recursive';

  if (!path.existsSync('/tmp/fs2http')) fs.mkdirSync('/tmp/fs2http');

  if (path.existsSync(prefixPath)) wrench.rmdirSyncRecursive(prefixPath);

  fs.mkdirSync(prefixPath);

  fs.mkdirSync(prefixPath + '/rmdirRec');

  fs.mkdirSync(prefixPath + '/rmdirRec/empty');

  fs.mkdirSync(prefixPath + '/rmdirRec/nonempty');

  fs.mkdirSync(prefixPath + '/rmdirRec/nonempty/dir');

  fs.writeFileSync(prefixPath + '/rmdirRec/nonempty/file', 'file');

  fs.writeFileSync(prefixPath + '/rmdirRec/onlyfile', 'onlyfile');

  fs.mkdirSync(prefixPath + '/chmodRec');

  fs.mkdirSync(prefixPath + '/chmodRec/empty');

  fs.mkdirSync(prefixPath + '/chmodRec/nonempty');

  fs.mkdirSync(prefixPath + '/chmodRec/nonempty/dir');

  fs.writeFileSync(prefixPath + '/chmodRec/nonempty/dir/file1', 'file');

  fs.writeFileSync(prefixPath + '/chmodRec/nonempty/file', 'file');

  fs.writeFileSync(prefixPath + '/chmodRec/onlyfile', 'onlyfile');

  fs.mkdirSync(prefixPath + '/chownRec');

  fs.mkdirSync(prefixPath + '/chownRec/empty');

  fs.mkdirSync(prefixPath + '/chownRec/nonempty');

  fs.mkdirSync(prefixPath + '/chownRec/nonempty/dir');

  fs.writeFileSync(prefixPath + '/chownRec/nonempty/dir/file1', 'file');

  fs.writeFileSync(prefixPath + '/chownRec/nonempty/file', 'file');

  fs.writeFileSync(prefixPath + '/chownRec/onlyfile', 'onlyfile');

  suite.discuss("When trying fs2http recursive routes").use("localhost", 3000).setHeader("Content-Type", "application/json");

  suite.del('/fs2http/rmdirRec', {
    path: prefixPath + '/rmdirRec/empty'
  }).expect('rmdirRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    return path.exists(prefixPath + '/rmdirRec/empty', function(exists) {
      return assert.isFalse(exists);
    });
  });

  suite.discuss('with non empty directory').del('/fs2http/rmdirRec', {
    path: prefixPath + '/rmdirRec/nonempty'
  }).expect('rmdirRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    path.exists(prefixPath + '/rmdirRec/nonempty', function(exists) {
      return assert.isFalse(exists);
    });
    return path.exists(prefixPath + '/rmdirRec', function(exists) {
      return assert.isTrue(exists);
    });
  }).undiscuss();

  suite.discuss('with non existing directory').del('/fs2http/rmdirRec', {
    path: prefixPath + '/rmdirRec/nonexisting'
  }).expect('rmdirRec route', 500, function(err, res, body) {}).undiscuss();

  suite.discuss('with a file and not a directory').del('/fs2http/rmdirRec', {
    path: prefixPath + '/rmdirRec/onlyfile'
  }).expect('rmdirRec route', 200, function(err, res, body) {
    return path.exists(prefixPath + '/rmdirRec/onlyfile', function(exists) {
      return assert.isFalse(exists);
    });
  }).undiscuss();

  suite.post('/fs2http/chownRec', {
    path: prefixPath + '/chownRec/empty',
    uid: fs.statSync(prefixPath + '/chownRec')['uid'],
    gid: newGid
  }).expect('chownRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    return fs.stat(prefixPath + '/chownRec/empty', function(err, stats) {
      return assert.equal(stats['gid'], newGid);
    });
  });

  suite.discuss('with non empty directory').post('/fs2http/chownRec', {
    path: prefixPath + '/chownRec/nonempty',
    uid: fs.statSync(prefixPath + '/chownRec/nonempty')['uid'],
    gid: newGid
  }).expect('chownRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    fs.stat(prefixPath + '/chownRec/nonempty/', function(err, stats) {
      return assert.equal(stats['gid'], newGid);
    });
    fs.stat(prefixPath + '/chownRec/nonempty/dir', function(err, stats) {
      return assert.equal(stats['gid'], newGid);
    });
    fs.stat(prefixPath + '/chownRec/nonempty/dir/file1', function(err, stats) {
      return assert.equal(stats['gid'], newGid);
    });
    fs.stat(prefixPath + '/chownRec/nonempty/file', function(err, stats) {
      return assert.equal(stats['gid'], newGid);
    });
    return fs.stat(prefixPath + '/chownRec', function(err, stats) {
      return assert.notEqual(stats['gid'], newGid);
    });
  }).undiscuss();

  suite.discuss('with non existing directory').post('/fs2http/chownRec', {
    path: prefixPath + '/chownRec/nonexisting',
    uid: 1000,
    gid: 1000
  }).expect('chownRec route', 500, function(err, res, body) {}).undiscuss();

  suite.discuss('with a file and not a directory').post('/fs2http/chownRec', {
    path: prefixPath + '/chownRec/onlyfile',
    uid: fs.statSync(prefixPath + '/chownRec/onlyfile')['uid'],
    gid: newGid
  }).expect('chownRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    return fs.stat(prefixPath + '/chownRec/onlyfile', function(err, stats) {
      return assert.equal(stats['gid'], newGid);
    });
  }).undiscuss();

  suite.post('/fs2http/chmodRec', {
    path: prefixPath + '/chmodRec/empty',
    mode: '0777'
  }).expect('chmodRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    return fs.stat(prefixPath + '/chmodRec/empty', function(err, stats) {
      return assert.equal(stats['mode'], 16895);
    });
  });

  suite.discuss('with non existing directory').post('/fs2http/chmodRec', {
    path: prefixPath + '/chmodRec/nonempty',
    mode: '0777'
  }).expect('chmodRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    fs.stat(prefixPath + '/chmodRec/nonempty', function(err, stats) {
      return assert.equal(stats['mode'], 16895);
    });
    fs.stat(prefixPath + '/chmodRec/nonempty/dir', function(err, stats) {
      return assert.equal(stats['mode'], 16895);
    });
    fs.stat(prefixPath + '/chmodRec/nonempty/dir/file1', function(err, stats) {
      return assert.equal(stats['mode'], 16895);
    });
    fs.stat(prefixPath + '/chmodRec/nonempty/file', function(err, stats) {
      return assert.equal(stats['mode'], 16895);
    });
    return fs.stat(prefixPath + '/chmodRec', function(err, stats) {
      return assert.notEqual(stats['mode'], 16895);
    });
  }).undiscuss();

  suite.discuss('with non existing directory').post('/fs2http/chmodRec', {
    path: prefixPath + '/chmodRec/nonexisting',
    mode: '0777'
  }).expect('chmodRec route', 500, function(err, res, body) {}).undiscuss();

  suite.discuss('with a file and not a directory').post('/fs2http/chmodRec', {
    path: prefixPath + '/chmodRec/onlyfile',
    mode: '0777'
  }).expect('chmodRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    return fs.stat(prefixPath + '/chmodRec/onlyfile', function(err, stats) {
      return assert.equal(stats['mode'], 16895);
    });
  }).undiscuss();

  suite["export"](module);

}).call(this);
