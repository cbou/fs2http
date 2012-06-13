fs = require 'fs'
step = require 'step'
utils = require '../utils'

module.exports = 
  method: 'post'
  url: '/fs2http/rename'
  function: (req, res) ->
    path1 = req.body.path1
    path2 = req.body.path2

    result = {}

    utils.updatePath req, res, path1, (path1) ->
      utils.updatePath req, res, path2, (path2) ->
        writeProtection1 = utils.writeProtection(req, res, path1)
        writeProtection2 = utils.writeProtection(req, res, path2)

        sendResult = (err) ->
          if (err)
            utils.forbiddenToResult result, err, res
            res.send result

          else
            fs.rename path1, path2, (err) ->
              if err
                utils.errorToResult(result, err, res)

              res.send result

        step writeProtection1, writeProtection2, sendResult