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

  fs.mkdirSync(prefixPath + '/rmRec');

  fs.mkdirSync(prefixPath + '/rmRec/empty');

  fs.mkdirSync(prefixPath + '/rmRec/nonempty');

  fs.mkdirSync(prefixPath + '/rmRec/nonempty/dir');

  fs.writeFileSync(prefixPath + '/rmRec/nonempty/file', 'file');

  fs.writeFileSync(prefixPath + '/rmRec/onlyfile', 'onlyfile');

  fs.mkdirSync(prefixPath + '/rmRec/dir');

  fs.symlinkSync(prefixPath + '/rmRec/dir', prefixPath + '/rmRec/linkdir');

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

  fs.mkdirSync(prefixPath + '/copyRec');

  fs.mkdirSync(prefixPath + '/copyRec/empty');

  fs.mkdirSync(prefixPath + '/copyRec/nonempty');

  fs.mkdirSync(prefixPath + '/copyRec/nonempty/dir');

  fs.writeFileSync(prefixPath + '/copyRec/nonempty/dir/file1', 'file');

  fs.writeFileSync(prefixPath + '/copyRec/file', 'new content');

  suite.discuss("When trying fs2http recursive routes").use("localhost", 3000).setHeader("Content-Type", "application/json").del('/fs2http/rmRec', {
    path: prefixPath + '/rmRec/empty'
  }).expect('rmRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    return path.exists(prefixPath + '/rmRec/empty', function(exists) {
      return assert.isFalse(exists);
    });
  }).discuss('with non empty directory').del('/fs2http/rmRec', {
    path: prefixPath + '/rmRec/nonempty'
  }).expect('rmRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    path.exists(prefixPath + '/rmRec/nonempty', function(exists) {
      return assert.isFalse(exists);
    });
    return path.exists(prefixPath + '/rmRec', function(exists) {
      return assert.isTrue(exists);
    });
  }).undiscuss().discuss('with link').del('/fs2http/rmRec', {
    path: prefixPath + '/rmRec/linkdir'
  }).expect('rmRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    return path.exists(prefixPath + '/rmRec/linkdir', function(exists) {
      return assert.isFalse(exists);
    });
  }).undiscuss().discuss('with non existing directory').del('/fs2http/rmRec', {
    path: prefixPath + '/rmRec/nonexisting'
  }).expect('rmRec route', 500, function(err, res, body) {
    return assert.equal(JSON.parse(body)['error'].length, 1);
  }).undiscuss().discuss('with a file and not a directory').del('/fs2http/rmRec', {
    path: prefixPath + '/rmRec/onlyfile'
  }).expect('rmRec route', 200, function(err, res, body) {
    return path.exists(prefixPath + '/rmRec/onlyfile', function(exists) {
      return assert.isFalse(exists);
    });
  }).undiscuss().post('/fs2http/chownRec', {
    path: prefixPath + '/chownRec/empty',
    uid: fs.statSync(prefixPath + '/chownRec')['uid'],
    gid: newGid
  }).expect('chownRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    return fs.stat(prefixPath + '/chownRec/empty', function(err, stats) {
      return assert.equal(stats['gid'], newGid);
    });
  }).discuss('with non empty directory').post('/fs2http/chownRec', {
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
  }).undiscuss().discuss('with non existing directory').post('/fs2http/chownRec', {
    path: prefixPath + '/chownRec/nonexisting',
    uid: 1000,
    gid: 1000
  }).expect('chownRec route', 500, function(err, res, body) {
    return assert.equal(JSON.parse(body)['error'].length, 1);
  }).undiscuss().discuss('with a file and not a directory').post('/fs2http/chownRec', {
    path: prefixPath + '/chownRec/onlyfile',
    uid: fs.statSync(prefixPath + '/chownRec/onlyfile')['uid'],
    gid: newGid
  }).expect('chownRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    return fs.stat(prefixPath + '/chownRec/onlyfile', function(err, stats) {
      return assert.equal(stats['gid'], newGid);
    });
  }).undiscuss().post('/fs2http/chmodRec', {
    path: prefixPath + '/chmodRec/empty',
    mode: '0777'
  }).expect('chmodRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    return fs.stat(prefixPath + '/chmodRec/empty', function(err, stats) {
      return assert.equal(stats['mode'], 16895);
    });
  }).discuss('with non existing directory').post('/fs2http/chmodRec', {
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
  }).undiscuss().discuss('with non existing directory').post('/fs2http/chmodRec', {
    path: prefixPath + '/chmodRec/nonexisting',
    mode: '0777'
  }).expect('chmodRec route', 500, function(err, res, body) {}).undiscuss().discuss('with a file and not a directory').post('/fs2http/chmodRec', {
    path: prefixPath + '/chmodRec/onlyfile',
    mode: '0777'
  }).expect('chmodRec route', 200, function(err, res, body) {
    assert.equal(body, '{}');
    return assert.equal(fs.statSync(prefixPath + '/chmodRec/onlyfile')['mode'], 33279);
  }).undiscuss().discuss('with empty directory').post('/fs2http/copyRec', {
    path: prefixPath + '/copyRec/empty',
    newpath: prefixPath + '/copyRec/empty2'
  }).expect('copyRec route', 200, function(err, res, body) {
    assert.isTrue(path.existsSync(prefixPath + '/copyRec/empty'));
    return assert.isTrue(path.existsSync(prefixPath + '/copyRec/empty2'));
  }).undiscuss().discuss('with non empty directory').post('/fs2http/copyRec', {
    path: prefixPath + '/copyRec/nonempty',
    newpath: prefixPath + '/copyRec/nonempty2'
  }).expect('copyRec route', 200, function(err, res, body) {
    assert.isTrue(path.existsSync(prefixPath + '/copyRec/nonempty'));
    assert.isTrue(path.existsSync(prefixPath + '/copyRec/nonempty/dir'));
    assert.isTrue(path.existsSync(prefixPath + '/copyRec/nonempty/dir/file1'));
    assert.isTrue(path.existsSync(prefixPath + '/copyRec/nonempty2'));
    assert.isTrue(path.existsSync(prefixPath + '/copyRec/nonempty2/dir'));
    assert.isTrue(path.existsSync(prefixPath + '/copyRec/nonempty2/dir/file1'));
    assert.equal(fs.readFileSync(prefixPath + '/copyRec/nonempty/dir/file1', 'utf-8'), 'file');
    return assert.equal(fs.readFileSync(prefixPath + '/copyRec/nonempty2/dir/file1', 'utf-8'), 'file');
  }).undiscuss().discuss('with file').post('/fs2http/copyRec', {
    path: prefixPath + '/copyRec/file',
    newpath: prefixPath + '/copyRec/file2'
  }).expect('copyRec route', 200, function(err, res, body) {
    assert.isTrue(path.existsSync(prefixPath + '/copyRec/file'));
    assert.isTrue(path.existsSync(prefixPath + '/copyRec/file2'));
    assert.equal(fs.readFileSync(prefixPath + '/copyRec/file'), 'new content');
    return assert.equal(fs.readFileSync(prefixPath + '/copyRec/file2'), 'new content');
  }).undiscuss();

  suite["export"](module);

}).call(this);
