from llm_decorator import *
import os
from dotenv import load_dotenv
import requests

# Cargar variables de entorno desde el archivo .env
load_dotenv()

# Obtener el token de Hugging Face
HUGGINGFACE_API_TOKEN = os.getenv("HUGGINGFACE_API_TOKEN")

# Verificar que el token se haya cargado correctamente
if HUGGINGFACE_API_TOKEN is None:
    raise ValueError("No se ha encontrado el token de Hugging Face en el archivo .env")
else:
    print("Token de Hugging Face cargado correctamente")


class TranslationDecorator(LLMDecorator):
    def generate_summary(self, text, input_lang, output_lang, model):
        """Traduce el texto de entrada a otro idioma utilizando el modelo especificado y la API de Hugging Face."""
        # Variables para realizar la solicitud POST a la API de Hugging Face
        url = "https://api-inference.huggingface.co/models/" + model

        headers = {
            "Authorization": f"Bearer {HUGGINGFACE_API_TOKEN}",
        }

        data = {
            "inputs": "Traduce del " + input_lang + " al " + output_lang + " el siguiente texto: " + text,
        }

        # Realizar la solicitud POST a la API de Hugging Face
        try:
            response = requests.post(url, headers=headers, json=data)
            response.raise_for_status()
            return response.json()
        except Exception as e:
            return f"Error al generar el resumen: {e}"
