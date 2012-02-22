util = require 'util'
fs = require 'fs'
path = require 'path'

utils = {}

utils.readProtection = (req, res, path) ->
  protections = req.app.fs2http.protections
  (err) ->
    if (err)
      throw err
    callback = this
    protections.read req, res, path, callback
    undefined

utils.writeProtection = (req, res, path) ->
  protections = req.app.fs2http.protections
  (err) ->
    if (err)
      throw err
    callback = this
    protections.write req, res, path, callback
    undefined

utils.forbiddenToResult = (result, err, res) ->
  if !util.isArray result['error']
    result['error'] = []
  
  if res
    res.status(403)
  
  result['error'].push(err)

utils.errorToResult = (result, err, res) ->
  if !util.isArray result['error']
    result['error'] = []
  
  if res
    res.status(500)
  
  result['error'].push(err)

utils.findValidGid = () ->
  _path = '/tmp/fs2http/findValidGid'

  if !path.existsSync '/tmp/fs2http'
    fs.mkdirSync '/tmp/fs2http'

  if path.existsSync _path
    fs.rmdirSync _path
    
  fs.mkdirSync _path

  currentGid = fs.statSync(_path)['gid']
  currentUid = fs.statSync(_path)['uid']
  for num in [1..3000]
    try
      r = fs.chownSync _path, currentUid, num
      return num
    catch err

  currentGid

utils.copyFile = (path, newpath, callback) ->
  readStream = fs.createReadStream path
  writeStream = fs.createWriteStream newpath

  util.pump readStream, writeStream, (err) ->
    callback err

  null

module.exports = utils