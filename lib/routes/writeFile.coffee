fs = require 'fs'
step = require 'step'
utils = require '../utils'

module.exports =
  method: 'post'
  url: '/fs2http/writeFile'
  function: (req, res) ->
    path = req.body.path
    data = req.body.data
    encoding = if req.body.encoding then req.body.encoding else undefined

    result = {}

    utils.updatePath req, res, path, (path) ->
      writeProtection = utils.writeProtection(req, res, path)

      sendResult = (err) ->
        if (err)
          utils.forbiddenToResult result, err, res
          res.send result

        else
          fs.writeFile path, data, encoding, (err) ->
            if err
              utils.errorToResult(result, err, res)

            res.send result

      step writeProtection, sendResult