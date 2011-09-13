#Jade Client Connect
This is a piece of Middleware for the
[connect](http://senchalabs.github.com/connect/) framework. It can be
plugged into Connect servers or Express servers and expose a URL to the
client which will have as a javascript file all of the compiled
templates.

##How to use
Copy Git repository into your project
run 'npm install -d'

###In your connect server file
```
app = require('connect').createServer();
app.use(require('./jade-client-connect/')(__dirname + "/views"));
```

###On the client
```
<script src="/scripts/templates.js"></script>
<script>
  // Assuming you have a file named content.jade in the views folder
  var html = tpl.content({ title: "Hello World" });
</script
```
##Defaults & Options
```
var options = {
  ns : 'tpl'
}
app.use(require('./jade-client-connect/')(__dirname+"/views", options));
```

The src option is the folder that contains all of the jade templates. Each of
the files inside this directory will be compiled as a javascript jade
template in the ns client namespace. By default the namespace is tpl so
all teplates will be accessed by calling something like tpl.footer().
Only one file will be sent back to the client.

##Running Tests & Compiling Source
```
cake build
cake test
```
