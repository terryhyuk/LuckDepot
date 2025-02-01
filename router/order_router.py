from database.model.user import User
from database.model.order import Order
from database.model.product import Product
from fastapi import APIRouter, Depends,HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import desc, func, cast, Integer, String
from database.conn.connection import db
from datetime import datetime
from dateutil.relativedelta import relativedelta

router = APIRouter()



## ----------------관리자용--------------------

# 관리자용 유저 구매내역 조회
@router.get("/select_all")
async def get_orders(session: Session = Depends(db.session)):
    """
    관리자용 \n
    사용자별 구매내역 조회 (이름, 아이디, 총 구매금액, 최근 구매일) \n
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
            func.sum(func.sum(Order.price)).over().label('sum'), 
            func.avg(func.sum(Order.price)).over().label('avg'), 
            func.avg(func.sum(Order.price)).over().label('avg'), 
        ).join(
            User,
            Order.user_seq == User.seq
        ).group_by(
            User.seq,  # User.seq 추가
        ).order_by(
            desc('total_payment')
        ).all()
        if not orders:
            raise HTTPException(status_code=400, detail="admin order list not found")
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
        return {'result' : e}
    

# 관리자 dash board, 매출관리 월별 그래프
@router.get('/month', status_code=200)
def test(session: Session = Depends(db.session)):
    try:
        current_date = datetime.now()
        
        # 월별 매출 쿼리
        months_data = session.query(
            func.substring(func.min(Order.id),3,2).label('month'),
            func.sum(Order.price).label('month_price'),
        ).filter(
            cast(func.substring(Order.id, 1, 4), String).between(
                (current_date - relativedelta(months=5)).strftime('%y%m'),
                current_date.strftime('%y%m')
            )
        ).group_by(
            func.substring(Order.id,3,2)
        ).order_by(
            func.substring(Order.id,3,2).desc()
        ).all()

        if not months_data:
            raise HTTPException(status_code=400, detail='months not found')
            
        # 월별 매출 데이터를 딕셔너리로 변환
        sales_dict = {month[0]: month[1] for month in months_data}

        # 최근 6개월의 월 리스트 생성
        months_list = []
        for i in range(6):
            past_date = current_date - relativedelta(months=i)
            months_list.append(past_date.strftime('%Y%m'))
            
        
        # 최근 6개월 데이터 생성 (없는 월은 0으로 설정)
        month_sales_list = [
            {
                'month': f"{month[:4]}.{month[-2:]}",
                'sales': sales_dict.get(month[-2:], 0)
            }
            for month in reversed(months_list)
        ]
        return {'result': month_sales_list}
        
    except Exception as e:
        print(e)
        return {'result': e}


@router.put('/')
async def update(session : Session = Depends(db.session), order_id : str = None, status : str = None):
    """
    관리자용 \n
    order테이블 배송상태 업데이트, \n
    """
    try :
        order = session.query(Order).filter(Order.id == order_id, Order.status != "배송완료").first()
        if not order :    
            return {'result' : '배송중인 상품이 없습니다.'}
        setattr(order, 'status', status) # 수정 함수 order에서 'status' 컬럼값을 status로 수정
        session.commit()
        return {'result' : 'ok'}
    except Exception as e:
        return {'result' : e}   



##----------------------- 유저 ----------------------------

# 사용자에 따른 주문 조회
@router.get('/{user_seq}')
async def order_select(user_seq : int, session : Session = Depends(db.session)):
    """
    사용자용 \n
    주문목록 조회 user_seq사용 \n
    임시
    """
    try :
        orders = session.query(
            Order.id, 
            Order.user_seq, 
            Order.payment_type, 
            Order.price, 
            Order.address, 
            Order.order_date, 
            Order.status,
            Order.delivery_type
            ).filter(
            Order.user_seq == user_seq
            ).all()
        if not orders:
            raise HTTPException(status_code=400, detail="user order not found")
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
                        'delivery_type' : order[7]
                    }
                    for order in orders
                ]
                } #
    except Exception as e: 
        return {'results' : e}

# 주문입력
# 주문번호, user_seq, 결제수단, 가격, 배송지 
# 최초 입력시 배송상태는 '배송전'으로 고정값 입력
@router.post('/')
async def insert(session : Session = Depends(db.session), id : str = None,user_seq : int = None, payment_type : str = None, price : float = None, address : str = None, delivery_type : int = None):
    """
    사용자용
    주문 입력함수
    """
    try :
        new_order = Order(
            id  = id, # 주문 번호,
            user_seq = user_seq, # 유저 seq
            payment_type = payment_type, # 결제수단
            price = price, # 가격
            address = address, # 배송지
            order_date = datetime.now(), # 주문일자
            status = "배송전", # 배송 상태
            delivery_type = delivery_type
        )
        session.add(new_order)
        session.commit()
        return {'result' : 'ok'}
    except Exception as e:
        return {'result' : e}







