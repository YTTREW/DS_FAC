
from abc import ABC, abstractmethod

# Clase base Compositor (Strategy)
class Compositor(ABC):
    @abstractmethod
    def compose(self, url):
        pass