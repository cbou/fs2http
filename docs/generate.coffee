fs = require 'fs'
path = require 'path'
markdox = require 'markdox'
async = require 'async'
u = require 'underscore'
docFolder = __dirname
files = [];

formatter = (docfile) ->
  route = require docfile.filename
  docfile.javadoc.forEach (javadoc, index) ->
    docfile.javadoc[index].httpMethod = route.method.toUpperCase()
    docfile.javadoc[index].defaultUrl = route.url

  return docfile


fs.readdir __dirname + '/../lib/routes', (err, files) ->
  # index.coffee should not be documented
  files = u.without files, 'index.coffee', 'routes-utils.coffee'

  files.forEach (file, index) ->
    files[index] = __dirname + '/../lib/routes/' + file 
  outputFile = docFolder + '/routes.md'

  markdox.process files,
    output: outputFile
    formatter: formatter
    template: __dirname + '/template.md.ejs'
  , (err, output) ->
    throw err if err
    console.log('Routes documentation generated with success in ' + outputFile);
