var express = require('express');
var server = express();

server.use('/', express.static('/home/site/wwwroot'));
server.listen(process.env.PORT);
