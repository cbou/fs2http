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

fs.mkdirSync prefixPath + '/symlink'
fs.mkdirSync prefixPath + '/symlink/dir'
fs.mkdirSync prefixPath + '/symlink/file'
fs.mkdirSync prefixPath + '/symlink/link'
fs.symlinkSync prefixPath + '/symlink/link', prefixPath + '/symlink/linklink'

fs.mkdirSync prefixPath + '/unlink'
fs.mkdirSync prefixPath + '/unlink/dir1'
fs.mkdirSync prefixPath + '/unlink/dir2'
fs.symlinkSync prefixPath + '/unlink/dir2', prefixPath + '/unlink/linkdir'
fs.writeFileSync prefixPath + '/unlink/file', 'file'

fs.mkdirSync prefixPath + '/readlink'
fs.mkdirSync prefixPath + '/readlink/dir'
fs.symlinkSync prefixPath + '/readlink/dir', prefixPath + '/readlink/linkdir'
fs.writeFileSync prefixPath + '/readlink/file', 'file'
fs.symlinkSync prefixPath + '/readlink/file', prefixPath + '/readlink/linkfile'

fs.mkdirSync prefixPath + '/exists'
fs.mkdirSync prefixPath + '/exists/dir'
fs.writeFileSync prefixPath + '/exists/file', 'file'
fs.symlinkSync prefixPath + '/exists/dir', prefixPath + '/exists/linkdir'

