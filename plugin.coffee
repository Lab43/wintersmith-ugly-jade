async = require 'async'
jade = require 'jade'
fs = require 'fs'
path = require 'path'


module.exports = (wintersmith, callback) ->

  class UglyJadeTemplate extends wintersmith.defaultPlugins.JadeTemplate
  
  UglyJadeTemplate.fromFile = (filename, base, callback) ->
    fullpath = path.join base, filename
    async.waterfall [
      (callback) ->
        fs.readFile fullpath, callback
      (buffer, callback) =>
        try
          rv = jade.compile buffer.toString(),
            filename: fullpath
            pretty: false
          callback null, new this rv
        catch error
          callback error
    ], callback

  wintersmith.registerTemplatePlugin '**/*.jade', UglyJadeTemplate
  callback()