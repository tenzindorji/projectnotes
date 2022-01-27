#!/usr/bin/python3
import http.server
import logging
import os
import socketserver
import subprocess
from string import Template

PORT = 4567
RELOAD_TIMER = 30  # seconds
ROOT_DIR = os.path.dirname(os.path.abspath(__file__))


def get_uptime():
    """Returns the output of call to 'uptime'"""

    process = subprocess.run(["uptime", "--pretty"], stdout=subprocess.PIPE)
    return process.stdout.decode("UTF-8").strip()


class Handler(http.server.SimpleHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/html")
        self.end_headers()

    def do_GET(self):
        logging.info(
            "GET request,\nPath: %s\nHeaders:\n%s\n", str(self.path), str(self.headers)
        )
        self._set_headers()
        # Format the uptime to just output the time
        uptime = get_uptime().replace("up ", "")

        # Create simple templating so we can style our page easier
        # We pass in the index.html with a simple template variable
        with open(os.path.join(ROOT_DIR, "index.html")) as f:
            index_file = Template(f.read()).substitute(
                uptime=uptime, timer=RELOAD_TIMER
            )
            self.wfile.write(bytes(index_file, "UTF-8"))
            return


def unit_tests():
    print("All tests passed!")
    return 0


if __name__ == "__main__":
    import sys

    if len(sys.argv) > 1 and sys.argv[1] == "test":
        unit_tests()
        sys.exit(0)

    PORT = int(os.environ.get("PORT") or PORT)
    logging.basicConfig(level=logging.INFO)

    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        logging.info("Serving at port %s", PORT)
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            pass
        httpd.server_close()
        logging.info("Stopping server...\n")
