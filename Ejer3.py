import requests
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import yaml
from abc import ABC, abstractmethod

# Clase base Compositor (Strategy)
class Compositor(ABC):
    @abstractmethod
    def compose(self, url):
        pass

# Estrategia con BeautifulSoup
class SimpleCompositor(Compositor):
    def compose(self, url):
        response = requests.get(url)
        soup = BeautifulSoup(response.text, 'html.parser')
        return self.extraer_datos(soup)

    def extraer_datos(self, soup):
        quotes = []
        for quote in soup.select('.quote'):
            text = quote.select_one('.text').get_text(strip=True)
            author = quote.select_one('.author').get_text(strip=True)
            tags = [tag.get_text(strip=True) for tag in quote.select('.tags .tag')]
            quotes.append({'text': text, 'author': author, 'tags': tags})
        return quotes

# Estrategia con Selenium
class TexCompositor(Compositor):
    def __init__(self):
        options = Options()
        options.add_argument('--headless')
        self.driver = webdriver.Chrome(service=Service(), options=options)
    
    def compose(self, url):
        self.driver.get(url)
        quotes = self.extraer_datos()
        return quotes
    
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

if __name__ == "__main__":
    BASE_URL = "https://quotes.toscrape.com"
    
    # Usando SimpleCompositor (BeautifulSoup)
    bs_composition = Composition(SimpleCompositor())
    bs_quotes = bs_composition.obtener_datos(BASE_URL)
    bs_composition.save_to_yaml(bs_quotes, "quotes_bs.yml")
    print("Datos guardados con SimpleCompositor en 'quotes_bs.yml'")
    
    # Usando TexCompositor (Selenium)
    selenium_composition = Composition(TexCompositor())
    selenium_quotes = selenium_composition.obtener_datos(BASE_URL)
    selenium_composition.save_to_yaml(selenium_quotes, "quotes_selenium.yml")
    selenium_composition.compositor.close()
    print("Datos guardados con TexCompositor en 'quotes_selenium.yml'")
