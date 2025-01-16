import pandas as pd 
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
import statsmodels.api as sm
import pickle
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from imblearn.over_sampling import SMOTE

def train_logistic_model():
    data1 = pd.read_csv("./flask_app/train.csv")
    data2 = pd.read_csv('./flask_app/test.csv')
    dataset = pd.concat([data1, data2], ignore_index=True) 

    # One hot encoding
    dataset['y'] = dataset['y'].str.replace('"', '').str.strip()
    dataset.loc[dataset['y'] == 'yes', 'outcome_num'] = 1 
    dataset.loc[dataset['y'] == 'no', 'outcome_num'] = 0

    dataset['age'] = dataset['age'].astype(float)
    dataset['balance'] = dataset['balance'].astype(float)

    # Scale features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(dataset[["age", "balance"]])

    # Train/test split
    X_train, X_test, y_train, y_test = train_test_split(
        X_scaled, 
        dataset['outcome_num'], 
        test_size=0.2, 
        random_state=1
    )

    # Apply SMOTE to the training set
    sm = SMOTE(random_state=42)
    X_train_resampled, y_train_resampled = sm.fit_resample(X_train, y_train)

    model = LogisticRegression()
    model.fit(X_train_resampled, y_train_resampled)

    y_prediction = model.predict(X_test)
    print("The score of this model is:", model.score(X_test, y_test))

    with open('logistic.pkl', 'wb') as file:
        pickle.dump(model, file)

train_logistic_model()
