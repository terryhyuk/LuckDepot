from database.model.orderdetail import OrderDetail
from database.model.product import Product
from database.model.deliver import Deliver
from database.model.order import Order
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, subqueryload
from sqlalchemy import desc, func, cast, String
from database.conn.connection import db


router = APIRouter()

# @router.get('/{user_seq}')
# def user_deliver(session: Session = Depends(db.session),user_seq : int = None):
#     try:
#         delivers = session.query(
#             Deliver.id.label('deliver_id'),
#             OrderDetail.id.label('order_id'),
#             func.min(Order.status),
#             func.min(OrderDetail.name).label('product_name'),
#             func.min(Product.image),
#             func.sum(OrderDetail.price),
#             func.count(OrderDetail.name).label('product_count')
#         ).join(
#             OrderDetail,
#             OrderDetail.id == Order.id
#         ).join(
#             Product,
#             Product.id == OrderDetail.product_id
#         ).join(
#             Deliver,
#             Deliver.order_id == Order.id
#         ).filter(
#             Order.user_seq == user_seq,  # 특정 user_seq에 해당하는 주문만 필터링
            
#         ).group_by(
#             # Product.image,
#             # Order.price,
#             # Order.status,
#             OrderDetail.id,
#             # Order.id,
#             Deliver.id
#         ).all()
#         if not delivers :
#             raise HTTPException(status_code=400, detail="orderlist not found")
#         return {'result' :
#                 [
#                     {
#                         'deliver_id' : deliver[0],
#                         'order_id' : deliver[1],
#                         'status' : deliver[2],
#                         'product_name' : deliver[3],
#                         'image' : deliver[4],
#                         'price' : deliver[5],
#                         'count' : deliver[6]
#                     }
#                 ]
#                 for deliver in delivers
#                 }
            
#     except Exception as e:
#         print(f"Error: {e}")
#         return None

# @router.get('/{order_id}')
# def user_deliver(session: Session = Depends(db.session), order_id: str = None):
#     """
#     배송현황 페이지
#     orderid 입력해서 사용
#     """
#     try:
#         delivers = session.query(
#             OrderDetail.id, # 주문 번호
#             Deliver.id, # 배송 번호
#             Order.status,
#             Product.image, # 상품 이미지 1개만 출력
#             Product.name,
#             OrderDetail.quantity, #대표상품 주문 갯수만 출력
#             func.sum(OrderDetail.price), # 주문 총 가격
#         ).join(
#             Product,
#             OrderDetail.product_id == Product.id
#         ).join(
#             Deliver,
#             Deliver.order_id == OrderDetail.id
#         ).join(
#             Order,
#             Order.id == OrderDetail.id
#         ).filter(
#             OrderDetail.id == order_id
#         ).all()
#         if not delivers:
#             raise HTTPException(status_code=400, detail="deliverlist not found")
            
#         return {'result': [
#             {
#                 'status': deliver[2],
#                 'image': deliver[3],
#                 'product_name': deliver[4],
#                 'quantity': deliver[5],
#             }
#             for deliver in delivers
#         ],
#         'deliver_id': delivers[0][0],
#         'order_id': delivers[0][1],
#         'price' : delivers[0][6],
#         }
            
#     except Exception as e:
#         print(f"Error: {e}")
#         return None
