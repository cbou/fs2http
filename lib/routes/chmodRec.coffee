fs = require 'fs'
step = require 'step'
utils = require '../utils'
wrench = require 'wrench'

###*
 * Change file mode bits recursively
 *
 * @param {String} path The path 
 * @param {String} mode The new mode
 * @name ChmodRec route
###
module.exports =
  method: 'post'
  url: '/fs2http/chmodRec'
  function: (req, res) ->
    path = req.body.path
    mode = req.body.mode

    result = {}

    utils.updatePath req, res, path, (path) ->
      writeProtection = utils.writeProtection(req, res, path)

      sendResult = (err) ->
        if (err)
          utils.forbiddenToResult result, err, res
          res.send result
        else 
          fs.stat path, (err,stats) ->
            if err 
              utils.errorToResult(result, err, res)

            if stats && stats.isDirectory()
              try 
              	wrench.chmodSyncRecursive path, mode
              catch err
                utils.errorToResult(result, err, res)
              res.send result

            else if stats && stats.isFile()
              fs.chmod path, mode, (err) ->
                if err
                  utils.errorToResult(result, err, res)
                res.send result

            else 
              err = 
                code : 'NOTIMPL'
                message: 'function not implemented yet'

              utils.errorToResult(result, err, res)
              res.send result

      step writeProtection, sendResult
      