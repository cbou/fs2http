fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  filename = req.query.filename
  encoding = if req.query.encoding then req.query.encoding else null

  result = 
    error : []
    success : true

  fs.readFile filename, encoding, (err, data) ->
    if err
      utils.errorToResult(result, err)

    result['data'] = data;

    res.send result