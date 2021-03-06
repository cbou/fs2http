path = require 'path'
step = require 'step'
utils = require '../utils'

###*
 * Test whether or not the given path exists
 *
 * @param {String} path The path
 * @name Exists route
###
module.exports =
  method: 'get'
  url: '/fs2http/exists'
  function: (req, res) ->
    _path = req.query.path

    result = {}

    readProtection = utils.readProtection(req, res, _path)

    utils.updatePath req, res, _path, (_path) ->
      sendResult = (err) ->
        if (err)
          utils.forbiddenToResult result, err, res
          res.send result
        else
          try
            path.exists _path, (exist) ->
              result['exists'] = exist;

              res.send result
          catch err
            utils.errorToResult(result, err, res)
            res.send result

      step readProtection, sendResult