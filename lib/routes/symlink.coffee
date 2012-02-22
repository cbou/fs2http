fs = require 'fs'
step = require 'step'
utils = require '../utils'

module.exports = (req, res) ->
  link = req.body.link
  path = req.body.path
  type = if req.body.type then req.body.type else undefined

  result = {}

  writeProtection = utils.writeProtection(req, res, path)

  sendResult = (err) ->
    if (err)
      utils.forbiddenToResult result, err, res

    else
      fs.symlink path, link, type, (err) ->
        if err
          utils.errorToResult(result, err, res)

    res.send result

  step writeProtection, sendResult