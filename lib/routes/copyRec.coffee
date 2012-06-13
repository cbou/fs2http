fs = require 'fs'
step = require 'step'
utils = require '../utils'
wrench = require 'wrench'

module.exports =
  method: 'post'
  url: '/fs2http/copyRec'
  function: (req, res) ->
    path = req.body.path
    newpath = req.body.newpath

    result = {}

    utils.updatePath req, res, path, (path) ->
      utils.updatePath req, res, newpath, (newpath) ->
        writeProtection = utils.writeProtection(req, res, newpath)
        readProtection = utils.readProtection(req, res, path)

        sendResult = (err) ->
          if (err)
            utils.forbiddenToResult result, err, res
            res.send result
          else
            fs.stat path, (err,stats) ->
              if err 
                utils.errorToResult(result, err, res)

              if stats && stats.isDirectory()
                wrench.copyDirRecursive path, newpath, (err) ->
                  if err
                    utils.errorToResult(result, err, res)
                  res.send result

              else if stats && stats.isFile()
                utils.copyFile path, newpath, (err) ->
                  if err
                    utils.errorToResult(result, err, res)
                  res.send result

              else 
                err = 
                  code : 'NOTIMPL'
                  message: 'function not implemented yet'

                utils.errorToResult(result, err, res)
                res.send result

        step writeProtection, readProtection, sendResult