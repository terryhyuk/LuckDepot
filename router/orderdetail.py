from database.model.orderdetail import OrderDetail
from database.model.product import Product
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import desc, func
from database.conn.connection import db


router = APIRouter()
# 관리자용
@router.get('/select')
async def select(session : Session = Depends(db.session)):
    """
    관리자용
    상품이름, 상품별 판매수량, 상품별 총 합 조회
    """
    try :
        orders = session.query(
            Product.name, # 상품 이름
            func.sum(OrderDetail.quantity).label('order_count'), # 판매 수량
            func.sum(OrderDetail.price).label('total_price'), # 총 합
        ).join(
            Product, 
            Product.id == OrderDetail.product_id
        ).group_by(
        Product.name
        ).order_by(desc('order_count'))
        if not orders :
            return {'result': '판매 내역이 없습니다.'}
        return {'result' : 
                    [
                        {
                            'name' : order[0],
                            'order_count' : order[1],
                            'total_price' : order[2]
                        }
                        for order in orders
                    ]
                }
    except Exception as e:
        print('error', e)
        return {'result' : e}
    finally :
        session.close()


@router.get("/select/{user_seq}")
async def user(session : Session = Depends(db.session), user_seq : int = None):
    """
    사용자용
    user_seq(pk)를 통해 orderdetail 테이블 조회
    """
    try :
        orderdetail = session.query(
            OrderDetail.id,
            OrderDetail.user_seq,
            OrderDetail.product_id, 
            OrderDetail.price, 
            OrderDetail.quantity
            ).filter(OrderDetail.user_seq == user_seq).all()
        if not orderdetail :
            return {'result': '구매 내역이 없습니다.'}
        return { "result": 
                [
                    {
                    "id" : detail[0],
                    "user_seq" : detail[1],
                    "prodcut_id": detail[2], # 상품 아이디(pk)
                    "price": detail[3], # 상품 가격
                    "quantity": detail[4], # 수량
                    }
                for detail in orderdetail
                ],
            }
    except Exception as e:
        print('error', e)
        return {'result' : e}
    
    finally : 
        session.close()


@router.get('/insert')
async def insert(session : Session = Depends(db.session), id : str = None, user_seq : int = None, product_id : int = None, price : int = None, quantity : int = None):
    """
    사용자용
    주문시 orderdetail 입력
    """
    try :
        new_order = OrderDetail(
            id = id,
            user_seq = user_seq,
            product_id = product_id,
            price = price,
            quantity = quantity
        )
        session.add(new_order)
        session.commit()
        return {'result' : 'ok'}
    except Exception as e:
        print('error', e)
        return {'result' : e}
    finally:
        session.close()


@router.delete('/delete')
async def delete(session : Session = Depends(db.session), orderdetail_id : str = None):
    """
    필요시 사용
    orderdetail 정보 삭제 
    orderdetail_id (pk) 사용
    """
    try :
        orderdetail = session.query(OrderDetail).filter(OrderDetail.id == orderdetail_id).first()
        if not orderdetail :
            print('주문내역이 없습니다.')
            return {'result' : '주문내역이 없습니다'}
        session.delete(orderdetail)
        session.commit()
        return {'result' : 'ok'}
    except Exception as e:
        print('삭제 에러' , e)
        return {'result' : e}
    finally :
        session.close()


