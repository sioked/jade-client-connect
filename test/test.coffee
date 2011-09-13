request = require 'request'
fs = require 'fs'
rimraf = require 'rimraf'

app = require('connect').createServer()
app.use require('../index.js')("#{__dirname}/views")
app.listen 1337

exports['Basic Test'] = (test) ->
  test.expect 1
  test.ok true, "Failed assertion"
  test.done()

  
exports['Basic doctype test'] = (test) ->
  test.expect 2
  callback = -> request 'http://localhost:1337/js/templates.js', (err, res, body) ->
    test.equal res.headers["content-type"], "application/javascript" 
    test.ok /DOCTYPE html/.test body
    test.done()
  setTimeout callback, 100
    
exports['incorrect file name'] = (test) ->
  test.expect 1
  request 'http://localhost:1337/js/incorrect.js', (err, res, body) ->
    test.equal res.statusCode, "404"
    test.done()
    
exports["File name incorrect location in Url"] = (test) ->
  test.expect 1
  request 'http://localhost:1337/js/templates.js/else', (err, res, body) ->
    test.equal res.statusCode, "404"
    test.done()
    
exports['Test Default NameSpace'] = (test) ->
  test.expect 1
  request 'http://localhost:1337/js/templates.js', (err, res, body) ->
    test.ok /tpl.doctype\s?=/.test body
    test.done()

exports['Test custom NameSpace'] = (test) ->
  test.expect 1
  app.close()
  app = require('connect').createServer()
  app.use require('../index.js')("#{__dirname}/views", {ns : "test"})
  app.listen 1338
  callback = -> request 'http://localhost:1338/js/templates.js', (err, res, body) ->
    test.ok /test.doctype\s?=/.test body
    test.done()
  setTimeout callback, 100
    
exports['Test custom view folder'] = (test) ->
  test.expect 1
  app.close()
  app = require('connect').createServer()
  app.use require('../index.js')("#{__dirname}/views2")
  app.listen 1338
  callback = -> request 'http://localhost:1338/js/templates.js', (err, res, body) ->
    test.ok /tpl.test1\s?=/.test body
    test.done()
  setTimeout callback, 100

exports['Test watch change'] = (test) ->
  test.expect 1
  app.close()
  rimraf "temp", ->
    fs.mkdirSync "temp", 0755
    app = require('connect').createServer()
    app.use require('../index.js')("#{__dirname}/temp")
    app.listen 1337
    doctype = fs.openSync "temp/doctype.jade", 'a'
    fs.writeSync doctype, "h1 test write"
    fs.closeSync doctype
    callback = -> request 'http://localhost:1337/js/templates.js', (err, res, body) ->
      test.ok /test write/.test body
      rimraf "temp", ->
        test.done()
    setTimeout callback, 100
