from SimpleCompositor import SimpleCompositor
from Composition import Composition
from TexCompositor import TexCompositor

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
