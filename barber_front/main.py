import os

# Lista de pacotes a serem instalados
packages = [
    "flutter_bloc",
    "dio",
    "pretty_dio_logger",
    "get",
    "firebase_core",
    "image_picker",
    "equatable",
    "firebase_messaging",
    "jwt_decoder",
    "firebase_auth",
    "flutter_secure_storage",
    "get_it",
    "dartz",
    "flutter_svg",
    "graphql_flutter",
    "intl",
    "path_provider",
    "hive",
    "google_maps_flutter",
    "permission_handler",
    "geolocator",
    "asyncstate",
    "loading_animation_widget",
    "firebase_storage",
    "firebase_database",
    "cloud_firestore",
    "google_fonts",
    "geocoder2"
]

# Instalação dos pacotes
for package in packages:
    os.system(f"flutter pub add {package}")

# Executa o comando "flutter pub get" para instalar as dependências
os.system("flutter pub get")

print("Pacotes instalados com sucesso!")
