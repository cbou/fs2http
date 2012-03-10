fs = require 'fs'
step = require 'step'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.query.path

  result = {}

  utils.updatePath req, res, path, (path) ->
    readProtection = utils.readProtection(req, res, path)

    sendResult = (err) ->
      if (err)
        utils.forbiddenToResult result, err, res
        res.send result

      else
        fs.readlink path, (err, linkString) ->
          if err
            utils.errorToResult(result, err, res)

          result['linkString'] = linkString;

          res.send result

    step readProtection, sendResult