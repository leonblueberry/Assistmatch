from flask import Flask, jsonify, request
import os
import psycopg2
from dotenv import load_dotenv

# Load environment variables for database security
load_dotenv()

app = Flask(__name__)

# Database connection logic
def get_db_connection():
    try:
        conn = psycopg2.connect(
            host=os.getenv('DB_HOST'),
            database=os.getenv('DB_NAME'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASS'),
            port=os.getenv('DB_PORT')
        )
        return conn
    except Exception as e:
        print(f"Error connecting to database: {e}")
        return None

@app.route('/')
def home():
    return jsonify({"message": "Welcome to the Assistmatch API", "status": "running"})

# Example Data Engineering Route: Fetching Job Posts
@app.route('/api/jobs', methods=['GET'])
def get_jobs():
    conn = get_db_connection()
    if conn is None:
        return jsonify({"error": "Database connection failed"}), 500
    
    cur = conn.cursor()
    cur.execute('SELECT title, city, wage_rate FROM job_posts WHERE is_active = TRUE;')
    jobs = cur.fetchall()
    cur.close()
    conn.close()
    
    return jsonify(jobs)

if __name__ == '__main__':
    app.run(debug=True)
