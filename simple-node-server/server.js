const http = require('http');
const port = 3000;
const server = http.createServer((req, res) => {
    res.end('Hello, from Kubernetes!');
});

server.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
