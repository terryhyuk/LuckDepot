from database.model.orderdetail import OrderDetail
from database.model.product import Product
from database.model.deliver import Deliver
from database.model.order import Order
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database.conn.connection import db
from sqlalchemy.sql import func

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
            Order.order_date # 주문날짜
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
        )
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
        'order_date' : delivers[0][6].strftime('%Y-%m-%d')
        }
            
    except Exception as e:
        print('deliver-user_deliver', e)
        return {'result' : e}


# 사용자의 배송중인 건수 조회
@router.get('/{user_seq}/{order_id}')
def user_deliver(session: Session = Depends(db.session), user_seq: int = None, order_id: str = None):
    """
    ✅ `사용자의 주문 개수 가져오기`  
    ✅ 🚀 `Order.id`와 `OrderDetail.order_id`를 올바르게 조인  
    """
    try:
        deliver_count = (
            session.query(func.count(Deliver.id))  # 🚀 배송 건수 조회
            .join(OrderDetail, Deliver.order_id == OrderDetail.id)  # ✅ 배송-주문 상세 조인
            .join(Order, Order.id == OrderDetail.id)  # ✅ 주문-주문 상세 조인 (🚀 에러 해결)
            .filter(OrderDetail.id == order_id)  # ✅ 특정 주문 ID 필터링
            .filter(Order.user_seq == user_seq)  # ✅ 특정 사용자 필터링
            .scalar()  # 🚀 단일 값 반환
        )
        
        if deliver_count is None or deliver_count == 0:
            raise HTTPException(status_code=400, detail="🚨 배송 데이터 없음 (deliverlist not found)")
            
        return {"order_id": order_id, "deliver_count": deliver_count}
            
    except Exception as e:
        print("❌ [ERROR] user_deliver:", e)
        return {"result": str(e)}