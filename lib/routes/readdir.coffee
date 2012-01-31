fs = require 'fs'
util = require 'util'

module.exports = (req, res) ->
  path = req.query.path

  result = {}

  fs.readdir path, (err, files) ->
    if err
      utils.errorToResult(result, err, res)

    result['files'] = files;

    res.send result