from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from config.database import get_db
from models.product import Product
from schemas.schema_product import ProductCreate, ProductDetailResponse, ProductListResponse
from utils.utils import  raise_exception



router_product = APIRouter(
    prefix="/products",
    tags=["PRODUITS"]
)

@router_product.post("/", response_model=ProductDetailResponse)
def create_product(product: ProductCreate, db: Session = Depends(get_db)):
    db_product = Product(**product.dict())
    db.add(db_product)
    db.commit()
    db.refresh(db_product)

    return ProductDetailResponse(code=201, message="Produit créé avec succès", data=db_product)


@router_product.get("/", response_model=ProductListResponse)
def get_products(db: Session = Depends(get_db)):
    products = db.query(Product).all()
    return ProductListResponse(code=200, message="Liste des produits récupérée", data=products)


@router_product.get("/{product_id}", response_model=ProductDetailResponse)
def get_product(product_id: int, db: Session = Depends(get_db)):
    product = db.query(Product).filter(Product.id == product_id).first()

    if not product:
        raise_exception(404, "Produit non trouvé", f"le produit avec l'id {product_id} n'existe pas")

    return ProductDetailResponse(code=200, message="Produit récupéré", data=product)


@router_product.put("/{product_id}", response_model=ProductDetailResponse)
def update_product(product_id: int, product: ProductCreate, db: Session = Depends(get_db)):
    db_product = db.query(Product).filter(Product.id == product_id).first()

    if not db_product:
        raise_exception(404, "Produit non trouvé", f"Le produit avec l'ID {product_id} n'existe pas")

    # Mise à jour des champs
    db_product.name = product.name
    db_product.description = product.description
    db_product.price = product.price

    db.commit()
    db.refresh(db_product)

    return ProductDetailResponse(code=200, message="Produit mis à jour avec succès", data=db_product)


@router_product.delete("/{product_id}", response_model=ProductDetailResponse)
def delete_product(product_id: int, db: Session = Depends(get_db)):
    db_product = db.query(Product).filter(Product.id == product_id).first()

    if not db_product:
        raise_exception(404, "Produit non trouvé", f"Le produit avec l'ID {product_id} n'existe pas")

    db.delete(db_product)
    db.commit()

    return ProductDetailResponse(code=200, message="Produit supprimé avec succès", data= None)
