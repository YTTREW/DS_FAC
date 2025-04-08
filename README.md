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

## Práctica 2

### Ejercicio 4

Para poder hacer uso de la API de HuggingFace se debe clonar el archivo `lib/secrets/secrets_template.dart`:

```bash

cp lib/secrets/secrets_template.dart lib/secrets/secrets.dart
```

Una vez clonado, se debe modificar el archivo `lib/secrets/secrets.dart` para incluir el token de la API de HuggingFace:

```dart

const String huggingFaceToken = 'YOUR_HUGGING_FACE_API_TOKEN';
```

En dicho campo cambiaremos `'YOUR_HUGGING_FACE_API_TOKEN'` por el token generado en la
[web de HuggingFace](https://huggingface.co/settings/tokens).

La ruta para hacer la llamada a los modelos ya se encuentra indicada. Para modificar la ruta únicamente
hace falta cambiar el campo `huggingFaceModel`. En nuestro caso haremos uso de la
URL https://api-inference.huggingface.co/models/.
