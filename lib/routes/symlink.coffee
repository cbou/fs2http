fs = require 'fs'
step = require 'step'
utils = require '../utils'

###*
 * Make a new name for a file
 *
 * @param {String} link The destination 
 * @param {String} path The path to link
 * @name Symlink route
###
module.exports = 
  method: 'post'
  url: '/fs2http/symlink'
  function: (req, res) ->
    link = req.body.link
    path = req.body.path
    type = if req.body.type then req.body.type else undefined

    result = {}

    utils.updatePath req, res, path, (path) ->
      utils.updatePath req, res, link, (link) ->
        writeProtection = utils.writeProtection(req, res, path)

        sendResult = (err) ->
          if (err)
            utils.forbiddenToResult result, err, res
            res.send result

          else
            fs.symlink path, link, type, (err) ->
              if err
                utils.errorToResult(result, err, res)

              res.send result

        step writeProtection, sendResult