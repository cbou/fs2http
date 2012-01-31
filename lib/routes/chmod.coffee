fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.body.path
  mode = req.body.mode

  result = {}

  fs.chmod path, mode, (err) ->
    if err
      utils.errorToResult(result, err, res)

    res.send result