fs = require 'fs'
util = require 'util'
async = require 'async'

module.exports = (req, res) ->
  path = req.query['path']
  fs.readdir path, (err, files) ->
    
    if util.isArray files
      result = {}
      result['files'] = {}

      result['success'] = true
      result['errors'] = []

      async.forEach files, (file, callback) ->
        result['files'][file] = fs.statSync path + '/' + file
        , (err) ->
          result['success'] = true
          result['errors'] = [err]

      res.send result
    else
      res.send '[]' 