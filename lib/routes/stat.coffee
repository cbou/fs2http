fs = require 'fs'
step = require 'step'
utils = require '../utils'

###*
 * Display file or file system status
 *
 * @param {String} path The path
 * @name Stat route
###
module.exports =
  method: 'get'
  url: '/fs2http/stat'
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
          fs.stat path, (err, stats) ->
            if err
              utils.errorToResult(result, err, res)

            result['stats'] = stats;

            res.send result

      step readProtection, sendResult