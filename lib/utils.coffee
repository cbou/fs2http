util = require 'util'
fs = require 'fs'
path = require 'path'

utils = {}

utils.errorToResult = (result, err, res) ->
  if !util.isArray result['error']
    result['error'] = []
  
  if res
    res.status(500)
  
  result['error'].push(err)

utils.findValidGid = () ->
  _path = '/tmp/fs2http/findValidGid'
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

module.exports = utils