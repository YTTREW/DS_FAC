from abc import ABC, abstractmethod


class LLM(ABC):
    """Clase interfaz"""
    @abstractmethod
    def generate_summary(text, input_lang, output_lang, model):
        pass
