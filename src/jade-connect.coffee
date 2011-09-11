fs      = require "fs"
jade    = require "jade"
path    = require "path"

module.exports = (options = {}) ->
  # uglify  = require "uglify-js"

  src = options.src || "views"
  ns = options.ns || "tpl"
  src = src.slice 1, src.length if src.charAt(0) is "/"
  templates = "window.#{ns} = {};"
  fs.readdir src, (err, files) ->
    if not err
      files.forEach (file) ->
        filename = "#{src}/#{file}"
        nm = /(.*)\.jade$/.exec(file)[1]
        tpl = fs.readFileSync filename
        fn = jade.compile tpl, {client: true, compileDebug: false, filename:filename}
        templates += "#{ns}.#{nm} = #{fn};"

  url = options.url || "templates.js"
  re = new RegExp ".*#{url}$"
  
  (req, res, next) ->
    if re.test req.url
      res.setHeader "Content-Type", "application/javascript"
      res.end templates
    else
      next()