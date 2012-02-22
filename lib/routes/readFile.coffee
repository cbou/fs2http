fs = require 'fs'
step = require 'step'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.query.path
  encoding = if req.query.encoding then req.query.encoding else null

  result = {}

  readProtection = utils.readProtection(req, res, path)

  sendResult = (err) ->
    if (err)
      utils.forbiddenToResult result, err, res
      res.send result

    else
      fs.readFile path, encoding, (err, data) ->
        if err
          utils.errorToResult(result, err, res)

        result['data'] = data;
        res.send result

  step readProtection, sendResult