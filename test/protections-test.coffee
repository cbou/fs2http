APIeasy = require("api-easy")
assert = require("assert")
suite = APIeasy.describe("fs2http: Node routes")
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

testName = 'protection'

newGid = utils.findValidGid()
tmpFixturesPath = config.prefixPath + config.paths[testName]

utils.prepareTest testName

# copy fixtures
wrench.copyDirSyncRecursive __dirname + '/fixtures/' + testName, config.prefixPath + '/' + testName

fs.symlinkSync tmpFixturesPath + '/read-protected/readlink/dir', tmpFixturesPath + '/read-protected/readlink/linkdir'

suite
  .discuss('When trying fs2http node routes')
  .use('localhost', 3000)
  .setHeader('Content-Type', 'application/json')

  .put '/fs2http/customChmodUrl',
    path : tmpFixturesPath + '/write-protected'
    mode : '0777'
  .expect 'chmod route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'

  .post '/fs2http/chown',
    path : tmpFixturesPath + '/write-protected'
    uid : fs.statSync(tmpFixturesPath)['uid']
    gid : newGid
  .expect 'chown route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'

  .post '/fs2http/mkdir',
    path : tmpFixturesPath + '/write-protected'
  .expect 'mkdir route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'

  .get '/fs2http/readFile',
    path : tmpFixturesPath + '/read-protected/file'
    encoding : 'utf-8'
  .expect 'readFile route, with non-empty file', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path read protected'

  .get '/fs2http/readdir',
    path : tmpFixturesPath + '/read-protected'
  .expect 'readdir route, with non-empty file', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path read protected'

  .discuss('with non empty directory')
  .post '/fs2http/rename',
    path1 : tmpFixturesPath + '/write-protected/rename/file'
    path2 : tmpFixturesPath + '/write-protected/file'
  .expect 'rename route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  .undiscuss()

  .del '/fs2http/rmdir',
    path : tmpFixturesPath + '/write-protected'
  .expect 'rmdir route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'

  .get '/fs2http/stat',
    path : tmpFixturesPath + '/read-protected'
  .expect 'stat route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path read protected'

  .post '/fs2http/utimes',
    path : tmpFixturesPath + '/write-protected'
    atime : 104321
    mtime : 654231
  .expect 'utimes route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'

  .discuss('with empty data')
  .post '/fs2http/writeFile',
    path : tmpFixturesPath + '/write-protected/file'
    data : 'file'
  .expect 'writeFile route, with data', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  .undiscuss()

  .discuss('link a file')
  .post '/fs2http/symlink',
    path : tmpFixturesPath + '/write-protected/symlink/file'
    link : tmpFixturesPath + '/write-protected/linkfile'
  .expect 'link route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  .undiscuss()

  .discuss('unlink a file')
  .del '/fs2http/unlink',
    path : tmpFixturesPath + '/write-protected/unlink/file'
  .expect 'unlink route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  .undiscuss()

  .discuss('readlink a dir link')
  .get '/fs2http/readlink',
    path : tmpFixturesPath + '/read-protected/readlink/linkdir'
  .expect 'readlink route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path read protected'
  .undiscuss()

  .discuss('exists a file')
  .get '/fs2http/exists',
    path : tmpFixturesPath + '/read-protected/exists/file'
  .expect 'exists route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path read protected'
  .undiscuss()

  .post '/fs2http/chmodRec',
    path : tmpFixturesPath + '/write-protected'
    mode : '0777'
  .expect 'chmod route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  
  .post '/fs2http/chownRec',
    path : tmpFixturesPath + '/write-protected'
    uid : fs.statSync(tmpFixturesPath)['uid']
    gid : newGid
  .expect 'chown route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'

  .del '/fs2http/rmRec',
    path : tmpFixturesPath + '/write-protected'
  .expect 'chmod route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'

  .discuss('copy recursively with 2 protected dir')
  suite.post '/fs2http/copyRec',
    path : tmpFixturesPath + '/read-protected'
    newpath : tmpFixturesPath + '/write-protected'
  .expect 'chown route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  .undiscuss()

  .discuss('copy recursively with only write protected dir')
  .post '/fs2http/copyRec',
    path : tmpFixturesPath + '/read-allowed'
    newpath : tmpFixturesPath + '/write-protected'
  .expect 'chown route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  .undiscuss()

  suite.discuss('copy recursively with only read protected dir')
  suite.post '/fs2http/copyRec',
    path : tmpFixturesPath + '/read-protected'
    newpath : tmpFixturesPath + '/write-allowed'
  .expect 'chown route', 403, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path read protected'
  .undiscuss()

  .export module