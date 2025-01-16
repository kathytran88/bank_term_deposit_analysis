from flask import Flask, render_template, request
import pickle
import numpy as np
from sklearn.preprocessing import StandardScaler
import os
import pandas as pd

app = Flask(__name__)

file_path = os.path.join(os.path.dirname(__file__), 'logistic.pkl')
print(f"Loading model from: {file_path}")

try:
    with open(file_path, 'rb') as file:
        model = pickle.load(file)
except FileNotFoundError:
    print(f"File not found: {file_path}")
    model = None

@app.route('/', methods=['GET', 'POST'])
def index():
    prediction_text = None

    if request.method == 'POST':
        age = float(request.form['age'])
        balance = float(request.form['balance'])

        input_data = np.array([[age, balance]])

        scaler = StandardScaler()
        input_data = scaler.fit_transform(input_data)

        if model is not None:
            prediction = model.predict(input_data)
            prediction_text = 'Yes (will subscribe to term deposit)' if prediction[0] == 1 else 'No (will not subscribe to term deposit)'
        else:
            prediction_text = 'Model not found'

    path_to_file = 'sql_analysis.sql' 
    sql_content = None
    if os.path.exists(path_to_file):
        with open(path_to_file, 'r') as file:
            sql_content = file.read()
    else:
        sql_content = "File inaccessible."

#############################################
    FLASK_APP_DIR = os.path.dirname(os.path.abspath(__file__))
    
    ROOT_DIR = os.path.dirname(FLASK_APP_DIR)
    #
    csv_path = os.path.join(ROOT_DIR, 'SQL_results.csv')

    print(f"Flask app directory: {FLASK_APP_DIR}")
    print(f"Root directory: {ROOT_DIR}")
    print(f"Looking for CSV at: {csv_path}")

    csv_content = None
    if os.path.exists(csv_path):
        try:
            df = pd.read_csv(csv_path)
            df.columns = df.columns.str.strip()
            if 'Unnamed: 0' in df.columns:
                df = df.rename(columns={'Unnamed: 0': ''})
            csv_content = df.to_html(classes='table table-striped', index=False)
            print("Successfully read CSV file")
        except Exception as e:
            csv_content = f'Error reading CSV file: {str(e)}'
            print(f"Error reading CSV: {str(e)}")
    else:
        csv_content = 'CSV file not found'
        print(f"CSV file not found at path: {csv_path}")

    #################################
    print(f"CSV path: {csv_path}")
    print(f"CSV file exists: {os.path.exists(csv_path)}")
    if csv_content:
        print("CSV content was loaded successfully")
    else:
        print("CSV content is None")

    
    return render_template('index.html', sql_content=sql_content, prediction_text=prediction_text, csv_content=csv_content)

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 8080)), debug=True)
