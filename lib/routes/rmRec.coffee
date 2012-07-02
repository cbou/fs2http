fs = require 'fs'
step = require 'step'
utils = require '../utils'
wrench = require 'wrench'

###*
 * Remove files and directories recursively
 *
 * @param {String} path The path
 * @name RmRec route
###
module.exports =
  method: 'del'
  url: '/fs2http/rmRec'
  function: (req, res) ->
    path = req.body.path

    result = {}

    utils.updatePath req, res, path, (path) ->
      writeProtection = utils.writeProtection(req, res, path)

      sendResult = (err) ->
        if (err)
          utils.forbiddenToResult result, err, res
          res.send result
        else
          fs.lstat path, (err,stats) ->
            if err 
              utils.errorToResult(result, err, res)
              res.send result
              return;

            if stats && stats.isDirectory()
              wrench.rmdirRecursive path, (err) ->
                if err
                  utils.errorToResult(result, err, res)
                res.send result
            else if stats && (stats.isFile() ||  stats.isSymbolicLink())
              fs.unlink path, (err) ->
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