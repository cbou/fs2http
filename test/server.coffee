express = require 'express'
fs2http = require '../lib/fs2http'

app = module.exports = express.createServer()

app.configure ->
  app.use express.bodyParser()

fs2http.use app

fs2http.protections.read = (req, res, path, callback) ->
  regex = /\/tmp\/fs2http\/protection\/read-protected/g;
  setTimeout ()-> 
    if regex.test(path)
      callback('path read protected')
    else
      callback()
  , 1000
  undefined

fs2http.protections.write = (req, res, path, callback) ->
  regex = /\/tmp\/fs2http\/protection\/write-protected/g;
  if regex.test(path)
    callback('path write protected')
  else
    callback()
  undefined

module.export = app

app.listen 3000