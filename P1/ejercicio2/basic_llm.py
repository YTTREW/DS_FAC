from llm import *
from transformers import pipeline
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


class BasicLLM(LLM):
    def __init__(self, model):
        self.model = model

    def generate_summary(text, input_lang, output_lang, model):
        """Generates a summary of the input text using the model and Huggingface's pipeline."""  # TODO: español

        # Variables para realizar la solicitud POST a la API de Hugging Face
        url = "https://api-inference.huggingface.co/models/" + model

        headers = {
            "Authorization": f"Bearer {HUGGINGFACE_API_TOKEN}",
        }

        data = {
            "inputs": "Haz un resumen de este texto: " + text,
        }

        try:
            # Realizar la solicitud POST a la API de Hugging Face
            response = requests.post(url, headers=headers, json=data)
            response.raise_for_status()
            return response.json()[0]["summary_text"]
        except Exception as e:
            return f"Error al generar el resumen: {e}"
