from Compositor import Compositor
import requests
from bs4 import BeautifulSoup
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
