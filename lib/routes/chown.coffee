fs = require 'fs'
step = require 'step'
utils = require '../utils'

###*
 * change file owner and group
 *
 * @param {String} path The path
 * @param {String} uid The new uid
 * @param {String} gid The new gid
 * @name ChownRec route
###
module.exports =
  method: 'post'
  url: '/fs2http/chown'
  function: (req, res) ->
    path = req.body.path
    uid = req.body.uid
    gid = req.body.gid
    
    result = {}

    utils.updatePath req, res, path, (path) ->
      writeProtection = utils.writeProtection(req, res, path)
      
      sendResult = (err) ->
        if (err)
          utils.forbiddenToResult result, err, res
          res.send result

        else
          fs.chown path, uid, gid, (err) ->
            if err
              utils.errorToResult(result, err, res)

            res.send result

      step writeProtection, sendResult