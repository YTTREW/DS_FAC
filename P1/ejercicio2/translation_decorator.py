from llm_decorator import *
import requests


class TranslationDecorator(LLMDecorator):
    """
    Clase decoradora que traduce el texto de entrada a otro idioma.
    """

    def generate_summary(self, text, input_lang, output_lang, model):
        """
        Traduce un texto de entrada al idioma especificado.

        Args:
            text (str): El texto de entrada que se desea traducir.
            input_lang (str): El idioma del texto de entrada.
            output_lang (str): El idioma al que se desea traducir el texto.
            model (str): El nombre del modelo de Hugging Face que se utilizará para la traducción.

        Returns:
            str: El texto traducido al idioma especificado.
        """

        # Variables para realizar la solicitud POST a la API de Hugging Face
        url = f"https://api-inference.huggingface.co/models/{model}"

        headers = {
            "Authorization": f"Bearer {self.llm.api_token}",
        }

        data = {
            "inputs": text,
        }

        # Realizar la solicitud POST a la API de Hugging Face
        try:
            response = requests.post(url, headers=headers, json=data)
            response.raise_for_status()
            return response.json()[0]["translation_text"]
        except Exception as e:
            return f"Error al generar el resumen: {e}"
