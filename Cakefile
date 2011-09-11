fs = require "fs"
{print} = require "sys"
{spawn, exec} = require 'child_process'

build = (callback) ->
  coffee = spawn "coffee", ['-c', '-o', 'lib', 'src']
  coffee.stdout.on 'data', (data) -> print data.toString()
  coffee.stderr.on 'data', (data) -> print data.toString()
  callback?()

task 'build', "Compile all of the coffescripts into javascripts", ->
  coffee = spawn "coffee", ['-c', '-o', 'lib', 'src']
  coffee.stdout.on 'data', (data) -> print data.toString()
  coffee.stderr.on 'data', (data) -> print data.toString()

task 'test', "Run the test suite", ->
  build ->
    tests = null
    tests = spawn "coffee", ["-e", "{reporters} = require 'nodeunit'; reporters.default.run ['.']"], cwd: 'test'
    tests.stdout.on 'data', (data) -> print data.toString()
    tests.stderr.on 'data', (data) -> print data.toString()