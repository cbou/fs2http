(function() {
  var step;

  step = require('step');

  /*
  maybe like that:
  
    routesUtils.execute req, res, 
        method: 'write'
        arguments: []
      , 
        method: 'chmod'
        arguments: []
      , () ->
        fs.chmod path, mode, (err) ->
          
          console.log arguments
          if err
            utils.errorToResult(result, err, res)
  
          res.send result
  */

  module.exports.execute = function() {
    var argc, lastCallback, protections, req, res;
    argc = arguments.length;
    lastCallback = arguments[argc - 1];
    req = arguments[0];
    res = arguments[1];
    protections = function() {
      setTimeout((function(callback) {
        return function() {
          return callback(null, 1);
        };
      })(this.parallel()), 100);
      setTimeout((function(callback) {
        return function() {
          return callback(null, 1);
        };
      })(this.parallel()), 1000);
      return;
    };
    /*
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
    */
    return step(protections, lastCallback);
  };

}).call(this);
