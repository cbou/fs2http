fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.query.path

  result = {}

  fs.readlink path, (err, linkString) ->
    if err
      utils.errorToResult(result, err, res)

    result['linkString'] = linkString;

    res.send result