fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.query.path
  encoding = if req.query.encoding then req.query.encoding else null

  result = {}

  fs.readFile path, encoding, (err, data) ->
    if err
      utils.errorToResult(result, err, res)

    result['data'] = data;

    res.send result