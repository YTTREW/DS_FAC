from llm import *
import requests


class BasicLLM(LLM):
    """
    Clase que implementa la interfaz LLM. Utiliza la API de Hugging Face para generar resúmenes a partir de un texto de entrada.
    """

    def __init__(self, api_token):
        """
        Inicializa la clase con el token de la API de Hugging Face.

        Args:
            api_token (str): El token de la API de Hugging Face.
        """
        self.api_token = api_token

    def generate_summary(self, text, input_lang, output_lang, model):
        """
        Devuelve un resumen del texto de entrada utilizando el modelo especificado y la API de Hugging Face.

        Args:
            text (str): El texto de entrada que se desea resumir.
            input_lang (str): El idioma del texto de entrada (no se utiliza en esta implementación, pero se mantiene por compatibilidad con la interfaz).
            output_lang (str): El idioma del resumen (no se utiliza en esta implementación, pero se mantiene por compatibilidad con la interfaz).
            model (str): El nombre del modelo de Hugging Face que se utilizará para generar el resumen.

        Returns:
            str: El resumen del texto de entrada.
        """

        # Variables para realizar la solicitud POST a la API de Hugging Face
        url = f"https://api-inference.huggingface.co/models/{model}"

        headers = {
            "Authorization": f"Bearer {self.api_token}",
        }

        data = {
            "inputs": f"Haz un resumen de este texto: {text}",
        }

        # Realizar la solicitud POST a la API de Hugging Face
        try:
            response = requests.post(url, headers=headers, json=data)
            response.raise_for_status()
            return response.json()[0]["summary_text"]
        except Exception as e:
            return f"Error al generar el resumen: {e}"
