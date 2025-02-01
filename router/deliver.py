from database.model.orderdetail import OrderDetail
from database.model.product import Product
from database.model.deliver import Deliver
from database.model.order import Order
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database.conn.connection import db


router = APIRouter()

@router.get('/{order_id}')
def user_deliver(session: Session = Depends(db.session), order_id: str = None):
    """
    배송현황 페이지
    orderid 입력해서 사용
    """
    try:
        delivers = session.query(
            Product.name, # 상품 이름
            Product.image,  # 상품 이미지
            OrderDetail.quantity,  # 상품별 구매 수량
            Deliver.id, # 배송 번호
            OrderDetail.id, # 주문 번호
            Order.status, # 배송 상태
            Order.order_date, # 주문날짜
            Order.address, # 배송지            
            Deliver.delivery_type, # Ship Mode
        ).join(
            Product,
            OrderDetail.product_id == Product.id
        ).join(
            Deliver,
            Deliver.order_id == OrderDetail.id
        ).join(
            Order,
            Order.id == OrderDetail.id
        ).filter(
            OrderDetail.id == order_id
        ).all()
        if not delivers:
            raise HTTPException(status_code=400, detail="deliverlist not found")
            
        return {'result': [
            {
                'product_name': deliver[0],
                'image': deliver[1], 
                'quantity': deliver[2],
                
            }
            for deliver in delivers
        ],
        'deliver_id': delivers[0][2],
        'order_id': delivers[0][4],
        'status': delivers[0][5],
        'order_date' : {
                        'month': int(delivers[0][6].strftime('%m')),
                        'year': int(delivers[0][6].strftime('%Y')),
                        },
        'weekday': (int(delivers[0][6].strftime('%w'))-1)%7,
        'delivery_type' : delivers[0][7],
        'address' : delivers[0][8]
        }
        
    except Exception as e:
        print('error', e)
        return {'result' : e}


# @router.post('/')
# async def new_delivery(sesison : Session = Depends(db.session), id : str = None, driver_seq : int = None, hub_id : int = None, truck_id :str = None, order_id : str = None, start_date : str = None, end_date : str = None, delivery_type : int = None):

