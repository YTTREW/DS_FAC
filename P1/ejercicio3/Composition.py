from Compositor import Compositor
import yaml
# Clase principal Composition
class Composition:
    def __init__(self, compositor: Compositor):
        self.compositor = compositor

    def obtener_datos(self, base_url, pages):
        all_quotes = [] # Lista que almacenará todas las citas
        for page in range(1, pages + 1): # Iteramos sobre las páginas
            url = f"{base_url}/page/{page}/"
        # Obtenemos las citas de la página y las añadimos a la lista
            all_quotes.extend(self.compositor.compose(url)) 
        return all_quotes

    def save_to_yaml(self, data, filename):
        #Creo fichero de escritura
        with open(filename, 'w', encoding='utf-8') as file: 
            # Guardo los datos en el fichero
            yaml.dump(data, file, allow_unicode=True)

