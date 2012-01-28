fs = require 'fs'
util = require 'util'

module.exports = (req, res) ->
  dir = req.query.dir

  result = 
    error : []
    success : true

  fs.readdir dir, (err, files) ->
    if err
      utils.errorToResult(result, err)

    result['files'] = files;

    res.send result