from llm_decorator import *
import requests


class ExpansionDecorator(LLMDecorator):
    """
    Clase decoradora que expande el texto de entrada.
    """

    def generate_summary(self, text, input_lang, output_lang, model):
        """
        Expande el texto de entrada.

        Args:
            text (str): El texto de entrada que se desea expandir.
            input_lang (str): El idioma del texto de entrada.
            output_lang (str): El idioma del resumen.
            model (str): El nombre del modelo de Hugging Face que se utilizará para la expansión.

        Returns:
            str: El texto expandido.
        """

        # Variables para realizar la solicitud POST a la API de Hugging Face
        url = f"https://api-inference.huggingface.co/models/{model}"

        headers = {
            "Authorization": f"Bearer {self.llm.api_token}",
        }

        data = {
            "inputs": f"Expand the following text in more detail: {text}",
            "parameters": {
                "max_length": 500
            }
        }

        # Realizar la solicitud POST a la API de Hugging Face
        try:
            response = requests.post(url, headers=headers, json=data)
            response.raise_for_status()
            return response.json()[0]["generated_text"]
        except Exception as e:
            return f"Error al generar el resumen: {e}"
