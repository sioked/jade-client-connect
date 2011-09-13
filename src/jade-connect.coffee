fs      = require "fs"
jade    = require "jade"
path    = require "path"
watch = require "watch"
templates = ""
source = ""
opts = {}

compile = (src = source, options = opts) ->
  ns = options.ns || "tpl"
  templates = "window.#{ns} = {};"
  fs.readdir src, (err, files) ->
    if err
      console.log err
    else
      files.forEach (file) ->
        filename = "#{src}/#{file}"
        nm = /(.*)\.jade$/.exec(file)[1]
        tpl = fs.readFileSync filename
        fn = jade.compile tpl, {client: true, compileDebug: false, filename:filename}
        templates += "#{ns}.#{nm} = #{fn};"
  templates

module.exports = (src, options = {}) ->
  throw new Error "Source directory not included" if not src
  templates = compile src, options
  source = src
  opts = options
  url = options.url || "templates.js"
  re = new RegExp ".*#{url}$"
  watch.watchTree src, ->
    compile()

  (req, res, next) ->
    if re.test req.url
      res.setHeader "Content-Type", "application/javascript"
      res.end templates
    else
      next()
