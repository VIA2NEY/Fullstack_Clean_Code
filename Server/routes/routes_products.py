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