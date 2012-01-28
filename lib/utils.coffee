
utils = {}

utils.errorToResult = (result, err) ->
  result['error'].push(err)
  result['success'] = false

module.exports = utils