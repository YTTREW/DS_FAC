from Compositor import Compositor
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options

# Estrategia con Selenium
class TexCompositor(Compositor):
    # Metodo para abrir el navegador chrome sin que se muestre en pantalla
    def __init__(self):
        options = Options()
        options.add_argument('--headless')
        self.driver = webdriver.Chrome(service=Service(), options=options)
    
    def compose(self, url):
        self.driver.get(url)
        quotes = self.extraer_datos()
        return quotes
    # Metodo para extraer los datos de la pagina
    def extraer_datos(self):
        quotes = []
        elements = self.driver.find_elements(By.CLASS_NAME, 'quote')
        for element in elements:
            text = element.find_element(By.CLASS_NAME, 'text').text
            author = element.find_element(By.CLASS_NAME, 'author').text
            tags = [tag.text for tag in element.find_elements(By.CLASS_NAME, 'tag')]
            quotes.append({'text': text, 'author': author, 'tags': tags})
        return quotes
    
    def close(self):
        self.driver.quit()
