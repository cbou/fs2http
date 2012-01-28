APIeasy = require("api-easy")
assert = require("assert")
suite = APIeasy.describe("your/awesome/api")
fs = require('fs')
wrench = require('wrench')
path = require 'path'

wrench.rmdirSyncRecursive '/tmp/fs2http'
fs.mkdirSync '/tmp/fs2http'

fs.mkdirSync '/tmp/fs2http/stat'
fs.mkdirSync '/tmp/fs2http/chmod'
fs.mkdirSync '/tmp/fs2http/chown'
fs.mkdirSync '/tmp/fs2http/readFile'

fs.writeFileSync '/tmp/fs2http/readFile/empty', ''
fs.writeFileSync '/tmp/fs2http/readFile/file', 'file'

fs.mkdirSync '/tmp/fs2http/rename'
fs.writeFileSync '/tmp/fs2http/rename/file', ''

fs.mkdirSync '/tmp/fs2http/rmdir'
fs.mkdirSync '/tmp/fs2http/utimes'
fs.mkdirSync '/tmp/fs2http/writeFile'

suite.discuss("When trying fs2http node routes")
  .use("localhost", 3000)
  .setHeader("Content-Type", "application/json")

  .post '/fs2http/chmod',
    path : '/tmp/fs2http/chmod'
    mode : '0777'
  .expect('chmod route', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['success'], true
    assert.equal JSON.parse(body)['error'].length, 0

    fs.stat '/tmp/fs2http/chmod', (err, stats) ->
      assert.equal stats['mode'], 16895
  )

  .post '/fs2http/chown',
    path : '/tmp/fs2http/chown'
    uid : fs.statSync('/tmp/fs2http/chown')['uid']
    gid : 1000
  .expect('chown route', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['success'], true
    assert.equal JSON.parse(body)['error'].length, 0

    fs.stat '/tmp/fs2http/chown', (err, stats) ->
      assert.equal stats['gid'], 1000
  )

  .post '/fs2http/mkdir',
    path : '/tmp/fs2http/mkdir'
  .expect('mkdir route', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['success'], true
    assert.equal JSON.parse(body)['error'].length, 0
    
    path.exists '/tmp/fs2http/mkdir', (exists) ->
      assert.ok exists
  )

  .get '/fs2http/readFile',
    filename : '/tmp/fs2http/readFile/empty'
    encoding : 'utf-8'
  .expect('readFile route, with empty file', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['success'], true
    assert.equal JSON.parse(body)['error'].length, 0
    assert.equal JSON.parse(body)['data'], ''
  )

  .get '/fs2http/readFile',
    filename : '/tmp/fs2http/readFile/file'
    encoding : 'utf-8'
  .expect('readFile route, with non-empty file', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['success'], true
    assert.equal JSON.parse(body)['error'].length, 0
    assert.equal JSON.parse(body)['data'], 'file'
  )

  .post '/fs2http/rename',
    path1 : '/tmp/fs2http/rename/file'
    path2 : '/tmp/fs2http/rename/file2'
  .expect('rename route', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['success'], true
    assert.equal JSON.parse(body)['error'].length, 0

    path.exists '/tmp/fs2http/rename/file1', (exists) ->
      assert.ok !exists

    path.exists '/tmp/fs2http/rename/file2', (exists) ->
      assert.ok exists
  )

  .post '/fs2http/rename',
    path1 : '/tmp/fs2http/rename/file'
    path2 : '/dev/null'
  .expect('rename route, with non existing file', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['success'], false
    assert.equal JSON.parse(body)['error'].length, 1
  )

  .del '/fs2http/rmdir',
    path : '/tmp/fs2http/rmdir'
  .expect('rmdir route', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['success'], true
    assert.equal JSON.parse(body)['error'].length, 0

    path.exists '/tmp/fs2http/rmdir', (exists) ->
      assert.ok !exists
  )

  .del '/fs2http/rmdir',
    path : '/tmp/fs2http/nonexisting'
  .expect('rmdir route', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['success'], false
    assert.equal JSON.parse(body)['error'].length, 1
  )

  .get '/fs2http/stat',
    path : '/tmp/fs2http/stat'
  .expect('stat route', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['success'], true
    assert.equal JSON.parse(body)['error'].length, 0
    assert.ok JSON.parse(body)['stats']
  )

  .post '/fs2http/utimes',
    path : '/tmp/fs2http/utimes'
    atime : 104321
    mtime : 654231
  .expect('utimes route', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['success'], true
    assert.equal JSON.parse(body)['error'].length, 0

    fs.stat '/tmp/fs2http/utimes', (err, stats) ->
      assert.equal stats['atime'].getTime() / 1000, 104321
      assert.equal stats['mtime'].getTime() / 1000, 654231
  )

  .post '/fs2http/writeFile',
    filename : '/tmp/fs2http/writeFile/file'
    data : 'file'
  .expect('writeFile route, with data', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['success'], true
    assert.equal JSON.parse(body)['error'].length, 0

    fs.readFile '/tmp/fs2http/writeFile/file', 'utf-8', (err, data) ->
      assert.equal data, 'file'
  )

  .post '/fs2http/writeFile',
    filename : '/tmp/fs2http/writeFile/empty'
    data : ''
  .expect('writeFile route, empty data', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['success'], true
    assert.equal JSON.parse(body)['error'].length, 0

    fs.readFile '/tmp/fs2http/writeFile/empty', 'utf-8', (err, data) ->
      assert.equal data, ''
  )


process.nextTick ->
  suite.export module