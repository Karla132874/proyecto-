import openai
import os
from dotenv import load_dotenv

load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")


def obtener_recomendaciones_chatgpt(texto_cv, area):
    prompt = f"""
Eres un experto reclutador. El área profesional detectada para este CV es: {area}.
Lee el siguiente currículum y ofrece pequeñas recomendaciones para mejorarlo:

{texto_cv}

Devuelve solo un texto con tres recomendaciones cortas sin caracteres especiales y con un lenguaje neutral no formal 
"""

    respuesta = openai.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7,
        max_tokens=300,
    )
    return respuesta.choices[0].message.content.strip()