fs = require 'fs'
step = require 'step'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.body.path
  mode = req.body.mode

  result = {}

  writeProtection = utils.writeProtection(req, res, path)

  readProtection = utils.readProtection(req, res, path)

  sendResult = (err) ->
    if (err)
      utils.forbiddenToResult result, err, res

    else
      fs.chmod path, mode, (err) ->
        if err
          utils.errorToResult(result, err, res)

    res.send result

  step writeProtection, sendResult

  step readProtection, sendResult
