fs = require 'fs'
step = require 'step'
utils = require '../utils'

###*
 * Remove empty directories
 *
 * @param {String} path The path
 * @name Rmdir route
###
module.exports =
  method: 'del'
  url: '/fs2http/rmdir'
  function: (req, res) ->
    path = req.body.path

    result = {}

    utils.updatePath req, res, path, (path) ->
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