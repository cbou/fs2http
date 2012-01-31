util = require 'util'

utils = {}

utils.errorToResult = (result, err, res) ->
  if !util.isArray result['error']
    result['error'] = []
  
  if res
    res.status(500)
  
  result['error'].push(err)

module.exports = utils