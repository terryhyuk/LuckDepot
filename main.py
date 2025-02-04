from fastapi import FastAPI, Request
from fastapi.security import APIKeyHeader
from starlette.middleware.cors import CORSMiddleware

import uvicorn
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles


templates = Jinja2Templates(directory="templates")

API_KEY_HEADER = APIKeyHeader(name="Authorization", auto_error=False)

def create_app():
    """
    앱 함수 실행
    :return:
    """
    app = FastAPI()
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        # allow_origins=conf().ALLOW_SITE,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    return app


app = create_app()
app.mount("/static", StaticFiles(directory="static"), name="static")
app.mount("/", StaticFiles(directory="templates", html=True), name="flutter")
templates = Jinja2Templates(directory="templates")

@app.get("/", response_class=HTMLResponse)
async def main():
    return "templates/index.html"

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
