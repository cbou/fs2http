fs = require 'fs'
step = require 'step'
utils = require '../utils'

module.exports = (req, res) ->
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