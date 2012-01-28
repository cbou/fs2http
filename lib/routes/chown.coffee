fs = require 'fs'
utils = require '../utils'

module.exports = (req, res) ->
  path = req.body.path
  uid = req.body.uid
  gid = req.body.gid
  
  result = 
    error : []
    success : true

  fs.chown path, uid, gid, (err) ->
    if err
      utils.errorToResult(result, err)

    res.send result