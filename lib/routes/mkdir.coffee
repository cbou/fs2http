fs = require 'fs'
step = require 'step'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.body.path
  mode = if req.body.mode then req.body.mode else undefined

  result = {}

  writeProtection = utils.writeProtection(req, res, path)

  sendResult = (err) ->
    if (err)
      utils.forbiddenToResult result, err, res

    else
      fs.mkdir path, mode, (err) ->
        if err
          utils.errorToResult(result, err, res)

    res.send result

  step writeProtection, sendResult