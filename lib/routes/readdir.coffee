fs = require 'fs'
step = require 'step'
util = require 'util'
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
      fs.readdir path, (err, files) ->
        if err
          utils.errorToResult(result, err, res)

        result['files'] = files;

        res.send result

  step readProtection, sendResult