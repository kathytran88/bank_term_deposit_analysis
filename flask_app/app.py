from flask import Flask, render_template, request
import pickle
import numpy as np
from sklearn.preprocessing import StandardScaler

app = Flask(__name__)

with open('logistic.pkl', 'rb') as file:
    logistic_model = pickle.load(file)

@app.route('/', methods=['GET', 'POST'])
def index():
    prediction_text = None 
    if request.method == 'POST':
        age = float(request.form['age'])
        balance = float(request.form['balance'])

        input_data = np.array([[age, balance]])

        scaler = StandardScaler()
        input_data = scaler.fit_transform(input_data)

        prediction = logistic_model.predict(input_data)

        prediction_text = 'Yes (will subscribe to term deposit)' if prediction[0] == 1 else 'No (will not subscribe to term deposit)'
    return render_template('index.html', prediction_text = prediction_text)
