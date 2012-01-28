fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.body.path

  result = 
    error : []
    success : true

  fs.rmdir path, (err) ->
    if err
      utils.errorToResult(result, err)

    res.send result