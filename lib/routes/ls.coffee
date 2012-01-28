fs = require 'fs'
util = require 'util'
async = require 'async'

module.exports = (req, res) ->
  dir = req.query['dir']
  fs.readdir dir, (err, files) ->
    
    if util.isArray files
      result = {}
      result['files'] = {}

      result['success'] = true
      result['errors'] = []

      async.forEach files, (file, callback) ->
        result['files'][file] = fs.statSync dir + '/' + file
        , (err) ->
          result['success'] = true
          result['errors'] = [err]

      res.send result
    else
      res.send '[]' 