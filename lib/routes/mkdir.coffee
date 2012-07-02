fs = require 'fs'
step = require 'step'
utils = require '../utils'

###*
 * Make a directory
 *
 * @param {String} path The path
 * @param {String} mode The mode (optional, default comes from Node.js)
 * @name Mkdir route
###
module.exports = 
  method: 'post'
  url: '/fs2http/mkdir'
  function: (req, res) ->
    path = req.body.path
    mode = if req.body.mode then req.body.mode else undefined

    result = {}

    utils.updatePath req, res, path, (path) ->
      writeProtection = utils.writeProtection(req, res, path)

      sendResult = (err) ->
        if (err)
          utils.forbiddenToResult result, err, res
          res.send result

        else
          fs.mkdir path, mode, (err) ->
            if err
              utils.errorToResult(result, err, res)

            res.send result

      step writeProtection, sendResult