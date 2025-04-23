import os
import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)

# Récupérer les variables d'environnement
db_host = os.environ.get('DB_HOST', 'localhost')
db_user = os.environ.get('DB_USER', 'postgres')
db_password = os.environ.get('DB_PASSWORD', 'postgres')
db_name = os.environ.get('DB_NAME', 'postgres')
app_env = os.environ.get('APP_ENV', 'production')

@app.route('/')
def index():
    return jsonify({
        'message': 'Server is running',
        'environment': app_env
    })

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy'
    })

@app.route('/db-check')
def db_check():
    try:
        # Tentative de connexion à la base de données
        conn = psycopg2.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            dbname=db_name
        )
        
        # Si la connexion est réussie
        cur = conn.cursor()
        cur.execute('SELECT version();')
        db_version = cur.fetchone()
        cur.close()
        conn.close()
        
        return jsonify({
            'status': 'connected',
            'db_version': db_version[0],
            'host': db_host,
            'database': db_name,
            'user': db_user
        })
    except Exception as e:
        return jsonify({
            'status': 'error',
            'message': str(e)
        }), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)