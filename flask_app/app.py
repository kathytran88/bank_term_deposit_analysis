from flask import Flask, render_template, request
import pickle
import numpy as np
from sklearn.preprocessing import StandardScaler
import os
import pandas as pd

app = Flask(__name__)

# Absolute path to the file
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

    # Handle the form submission for the Logistic Regression model
    if request.method == 'POST':
        age = float(request.form['age'])
        balance = float(request.form['balance'])

        input_data = np.array([[age, balance]])

        # Assuming you have a scaler saved; otherwise, this step should be adapted
        scaler = StandardScaler()
        input_data = scaler.fit_transform(input_data)

        if model is not None:
            prediction = model.predict(input_data)
            prediction_text = 'Yes (will subscribe to term deposit)' if prediction[0] == 1 else 'No (will not subscribe to term deposit)'
        else:
            prediction_text = 'Model not found'

    # Load the SQL file content
    path_to_file = 'sql_analysis.sql'  # Adjust the path if necessary
    sql_content = None
    if os.path.exists(path_to_file):
        with open(path_to_file, 'r') as file:
            sql_content = file.read()
    else:
        sql_content = "File inaccessible."

    # Load csv file 
    path_to_csv = 'SQL_results.csv'  # Adjust the path if necessary
    csv_content = None
    if os.path.exists(path_to_csv):
        df = pd.read_csv(path_to_csv)
        df.columns = df.columns.str.strip()
        df = df.rename(columns={'Unnamed 0': ''})
        csv_content = df.to_html(classes='csv-table', index=False)
    else:
        csv_content = 'File inaccessible'

    # Render the template with both prediction and SQL content
    return render_template('index.html', sql_content=sql_content, prediction_text=prediction_text, csv_content=csv_content)

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
