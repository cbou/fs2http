fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.body.path

  result = {}

  fs.unlink path, (err) ->
    if err
      utils.errorToResult(result, err, res)

    res.send result