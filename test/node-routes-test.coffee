APIeasy = require 'api-easy'
assert = require 'assert'
suite = APIeasy.describe 'fs2http: Node routes'
fs = require 'fs'
wrench = require 'wrench'
path = require 'path'
u = require 'underscore'

utils = require './utils'
app = require './server'

try
  config = require './config.private'
catch error
  config = require './config.public'

testName = 'node-routes'

newGid = utils.findValidGid()
tmpFixturesPath = config.prefixPath + config.paths[testName]

utils.prepareTest testName

# copy fixtures
wrench.copyDirSyncRecursive __dirname + '/fixtures/' + testName, config.prefixPath + '/' + testName

# create empty dirs
fs.mkdirSync tmpFixturesPath + '/rmdir/empty'
fs.mkdirSync tmpFixturesPath + '/rmdir/nonempty/dir'

fs.symlinkSync tmpFixturesPath + '/symlink/link', tmpFixturesPath + '/symlink/linklink'

fs.symlinkSync tmpFixturesPath + '/unlink/dir2', tmpFixturesPath + '/unlink/linkdir'
fs.writeFileSync tmpFixturesPath + '/unlink/file', 'file'

fs.symlinkSync tmpFixturesPath + '/readlink/dir', tmpFixturesPath + '/readlink/linkdir'
fs.writeFileSync tmpFixturesPath + '/readlink/file', 'file'
fs.symlinkSync tmpFixturesPath + '/readlink/file', tmpFixturesPath + '/readlink/linkfile'

fs.symlinkSync tmpFixturesPath + '/exists/dir', tmpFixturesPath + '/exists/linkdir'

