fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.query.path

  result = 
    error : []
    success : true

  fs.stat path, (err, stats) ->
    if err
      utils.errorToResult(result, err)

    result['stats'] = stats;

    res.send result