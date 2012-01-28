fs2http
==========

This module creates Express routes to make filesystem manipulation possible.


Installation
--------

    npm install fs2http

Quick Start
--------

Install Express:

    npm install express

Create following file:

    var express = require('express')
    var fs2http = require('fs2http')
    
    var app = module.exports = express.createServer();
    
    // Configuration
    app.configure(function(){
      app.use(express.bodyParser());
    });
    
    fs2http.use(app);
    
    app.listen(3000);
    console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);


`fs2http.use(app);` creates routes the fs2http routes

Running Tests
--------

Run tests:
    node test/node-routes-test.js

License
--------

(The MIT License)

Copyright (c) 2012 Charles Bourasseau <charles.bourasseau@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.