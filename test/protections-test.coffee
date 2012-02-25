APIeasy = require("api-easy")
assert = require("assert")
suite = APIeasy.describe("fs2http: Node routes")
fs = require('fs')
wrench = require('wrench')
path = require 'path'
utils = require '../lib/utils'
app = require './server'
u = require 'underscore'

newGid = utils.findValidGid()
prefixPath = '/tmp/fs2http/protection';

if !path.existsSync '/tmp/fs2http'
  fs.mkdirSync '/tmp/fs2http'

if path.existsSync prefixPath
  wrench.rmdirSyncRecursive prefixPath
fs.mkdirSync prefixPath

fs.mkdirSync prefixPath + '/write-protected'
fs.mkdirSync prefixPath + '/read-protected'
fs.mkdirSync prefixPath + '/write-allowed'
fs.mkdirSync prefixPath + '/read-allowed'

fs.writeFileSync prefixPath + '/write-protected/file', 'file'

fs.mkdirSync prefixPath + '/write-protected/rename'
fs.writeFileSync prefixPath + '/write-protected/rename/file', 'file'

fs.mkdirSync prefixPath + '/write-protected/symlink'
fs.mkdirSync prefixPath + '/write-protected/symlink/file'

fs.mkdirSync prefixPath + '/write-protected/unlink'
fs.writeFileSync prefixPath + '/write-protected/unlink/file', 'file'

fs.mkdirSync prefixPath + '/read-protected/readFile'
fs.writeFileSync prefixPath + '/read-protected/readFile/file', 'file'

fs.mkdirSync prefixPath + '/read-protected/readlink'
fs.mkdirSync prefixPath + '/read-protected/readlink/dir'
fs.symlinkSync prefixPath + '/read-protected/readlink/dir', prefixPath + '/read-protected/readlink/linkdir'

fs.mkdirSync prefixPath + '/read-protected/exists'
fs.writeFileSync prefixPath + '/read-protected/exists/file', 'file'

suite.discuss("When trying fs2http node routes")
  .use("localhost", 3000)
  .setHeader("Content-Type", "application/json")

  suite.post '/fs2http/chmod',
    path : prefixPath + '/write-protected'
    mode : '0777'
  .expect('chmod route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )

  suite.post '/fs2http/chown',
    path : prefixPath + '/write-protected'
    uid : fs.statSync(prefixPath)['uid']
    gid : newGid
  .expect('chown route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )

  suite.post '/fs2http/mkdir',
    path : prefixPath + '/write-protected'
  .expect('mkdir route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )

  suite.get '/fs2http/readFile',
    path : prefixPath + '/read-protected/file'
    encoding : 'utf-8'
  .expect('readFile route, with non-empty file', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path read protected'
  )

  suite.get '/fs2http/readdir',
    path : prefixPath + '/read-protected'
  .expect('readdir route, with non-empty file', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path read protected'
  )

  suite.discuss('with non empty directory')
  .post '/fs2http/rename',
    path1 : prefixPath + '/write-protected/rename/file'
    path2 : prefixPath + '/write-protected/file'
  .expect('rename route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )
  .undiscuss()

  suite.del '/fs2http/rmdir',
    path : prefixPath + '/write-protected'
  .expect('rmdir route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )

  suite.get '/fs2http/stat',
    path : prefixPath + '/read-protected'
  .expect('stat route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path read protected'
  )

  suite.post '/fs2http/utimes',
    path : prefixPath + '/write-protected'
    atime : 104321
    mtime : 654231
  .expect('utimes route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )

  suite.discuss('with empty data')
  .post '/fs2http/writeFile',
    path : prefixPath + '/write-protected/file'
    data : 'file'
  .expect('writeFile route, with data', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )
  .undiscuss()

  suite.discuss('link a file')
  .post '/fs2http/symlink',
    path : prefixPath + '/write-protected/symlink/file'
    link : prefixPath + '/write-protected/linkfile'
  .expect('link route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )
  .undiscuss()

  suite.discuss('unlink a file')
  .del '/fs2http/unlink',
    path : prefixPath + '/write-protected/unlink/file'
  .expect('unlink route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )
  .undiscuss()

  suite.discuss('readlink a dir link')
  .get '/fs2http/readlink',
    path : prefixPath + '/read-protected/readlink/linkdir'
  .expect('readlink route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path read protected'
  )
  .undiscuss()

  suite.discuss('exists a file')
  .get '/fs2http/exists',
    path : prefixPath + '/read-protected/exists/file'
  .expect('exists route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path read protected'
  )
  .undiscuss()

  suite.post '/fs2http/chmodRec',
    path : prefixPath + '/write-protected'
    mode : '0777'
  .expect('chmod route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )
  suite.post '/fs2http/chownRec',
    path : prefixPath + '/write-protected'
    uid : fs.statSync(prefixPath)['uid']
    gid : newGid
  .expect('chown route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )

  suite.del '/fs2http/rmRec',
    path : prefixPath + '/write-protected'
  .expect('chmod route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )

  suite.discuss('copy recursively with 2 protected dir')
  suite.post '/fs2http/copyRec',
    path : prefixPath + '/read-protected'
    newpath : prefixPath + '/write-protected'
  .expect('chown route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )
  .undiscuss()

  suite.discuss('copy recursively with only write protected dir')
  suite.post '/fs2http/copyRec',
    path : prefixPath + '/read-allowed'
    newpath : prefixPath + '/write-protected'
  .expect('chown route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path write protected'
  )
  .undiscuss()

  suite.discuss('copy recursively with only read protected dir')
  suite.post '/fs2http/copyRec',
    path : prefixPath + '/read-protected'
    newpath : prefixPath + '/write-allowed'
  .expect('chown route', 403, (err, res, body) ->
    assert.equal body['error'].length, 1
    assert.equal body['error'][0], 'path read protected'
  )
  .undiscuss()

suite.export module