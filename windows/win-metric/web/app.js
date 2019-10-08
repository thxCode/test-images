var http = require('http');
var url = require('url');
var number = 0;

http.createServer(function (req, res) {
    var urlParts = url.parse(req.url);
    if (urlParts.pathname !== '/favicon.ico') {
        if ( urlParts.pathname === '/metrics' ) {
            res.writeHead(200, { 'Content-Type': 'text/plain' }); 
            res.end('accessed_count ' + number + '\n'); 
        } else {
            number++;
            res.writeHead(200, { 'Content-Type': 'text/plain' });
            res.end('Accessed ' + number + '\n'); 
        }
    }
}).listen(80);
