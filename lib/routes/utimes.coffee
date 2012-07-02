fs = require 'fs'
step = require 'step'
utils = require '../utils'

###*
 * Change file last access and modification times
 *
 * @param {String} path The path 
 * @param {String} atime The last access time (see Node.js documentation for format)
 * @param {String} mtime The last modification time (see Node.js documentation for format)
 * @name Utimes route
###
module.exports =
  method: 'post'
  url: '/fs2http/utimes'
  function: (req, res) ->
    path = req.body.path
    atime = req.body.atime
    mtime = req.body.mtime

    result = {}

    utils.updatePath req, res, path, (path) ->
      writeProtection = utils.writeProtection(req, res, path)

      sendResult = (err) ->
        if (err)
          utils.forbiddenToResult result, err, res
          res.send result

        else
          fs.utimes path, atime, mtime, (err) ->
            if err
              utils.errorToResult(result, err, res)

            res.send result

      step writeProtection, sendResult