from flask import Flask

app = Flask(__name__)

VERSION = "1.0.2"
MESSAGE = "Hello in my final project app page @YevhenT"

@app.route('/')
def hello():
    return f"Version: {VERSION}\n{MESSAGE}", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)