fs = require 'fs'
step = require 'step'
utils = require '../utils'
wrench = require 'wrench'

module.exports = (req, res) ->
  path = req.body.path
  mode = req.body.mode

  result = {}

  writeProtection = utils.writeProtection(req, res, path)

  sendResult = (err) ->
    if (err)
      utils.forbiddenToResult result, err, res
      res.send result
    else 
      fs.stat path, (err,stats) ->
        if err 
          utils.errorToResult(result, err, res)

        if stats && stats.isDirectory()
          try 
          	wrench.chmodSyncRecursive path, mode
          catch err
            utils.errorToResult(result, err, res)
          res.send result

        else if stats && stats.isFile()
          fs.chmod path, mode, (err) ->
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