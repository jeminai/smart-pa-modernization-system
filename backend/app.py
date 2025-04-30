from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/api/status')
def status():
    return jsonify({"status": "Smart PA Backend Running"})

@app.route('/')
def home():
    return """
    <html>
        <head><title>Smart PA Backend</title></head>
        <body style="font-family: sans-serif; text-align: center; padding: 50px;">
            <h1>🔊 Smart PA Modernization System</h1>
            <p>Status: <strong>Backend is running.</strong></p>
            <p><a href="/api/status">Check API Status JSON</a></p>
        </body>
    </html>
    """

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
