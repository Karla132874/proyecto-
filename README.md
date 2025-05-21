# proyecto-
Evaluador de CV con IA
Este proyecto permite analizar currículums en formato PDF o imagen, identificar el área profesional más probable y generar recomendaciones para mejorarlo. Utiliza procesamiento de lenguaje natural y un modelo de clasificación entrenado con scikit-learn, junto con la API de OpenAI para generar sugerencias personalizadas.

Componentes
Backend (Python + FastAPI): expone una API que recibe el archivo, extrae el texto, predice el área y genera recomendaciones usando GPT.

Frontend (Flutter): aplicación móvil que permite al usuario subir su CV, enviar la solicitud y ver los resultados.

Tecnologías
FastAPI, scikit-learn, TfidfVectorizer, Logistic Regression, PyMuPDF, pytesseract, OpenAI API

Flutter, Dart

Ejecución
Backend: ejecutar uvicorn api:app --reload

Flutter: ejecutar flutter run o flutter build apk para generar el instalador

Despliegue
Para uso temporal, se puede subir el backend a plataformas como Render.com o Railway que permiten desplegar APIs rápidamente a partir de un repositorio.
