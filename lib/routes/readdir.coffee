fs = require 'fs'
step = require 'step'
util = require 'util'
utils = require '../utils'

###*
 * Read a directory
 *
 * @param {String} path The path
 * @name Readdir route
###
module.exports =
  method: 'get'
  url: '/fs2http/readdir'
  function: (req, res) ->
    path = req.query.path

    result = {}

    utils.updatePath req, res, path, (path) ->
      readProtection = utils.readProtection(req, res, path)

      sendResult = (err) ->
        if (err)
          utils.forbiddenToResult result, err, res
          res.send result

        else
          fs.readdir path, (err, files) ->
            if err
              utils.errorToResult(result, err, res)

            result['contents'] = files;

            res.send result

      step readProtection, sendResult