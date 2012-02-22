fs = require 'fs'
step = require 'step'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.query.path

  result = {}
  
  readProtection = utils.readProtection(req, res, path)

  sendResult = (err) ->
    if (err)
      utils.forbiddenToResult result, err, res
      res.send result

    else
      fs.stat path, (err, stats) ->
        if err
          utils.errorToResult(result, err, res)

        result['stats'] = stats;

        res.send result

  step readProtection, sendResult