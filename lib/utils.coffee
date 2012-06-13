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

utils.updatePath = (req, res, path, callback) ->
  req.app.fs2http.updatePath req, res, path, callback

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

utils.copyFile = (path, newpath, callback) ->
  readStream = fs.createReadStream path
  writeStream = fs.createWriteStream newpath

  util.pump readStream, writeStream, (err) ->
    callback err

  null

module.exports = utils