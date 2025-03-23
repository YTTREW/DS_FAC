from basic_llm import *
from translation_decorator import *
from expansion_decorator import *
import json
import os
from dotenv import load_dotenv

# DEBUG: Variable para activar o desactivar la depuración
DEBUG = True

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

if DEBUG:
    print(f"\nTexto: {texto}")
    print(f"Idioma de entrada: {input_lang}")
    print(f"Idioma de salida: {output_lang}")
    print(f"Modelo LLM: {model_llm}")
    print(f"Modelo de traducción: {model_translation}")
    print(f"Modelo de expansión: {model_expansion}\n")


if __name__ == "__main__":
    # Mostrar el texto original
    print(f"Texto original:\n{texto}")

    # Crear las instancias de las clases
    llm_basic = BasicLLM(HUGGINGFACE_API_TOKEN)
    llm_translation = TranslationDecorator(llm_basic)
    llm_expansion = ExpansionDecorator(llm_basic)

    # Generar y mostrar el resumen básico del texto original
    summary = llm_basic.generate_summary(texto, input_lang, output_lang, model_llm)
    print(f"\nResumen del texto original:\n{summary}")

    # Generar y mostrar el resumen traducido
    translation = llm_translation.generate_summary(summary, input_lang, output_lang, model_translation)
    print(f"\nTexto traducido:\n{translation}")

    # Generar y mostrar el resumen expandido
    expansion = llm_expansion.generate_summary(summary, input_lang, output_lang, model_expansion)
    print(f"\nTexto expandido:\n{expansion}")

    # Generar y mostrar la traducción del texto expandido
    translation_expansion = llm_translation.generate_summary(expansion, input_lang, output_lang, model_translation)
    print(f"\nTexto expandido y traducido:\n{translation_expansion}")
