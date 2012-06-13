fs = require 'fs'
step = require 'step'
utils = require '../utils'
wrench = require 'wrench'

module.exports =
  method: 'post'
  url: '/fs2http/chownRec'
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
          fs.stat path, (err,stats) ->

            if err 
              utils.errorToResult(result, err, res)
              res.send result
              return;

            if stats && stats.isDirectory()
              try 
                wrench.chownSyncRecursive path, uid, gid
              catch err
                utils.errorToResult(result, err, res)
              res.send result

            else if stats && stats.isFile()
              fs.chown path, uid, gid, (err) ->
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