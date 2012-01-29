fs = require 'fs'
util = require 'util'

module.exports = (req, res) ->
  path = req.query.path

  result = 
    error : []
    success : true

  fs.readdir path, (err, files) ->
    if err
      utils.errorToResult(result, err)

    result['files'] = files;

    res.send result