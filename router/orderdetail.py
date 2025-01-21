from database.model.orderdetail import OrderDetail
from database.model.product import Product
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import desc, func
from database.conn.connection import db


router = APIRouter()

router.get('/select')
async def insert(session : Session = Depends(db.session)):
    try :
        order = session.query(
            Product.name, # 상품 이름
            func.count(Product.id).label('order_count'), # 판매 수량
            func.sum(OrderDetail.price).label('total_price'), # 총 합
        ).join(
            Product, Product.id == OrderDetail.product_id
        ).group_by(
        Product.name
        ).order_by(desc('order_count'))
        if not order :
            print('판매 내역이 없습니다.')
        session.close()
        return {'result' : order}
    except Exception as e:
        session.close()
        print('error', e)
        return {'result' : e}

