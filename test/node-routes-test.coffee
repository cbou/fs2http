APIeasy = require("api-easy")
assert = require("assert")
suite = APIeasy.describe("fs2http: Node routes")
fs = require('fs')
wrench = require('wrench')
path = require 'path'
utils = require '../lib/utils'
app = require './server'

newGid = utils.findValidGid()
prefixPath = '/tmp/fs2http/node';

if !path.existsSync '/tmp/fs2http'
  fs.mkdirSync '/tmp/fs2http'

if path.existsSync prefixPath
  wrench.rmdirSyncRecursive prefixPath
fs.mkdirSync prefixPath

fs.mkdirSync prefixPath + '/stat'
fs.mkdirSync prefixPath + '/chmod'
fs.mkdirSync prefixPath + '/chown'

fs.mkdirSync prefixPath + '/readFile'
fs.writeFileSync prefixPath + '/readFile/empty', ''
fs.writeFileSync prefixPath + '/readFile/file', 'file'

fs.mkdirSync prefixPath + '/readdir'
fs.writeFileSync prefixPath + '/readdir/empty', ''
fs.writeFileSync prefixPath + '/readdir/file', 'file'

fs.mkdirSync prefixPath + '/rename'
fs.writeFileSync prefixPath + '/rename/file', 'file'

fs.mkdirSync prefixPath + '/rmdir'
fs.mkdirSync prefixPath + '/rmdir/empty'
fs.mkdirSync prefixPath + '/rmdir/nonempty'
fs.mkdirSync prefixPath + '/rmdir/nonempty/dir'
fs.writeFileSync prefixPath + '/rmdir/nonempty/file', 'file'

fs.mkdirSync prefixPath + '/utimes'
fs.mkdirSync prefixPath + '/writeFile'


suite.discuss("When trying fs2http node routes")
  .use("localhost", 3000)
  .setHeader("Content-Type", "application/json")

  .post '/fs2http/chmod',
    path : prefixPath + '/chmod'
    mode : '0777'
  .expect('chmod route', 200, (err, res, body) ->
    assert.equal body, '{}'
    fs.stat prefixPath + '/chmod', (err, stats) ->
      assert.equal stats['mode'], 16895
  )

  .post '/fs2http/chown',
    path : prefixPath + '/chown'
    uid : fs.statSync(prefixPath + '/chown')['uid']
    gid : newGid
  .expect('chown route', 200, (err, res, body) ->
    assert.equal body, '{}'
    fs.stat prefixPath + '/chown', (err, stats) ->
      assert.equal stats['gid'], newGid
  )

  .post '/fs2http/mkdir',
    path : prefixPath + '/mkdir'
  .expect('mkdir route', 200, (err, res, body) ->
    assert.equal body, '{}'
    path.exists prefixPath + '/mkdir', (exists) ->
      assert.ok exists
  )

  .discuss('with empty file')
  .get '/fs2http/readFile',
    path : prefixPath + '/readFile/empty'
    encoding : 'utf-8'
  .expect('readFile route, with empty file', 200, (err, res, body) ->
    assert.isEmpty JSON.parse(body)['data']
  )
  .undiscuss()

  .get '/fs2http/readFile',
    path : prefixPath + '/readFile/file'
    encoding : 'utf-8'
  .expect('readFile route, with non-empty file', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['data'], 'file'
  )

  .get '/fs2http/readdir',
    path : prefixPath + '/readdir'
  .expect('readdir route, with non-empty file', 200, (err, res, body) ->
    assert.equal JSON.parse(body)['files'].length, 2
    assert.include JSON.parse(body)['files'], 'empty'
    assert.include JSON.parse(body)['files'], 'file'
  )

  .discuss('with non empty directory')
  .post '/fs2http/rename',
    path1 : prefixPath + '/rename/file'
    path2 : prefixPath + '/rename/file2'
  .expect('rename route', 200, (err, res, body) ->
    assert.equal body, '{}'
    path.exists prefixPath + '/rename/file', (exists) ->
      assert.isFalse exists

    path.exists prefixPath + '/rename/file2', (exists) ->
      assert.isTrue exists
  )
  .undiscuss()

  .post '/fs2http/rename',
    path1 : prefixPath + '/rename/file'
    path2 : '/dev/null'
  .expect('rename route, with non existing file', 500, (err, res, body) ->
    assert.equal JSON.parse(body)['error'].length, 1
  )

  .del '/fs2http/rmdir',
    path : prefixPath + '/rmdir/empty'
  .expect('rmdir route', 200, (err, res, body) ->
    assert.equal body, '{}'
    path.exists prefixPath + '/rmdir/empty', (exists) ->
      assert.isFalse exists
  )

  .discuss('with non empty directory')
  .del '/fs2http/rmdir',
    path : prefixPath + '/rmdir/nonempty'
  .expect('rmdir route', 500, (err, res, body) ->
    assert.equal JSON.parse(body)['error'].length, 1

    path.exists prefixPath + '/rmdir/nonempty', (exists) ->
      assert.isTrue exists
  )
  .undiscuss()

  .discuss('with non existing directory')
  .del '/fs2http/rmdir',
    path : prefixPath + '/rmdir/nonexisting'
  .expect('rmdir route', 500, (err, res, body) ->
    assert.equal JSON.parse(body)['error'].length, 1
  )
  .undiscuss()

  .get '/fs2http/stat',
    path : prefixPath + '/stat'
  .expect('stat route', 200, (err, res, body) ->
    assert.ok JSON.parse(body)['stats']
  )

  .post '/fs2http/utimes',
    path : prefixPath + '/utimes'
    atime : 104321
    mtime : 654231
  .expect('utimes route', 200, (err, res, body) ->
    assert.equal body, '{}'
    fs.stat prefixPath + '/utimes', (err, stats) ->
      assert.equal stats['atime'].getTime() / 1000, 104321
      assert.equal stats['mtime'].getTime() / 1000, 654231
  )

  .discuss('with empty data')
  .post '/fs2http/writeFile',
    path : prefixPath + '/writeFile/file'
    data : 'file'
  .expect('writeFile route, with data', 200, (err, res, body) ->
    assert.equal body, '{}'
    fs.readFile prefixPath + '/writeFile/file', 'utf-8', (err, data) ->
      assert.equal data, 'file'
  )
  .undiscuss()

  .post '/fs2http/writeFile',
    path : prefixPath + '/writeFile/empty'
    data : ''
  .expect('writeFile route, empty data', 200, (err, res, body) ->
    fs.readFile prefixPath + '/writeFile/empty', 'utf-8', (err, data) ->
      assert.isEmpty data
  )

suite.export module