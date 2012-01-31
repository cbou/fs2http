fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.body.path
  mode = if req.body.mode then req.body.mode else undefined

  result = {}

  fs.mkdir path, mode, (err) ->
    if err
      utils.errorToResult(result, err, res)

    res.send result