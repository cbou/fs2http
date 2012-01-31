fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.query.path

  result = {}

  fs.stat path, (err, stats) ->
    if err
      utils.errorToResult(result, err, res)

    result['stats'] = stats;

    res.send result