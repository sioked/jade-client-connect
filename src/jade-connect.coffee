fs      = require "fs"
jade    = require "jade"
path    = require "path"
templates = ""

compile = (options = {}) ->
  console.log "running compile"
  src = options.src || "views"
  ns = options.ns || "tpl"
  src = src.slice 1, src.length if src.charAt(0) is "/"
  templates = "window.#{ns} = {};"
  console.log "starting readdir with dir: #{src}"
  fs.readdir src, (err, files) ->
    if err
      console.log err
    else
      files.forEach (file) ->
        console.log "compiling file: #{file}"
        filename = "#{src}/#{file}"
        nm = /(.*)\.jade$/.exec(file)[1]
        tpl = fs.readFileSync filename
        fn = jade.compile tpl, {client: true, compileDebug: false, filename:filename}
        templates += "#{ns}.#{nm} = #{fn};"
  templates

module.exports = (options = {}) ->
  templates = compile(options)
  url = options.url || "templates.js"
  re = new RegExp ".*#{url}$"
  compile options

  (req, res, next) ->
    if re.test req.url
      res.setHeader "Content-Type", "application/javascript"
      res.end templates
    else
      next()
