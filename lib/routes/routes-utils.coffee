step = require 'step'

# It's not used for the moment...

###
maybe like that:

  routesUtils.execute req, res, 
      method: 'write'
      arguments: []
    , 
      method: 'chmod'
      arguments: []
    , () ->
      fs.chmod path, mode, (err) ->
        
        if err
          utils.errorToResult(result, err, res)

        res.send result

###

module.exports.execute = ()->
  argc = arguments.length
  lastCallback = arguments[argc-1]
  req = arguments[0]
  res = arguments[1]

  protections = () ->
    setTimeout(
      ((callback) ->
        ->
          callback null, 1
      ) @parallel()
    , 100);
    setTimeout(
      ((callback) ->
        ->
          callback null, 1
      ) @parallel()
    , 1000);
    undefined

  ###
  writeProtection = (err) ->
    if (err)
      throw err
    callback = this
    protections.write req, res, path, callback
    undefined

  chmodProtection = (err) ->
    if (err)
      throw err

    callback = this
    protections.chmod req, res, path, callback
    undefined
  ###

  step protections, lastCallback
