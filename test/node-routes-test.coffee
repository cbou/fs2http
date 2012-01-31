APIeasy = require("api-easy")
assert = require("assert")
suite = APIeasy.describe("fs2http: Node routes")
fs = require('fs')
wrench = require('wrench')
path = require 'path'
require './server'

if path.existsSync '/tmp/fs2http'
  wrench.rmdirSyncRecursive '/tmp/fs2http'
fs.mkdirSync '/tmp/fs2http'

fs.mkdirSync '/tmp/fs2http/stat'
fs.mkdirSync '/tmp/fs2http/chmod'
fs.mkdirSync '/tmp/fs2http/chown'

fs.mkdirSync '/tmp/fs2http/readFile'
fs.writeFileSync '/tmp/fs2http/readFile/empty', ''
fs.writeFileSync '/tmp/fs2http/readFile/file', 'file'

fs.mkdirSync '/tmp/fs2http/readdir'
fs.writeFileSync '/tmp/fs2http/readdir/empty', ''
fs.writeFileSync '/tmp/fs2http/readdir/file', 'file'

fs.mkdirSync '/tmp/fs2http/rename'
fs.writeFileSync '/tmp/fs2http/rename/file', 'file'

fs.mkdirSync '/tmp/fs2http/rmdir'
fs.mkdirSync '/tmp/fs2http/rmdir/empty'
fs.mkdirSync '/tmp/fs2http/rmdir/nonempty'
fs.mkdirSync '/tmp/fs2http/rmdir/nonempty/dir'
fs.writeFileSync '/tmp/fs2http/rmdir/nonempty/file', 'file'

fs.mkdirSync '/tmp/fs2http/utimes'
fs.mkdirSync '/tmp/fs2http/writeFile'


suite.discuss("When trying fs2http node routes")
  .use("localhost", 3000)
  .setHeader("Content-Type", "application/json")

  .post '/fs2http/chmod',
    path : '/tmp/fs2http/chmod'
    mode : '0777'
  .expect('chmod route', 200, (err, res, body) ->
    assert.equal body, '{}'
    fs.stat '/tmp/fs2http/chmod', (err, stats) ->
      assert.equal stats['mode'], 16895
  )

  .post '/fs2http/chown',
    path : '/tmp/fs2http/chown'
    uid : fs.statSync('/tmp/fs2http/chown')['uid']
    gid : 1000
  .expect('chown route', 200, (err, res, body) ->
    assert.equal body, '{}'
    fs.stat '/tmp/fs2http/chown', (err, stats) ->
      assert.equal stats['gid'], 1000
  )

  .post '/fs2http/mkdir',
    path : '/tmp/fs2http/mkdir'
  .expect('mkdir route', 200, (err, res, body) ->
    assert.equal body, '{}'
    path.exists '/tmp/fs2http/mkdir', (exists) ->
      assert.ok exists
  )

  .discuss('with empty file')
  .get '/fs2http/readFile',
    path : '/tmp/fs2http/readFile/empty'
    encoding : 'utf-8'
  .expect('readFile route, with empty file', 200, (err, res, body) ->
    assert.isEmpty JSON.parse(body)['data']
  )
  .undiscuss()

  .get '/fs2http/readFile',
    path : '/tmp/fs2http/readFile/file'
    encoding : 'utf-8'
  .expect('readFile route, with non-empty file', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['data'], 'file'
  )

  .get '/fs2http/readdir',
    path : '/tmp/fs2http/readdir'
  .expect('readdir route, with non-empty file', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['files'].length, 2
    assert.include JSON.parse(body)['files'], 'empty'
    assert.include JSON.parse(body)['files'], 'file'
  )

  .discuss('with non empty directory')
  .post '/fs2http/rename',
    path1 : '/tmp/fs2http/rename/file'
    path2 : '/tmp/fs2http/rename/file2'
  .expect('rename route', 200, (err, res, body) ->
    assert.equal body, '{}'
    path.exists '/tmp/fs2http/rename/file', (exists) ->
      assert.isFalse exists

    path.exists '/tmp/fs2http/rename/file2', (exists) ->
      assert.isTrue exists
  )
  .undiscuss()

  .post '/fs2http/rename',
    path1 : '/tmp/fs2http/rename/file'
    path2 : '/dev/null'
  .expect('rename route, with non existing file', 500, (err, res, body) ->
    assert.equal JSON.parse(body)['error'].length, 1
  )

  .del '/fs2http/rmdir',
    path : '/tmp/fs2http/rmdir/empty'
  .expect('rmdir route', 200, (err, res, body) ->
    assert.equal body, '{}'
    path.exists '/tmp/fs2http/rmdir/empty', (exists) ->
      assert.isFalse exists
  )

  .discuss('with non empty directory')
  .del '/fs2http/rmdir',
    path : '/tmp/fs2http/rmdir/nonempty'
  .expect('rmdir route', 500, (err, res, body) ->
    assert.equal JSON.parse(body)['error'].length, 1

    path.exists '/tmp/fs2http/rmdir/nonempty', (exists) ->
      assert.isTrue exists
  )
  .undiscuss()

  .discuss('with non existing directory')
  .del '/fs2http/rmdir',
    path : '/tmp/fs2http/rmdir/nonexisting'
  .expect('rmdir route', 500, (err, res, body) ->
    assert.equal JSON.parse(body)['error'].length, 1
  )
  .undiscuss()

  .get '/fs2http/stat',
    path : '/tmp/fs2http/stat'
  .expect('stat route', 200, (err, res, body) ->
    assert.ok JSON.parse(body)['stats']
  )

  .post '/fs2http/utimes',
    path : '/tmp/fs2http/utimes'
    atime : 104321
    mtime : 654231
  .expect('utimes route', 200, (err, res, body) ->
    assert.equal body, '{}'
    fs.stat '/tmp/fs2http/utimes', (err, stats) ->
      assert.equal stats['atime'].getTime() / 1000, 104321
      assert.equal stats['mtime'].getTime() / 1000, 654231
  )

  .discuss('with empty data')
  .post '/fs2http/writeFile',
    path : '/tmp/fs2http/writeFile/file'
    data : 'file'
  .expect('writeFile route, with data', 200, (err, res, body) ->
    assert.equal body, '{}'
    fs.readFile '/tmp/fs2http/writeFile/file', 'utf-8', (err, data) ->
      assert.equal data, 'file'
  )
  .undiscuss()

  .post '/fs2http/writeFile',
    path : '/tmp/fs2http/writeFile/empty'
    data : ''
  .expect('writeFile route, empty data', 200, (err, res, body) ->
    fs.readFile '/tmp/fs2http/writeFile/empty', 'utf-8', (err, data) ->
      assert.isEmpty data
  )

suite.export module