from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import os
import io
from PIL import Image
from dotenv import load_dotenv
import openai
import fitz 

from modelo import cargar_o_entrenar_modelo, predecir_area
from recomendaciones import obtener_recomendaciones_chatgpt

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")
modelo = None

@app.on_event("startup")
def startup_event():
    global modelo
    modelo = cargar_o_entrenar_modelo()


def extraer_texto_pdf(file_bytes):
    texto = ""
    with fitz.open(stream=file_bytes, filetype="pdf") as doc:
        for pagina in doc:
            texto += pagina.get_text()
    return texto


def extraer_texto_imagen(file_bytes):
    imagen = Image.open(io.BytesIO(file_bytes))
    import pytesseract
    texto = pytesseract.image_to_string(imagen)
    return texto


@app.post("/subir-cv/")
async def subir_cv(file: UploadFile = File(...)):
    try:
        contenido = await file.read()

        if file.content_type == "application/pdf":
            texto = extraer_texto_pdf(contenido)
        elif file.content_type.startswith("image/"):
            texto = extraer_texto_imagen(contenido)
        else:
            raise HTTPException(status_code=400, detail="Formato no soportado. Usa PDF o imagen.")

        if not texto.strip():
            raise HTTPException(status_code=400, detail="No se pudo extraer texto del archivo.")

        area = predecir_area(texto)
        recomendaciones = obtener_recomendaciones_chatgpt(texto, area)

        return {
            "area": area,
            "recomendaciones": recomendaciones
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))