# app.py
from http.server import SimpleHTTPRequestHandler
from socketserver import TCPServer

class MyHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()

            # Define your HTML content
            html_content = """
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>EKS Deployment working!</title>
                <style>
                    body {
                        font-family: 'Arial', sans-serif;
                        background-color: #f0f0f0;
                        text-align: center;
                        margin-top: 100px;
                    }
                    h1 {
                        color: #333;
                    }
                </style>
            </head>
            <body>
                <h1>Hello, World!</h1>
                <p>Welcome to my fancy webpage served by Python.</p>
            </body>
            </html>
            """

            # Send the HTML content as bytes
            self.wfile.write(html_content.encode())
        else:
            # If the requested path is not '/', serve the default behavior
            super().do_GET()

if __name__ == '__main__':
    server_address = ('', 80)
    httpd = TCPServer(server_address, MyHandler)
    print('Serving on port 80...')
    httpd.serve_forever()
