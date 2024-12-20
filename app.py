from flask import Flask

app = Flask(__name__)

VERSION = "1.0.0"
MESSAGE = "Hello from Python App!"

@app.route('/')
def hello():
    return f"Version: {VERSION}\n{MESSAGE}", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)