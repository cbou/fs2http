fs = require 'fs'
step = require 'step'
utils = require '../utils'

module.exports = (req, res) ->
  path1 = req.body.path1
  path2 = req.body.path2

  result = {}

  writeProtection1 = utils.writeProtection(req, res, path1)
  writeProtection2 = utils.writeProtection(req, res, path2)

  sendResult = (err) ->
    if (err)
      utils.forbiddenToResult result, err, res

    else
      fs.rename path1, path2, (err) ->
        if err
          utils.errorToResult(result, err, res)

    res.send result

  step writeProtection1, writeProtection2, sendResult