fs = require 'fs'
utils = require '../utils'
wrench = require 'wrench'

module.exports = (req, res) ->
  path = req.body.path

  result = {}

  fs.stat path, (err,stats) ->
    if err 
      utils.errorToResult(result, err, res)

    if stats && stats.isDirectory()
      wrench.rmdirRecursive path, (err) ->
        if err
          utils.errorToResult(result, err, res)
        res.send result

    else if stats && stats.isFile()  
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