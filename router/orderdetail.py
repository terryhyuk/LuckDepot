from database.model.orderdetail import OrderDetail
from database.model.product import Product
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import desc, func, cast, String, Integer
from database.conn.connection import db
from datetime import datetime, timedelta



router = APIRouter()
# 관리자용 매출 연별 조회
@router.get('/year')
async def select(session : Session = Depends(db.session)):
    """
    관리자용
    상품이름, 상품별 판매수량, 상품별 총 합 조회
    """
    try :
        # 현재 시간 기준 년도
        current_year = datetime.now().strftime('%y')
        orders = session.query(
            Product.name, # 상품 이름
            func.sum(OrderDetail.quantity).label('order_count'), # 판매 수량
            func.sum(OrderDetail.price).label('total_price'), # 총 합
        ).join(
            Product, 
            Product.id == OrderDetail.product_id
        ).filter(
            cast(func.substring(OrderDetail.id, 1, 2), String) == current_year
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

# 관리자용 매출 관리 주별 조회
@router.get('/week')
async def select(session : Session = Depends(db.session)):
    """
    관리자용 매출관리 "월"
    상품이름, 상품별 판매수량, 상품별 총 합 조회
    """
    try :
        # 현재 날짜 기준으로 이번주의 시작일과 종료일 계산
        current_date = datetime.now()
        # 월요일이 0, 일요일이 6
        start_of_week = current_date - timedelta(days=current_date.weekday())
        end_of_week = start_of_week + timedelta(days=6)
        orders = session.query(
            Product.name, # 상품 이름
            func.sum(OrderDetail.quantity).label('order_count'), # 판매 수량
            func.sum(OrderDetail.price).label('total_price'), # 총 합
        ).join(
            Product, 
            Product.id == OrderDetail.product_id
        ).filter(
            cast(func.substring(OrderDetail.id, 1, 6), String).between(
                start_of_week.strftime('%y%m%d'),
                end_of_week.strftime('%y%m%d')
            )
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


# 관리자용 매출 관리 주별 조회
@router.get('/month')
async def select(session : Session = Depends(db.session)):
    """
    관리자용 매출관리 "월"
    상품이름, 상품별 판매수량, 상품별 총 합 조회
    """
    try :
        # 현재 시간 기준 월
        current_month = datetime.now().strftime('%m')
        orders = session.query(
            Product.name, # 상품 이름
            func.sum(OrderDetail.quantity).label('order_count'), # 판매 수량
            func.sum(OrderDetail.price).label('total_price'), # 총 합
        ).join(
            Product, 
            Product.id == OrderDetail.product_id
        ).filter(
            cast(func.substring(OrderDetail.id, 3, 2), String) == current_month
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
async def insert(session : Session = Depends(db.session), id : str = None, user_seq : int = None, product_id : int = None, price : float = None, quantity : int = None, name : str = None):
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
            quantity = quantity,
            name = name
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


