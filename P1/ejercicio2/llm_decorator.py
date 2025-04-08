from llm import *


class LLMDecorator(LLM):
    """
    Clase base para los decoradores de la clase LLM, extiende la funcionalidad de la clase LLM.
    """

    def __init__(self, llm):
        """
        Inicializa la clase con una instancia de la clase LLM.

        Args:
            llm (LLM): La instancia de la clase LLM.
        """
        self.llm = llm

    def generate_summary(self, text, input_lang, output_lang, model):
        """Devuelve un resumen del texto de entrada utilizando el modelo especificado y la API de Hugging Face.

        Args:
            text (str): El texto de entrada que se desea resumir.
            input_lang (str): El idioma del texto de entrada.
            output_lang (str): El idioma del resumen.
            model (str): El nombre del modelo de Hugging Face que se utilizará para generar el resumen.

        Returns:
            str: El resumen del texto de entrada.
        """
        return self.llm.generate_summary(text, input_lang, output_lang, model)
