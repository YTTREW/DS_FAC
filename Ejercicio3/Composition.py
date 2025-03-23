from Compositor import Compositor
import yaml
# Clase principal Composition
class Composition:
    def __init__(self, compositor: Compositor):
        self.compositor = compositor

    def obtener_datos(self, base_url, pages=5):
        all_quotes = []
        for page in range(1, pages + 1):
            url = f"{base_url}/page/{page}/"
            all_quotes.extend(self.compositor.compose(url))
        return all_quotes

    def save_to_yaml(self, data, filename):
        with open(filename, 'w', encoding='utf-8') as file:
            yaml.dump(data, file, allow_unicode=True)
