fs = require 'fs'
step = require 'step'
utils = require '../utils'

###*
 * Write the content of a file
 *
 * @param {String} path The path 
 * @param {String} data The content to write
 * @param {String} encoding The encoding of the data (optional, default is setted from Node.js)
 * @name WriteFile route
###
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