APIeasy = require("api-easy")
assert = require("assert")
suite = APIeasy.describe("fs2http: Recursive routes")
fs = require('fs')
wrench = require('wrench')
path = require 'path'
u = require 'underscore'

utils = require './utils'
app = require './server'

try
  config = require './config.private'
catch error
  config = require './config.public'

testName = 'recursive'

newGid = utils.findValidGid()
tmpFixturesPath = config.prefixPath + config.paths[testName]

utils.prepareTest testName

# copy fixtures
wrench.copyDirSyncRecursive __dirname + '/fixtures/' + testName, config.prefixPath + '/' + testName

fs.mkdirSync tmpFixturesPath + '/rmRec/empty'
fs.symlinkSync tmpFixturesPath + '/rmRec/dir', tmpFixturesPath + '/rmRec/linkdir'
fs.mkdirSync tmpFixturesPath + '/chmodRec/empty'
fs.mkdirSync tmpFixturesPath + '/chownRec/empty'
fs.mkdirSync tmpFixturesPath + '/copyRec/empty'

suite
  .discuss('When trying fs2http node routes')
  .use('localhost', 3000)
  .setHeader('Content-Type', 'application/json')

  .del '/fs2http/rmRec',
    path : tmpFixturesPath + '/rmRec/empty'
  .expect 'rmRec route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0
    path.exists tmpFixturesPath + '/rmRec/empty', (exists) ->
      assert.isFalse exists

  .discuss('with non empty directory')
  .del '/fs2http/rmRec',
    path : tmpFixturesPath + '/rmRec/nonempty'
  .expect 'rmRec route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0

    path.exists tmpFixturesPath + '/rmRec/nonempty', (exists) ->
      assert.isFalse exists

    path.exists tmpFixturesPath + '/rmRec', (exists) ->
      assert.isTrue exists
  .undiscuss()

  .discuss('with link')
  .del '/fs2http/rmRec',
    path : tmpFixturesPath + '/rmRec/linkdir'
  .expect 'rmRec route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0
    path.exists tmpFixturesPath + '/rmRec/linkdir', (exists) ->
      assert.isFalse exists
  .undiscuss()

  .discuss('with non existing directory')
  .del '/fs2http/rmRec',
    path : tmpFixturesPath + '/rmRec/nonexisting'
  .expect 'rmRec route', 500, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
  .undiscuss()

  .discuss('with a file and not a directory')
  .del '/fs2http/rmRec',
    path : tmpFixturesPath + '/rmRec/onlyfile'
  .expect 'rmRec route', 200, (err, res, body) ->
    body = JSON.parse body
    path.exists tmpFixturesPath + '/rmRec/onlyfile', (exists) ->
      assert.isFalse exists
  .undiscuss()
 
  .post '/fs2http/chownRec',
    path : tmpFixturesPath + '/chownRec/empty'
    uid : fs.statSync(tmpFixturesPath + '/chownRec')['uid']
    gid : newGid
  .expect 'chownRec route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0
    fs.stat tmpFixturesPath + '/chownRec/empty', (err, stats) ->
      assert.equal stats['gid'], newGid

  .discuss('with non empty directory')
  .post '/fs2http/chownRec',
    path : tmpFixturesPath + '/chownRec/nonempty'
    uid : fs.statSync(tmpFixturesPath + '/chownRec/nonempty')['uid']
    gid : newGid
  .expect 'chownRec route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0
    fs.stat tmpFixturesPath + '/chownRec/nonempty/', (err, stats) ->
      assert.equal stats['gid'], newGid
    fs.stat tmpFixturesPath + '/chownRec/nonempty/dir', (err, stats) ->
      assert.equal stats['gid'], newGid
    fs.stat tmpFixturesPath + '/chownRec/nonempty/dir/file1', (err, stats) ->
      assert.equal stats['gid'], newGid
    fs.stat tmpFixturesPath + '/chownRec/nonempty/file', (err, stats) ->
      assert.equal stats['gid'], newGid
    fs.stat tmpFixturesPath + '/chownRec', (err, stats) ->
      assert.notEqual stats['gid'], newGid
  .undiscuss()


  .discuss('with non existing directory')
  .post '/fs2http/chownRec',
    path : tmpFixturesPath + '/chownRec/nonexisting'
    uid : 1000
    gid : 1000
  .expect 'chownRec route', 500, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
  .undiscuss()

  .discuss('with a file and not a directory')
  .post '/fs2http/chownRec',
    path : tmpFixturesPath + '/chownRec/onlyfile'
    uid : fs.statSync(tmpFixturesPath + '/chownRec/onlyfile')['uid']
    gid : newGid
  .expect 'chownRec route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0
    fs.stat tmpFixturesPath + '/chownRec/onlyfile', (err, stats) ->
      assert.equal stats['gid'], newGid
  .undiscuss()

  .post '/fs2http/chmodRec',
    path : tmpFixturesPath + '/chmodRec/empty'
    mode : '0777'
  .expect 'chmodRec route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0
    fs.stat tmpFixturesPath + '/chmodRec/empty', (err, stats) ->
      assert.equal stats['mode'], 16895

  .discuss('with non existing directory')
  .post '/fs2http/chmodRec',
    path : tmpFixturesPath + '/chmodRec/nonempty'
    mode : '0777'
  .expect 'chmodRec route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0
    fs.stat tmpFixturesPath + '/chmodRec/nonempty', (err, stats) ->
      assert.equal stats['mode'], 16895
    fs.stat tmpFixturesPath + '/chmodRec/nonempty/dir', (err, stats) ->
      assert.equal stats['mode'], 16895
    fs.stat tmpFixturesPath + '/chmodRec/nonempty/dir/file1', (err, stats) ->
      assert.equal stats['mode'], 16895
    fs.stat tmpFixturesPath + '/chmodRec/nonempty/file', (err, stats) ->
      assert.equal stats['mode'], 16895
    fs.stat tmpFixturesPath + '/chmodRec', (err, stats) ->
      assert.notEqual stats['mode'], 16895
  .undiscuss()

  .discuss('with non existing directory')
  .post '/fs2http/chmodRec',
    path : tmpFixturesPath + '/chmodRec/nonexisting'
    mode : '0777'
  .expect 'chmodRec route', 500, (err, res, body) ->
    body = JSON.parse body
  .undiscuss()
  
  .discuss('with a file and not a directory')
  .post '/fs2http/chmodRec',
    path : tmpFixturesPath + '/chmodRec/onlyfile'
    mode : '0777'
  .expect 'chmodRec route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0

    assert.equal fs.statSync(tmpFixturesPath + '/chmodRec/onlyfile')['mode'], 33279
  .undiscuss()

  .discuss('with empty directory')
  .post '/fs2http/copyRec',
    path : tmpFixturesPath + '/copyRec/empty'
    newpath : tmpFixturesPath + '/copyRec/empty2'
  .expect 'copyRec route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.isTrue path.existsSync tmpFixturesPath + '/copyRec/empty'
    assert.isTrue path.existsSync tmpFixturesPath + '/copyRec/empty2'
  .undiscuss()
  
  .discuss('with non empty directory')
  .post '/fs2http/copyRec',
    path : tmpFixturesPath + '/copyRec/nonempty'
    newpath : tmpFixturesPath + '/copyRec/nonempty2'
  .expect 'copyRec route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.isTrue path.existsSync tmpFixturesPath + '/copyRec/nonempty'
    assert.isTrue path.existsSync tmpFixturesPath + '/copyRec/nonempty/dir'
    assert.isTrue path.existsSync tmpFixturesPath + '/copyRec/nonempty/dir/file1'
    assert.isTrue path.existsSync tmpFixturesPath + '/copyRec/nonempty2'
    assert.isTrue path.existsSync tmpFixturesPath + '/copyRec/nonempty2/dir'
    assert.isTrue path.existsSync tmpFixturesPath + '/copyRec/nonempty2/dir/file1'

    assert.equal fs.readFileSync(tmpFixturesPath + '/copyRec/nonempty/dir/file1', 'utf-8'), 'file'
    assert.equal fs.readFileSync(tmpFixturesPath + '/copyRec/nonempty2/dir/file1', 'utf-8'), 'file'
  .undiscuss()

  .discuss('with file')
  .post '/fs2http/copyRec',
    path : tmpFixturesPath + '/copyRec/file'
    newpath : tmpFixturesPath + '/copyRec/file2'
  .expect 'copyRec route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.isTrue path.existsSync tmpFixturesPath + '/copyRec/file'
    assert.isTrue path.existsSync tmpFixturesPath + '/copyRec/file2'
    assert.equal fs.readFileSync(tmpFixturesPath + '/copyRec/file'), 'new content'
    assert.equal fs.readFileSync(tmpFixturesPath + '/copyRec/file2'), 'new content'
  .undiscuss()

  .export module