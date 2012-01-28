fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.body.path
  mode = req.body.mode

  result = 
    error : []
    success : true

  fs.chmod path, mode, (err) ->
    if err
      utils.errorToResult(result, err)

    res.send result