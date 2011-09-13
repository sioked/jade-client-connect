(function() {
  var compile, fs, jade, opts, path, source, templates, watch;
  fs = require("fs");
  jade = require("jade");
  path = require("path");
  watch = require("watch");
  templates = "";
  source = "";
  opts = {};
  compile = function(src, options) {
    var ns;
    if (src == null) {
      src = source;
    }
    if (options == null) {
      options = opts;
    }
    ns = options.ns || "tpl";
    templates = "window." + ns + " = {};";
    fs.readdir(src, function(err, files) {
      if (err) {
        return console.log(err);
      } else {
        return files.forEach(function(file) {
          var filename, fn, nm, tpl;
          filename = "" + src + "/" + file;
          nm = /(.*)\.jade$/.exec(file)[1];
          tpl = fs.readFileSync(filename);
          fn = jade.compile(tpl, {
            client: true,
            compileDebug: false,
            filename: filename
          });
          return templates += "" + ns + "." + nm + " = " + fn + ";";
        });
      }
    });
    return templates;
  };
  module.exports = function(src, options) {
    var re, url;
    if (options == null) {
      options = {};
    }
    if (!src) {
      throw new Error("Source directory not included");
    }
    templates = compile(src, options);
    source = src;
    opts = options;
    url = options.url || "templates.js";
    re = new RegExp(".*" + url + "$");
    watch.watchTree(src, function() {
      return compile();
    });
    return function(req, res, next) {
      if (re.test(req.url)) {
        res.setHeader("Content-Type", "application/javascript");
        return res.end(templates);
      } else {
        return next();
      }
    };
  };
}).call(this);
