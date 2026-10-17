from flask import Flask, jsonify
app = Flask(__name__)
@app.get('/health')
def health():
    return jsonify(ok=True, service='python-api')
if __name__ == '__main__':
    app.run(port=5000)
