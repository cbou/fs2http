fs = require 'fs'
path = require 'path'
wrench = require 'wrench'

try
  config = require './config.private'
catch error
  config = require './config.public'

utils = {}

utils.prepareTest = (testName)->
  tmpFixturesPath = config.prefixPath + config.paths[testName]

  if !path.existsSync config.prefixPath
    fs.mkdirSync config.prefixPath

  if path.existsSync tmpFixturesPath
    wrench.rmdirSyncRecursive tmpFixturesPath
  fs.mkdirSync tmpFixturesPath

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

module.exports = utils