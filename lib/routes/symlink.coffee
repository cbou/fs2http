fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  link = req.body.link
  path = req.body.path
  type = if req.body.type then req.body.type else undefined

  result = {}

  fs.symlink path, link, type, (err) ->
    if err
      utils.errorToResult(result, err, res)

    res.send result