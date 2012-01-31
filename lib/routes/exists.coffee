path = require 'path'
utils = require '../utils'

module.exports = (req, res) ->
  _path = req.query.path

  result = {}

  try
    path.exists _path, (exist) ->
      result['exists'] = exist;

      res.send result
  catch err
    utils.errorToResult(result, err, res)
    res.send result