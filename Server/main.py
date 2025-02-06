from fastapi import FastAPI
from utils.utils import response_format

from fastapi.responses import JSONResponse
from fastapi.requests import Request
from fastapi.exceptions import RequestValidationError
from starlette.exceptions import HTTPException as StarletteHTTPException

from routes.routes_products import router_product

app = FastAPI()


# /// LA PARTIE CI DESSOUS ME PERMET DE STANDATISER LES REPONSE DES 
# /// EXPETION DE MES APIS EN FORMAT {"code": Status,"message": "msg","data": "data"}

@app.exception_handler(StarletteHTTPException)
async def custom_http_exception_handler(request: Request, exc: StarletteHTTPException):
    return JSONResponse(
        status_code=exc.status_code,
        content=response_format(exc.status_code, exc.detail["message"], exc.detail.get("data"))
    )

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    return JSONResponse(
        status_code=422,
        content=response_format(422, "Erreur de validation", exc.errors())
    )

# ### FIN DE LA PARTIE DE STANDATISATION DES REPONSES DES EXCEPTIONS


# Routes


app.include_router(router_product)