fs = require 'fs'
step = require 'step'
utils = require '../utils'

###*
 * Change file mode bits
 *
 * @param {String} path The path 
 * @param {String} mode The new mode
 * @name Chmod route
###
module.exports = 
  method: 'post'
  url: '/fs2http/chmod'
  function: (req, res) ->
    path = req.body.path
    mode = req.body.mode

    result = {}

    utils.updatePath req, res, path, (path) ->
      writeProtection = utils.writeProtection req, res, path

      sendResult = (err) ->
        if (err)
          utils.forbiddenToResult result, err, res
          res.send result

        else
          fs.chmod path, mode, (err) ->
            if err
              utils.errorToResult(result, err, res)

            res.send result

      step writeProtection, sendResult
