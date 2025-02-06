# FastAPI Store API

## Description

Ce projet est une API REST développée avec FastAPI qui permet de gérer des produits dans un store.  
L'API prend en charge la création, la récupération et la gestion des produits avec des réponses standardisées.  

## Fonctionnalités  

- 📌 **Ajout de produits**  
- 📌 **Liste des produits**  
- 📌 **Récupération d'un produit par son ID**  
- 📌 **Standardisation des réponses API**  
- 📌 **Gestion des exceptions et erreurs de validation**  

---

## 📁 Architecture du projet  

```
racine/
│── alembic/                 # Gestion des migrations de base de données
│   ├── versions/            # Historique des migrations
│   ├── env.py               # Configuration Alembic
│
│── config/                  # Configuration globale
│   ├── database.py          # Configuration de la base de données
│
│── models/                  # Définition des modèles SQLAlchemy
│   ├── product.py           # Modèle Product
│
│── routes/                  # Définition des routes API
│   ├── routes_products.py   # Routes pour la gestion des produits
│
│── schemas/                 # Définition des schémas de validation avec Pydantic
│   ├── schema_product.py    # Schéma des produits
│   ├── response_schemas.py  # Modèle de réponse standardisée
│
│── utils/                   # Fonctions utilitaires
│   ├── utils.py             # Fonctions pour formater les réponses et gérer les erreurs
│
│── main.py                  # Point d'entrée principal de l'API
│── README.md                # Documentation du projet
│── requirements.txt         # Dépendances Python
```

## 📌 Détail des fichiers principaux

- **config/database.py** : Configuration de la base de données SQLite avec SQLAlchemy.
- **models/product.py** : Définition du modèle Product utilisé pour stocker les données des produits.
- **routes/routes_products.py** : Routes API pour gérer les produits (création, récupération, etc.).
- **schemas/schema_product.py** : Définit les schémas Pydantic pour la validation des données produits.
- **schemas/response_schemas.py** : Contient une classe générique ResponseSchema pour structurer toutes les réponses.
- **utils/utils.py** : Contient des fonctions pour formater les réponses et gérer les exceptions de manière uniforme.
- **main.py** : Point d'entrée de l'application qui charge les routes et configure la gestion des exceptions.



## Installation

1️⃣ **Cloner le projet depuis le référentiel GitHub.**

   ```bash
   git clone https://github.com/Username/votre-projet-fastapi.git
   ```

2️⃣ **Accéder au répertoire du projet.**

    ```
    cd /SERVER
    ```

3️⃣ **Creation et Activation de l'environement virtuel**

- Crée un environement virtuel
     ```bash
     python -m venv env


- Activé le 
   ```bash
       .\env\Scripts\activate


4️⃣ **Installer les dépendances à partir du fichier requirements.txt.**
    ```bash
        pip install -r requirements.txt 

5️⃣ **Initialiser la base de données**

alembic upgrade head

6️⃣ **Lancer l'application**

uvicorn main:app --reload

L'API sera accessible à l'adresse : http://127.0.0.1:8000 🚀

## 📌Tester les endpoints

Une documentation interactive est disponible sur :

Swagger UI : http://127.0.0.1:8000/docs

Redoc : http://127.0.0.1:8000/redoc

## 📌 Exemple de requêtes API

### ➤ Créer un produit

POST /products/
```
{
  "name": "Produit A",
  "description": "Description du produit A",
  "price": 19.99
}
```

Réponse :
```
{
  "code": 201,
  "message": "Produit créé avec succès",
  "data": {
    "id": 1,
    "name": "Produit A",
    "description": "Description du produit A",
    "price": 19.99
  }
}
```

### ➤ Récupérer tous les produits

GET /products/

Réponse :
```
{
  "code": 200,
  "message": "Liste des produits récupérée",
  "data": [
    {
      "id": 1,
      "name": "Produit A",
      "description": "Description du produit A",
      "price": 19.99
    }
  ]
}
```
## 📌 Conclusion

Ce projet FastAPI est conçu pour être rapide, scalable et facile à maintenir. Il utilise SQLAlchemy pour la gestion des bases de données et Pydantic pour la validation des données. 🚀
