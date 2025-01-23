from database.model.user import User
from database.model.order import Order
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import desc, func
from database.conn.connection import db
from datetime import datetime


router = APIRouter()

# 사용자에 따른 주문 조회
@router.get('/select/{user_seq}')
async def order_select(user_seq : int, session : Session = Depends(db.session)):
    """
    내(사용자) 주문목록 조회 user_seq사용
    """
    try :
        orders = session.query(
            Order.id, 
            Order.user_seq, 
            Order.payment_type, 
            Order.price, 
            Order.address, 
            Order.order_date, 
            Order.status
            ).filter(
            Order.user_seq == user_seq
            ).all()
        return {'result' : 
                [
                    {
                        'id' : order[0], #주문 번호
                        'user_seq' : order[1], # 유저 seq(user pk)
                        'payment_type' : order[2], # 결제 수단
                        'price' : order[3], # 가격
                        'address' : order[4],  # 배송지
                        'order_date' : order[5].strftime('%Y-%m-%d %H:%M'), # 주문일자 (년-월-일 시간:분)
                        'status' : order[6], # 배송 상태
                    }
                    for order in orders
                ]
                } #
    except Exception as e: 
        print('orders error',e)
        return {'results' : e}
    finally :
        session.close()

# 관리자용 유저 구매내역 조회
@router.get("/select_all")
async def get_orders(session: Session = Depends(db.session)):
    """
    관리자용 
    사용자별 구매내역 조회 (이름, 아이디, 총 구매금액, 최근 구매일)
    사용자 합계 (총 구매금액, 평균 구매금액)
    """
    try:
        orders = session.query(
            User.name, 
            User.id, 
            func.sum(Order.price).label('total_payment'), 
            func.count(Order.user_seq).label('order_count'), 
            func.max(Order.order_date).label('last_order_date') , 
            func.sum(func.sum(Order.price)).over().label('sum'), 
            func.avg(func.sum(Order.price)).over().label('avg'), 
        ).join(
            User,
            Order.user_seq == User.seq
        ).group_by(
            User.seq,  # User.seq 추가
        ).order_by(
            desc('total_payment')
        ).all()
        return { "result": 
                [
                    {
                    "name": order[0], # 유저이름
                    "email": order[1], # 유저 아이디
                    "total_payment": order[2], # 유저별 총 구매 금액
                    'order_count' : order[3], # 유저별 총 주문 횟수
                    'last_order_date' : order[4].strftime('%Y-%m-%d') # 유저별 최근 주문 일자
                    }
                for order in orders
                ],
                'sum': orders[0][5], # 총 매출
                'avg' : round(orders[0][6]) # 평균 매출
            }
    except Exception as e:
        print(e)
        return {'result' : e}
    finally :
        session.close()


# 주문입력
# 주문번호, user_seq, 결제수단, 가격, 배송지 
# 최초 입력시 배송상태는 '배송전'으로 고정값 입력
@router.get('/insert')
async def insert(session : Session = Depends(db.session), id : str = None, user_seq : int = None, payment_type : str = None, price : float = None, address : str = None):
    """
    사용자용
    주문 입력함수
    """
    try :
        new_order = Order(
            id  = id, # 주문 번호
            user_seq = user_seq, # 유저 seq
            payment_type = payment_type, # 결제수단
            price = price, # 가격
            address = address, # 배송지
            order_date = datetime.now(), # 주문일자
            status = "배송전" # 배송 상태
        )
        session.add(new_order)
        session.commit()
        return {'result' : 'ok'}
    except Exception as e:
        print(e)
        return {'result' : e}
    finally :
        session.close()


@router.delete('/delete')
async def delete(session : Session = Depends(db.session), order_id : str = None):
    try :
        order = session.query(Order).filter(Order.id == order_id).first()
        if not order :
            print('주문내역이 없습니다.')
            return {'result' : '주문내역이 없습니다'}
        session.delete(order)
        session.commit()
        return {'result' : 'ok'}
    except Exception as e:
        print('주문 삭제 에러' , e)
        return {'result' : e}
    finally : 
        session.close()



@router.get('/update')
async def update(session : Session = Depends(db.session), order_id : str = None, status : str = None):
    """
    관리자용
    order테이블 배송상태 업데이트,
    배송완료가 아닌 주문만 수정가능
    """
    try :
        order = session.query(Order).filter(Order.id == order_id, Order.status != "배송완료").first()
        if not order :    
            return {'result' : '배송중인 상품이 없습니다.'}
        setattr(order, 'status', status)
        session.commit()
        return {'result' : 'ok'}
    except Exception as e:
        print(e)
        return {'result' : e}   
    finally : 
        session.close()
