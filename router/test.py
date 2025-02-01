from database.model.order import Order
from database.model.product import Product
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database.conn.connection import db
from starlette.responses import JSONResponse
from datetime import datetime

router = APIRouter()

@router.get("/", status_code=200)
async def index(session: Session = Depends(db.session)):
    start_time = datetime.now()  # 요청 시작 시간 기록
    product = session.query(Product).all()


    return product


