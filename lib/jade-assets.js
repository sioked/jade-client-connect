(function() {
  var compile, fs, jade, path;
  fs = require("fs");
  jade = require("jade");
  path = require("path");
  compile = function(options) {
    var ns, src, templates;
    src = options.src || "views";
    ns = options.ns || "tpl";
    if (src.charAt(0) === "/") {
      src = src.slice(1, src.length);
    }
    templates = "window." + ns + " = {};";
    fs.readdir(src, function(err, files) {
      if (!err) {
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
  module.exports = function(options) {
    var re, templates, url;
    if (options == null) {
      options = {};
    }
    templates = compile(options);
    url = options.url || "templates.js";
    re = new RegExp(".*" + url + "$");
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
