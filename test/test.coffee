request = require 'request'

app = require('connect').createServer()
app.use require('../index.js')()
app.listen 1337

exports['Basic Test'] = (test) ->
  test.expect 1
  test.ok true, "Failed assertion"
  test.done()
  
exports['Basic doctype test'] = (test) ->
  test.expect 2
  request 'http://localhost:1337/js/templates.js', (err, res, body) ->
    console.log "Body: #{body}"
    test.equal res.headers["content-type"], "application/javascript" 
    test.ok /DOCTYPE html/.test body
    test.done()
    
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
  app.use require('../index.js')({ns : "test"})
  app.listen 1338
  request 'http://localhost:1338/js/templates.js', (err, res, body) ->
    console.log body
    test.ok /test.doctype\s?=/.test body
    test.done()
    
exports['Test custom view folder'] = (test) ->
  test.expect 1
  app.close()
  app = require('connect').createServer()
  app.use require('../index.js')({src : "views2"})
  app.listen 1338
  request 'http://localhost:1338/js/templates.js', (err, res, body) ->
    console.log "body: #{body}"
    test.ok /tpl.test1\s?=/.test body
    test.done()