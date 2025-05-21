import os
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
import joblib

DATASET_PATH = "dataset.csv"
MODELO_PATH = "modelo_clasificacion.pkl"

modelo = None


def entrenar_modelo(ruta_csv=DATASET_PATH, modelo_guardado=MODELO_PATH):
    df = pd.read_csv(ruta_csv)
    X = df['texto_cv'].astype(str)
    y = df['area']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    pipeline = Pipeline([
        ('tfidf', TfidfVectorizer(max_features=10000, ngram_range=(1, 2), stop_words='english')),
        ('clf', LogisticRegression(max_iter=500))
    ])

    pipeline.fit(X_train, y_train)
    joblib.dump(pipeline, modelo_guardado)
    print("Modelo entrenado y guardado.")
    return pipeline


def cargar_o_entrenar_modelo():
    global modelo
    if modelo is not None:
        return modelo

    if os.path.exists(MODELO_PATH):
        modelo = joblib.load(MODELO_PATH)
    else:
        print("Modelo no encontrado, entrenando automáticamente...")
        modelo = entrenar_modelo()
    return modelo


def predecir_area(texto):
    if modelo is None:
        raise Exception("Modelo no cargado")
    return modelo.predict([texto])[0]
