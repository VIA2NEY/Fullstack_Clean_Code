from pydantic import BaseModel
from typing import List, Optional

from schemas.response_schemas import ResponseSchema

class ProductBase(BaseModel):
    name: str
    description: Optional[str] = None
    price: float

class ProductCreate(ProductBase):
    pass

class ProductResponse(ProductBase):
    id: int

    class Config:
        from_attributes = True


# Ajout d'un schéma de réponse spécifique
class ProductListResponse(ResponseSchema[list[ProductResponse]]):
    pass

class ProductDetailResponse(ResponseSchema[ProductResponse]):
    pass