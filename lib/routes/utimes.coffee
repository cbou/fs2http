fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.body.path
  atime = req.body.atime
  mtime = req.body.mtime

  result = {}

  fs.utimes path, atime, mtime, (err) ->
    if err
      utils.errorToResult(result, err, res)

    res.send result