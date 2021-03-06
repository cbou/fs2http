fs = require 'fs'
step = require 'step'
utils = require '../utils'

###*
 * Read a file
 *
 * @param {String} path The path
 * @name ReadFile route
###
module.exports = 
  method: 'get'
  url: '/fs2http/readFile'
  function: (req, res) ->
    path = req.query.path
    encoding = if req.query.encoding then req.query.encoding else null

    result = {}

    utils.updatePath req, res, path, (path) ->
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