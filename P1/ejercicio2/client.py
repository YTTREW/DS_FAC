from basic_llm import *
import json
import os
from dotenv import load_dotenv

# Cargar variables de entorno desde el archivo .env
load_dotenv()

# Obtener el token de Hugging Face
HUGGINGFACE_API_TOKEN = os.getenv("HUGGINGFACE_API_TOKEN")

# Verificar que el token se haya cargado correctamente
if HUGGINGFACE_API_TOKEN is None:
    raise ValueError("No se ha encontrado el token de Hugging Face en el archivo .env")
else:
    print("Token de Hugging Face cargado correctamente")

# Cargar los valores de configuración de config.json
base_path = os.path.dirname(os.path.abspath(__file__))
config_path = os.path.join(base_path, "config.json")

try:
    with open(config_path, "r") as f:
        config = json.load(f)
except FileNotFoundError:
    raise FileNotFoundError(f"No se ha encontrado el archivo de configuración en la ruta {config_path}")

texto = config["texto"]
input_lang = config["input_lang"]
output_lang = config["output_lang"]
model_llm = config["model_llm"]
model_translation = config["model_translation"]
model_expansion = config["model_expansion"]

# Mostrar el texto original
print(f"Texto original:\n{texto}")

# Crear un resumen del texto
texto_resumido = BasicLLM.generate_summary(texto, input_lang, output_lang, model_llm)
print(f"\nResumen del texto:\n{texto_resumido}")
