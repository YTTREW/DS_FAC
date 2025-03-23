# Desarrollo de Software - Prácticas

## Componentes del grupo

- Fernández Arrabal, Carlos
- García Mesa, Antonio Manuel
- Cuesta Bueno, Fernando

## Práctica 1

### Instalación de dependencias

Para poder instalar las dependencias necesarias recomendamos el uso de un entorno virtual.

```
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Ejercicio 2

Para poder ejecutar el programa se debe crear un archivo llamado `.env` en la carpeta `ejercicio2` con el siguiente contenido:

```
HUGGINGFACE_API_TOKEN=<tu_token>
```

Donde `<tu_token>` es el token de la API de Hugging Face.

El texto con el que se trabaja se encuentra en el archivo `config.json`, en el campo `texto`.

Para ejecutar el programa:

```
python3 cliente.py
```

### Ejercicio 3

Para ejecutar el programa:

```
python3 ejercicio3.py
```
