fs = require 'fs'
step = require 'step'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.body.path

  result = {}

  writeProtection = utils.writeProtection(req, res, path)

  sendResult = (err) ->
    if (err)
      utils.forbiddenToResult result, err, res
      res.send result

    else
      fs.rmdir path, (err) ->
        if err
          utils.errorToResult(result, err, res)

        res.send result

  step writeProtection, sendResult