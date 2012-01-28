fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  path1 = req.body.path1
  path2 = req.body.path2

  result = 
    error : []
    success : true

  fs.rename path1, path2, (err) ->
    if err
      utils.errorToResult(result, err)

    res.send result