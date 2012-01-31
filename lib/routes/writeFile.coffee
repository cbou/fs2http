fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.body.path
  data = req.body.data
  encoding = if req.body.encoding then req.body.encoding else undefined

  result = 
    error : []
    success : true

  fs.writeFile path, data, encoding, (err) ->
    if err
      utils.errorToResult(result, err)

    res.send result