suite.discuss("When trying fs2http node routes")
  .use("localhost", 3000)
  .setHeader("Content-Type", "application/json")
  
  suite.post '/fs2http/chmod',
    path : prefixPath + '/chmod'
    mode : '0777'
  .expect('chmod route', 200, (err, res, body) ->
    assert.equal u.size(body), 0
    fs.stat prefixPath + '/chmod', (err, stats) ->
      assert.equal stats['mode'], 16895
  )

  suite.post '/fs2http/chown',
    path : prefixPath + '/chown'
    uid : fs.statSync(prefixPath + '/chown')['uid']
    gid : newGid
  .expect('chown route', 200, (err, res, body) ->
    assert.equal u.size(body), 0
    fs.stat prefixPath + '/chown', (err, stats) ->
      assert.equal stats['gid'], newGid
  )

  suite.post '/fs2http/mkdir',
    path : prefixPath + '/mkdir'
  .expect('mkdir route', 200, (err, res, body) ->
    assert.equal u.size(body), 0
    path.exists prefixPath + '/mkdir', (exists) ->
      assert.ok exists
  )

  suite.discuss('with empty file')
  .get '/fs2http/readFile',
    path : prefixPath + '/readFile/empty'
    encoding : 'utf-8'
  .expect('readFile route, with empty file', 200, (err, res, body) ->
    assert.isEmpty body['data']
  )
  .undiscuss()

  suite.get '/fs2http/readFile',
    path : prefixPath + '/readFile/file'
    encoding : 'utf-8'
  .expect('readFile route, with non-empty file', 200, (err, res, body) ->
    assert.equal body['data'], 'file'
  )

  suite.get '/fs2http/readdir',
    path : prefixPath + '/readdir'
  .expect('readdir route, with non-empty file', 200, (err, res, body) ->
    assert.equal body['files'].length, 2
    assert.include body['files'], 'empty'
    assert.include body['files'], 'file'
  )

  suite.discuss('with non empty directory')
  .post '/fs2http/rename',
    path1 : prefixPath + '/rename/file'
    path2 : prefixPath + '/rename/file2'
  .expect('rename route', 200, (err, res, body) ->
    assert.equal u.size(body), 0
    path.exists prefixPath + '/rename/file', (exists) ->
      assert.isFalse exists

    path.exists prefixPath + '/rename/file2', (exists) ->
      assert.isTrue exists
  )
  .undiscuss()

  suite.post '/fs2http/rename',
    path1 : prefixPath + '/rename/file'
    path2 : '/dev/null'
  .expect('rename route, with non existing file', 500, (err, res, body) ->
    assert.equal body['error'].length, 1
  )

  suite.del '/fs2http/rmdir',
    path : prefixPath + '/rmdir/empty'
  .expect('rmdir route', 200, (err, res, body) ->
    assert.equal u.size(body), 0
    path.exists prefixPath + '/rmdir/empty', (exists) ->
      assert.isFalse exists
  )

  suite.discuss('with non empty directory')
  .del '/fs2http/rmdir',
    path : prefixPath + '/rmdir/nonempty'
  .expect('rmdir route', 500, (err, res, body) ->
    assert.equal body['error'].length, 1

    path.exists prefixPath + '/rmdir/nonempty', (exists) ->
      assert.isTrue exists
  )
  .undiscuss()

  suite.discuss('with non existing directory')
  .del '/fs2http/rmdir',
    path : prefixPath + '/rmdir/nonexisting'
  .expect('rmdir route', 500, (err, res, body) ->
    assert.equal body['error'].length, 1
  )
  .undiscuss()

  suite.get '/fs2http/stat',
    path : prefixPath + '/stat'
  .expect('stat route', 200, (err, res, body) ->
    assert.ok body['stats']
  )

  suite.post '/fs2http/utimes',
    path : prefixPath + '/utimes'
    atime : 104321
    mtime : 654231
  .expect('utimes route', 200, (err, res, body) ->
    assert.equal u.size(body), 0
    fs.stat prefixPath + '/utimes', (err, stats) ->
      assert.equal stats['atime'].getTime() / 1000, 104321
      assert.equal stats['mtime'].getTime() / 1000, 654231
  )

  suite.discuss('with empty data')
  .post '/fs2http/writeFile',
    path : prefixPath + '/writeFile/file'
    data : 'file'
  .expect('writeFile route, with data', 200, (err, res, body) ->
    assert.equal u.size(body), 0
    fs.readFile prefixPath + '/writeFile/file', 'utf-8', (err, data) ->
      assert.equal data, 'file'
  )
  .undiscuss()

  suite.post '/fs2http/writeFile',
    path : prefixPath + '/writeFile/empty'
    data : ''
  .expect('writeFile route, empty data', 200, (err, res, body) ->
    fs.readFile prefixPath + '/writeFile/empty', 'utf-8', (err, data) ->
      assert.isEmpty data
  )


  suite.discuss('link a dir')
  .post '/fs2http/symlink',
    path : prefixPath + '/symlink/dir'
    link : prefixPath + '/symlink/linkdir'
  .expect('link route', 200, (err, res, body) ->
    assert.equal u.size(body), 0

    fs.lstat prefixPath + '/symlink/linkdir', (err, stats) ->
      assert.isTrue stats.isSymbolicLink()
  )
  .undiscuss()

  suite.discuss('link a file')
  .post '/fs2http/symlink',
    path : prefixPath + '/symlink/file'
    link : prefixPath + '/symlink/linkfile'
  .expect('link route', 200, (err, res, body) ->
    assert.equal u.size(body), 0

    fs.lstat prefixPath + '/symlink/linkfile', (err, stats) ->
      assert.isTrue stats.isSymbolicLink()
  )
  .undiscuss()

  suite.discuss('link a link')
  .post '/fs2http/symlink',
    path : prefixPath + '/symlink/linklink'
    link : prefixPath + '/symlink/linklinklink'
  .expect('link route', 200, (err, res, body) ->
    assert.equal u.size(body), 0

    fs.lstat prefixPath + '/symlink/linklinklink', (err, stats) ->
      assert.isTrue stats.isSymbolicLink()
  )
  .undiscuss()

  suite.discuss('unlink a dir')
  .del '/fs2http/unlink',
    path : prefixPath + '/unlink/dir1'
  .expect('unlink route', 500, (err, res, body) ->
    assert.equal body['error'].length, 1

    path.exists prefixPath + '/unlink/dir1', (exists) ->
      assert.isTrue exists
  )
  .undiscuss()

  suite.discuss('unlink a file')
  .del '/fs2http/unlink',
    path : prefixPath + '/unlink/file'
  .expect('unlink route', 200, (err, res, body) ->
    assert.equal u.size(body), 0

    path.exists prefixPath + '/unlink/file', (exists) ->
      assert.isFalse exists
  )
  .undiscuss()

  suite.discuss('unlink a link')
  .del '/fs2http/unlink',
    path : prefixPath + '/unlink/linkdir'
  .expect('unlink route', 200, (err, res, body) ->
    assert.equal u.size(body), 0

    path.exists prefixPath + '/unlink/linkdir', (exists) ->
      assert.isFalse exists
  )
  .undiscuss()

  suite.discuss('readlink a dir link')
  .get '/fs2http/readlink',
    path : prefixPath + '/readlink/linkdir'
  .expect('readlink route', 200, (err, res, body) ->
    assert.equal body['linkString'], prefixPath + '/readlink/dir'
  )
  .undiscuss()

  suite.discuss('readlink a file link')
  .get '/fs2http/readlink',
    path : prefixPath + '/readlink/linkfile'
  .expect('readlink route', 200, (err, res, body) ->
    assert.equal body['linkString'], prefixPath + '/readlink/file'
  )
  .undiscuss()

  suite.discuss('readlink a file')
  .get '/fs2http/readlink',
    path : prefixPath + '/readlink/dir'
  .expect('readlink route', 500, (err, res, body) ->
    assert.equal body['error'].length, 1
  )
  .undiscuss()

  suite.discuss('readlink a file')
  .get '/fs2http/readlink',
    path : prefixPath + '/readlink/file'
  .expect('readlink route', 500, (err, res, body) ->
    assert.equal body['error'].length, 1
  )
  .undiscuss()

  suite.discuss('exists a file')
  .get '/fs2http/exists',
    path : prefixPath + '/exists/file'
  .expect('exists route', 200, (err, res, body) ->
    assert.isTrue body['exists']
  )
  .undiscuss()

  suite.discuss('exists a dir')
  .get '/fs2http/exists',
    path : prefixPath + '/exists/dir'
  .expect('exists route', 200, (err, res, body) ->
    assert.isTrue body['exists']
  )
  .undiscuss()

  suite.discuss('exists a linkdir')
  .get '/fs2http/exists',
    path : prefixPath + '/exists/linkdir'
  .expect('exists route', 200, (err, res, body) ->
    assert.isTrue body['exists']
  )
  .undiscuss()

suite.export module