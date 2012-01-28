express = require "express"
fs2http = require "../lib/fs2http"

app = module.exports = express.createServer()
app.configure ->
  app.use express.bodyParser()

fs2http.use app

app.get '/stop', (req, res) ->
  res.end()
  app.close()

app.listen 3000

module.export = app