suite
  .discuss("When trying fs2http node routes")
  .use("localhost", 3000)
  .setHeader("Content-Type", "application/json")
  
  .post '/fs2http/chmod',
    path : tmpFixturesPath + '/chmod'
    mode : '0777'
  .expect('chmod route', 200, (err, res, body) ->
    body = JSON.parse body
    fs.stat tmpFixturesPath + '/chmod', (err, stats) ->
      assert.equal stats['mode'], 16895
  )

  .post '/fs2http/chown',
    path : tmpFixturesPath + '/chown'
    uid : fs.statSync(tmpFixturesPath + '/chown')['uid']
    gid : newGid
  .expect('chown route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0
    fs.stat tmpFixturesPath + '/chown', (err, stats) ->
      assert.equal stats['gid'], newGid
  )

  .post '/fs2http/mkdir',
    path : tmpFixturesPath + '/mkdir'
  .expect('mkdir route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0
    path.exists tmpFixturesPath + '/mkdir', (exists) ->
      assert.ok exists
  )

  .discuss('with empty file')
  .get '/fs2http/readFile',
    path : tmpFixturesPath + '/readFile/empty'
    encoding : 'utf-8'
  .expect('readFile route, with empty file', 200, (err, res, body) ->
    body = JSON.parse body
    assert.isEmpty body['data']
  )
  .undiscuss()

  .get '/fs2http/readFile',
    path : tmpFixturesPath + '/readFile/file'
    encoding : 'utf-8'
  .expect('readFile route, with non-empty file', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['data'], 'file'
  )

  .get '/fs2http/readdir',
    path : tmpFixturesPath + '/readdir'
  .expect('readdir route, with non-empty file', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['contents'].length, 2
    assert.include body['contents'], 'empty'
    assert.include body['contents'], 'file'
  )

  .discuss('with non empty directory')
  .post '/fs2http/rename',
    path1 : tmpFixturesPath + '/rename/file'
    path2 : tmpFixturesPath + '/rename/file2'
  .expect('rename route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0
    path.exists tmpFixturesPath + '/rename/file', (exists) ->
      assert.isFalse exists

    path.exists tmpFixturesPath + '/rename/file2', (exists) ->
      assert.isTrue exists
  )
  .undiscuss()

  .post '/fs2http/rename',
    path1 : tmpFixturesPath + '/rename/file'
    path2 : '/dev/null'
  .expect('rename route, with non existing file', 500, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
  )

  .del '/fs2http/rmdir',
    path : tmpFixturesPath + '/rmdir/empty'
  .expect('rmdir route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0
    path.exists tmpFixturesPath + '/rmdir/empty', (exists) ->
      assert.isFalse exists
  )

  .discuss('with non empty directory')
  .del '/fs2http/rmdir',
    path : tmpFixturesPath + '/rmdir/nonempty'
  .expect('rmdir route', 500, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1

    path.exists tmpFixturesPath + '/rmdir/nonempty', (exists) ->
      assert.isTrue exists
  )
  .undiscuss()

  .discuss('with non existing directory')
  .del '/fs2http/rmdir',
    path : tmpFixturesPath + '/rmdir/nonexisting'
  .expect('rmdir route', 500, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
  )
  .undiscuss()

  .get '/fs2http/stat',
    path : tmpFixturesPath + '/stat'
  .expect('stat route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.ok body['stats']
  )

  .post '/fs2http/utimes',
    path : tmpFixturesPath + '/utimes'
    atime : 104321
    mtime : 654231
  .expect('utimes route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0
    fs.stat tmpFixturesPath + '/utimes', (err, stats) ->
      assert.equal stats['atime'].getTime() / 1000, 104321
      assert.equal stats['mtime'].getTime() / 1000, 654231
  )

  .discuss('with empty data')
  .post '/fs2http/writeFile',
    path : tmpFixturesPath + '/writeFile/file'
    data : 'file'
  .expect('writeFile route, with data', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0
    fs.readFile tmpFixturesPath + '/writeFile/file', 'utf-8', (err, data) ->
      assert.equal data, 'file'
  )
  .undiscuss()

  .post '/fs2http/writeFile',
    path : tmpFixturesPath + '/writeFile/empty'
    data : ''
  .expect('writeFile route, empty data', 200, (err, res, body) ->
    body = JSON.parse body
    fs.readFile tmpFixturesPath + '/writeFile/empty', 'utf-8', (err, data) ->
      assert.isEmpty data
  )


  .discuss('link a dir')
  .post '/fs2http/symlink',
    path : tmpFixturesPath + '/symlink/dir'
    link : tmpFixturesPath + '/symlink/linkdir'
  .expect('link route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0

    fs.lstat tmpFixturesPath + '/symlink/linkdir', (err, stats) ->
      assert.isTrue stats.isSymbolicLink()
  )
  .undiscuss()

  .discuss('link a file')
  .post '/fs2http/symlink',
    path : tmpFixturesPath + '/symlink/file'
    link : tmpFixturesPath + '/symlink/linkfile'
  .expect('link route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0

    fs.lstat tmpFixturesPath + '/symlink/linkfile', (err, stats) ->
      assert.isTrue stats.isSymbolicLink()
  )
  .undiscuss()

  .discuss('link a link')
  .post '/fs2http/symlink',
    path : tmpFixturesPath + '/symlink/linklink'
    link : tmpFixturesPath + '/symlink/linklinklink'
  .expect('link route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0

    fs.lstat tmpFixturesPath + '/symlink/linklinklink', (err, stats) ->
      assert.isTrue stats.isSymbolicLink()
  )
  .undiscuss()

  .discuss('unlink a dir')
  .del '/fs2http/unlink',
    path : tmpFixturesPath + '/unlink/dir1'
  .expect('unlink route', 500, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1

    path.exists tmpFixturesPath + '/unlink/dir1', (exists) ->
      assert.isTrue exists
  )
  .undiscuss()

  .discuss('unlink a file')
  .del '/fs2http/unlink',
    path : tmpFixturesPath + '/unlink/file'
  .expect('unlink route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0

    path.exists tmpFixturesPath + '/unlink/file', (exists) ->
      assert.isFalse exists
  )
  .undiscuss()

  .discuss('unlink a link')
  .del '/fs2http/unlink',
    path : tmpFixturesPath + '/unlink/linkdir'
  .expect('unlink route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal u.size(body), 0

    path.exists tmpFixturesPath + '/unlink/linkdir', (exists) ->
      assert.isFalse exists
  )
  .undiscuss()

  .discuss('readlink a dir link')
  .get '/fs2http/readlink',
    path : tmpFixturesPath + '/readlink/linkdir'
  .expect('readlink route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['linkString'], tmpFixturesPath + '/readlink/dir'
  )
  .undiscuss()

  .discuss('readlink a file link')
  .get '/fs2http/readlink',
    path : tmpFixturesPath + '/readlink/linkfile'
  .expect('readlink route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['linkString'], tmpFixturesPath + '/readlink/file'
  )
  .undiscuss()

  .discuss('readlink a file')
  .get '/fs2http/readlink',
    path : tmpFixturesPath + '/readlink/dir'
  .expect('readlink route', 500, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
  )
  .undiscuss()

  .discuss('readlink a file')
  .get '/fs2http/readlink',
    path : tmpFixturesPath + '/readlink/file'
  .expect('readlink route', 500, (err, res, body) ->
    body = JSON.parse body
    assert.equal body['error'].length, 1
  )
  .undiscuss()

  .discuss('exists a file')
  .get '/fs2http/exists',
    path : tmpFixturesPath + '/exists/file'
  .expect('exists file route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.isTrue body['exists']
  )
  .undiscuss()

  .discuss('exists a dir')
  .get '/fs2http/exists',
    path : tmpFixturesPath + '/exists/dir'
  .expect('exists dir route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.isTrue body['exists']
  )
  .undiscuss()

  .discuss('exists a linkdir')
  .get '/fs2http/exists',
    path : tmpFixturesPath + '/exists/linkdir'
  .expect('exists route', 200, (err, res, body) ->
    body = JSON.parse body
    assert.isTrue body['exists']
  )
  .undiscuss()

  .export(module)